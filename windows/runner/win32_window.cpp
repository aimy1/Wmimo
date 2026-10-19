#include "win32_window.h"

#include <dwmapi.h>
#include <flutter_windows.h>

#include "resource.h"

namespace {

/// Window attribute that enables dark mode window decorations.
///
/// Redefined in case the developer's machine has a Windows SDK older than
/// version 10.0.22000.0.
/// See: https://docs.microsoft.com/windows/win32/api/dwmapi/ne-dwmapi-dwmwindowattribute
#ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#endif

constexpr const wchar_t kWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

/// Registry key for app theme preference.
///
/// A value of 0 indicates apps should use dark mode. A non-zero or missing
/// value indicates apps should use light mode.
constexpr const wchar_t kGetPreferredBrightnessRegKey[] =
  L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize";
constexpr const wchar_t kGetPreferredBrightnessRegValue[] = L"AppsUseLightTheme";

// The number of Win32Window objects that currently exist.
static int g_active_window_count = 0;

enum class PreferredAppMode {
  Default,
  AllowDark,
  ForceDark,
  ForceLight,
  Max
};

using fnSetPreferredAppMode = PreferredAppMode(WINAPI*)(PreferredAppMode appMode);
using fnAllowDarkModeForApp = BOOL(WINAPI*)(BOOL allow);
using fnAllowDarkModeForWindow = BOOL(WINAPI*)(HWND hWnd, BOOL allow);
using fnFlushMenuThemes = void(WINAPI*)();
using fnShouldAppsUseDarkMode = BOOL(WINAPI*)();

using EnableNonClientDpiScaling = BOOL __stdcall(HWND hwnd);

// Scale helper to convert logical scaler values to physical using passed in
// scale factor
int Scale(int source, double scale_factor) {
  return static_cast<int>(source * scale_factor);
}

// Dynamically loads the |EnableNonClientDpiScaling| from the User32 module.
// This API is only needed for PerMonitor V1 awareness mode.
void EnableFullDpiSupportIfAvailable(HWND hwnd) {
  HMODULE user32_module = LoadLibraryA("User32.dll");
  if (!user32_module) {
    return;
  }
  auto enable_non_client_dpi_scaling =
      reinterpret_cast<EnableNonClientDpiScaling*>(
          GetProcAddress(user32_module, "EnableNonClientDpiScaling"));
  if (enable_non_client_dpi_scaling != nullptr) {
    enable_non_client_dpi_scaling(hwnd);
  }
  FreeLibrary(user32_module);
}

}  // namespace

// Manages the Win32Window's window class registration.
class WindowClassRegistrar {
 public:
  ~WindowClassRegistrar() = default;

  // Returns the singleton registrar instance.
  static WindowClassRegistrar* GetInstance() {
    if (!instance_) {
      instance_ = new WindowClassRegistrar();
    }
    return instance_;
  }

  // Returns the name of the window class, registering the class if it hasn't
  // previously been registered.
  const wchar_t* GetWindowClass();

  // Unregisters the window class. Should only be called if there are no
  // instances of the window.
  void UnregisterWindowClass();

 private:
  WindowClassRegistrar() = default;

  static WindowClassRegistrar* instance_;

  bool class_registered_ = false;
};

WindowClassRegistrar* WindowClassRegistrar::instance_ = nullptr;

const wchar_t* WindowClassRegistrar::GetWindowClass() {
  if (!class_registered_) {
    WNDCLASS window_class{};
    window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
    window_class.lpszClassName = kWindowClassName;
    window_class.style = CS_HREDRAW | CS_VREDRAW;
    window_class.cbClsExtra = 0;
    window_class.cbWndExtra = 0;
    window_class.hInstance = GetModuleHandle(nullptr);
    window_class.hIcon =
        LoadIcon(window_class.hInstance, MAKEINTRESOURCE(IDI_APP_ICON));
    window_class.hbrBackground = 0;
    window_class.lpszMenuName = nullptr;
    window_class.lpfnWndProc = Win32Window::WndProc;
    RegisterClass(&window_class);
    class_registered_ = true;
  }
  return kWindowClassName;
}

