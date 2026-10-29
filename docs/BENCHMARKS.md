# Performance Benchmarks & Quality Verification Report

This document provides reproducible performance benchmarks, scaling measurements, and internationalization completeness audits for **Wmimo**.

---

## 1. Subscription Profile Parsing & Scaling Benchmarks

Wmimo uses a zero-block asynchronous architecture that offloads large YAML subscription conversion and node classification to dedicated Dart background isolates (`Isolate.run`), keeping the UI thread responsive during subscription synchronization.

### Benchmark Environment
- **Platform**: Windows 11 x64 / Linux x64
- **Dart SDK**: >= 3.12.2
- **Flutter SDK**: >= 3.35.0
- **Test File**: [`test/benchmark_profile_scale_test.dart`](../test/benchmark_profile_scale_test.dart)

### Empirical Results

| Subscription Scale | Proxy Node Count | Parsing & Extraction Latency | Processing Throughput | Auto-Generated Smart Groups |
|:---|:---|:---|:---|:---|
| **Small** | 50 nodes | **~18.8 ms** | ~2,660 nodes/s | 6 Groups (HK, JP, US, SG, Auto, Fallback) |
| **Medium** | 500 nodes | **~59.1 ms** | ~8,460 nodes/s | 6 Groups |
| **Large** | 2,000 nodes | **~77.4 ms** | ~25,840 nodes/s | 6 Groups |
| **Stress** | 5,000 nodes | **~163.0 ms** | **~30,670 nodes/s** | 6 Groups |

### Fast-Path Optimization
- **`SubscriptionConverter.isClashYaml`**: Profile format detection operates on an optimized header-scanning heuristic:
  - 1,000 nodes: **~1.4 ms**
  - 5,000 nodes: **~1.9 ms**
- **UI Non-Blocking**: Because profile operations are processed in a background Isolate, main thread UI frame times remain locked at 60/120 FPS without frame drops.

---

## 2. Internationalization (i18n) Completeness Matrix

Wmimo provides native localization across 9 languages. Language files are validated by automated integrity tests ([`test/i18n_integrity_test.dart`](../test/i18n_integrity_test.dart)) and verification tooling ([`tool/verify_i18n.dart`](../tool/verify_i18n.dart)) to guarantee 0 missing keys and placeholder consistency.

### Completeness Audit

| Locale | Language | JSON File | Total Key Count | Missing Keys | Placeholder Parity | Completeness |
|:---|:---|:---|:---|:---|:---|:---|
| `zh-CN` | 简体中文 (Baseline) | `lib/i18n/zh-CN.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `en` | English | `lib/i18n/en.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `zh-TW` | 繁體中文 | `lib/i18n/zh-TW.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `ja` | 日本語 | `lib/i18n/ja.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `ko` | 한국어 | `lib/i18n/ko.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `ru` | Русский | `lib/i18n/ru.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `es` | Español | `lib/i18n/es.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `ar` | العربية | `lib/i18n/ar.i18n.json` | 798 | 0 | 100.0% | **100.0%** |
| `fa` | فارسی | `lib/i18n/fa.i18n.json` | 798 | 0 | 100.0% | **100.0%** |

*Audit result: 9/9 languages achieve 100.0% key coverage parity with 0 missing translation entries.*

---

## 3. How to Independently Reproduce

To reproduce the benchmark figures and i18n audits locally:

```bash
# 1. Run profile scaling benchmarks
flutter test test/benchmark_profile_scale_test.dart

# 2. Run automated i18n completeness and placeholder consistency tests
flutter test test/i18n_integrity_test.dart

# 3. Print the i18n coverage matrix report
dart run tool/verify_i18n.dart

# 4. Run full test suite (140+ unit & widget tests)
flutter test
```
