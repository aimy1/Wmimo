#pragma once
#include <windows.h>
#include <gdiplus.h>
#include <shlwapi.h>
#pragma comment(lib, "gdiplus.lib")
#pragma comment(lib, "shlwapi.lib")

class CImage {
private:
  HBITMAP m_hBitmap = NULL;
public:
  CImage() {}
  ~CImage() {
    if (m_hBitmap) {
      DeleteObject(m_hBitmap);
      m_hBitmap = NULL;
    }
  }
  void Attach(HBITMAP hBitmap) {
    if (m_hBitmap && m_hBitmap != hBitmap) {
      DeleteObject(m_hBitmap);
    }
    m_hBitmap = hBitmap;
  }
  HRESULT Save(IStream* stream, const GUID& guidFileType) {
    if (!m_hBitmap || !stream) return E_FAIL;
    ULONG_PTR gdiplusToken;
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
    {
      Gdiplus::Bitmap bitmap(m_hBitmap, NULL);
      bitmap.Save(stream, &guidFileType, NULL);
    }
    Gdiplus::GdiplusShutdown(gdiplusToken);
    return S_OK;
  }
};