void WindowClassRegistrar::UnregisterWindowClass() {
  UnregisterClass(kWindowClassName, nullptr);
  class_registered_ = false;
}

void Win32Window::EnableDarkModeForApp() {
  HMODULE uxtheme_module = LoadLibraryExW(L"uxtheme.dll", nullptr, LOAD_LIBRARY_SEARCH_SYSTEM32);
  if (!uxtheme_module) {
    return;
  }

  DWORD light_mode = 1;
  DWORD light_mode_size = sizeof(light_mode);
  LSTATUS result = RegGetValue(HKEY_CURRENT_USER, kGetPreferredBrightnessRegKey,
                               kGetPreferredBrightnessRegValue,
                               RRF_RT_REG_DWORD, nullptr, &light_mode,
                               &light_mode_size);
  bool is_dark = (result == ERROR_SUCCESS && light_mode == 0);

  // Windows 10 1903 (18362) and newer (including Windows 11): ordinal 135 is SetPreferredAppMode
  auto set_preferred_app_mode = reinterpret_cast<fnSetPreferredAppMode>(
      GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(135)));
  if (set_preferred_app_mode != nullptr) {
    set_preferred_app_mode(is_dark ? PreferredAppMode::ForceDark : PreferredAppMode::AllowDark);
  } else {
    // Windows 10 1809 (17763): ordinal 135 is AllowDarkModeForApp
    auto allow_dark_mode_for_app = reinterpret_cast<fnAllowDarkModeForApp>(
        GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(135)));
    if (allow_dark_mode_for_app != nullptr) {
      allow_dark_mode_for_app(TRUE);
    }
  }

  // Ordinal 136: FlushMenuThemes to flush cached light menu themes
  auto flush_menu_themes = reinterpret_cast<fnFlushMenuThemes>(
      GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(136)));
  if (flush_menu_themes != nullptr) {
    flush_menu_themes();
  }

  FreeLibrary(uxtheme_module);
}

Win32Window::Win32Window() {
  ++g_active_window_count;
}

Win32Window::~Win32Window() {
  --g_active_window_count;
  Destroy();
}

bool Win32Window::Create(const std::wstring& title,
                         const Point& origin,
                         const Size& size) {
  Destroy();

  const wchar_t* window_class =
      WindowClassRegistrar::GetInstance()->GetWindowClass();

  const POINT target_point = {static_cast<LONG>(origin.x),
                              static_cast<LONG>(origin.y)};
  HMONITOR monitor = MonitorFromPoint(target_point, MONITOR_DEFAULTTONEAREST);
  UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);
  double scale_factor = dpi / 96.0;

  HWND window = CreateWindow(
      window_class, title.c_str(), WS_OVERLAPPEDWINDOW | WS_VISIBLE,
      Scale(origin.x, scale_factor), Scale(origin.y, scale_factor),
      Scale(size.width, scale_factor), Scale(size.height, scale_factor),
      nullptr, nullptr, GetModuleHandle(nullptr), this);

  if (!window) {
    return false;
  }

  HMODULE uxtheme_module = LoadLibraryExW(L"uxtheme.dll", nullptr, LOAD_LIBRARY_SEARCH_SYSTEM32);
  if (uxtheme_module) {
    auto allow_dark_mode_for_window = reinterpret_cast<fnAllowDarkModeForWindow>(
        GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(133)));
    if (allow_dark_mode_for_window != nullptr) {
      allow_dark_mode_for_window(window, TRUE);
    }
    FreeLibrary(uxtheme_module);
  }

  UpdateTheme(window);

  if (!OnCreate()) {
    return false;
  }

  ShowWindow(window, SW_SHOWNORMAL);
  UpdateWindow(window);
  SetForegroundWindow(window);

  return true;
}

bool Win32Window::Show() {
  return ShowWindow(window_handle_, SW_SHOWNORMAL);
}

