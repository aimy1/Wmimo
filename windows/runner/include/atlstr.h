#pragma once
#include <string>
#include <windows.h>
#include <wincred.h>

class CString : public std::wstring {
public:
  using std::wstring::wstring;
  CString() : std::wstring() {}
  CString(const wchar_t* s) : std::wstring(s ? s : L"") {}
  CString(const std::wstring& s) : std::wstring(s) {}
  CString(const char* s) {
    if (s) {
      int len = MultiByteToWideChar(CP_UTF8, 0, s, -1, NULL, 0);
      if (len > 1) {
        resize(len - 1);
        MultiByteToWideChar(CP_UTF8, 0, s, -1, &(*this)[0], len);
      }
    }
  }
  operator const wchar_t*() const { return c_str(); }
  int GetLength() const { return (int)length(); }
  bool IsEmpty() const { return empty(); }
  void Empty() { clear(); }
  CString Mid(int first, int count) const {
    if (first >= (int)length()) return CString();
    return CString(substr(first, count));
  }
};
typedef CString CStringW;

class CA2W {
public:
  std::wstring m_str;
  wchar_t* m_psz;
  CA2W(const char* s) {
    if (s) {
      int len = MultiByteToWideChar(CP_UTF8, 0, s, -1, NULL, 0);
      if (len > 0) {
        m_str.resize(len);
        MultiByteToWideChar(CP_UTF8, 0, s, -1, &m_str[0], len);
      }
    }
    m_psz = const_cast<wchar_t*>(m_str.c_str());
  }
  operator LPCWSTR() const { return m_psz; }
};

class CW2A {
public:
  std::string m_str;
  char* m_psz;
  CW2A(const wchar_t* s) {
    if (s) {
      int len = WideCharToMultiByte(CP_UTF8, 0, s, -1, NULL, 0, NULL, NULL);
      if (len > 0) {
        m_str.resize(len);
        WideCharToMultiByte(CP_UTF8, 0, s, -1, &m_str[0], len, NULL, NULL);
      }
    }
    m_psz = const_cast<char*>(m_str.c_str());
  }
  operator LPCSTR() const { return m_psz; }
};