// static
LRESULT CALLBACK Win32Window::WndProc(HWND const window,
                                      UINT const message,
                                      WPARAM const wparam,
                                      LPARAM const lparam) noexcept {
  if (message == WM_NCCREATE) {
    auto window_struct = reinterpret_cast<CREATESTRUCT*>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA,
                     reinterpret_cast<LONG_PTR>(window_struct->lpCreateParams));

    auto that = static_cast<Win32Window*>(window_struct->lpCreateParams);
    EnableFullDpiSupportIfAvailable(window);
    that->window_handle_ = window;
  } else if (Win32Window* that = GetThisFromHandle(window)) {
    return that->MessageHandler(window, message, wparam, lparam);
  }

  return DefWindowProc(window, message, wparam, lparam);
}

LRESULT
Win32Window::MessageHandler(HWND hwnd,
                            UINT const message,
                            WPARAM const wparam,
                            LPARAM const lparam) noexcept {
  switch (message) {
    case WM_DESTROY:
      window_handle_ = nullptr;
      Destroy();
      if (quit_on_close_) {
        PostQuitMessage(0);
      }
      return 0;

    case WM_GETMINMAXINFO: {
      auto minMaxInfo = reinterpret_cast<MINMAXINFO*>(lparam);
      HMONITOR monitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);
      UINT dpi = FlutterDesktopGetDpiForMonitor(monitor);
      double scale_factor = dpi / 96.0;
      minMaxInfo->ptMinTrackSize.x = static_cast<LONG>(Scale(360, scale_factor));
      minMaxInfo->ptMinTrackSize.y = static_cast<LONG>(Scale(500, scale_factor));
      return 0;
    }

    case WM_DPICHANGED: {
      auto newRectSize = reinterpret_cast<RECT*>(lparam);
      LONG newWidth = newRectSize->right - newRectSize->left;
      LONG newHeight = newRectSize->bottom - newRectSize->top;

      SetWindowPos(hwnd, nullptr, newRectSize->left, newRectSize->top, newWidth,
                   newHeight, SWP_NOZORDER | SWP_NOACTIVATE);

      return 0;
    }
    case WM_SIZE: {
      RECT rect = GetClientArea();
      if (child_content_ != nullptr) {
        // Size and position the child window.
        MoveWindow(child_content_, rect.left, rect.top, rect.right - rect.left,
                   rect.bottom - rect.top, TRUE);
      }
      return 0;
    }

    case WM_ACTIVATE:
      if (child_content_ != nullptr) {
        SetFocus(child_content_);
      }
      return 0;

    case WM_THEMECHANGED:
    case WM_SETTINGCHANGE:
    case WM_DWMCOLORIZATIONCOLORCHANGED:
      UpdateTheme(hwnd);
      return 0;
  }

  return DefWindowProc(window_handle_, message, wparam, lparam);
}

void Win32Window::Destroy() {
  OnDestroy();

  if (window_handle_) {
    DestroyWindow(window_handle_);
    window_handle_ = nullptr;
  }
  if (g_active_window_count == 0) {
    WindowClassRegistrar::GetInstance()->UnregisterWindowClass();
  }
}

Win32Window* Win32Window::GetThisFromHandle(HWND const window) noexcept {
  return reinterpret_cast<Win32Window*>(
      GetWindowLongPtr(window, GWLP_USERDATA));
}

void Win32Window::SetChildContent(HWND content) {
  child_content_ = content;
  SetParent(content, window_handle_);
  RECT frame = GetClientArea();

  MoveWindow(content, frame.left, frame.top, frame.right - frame.left,
             frame.bottom - frame.top, true);

  SetFocus(child_content_);
}

RECT Win32Window::GetClientArea() {
  RECT frame;
  GetClientRect(window_handle_, &frame);
  return frame;
}

HWND Win32Window::GetHandle() {
  return window_handle_;
}

void Win32Window::SetQuitOnClose(bool quit_on_close) {
  quit_on_close_ = quit_on_close;
}

bool Win32Window::OnCreate() {
  // No-op; provided for subclasses.
  return true;
}

void Win32Window::OnDestroy() {
  // No-op; provided for subclasses.
}

static std::string g_app_theme_mode = "system";

void Win32Window::SetAppTheme(const std::string& theme_mode) {
  g_app_theme_mode = theme_mode;
  if (window_handle_) {
    UpdateTheme(window_handle_);
  }
}

void Win32Window::UpdateTheme(HWND const window) {
  BOOL enable_dark_mode = false;
  PreferredAppMode preferred_mode = PreferredAppMode::AllowDark;

  if (g_app_theme_mode == "dark") {
    enable_dark_mode = TRUE;
    preferred_mode = PreferredAppMode::ForceDark;
  } else if (g_app_theme_mode == "light") {
    enable_dark_mode = FALSE;
    preferred_mode = PreferredAppMode::ForceLight;
  } else {
    // "system" - Follow system theme
    DWORD light_mode = 1;
    DWORD light_mode_size = sizeof(light_mode);
    LSTATUS result = RegGetValue(HKEY_CURRENT_USER, kGetPreferredBrightnessRegKey,
                                 kGetPreferredBrightnessRegValue,
                                 RRF_RT_REG_DWORD, nullptr, &light_mode,
                                 &light_mode_size);

    if (result == ERROR_SUCCESS) {
      enable_dark_mode = (light_mode == 0);
    } else {
      HMODULE uxtheme_module = LoadLibraryExW(L"uxtheme.dll", nullptr, LOAD_LIBRARY_SEARCH_SYSTEM32);
      if (uxtheme_module) {
        auto should_apps_use_dark_mode = reinterpret_cast<fnShouldAppsUseDarkMode>(
            GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(132)));
        if (should_apps_use_dark_mode != nullptr) {
          enable_dark_mode = should_apps_use_dark_mode();
        }
        FreeLibrary(uxtheme_module);
      }
    }
    preferred_mode = enable_dark_mode ? PreferredAppMode::ForceDark : PreferredAppMode::ForceLight;
  }

  // Windows 10 2004+ and Windows 11 (20) & Windows 10 1809/1903 (19)
  DwmSetWindowAttribute(window, DWMWA_USE_IMMERSIVE_DARK_MODE,
                        &enable_dark_mode, sizeof(enable_dark_mode));
  const DWORD DWMWA_USE_IMMERSIVE_DARK_MODE_OLD = 19;
  DwmSetWindowAttribute(window, DWMWA_USE_IMMERSIVE_DARK_MODE_OLD,
                        &enable_dark_mode, sizeof(enable_dark_mode));

  HMODULE uxtheme_module = LoadLibraryExW(L"uxtheme.dll", nullptr, LOAD_LIBRARY_SEARCH_SYSTEM32);
  if (uxtheme_module) {
    auto set_preferred_app_mode = reinterpret_cast<fnSetPreferredAppMode>(
        GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(135)));
    if (set_preferred_app_mode != nullptr) {
      set_preferred_app_mode(preferred_mode);
    } else {
      auto allow_dark_mode_for_app = reinterpret_cast<fnAllowDarkModeForApp>(
          GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(135)));
      if (allow_dark_mode_for_app != nullptr) {
        allow_dark_mode_for_app(enable_dark_mode);
      }
    }

    auto allow_dark_mode_for_window = reinterpret_cast<fnAllowDarkModeForWindow>(
        GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(133)));
    if (allow_dark_mode_for_window != nullptr) {
      allow_dark_mode_for_window(window, enable_dark_mode);
    }

    auto flush_menu_themes = reinterpret_cast<fnFlushMenuThemes>(
        GetProcAddress(uxtheme_module, MAKEINTRESOURCEA(136)));
    if (flush_menu_themes != nullptr) {
      flush_menu_themes();
    }
    FreeLibrary(uxtheme_module);
  }

  SetWindowPos(window, nullptr, 0, 0, 0, 0,
               SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED);
}
