// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/widgets/framework.dart';

enum SpeedTestPhase {
  idle,
  ping,
  download,
  upload,
  completed,
  stopped,
}

class SpeedTestRecord {
  final DateTime time;
  final String nodeName;
  final double ping;
  final double jitter;
  final double downloadSpeed;
  final double uploadSpeed;
  final bool isProxy;

  SpeedTestRecord({
    required this.time,
    required this.nodeName,
    required this.ping,
    required this.jitter,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.isProxy,
  });
}

class SpeedTestScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: 'SpeedTestScreen');
  }

  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends LasyRenderingState<SpeedTestScreen>
    with SingleTickerProviderStateMixin {
  SpeedTestPhase _phase = SpeedTestPhase.idle;
  bool _useProxy = true;

  // Realtime target bandwidth & stats
  double _targetSpeedMbps = 0.0;
  double _displaySpeedMbps = 0.0;
  double _pingMs = 0.0;
  double _jitterMs = 0.0;
  double _downloadFinalMbps = 0.0;
  double _uploadFinalMbps = 0.0;

  // History records
  final List<SpeedTestRecord> _history = [];

  // Ookla-style Spring Needle Physics
  late Ticker _ticker;
  Duration? _lastElapsed;
  double _needleProgress = 0.0; // 0.0 -> 1.0 (Angle fraction)
  double _targetNeedleProgress = 0.0;
  double _needleVelocity = 0.0;

  // Sampling Timer & Cancellation
  Timer? _sampleTimer;
  bool _aborted = false;

  @override
  void initState() {
    super.initState();
    // 60/120 FPS Physics Ticker for authentic spring needle movement
    _ticker = createTicker(_onPhysicsTick);
    _ticker.start();
  }

  void _onPhysicsTick(Duration elapsed) {
    if (_lastElapsed == null) {
      _lastElapsed = elapsed;
      return;
    }

    final dt = (elapsed - _lastElapsed!).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    if (dt <= 0 || dt > 0.1) return;

    // Second-order spring dynamics (Speedtest signature feel)
    const double stiffness = 160.0;
    const double damping = 20.0;

    final force = (_targetNeedleProgress - _needleProgress) * stiffness;
    final dampingForce = -_needleVelocity * damping;
    final acceleration = force + dampingForce;

    _needleVelocity += acceleration * dt;
    _needleProgress += _needleVelocity * dt;

    if (_needleProgress < 0.0) {
      _needleProgress = 0.0;
      _needleVelocity = 0.0;
    } else if (_needleProgress > 1.05) {
      _needleProgress = 1.05;
      _needleVelocity = 0.0;
    }

    // Number counter smooth follow
    final speedDiff = _targetSpeedMbps - _displaySpeedMbps;
    if (speedDiff.abs() > 0.01) {
      _displaySpeedMbps += speedDiff * (speedDiff > 0 ? 0.18 : 0.12);
    } else {
      _displaySpeedMbps = _targetSpeedMbps;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _aborted = true;
    _sampleTimer?.cancel();
    _ticker.dispose();
    super.dispose();
  }

  void _setTargetSpeed(double speedMbps) {
    _targetSpeedMbps = speedMbps;
    _targetNeedleProgress = _speedToProgress(speedMbps);
  }

  HttpClient _createHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;
    client.connectionTimeout = const Duration(seconds: 8);
    client.maxConnectionsPerHost = 20;
    if (_useProxy) {
      final mixedPort = ClashSettingManager.getMixedPort();
      if (mixedPort > 0) {
        client.findProxy = (Uri uri) => "PROXY 127.0.0.1:$mixedPort";
      }
    } else {
      client.findProxy = null;
    }
    return client;
  }

  void _stopTest() {
    _aborted = true;
    _sampleTimer?.cancel();
    _setTargetSpeed(0.0);
    setState(() {
      _phase = SpeedTestPhase.stopped;
    });
  }

  Future<void> _startTest() async {
    if (_phase == SpeedTestPhase.ping ||
        _phase == SpeedTestPhase.download ||
        _phase == SpeedTestPhase.upload) {
      _stopTest();
      return;
    }

    _aborted = false;
    _setTargetSpeed(0.0);
    setState(() {
      _phase = SpeedTestPhase.ping;
      _displaySpeedMbps = 0.0;
      _pingMs = 0.0;
      _jitterMs = 0.0;
      _downloadFinalMbps = 0.0;
      _uploadFinalMbps = 0.0;
    });

    try {
      // 1. Ping & Jitter Phase (Gentle calibration sweep)
      await _runPingTest();
      if (_aborted || !mounted) return;

      // 2. High-Capacity Download Phase
      setState(() {
        _phase = SpeedTestPhase.download;
      });
      await _runDownloadTest();
      if (_aborted || !mounted) return;

      // 3. High-Capacity Upload Phase
      setState(() {
        _phase = SpeedTestPhase.upload;
        _setTargetSpeed(0.0);
      });
      await _runUploadTest();
      if (_aborted || !mounted) return;

      // 4. Completed
      _setTargetSpeed(0.0);
      setState(() {
        _phase = SpeedTestPhase.completed;
      });

      // Add to history
      final nodeName = _useProxy
          ? _getProxyNodeName()
          : Translations.of(context).SpeedTestScreen.directConnection;
      _history.insert(
        0,
        SpeedTestRecord(
          time: DateTime.now(),
          nodeName: nodeName,
          ping: _pingMs,
          jitter: _jitterMs,
          downloadSpeed: _downloadFinalMbps,
          uploadSpeed: _uploadFinalMbps,
          isProxy: _useProxy,
        ),
      );
    } catch (e) {
      if (!_aborted && mounted) {
        setState(() {
          _phase = SpeedTestPhase.stopped;
          _setTargetSpeed(0.0);
        });
      }
    }
  }

  Future<void> _runPingTest() async {
    final pingSamples = <double>[];
    final client = _createHttpClient();

    const pingUrls = [
      'https://speed.cloudflare.com/__down?bytes=0',
      'https://cp.cloudflare.com/generate_204',
      'https://1.1.1.1/cdn-cgi/trace',
      'https://speed.cloudflare.com/__down?bytes=0',
      'https://cp.cloudflare.com/generate_204',
      'https://1.1.1.1/cdn-cgi/trace',
    ];

    try {
      for (int i = 0; i < pingUrls.length; i++) {
        if (_aborted || !mounted) break;
        final stopwatch = Stopwatch()..start();
        try {
          final request = await client
              .getUrl(Uri.parse(pingUrls[i]))
              .timeout(const Duration(seconds: 3));
          final response =
              await request.close().timeout(const Duration(seconds: 3));
          await response.drain<void>();
          stopwatch.stop();
          final elapsedMs = stopwatch.elapsedMicroseconds / 1000.0;
          if (elapsedMs > 0 && elapsedMs < 4000) {
            pingSamples.add(elapsedMs);

            final validSamples =
                pingSamples.length > 1 ? pingSamples.sublist(1) : pingSamples;
            final avg =
                validSamples.reduce((a, b) => a + b) / validSamples.length;

            double jitterSum = 0;
            for (int j = 1; j < validSamples.length; j++) {
              jitterSum += (validSamples[j] - validSamples[j - 1]).abs();
            }
            final jitter = validSamples.length > 1
                ? jitterSum / (validSamples.length - 1)
                : 0.0;

            if (mounted) {
              setState(() {
                _pingMs = avg;
                _jitterMs = jitter;
              });
              // Subtle needle twitch during calibration
              _targetNeedleProgress = (i % 2 == 0) ? 0.06 : 0.02;
            }
          }
        } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 70));
      }
    } finally {
      client.close(force: true);
      _targetNeedleProgress = 0.0;
    }
  }

  Future<void> _runDownloadTest() async {
    final client = _createHttpClient();
    const testDuration = Duration(seconds: 8);
    const warmupDuration = Duration(milliseconds: 1500);
    final stopwatch = Stopwatch()..start();

    int totalBytes = 0;
    int warmupBytes = 0;
    bool warmupDone = false;
    int steadyStartUs = 0;

    int lastSampleBytes = 0;
    int lastSampleTimeUs = 0;
    final speedHistory = <double>[];

    final List<StreamSubscription> subscriptions = [];
    final testCompleter = Completer<void>();

    _sampleTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (_aborted || stopwatch.elapsed >= testDuration) {
        timer.cancel();
        if (!testCompleter.isCompleted) testCompleter.complete();
        return;
      }

      final nowUs = stopwatch.elapsedMicroseconds;

      if (!warmupDone && stopwatch.elapsed >= warmupDuration) {
        warmupDone = true;
        warmupBytes = totalBytes;
        steadyStartUs = nowUs;
      }

      final deltaBytes = totalBytes - lastSampleBytes;
      final deltaUs = nowUs - lastSampleTimeUs;

      if (deltaUs > 0) {
        final instantMbps =
            (deltaBytes * 8.0) / (deltaUs / 1000000.0) / 1000000.0;
        lastSampleBytes = totalBytes;
        lastSampleTimeUs = nowUs;

        if (warmupDone && instantMbps > 0) {
          speedHistory.add(instantMbps);
        }

        final recentSamples = speedHistory.length > 3
            ? speedHistory.sublist(speedHistory.length - 3)
            : [instantMbps];
        final displaySpeed =
            recentSamples.reduce((a, b) => a + b) / recentSamples.length;

        _setTargetSpeed(displaySpeed);
      }
    });

    // 6 Concurrent high-throughput download workers
    const chunkUrl = 'https://speed.cloudflare.com/__down?bytes=25000000';
    for (int worker = 0; worker < 6; worker++) {
      () async {
        while (!testCompleter.isCompleted && !_aborted) {
          try {
            final uri = Uri.parse(
              '$chunkUrl&w=$worker&r=${Random().nextInt(999999)}',
            );
            final request =
                await client.getUrl(uri).timeout(const Duration(seconds: 6));
            final response = await request.close();
            final sub = response.listen(
              (chunk) {
                totalBytes += chunk.length;
              },
              cancelOnError: true,
            );
            subscriptions.add(sub);
            await sub.asFuture<void>();
          } catch (_) {
            await Future.delayed(const Duration(milliseconds: 80));
          }
        }
      }();
    }

    await Future.any([
      testCompleter.future,
      Future.delayed(testDuration),
    ]);

    _sampleTimer?.cancel();
    stopwatch.stop();

    for (final sub in subscriptions) {
      try {
        await sub.cancel();
      } catch (_) {}
    }
    client.close(force: true);

    final steadyBytes = warmupDone ? (totalBytes - warmupBytes) : totalBytes;
    final steadyDurationUs = warmupDone
        ? (stopwatch.elapsedMicroseconds - steadyStartUs)
        : stopwatch.elapsedMicroseconds;

    if (steadyDurationUs > 0 && steadyBytes > 0) {
      final avgMbps =
          (steadyBytes * 8.0) / (steadyDurationUs / 1000000.0) / 1000000.0;
      if (mounted) {
        setState(() {
          _downloadFinalMbps = avgMbps;
          _setTargetSpeed(0.0);
        });
      }
    }
  }

  Future<void> _runUploadTest() async {
    final client = _createHttpClient();
    const testDuration = Duration(seconds: 6);
    const warmupDuration = Duration(milliseconds: 1200);
    final stopwatch = Stopwatch()..start();

    final dummyData = Uint8List(2 * 1024 * 1024);
    for (int i = 0; i < dummyData.length; i++) {
      dummyData[i] = (i % 256);
    }

    int totalBytesUploaded = 0;
    int warmupBytes = 0;
    bool warmupDone = false;
    int steadyStartUs = 0;

    int lastSampleBytes = 0;
    int lastSampleTimeUs = 0;
    final speedHistory = <double>[];

    final testCompleter = Completer<void>();

    _sampleTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (_aborted || stopwatch.elapsed >= testDuration) {
        timer.cancel();
        if (!testCompleter.isCompleted) testCompleter.complete();
        return;
      }

      final nowUs = stopwatch.elapsedMicroseconds;

      if (!warmupDone && stopwatch.elapsed >= warmupDuration) {
        warmupDone = true;
        warmupBytes = totalBytesUploaded;
        steadyStartUs = nowUs;
      }

      final deltaBytes = totalBytesUploaded - lastSampleBytes;
      final deltaUs = nowUs - lastSampleTimeUs;

      if (deltaUs > 0) {
        final instantMbps =
            (deltaBytes * 8.0) / (deltaUs / 1000000.0) / 1000000.0;
        lastSampleBytes = totalBytesUploaded;
        lastSampleTimeUs = nowUs;

        if (warmupDone && instantMbps > 0) {
          speedHistory.add(instantMbps);
        }

        final recentSamples = speedHistory.length > 3
            ? speedHistory.sublist(speedHistory.length - 3)
            : [instantMbps];
        final displaySpeed =
            recentSamples.reduce((a, b) => a + b) / recentSamples.length;

        _setTargetSpeed(displaySpeed);
      }
    });

    // 4 Parallel upload workers
    const uploadUrl = 'https://speed.cloudflare.com/__up';
    for (int worker = 0; worker < 4; worker++) {
      () async {
        while (!testCompleter.isCompleted && !_aborted) {
          try {
            final request = await client
                .postUrl(Uri.parse(uploadUrl))
                .timeout(const Duration(seconds: 5));
            request.headers.set(
              HttpHeaders.contentLengthHeader,
              dummyData.length,
            );
            request.add(dummyData);
            final response = await request.close();
            await response.drain<void>();
            totalBytesUploaded += dummyData.length;
          } catch (_) {
            await Future.delayed(const Duration(milliseconds: 80));
          }
        }
      }();
    }

    await Future.any([
      testCompleter.future,
      Future.delayed(testDuration),
    ]);

    _sampleTimer?.cancel();
    stopwatch.stop();
    client.close(force: true);

    final steadyBytes =
        warmupDone ? (totalBytesUploaded - warmupBytes) : totalBytesUploaded;
    final steadyDurationUs = warmupDone
        ? (stopwatch.elapsedMicroseconds - steadyStartUs)
        : stopwatch.elapsedMicroseconds;

    if (steadyDurationUs > 0 && steadyBytes > 0) {
      final avgMbps =
          (steadyBytes * 8.0) / (steadyDurationUs / 1000000.0) / 1000000.0;
      if (mounted) {
        setState(() {
          _uploadFinalMbps = avgMbps;
          _setTargetSpeed(0.0);
        });
      }
    }
  }

  String _getPhaseDescription(Translations tcontext) {
    switch (_phase) {
      case SpeedTestPhase.idle:
        return tcontext.SpeedTestScreen.ready;
      case SpeedTestPhase.ping:
        return tcontext.SpeedTestScreen.testingPing;
      case SpeedTestPhase.download:
        return tcontext.SpeedTestScreen.testingDownload;
      case SpeedTestPhase.upload:
        return tcontext.SpeedTestScreen.testingUpload;
      case SpeedTestPhase.completed:
        return tcontext.SpeedTestScreen.completed;
      case SpeedTestPhase.stopped:
        return tcontext.SpeedTestScreen.stopped;
    }
  }

  Color _getPhaseColor(ThemeData theme) {
    switch (_phase) {
      case SpeedTestPhase.idle:
        return theme.colorScheme.primary;
      case SpeedTestPhase.ping:
        return const Color(0xFFF59E0B);
      case SpeedTestPhase.download:
        return const Color(0xFF00E5FF);
      case SpeedTestPhase.upload:
        return const Color(0xFF8B5CF6);
      case SpeedTestPhase.completed:
        return const Color(0xFF10B981);
      case SpeedTestPhase.stopped:
        return theme.disabledColor;
    }
  }

  String _getProxyNodeName() {
    final currentProfile = ProfileManager.getCurrent();
    if (currentProfile != null) {
      if (currentProfile.remark.isNotEmpty) {
        return currentProfile.remark;
      }
      if (currentProfile.id.isNotEmpty) {
        return currentProfile.id;
      }
    }
    return 'Proxy';
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRunning = _phase == SpeedTestPhase.ping ||
        _phase == SpeedTestPhase.download ||
        _phase == SpeedTestPhase.upload;

    final nodeName = _getProxyNodeName();

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Mode Switch
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  if (ModalRoute.of(context)?.canPop ?? false)
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 36,
                        height: 32,
                        child: Icon(Icons.arrow_back_ios_outlined, size: 20),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      tcontext.SpeedTestScreen.title,
                      style: const TextStyle(
                        fontWeight: ThemeConfig.kFontWeightTitle,
                        fontSize: ThemeConfig.kFontSizeTitle,
                      ),
                    ),
                  ),
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                        value: true,
                        label: Text(
                          tcontext.SpeedTestScreen.currentProxy,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text(
                          tcontext.SpeedTestScreen.directConnection,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                    selected: {_useProxy},
                    onSelectionChanged: isRunning
                        ? null
                        : (Set<bool> newSelection) {
                            setState(() {
                              _useProxy = newSelection.first;
                            });
                          },
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),

            // Top Summary Bar (Speedtest Style 4-Metric Strip)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      context: context,
                      icon: Icons.timer_outlined,
                      iconColor: const Color(0xFF10B981),
                      label: tcontext.SpeedTestScreen.ping,
                      value: _pingMs > 0
                          ? '${_pingMs.toStringAsFixed(0)} ms'
                          : '--',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildMetricTile(
                      context: context,
                      icon: Icons.waves_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      label: tcontext.SpeedTestScreen.jitter,
                      value: _jitterMs > 0
                          ? '${_jitterMs.toStringAsFixed(0)} ms'
                          : '--',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildMetricTile(
                      context: context,
                      icon: Icons.cloud_download_rounded,
                      iconColor: const Color(0xFF00E5FF),
                      label: tcontext.SpeedTestScreen.download,
                      value: _downloadFinalMbps > 0
                          ? '${_downloadFinalMbps.toStringAsFixed(1)}'
                          : (_phase == SpeedTestPhase.download
                              ? '${_displaySpeedMbps.toStringAsFixed(1)}'
                              : '--'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildMetricTile(
                      context: context,
                      icon: Icons.cloud_upload_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      label: tcontext.SpeedTestScreen.upload,
                      value: _uploadFinalMbps > 0
                          ? '${_uploadFinalMbps.toStringAsFixed(1)}'
                          : (_phase == SpeedTestPhase.upload
                              ? '${_displaySpeedMbps.toStringAsFixed(1)}'
                              : '--'),
                    ),
                  ),
                ],
              ),
            ),

            // Main Speedtest Dial Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  const SizedBox(height: 6),

                  // The Speedtest Instrument Dial
                  Center(
                    child: SizedBox(
                      width: 270,
                      height: 270,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(270, 270),
                            painter: _SpeedtestDialPainter(
                              progress: _needleProgress,
                              color: _getPhaseColor(theme),
                              isDark: isDark,
                              phase: _phase,
                            ),
                          ),
                          // Central Digital Counter (Positioned below pivot)
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _phase == SpeedTestPhase.ping
                                      ? (_pingMs > 0
                                          ? _pingMs.toStringAsFixed(0)
                                          : '--')
                                      : (_phase == SpeedTestPhase.completed
                                          ? _downloadFinalMbps.toStringAsFixed(1)
                                          : (_displaySpeedMbps > 0.05
                                              ? _displaySpeedMbps
                                                  .toStringAsFixed(1)
                                              : '0.0')),
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1.2,
                                    height: 1.0,
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _phase == SpeedTestPhase.ping ? 'ms' : 'Mbps',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: (isDark
                                            ? Colors.white
                                            : Colors.black)
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getPhaseDescription(tcontext),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getPhaseColor(theme),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Server & Node Info Card
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.35),
                        width: 0.8,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _useProxy
                                ? Icons.dns_rounded
                                : Icons.public_rounded,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _useProxy
                                      ? '${tcontext.SpeedTestScreen.currentProxy}: $nodeName'
                                      : tcontext.SpeedTestScreen.directConnection,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${tcontext.SpeedTestScreen.server}: Cloudflare Speed CDN (Anycast)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: (isDark ? Colors.white : Colors.black)
                                        .withValues(alpha: 0.55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // History Section
                  if (_history.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tcontext.SpeedTestScreen.testHistory,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _history.clear();
                            });
                          },
                          icon: const Icon(Icons.delete_outline, size: 15),
                          label: Text(
                            tcontext.SpeedTestScreen.clearHistory,
                            style: const TextStyle(fontSize: 11.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ..._history.map(
                      (record) => _buildHistoryCard(record, theme, isDark),
                    ),
                  ],

                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: isRunning ? _stopTest : _startTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning
                        ? Colors.redAccent
                        : theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(
                    isRunning
                        ? Icons.stop_rounded
                        : (_phase == SpeedTestPhase.completed
                            ? Icons.refresh_rounded
                            : Icons.play_arrow_rounded),
                    size: 20,
                  ),
                  label: Text(
                    isRunning
                        ? tcontext.SpeedTestScreen.stopTest
                        : (_phase == SpeedTestPhase.completed
                            ? tcontext.SpeedTestScreen.reTest
                            : tcontext.SpeedTestScreen.startTest),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    SpeedTestRecord record,
    ThemeData theme,
    bool isDark,
  ) {
    final timeStr =
        '${record.time.hour.toString().padLeft(2, '0')}:${record.time.minute.toString().padLeft(2, '0')}:${record.time.second.toString().padLeft(2, '0')}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              record.isProxy ? Icons.dns_rounded : Icons.public_rounded,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.nodeName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 10,
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '↓ ${record.downloadSpeed.toStringAsFixed(1)} Mbps',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00E5FF),
                      ),
                    ),
                    Text(
                      '↑ ${record.uploadSpeed.toStringAsFixed(1)} Mbps',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Text(
                  '${record.ping.toStringAsFixed(0)} ms',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Official Ookla Speedtest Piecewise Scale Mapping
double _speedToProgress(double speed) {
  if (speed <= 0) return 0.0;
  if (speed <= 1.0) return (speed / 1.0) * 0.08;
  if (speed <= 5.0) return 0.08 + ((speed - 1.0) / 4.0) * 0.12;
  if (speed <= 10.0) return 0.20 + ((speed - 5.0) / 5.0) * 0.12;
  if (speed <= 50.0) return 0.32 + ((speed - 10.0) / 40.0) * 0.20;
  if (speed <= 100.0) return 0.52 + ((speed - 50.0) / 50.0) * 0.16;
  if (speed <= 250.0) return 0.68 + ((speed - 100.0) / 150.0) * 0.14;
  if (speed <= 500.0) return 0.82 + ((speed - 250.0) / 250.0) * 0.10;
  if (speed <= 1000.0) return 0.92 + ((speed - 500.0) / 500.0) * 0.08;
  return 1.0;
}

/// The Authentic Speedtest Dial & Needle Painter
class _SpeedtestDialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isDark;
  final SpeedTestPhase phase;

  _SpeedtestDialPainter({
    required this.progress,
    required this.color,
    required this.isDark,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    const startAngle = 135.0 * (pi / 180.0);
    const sweepTotalAngle = 270.0 * (pi / 180.0);

    // 1. Background Track Arc
    final bgPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotalAngle,
      false,
      bgPaint,
    );

    // 2. Speedtest Major & Minor Radial Ticks + Labels
    final majorTicks = [
      {'val': 0.0, 'label': '0'},
      {'val': 1.0, 'label': '1'},
      {'val': 5.0, 'label': '5'},
      {'val': 10.0, 'label': '10'},
      {'val': 50.0, 'label': '50'},
      {'val': 100.0, 'label': '100'},
      {'val': 250.0, 'label': '250'},
      {'val': 500.0, 'label': '500'},
      {'val': 1000.0, 'label': '1G'},
    ];

    final majorTickPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.28)
      ..strokeWidth = 1.5;

    for (final tick in majorTicks) {
      final val = tick['val'] as double;
      final label = tick['label'] as String;
      final fraction = _speedToProgress(val);
      final angle = startAngle + sweepTotalAngle * fraction;

      final innerR = radius - 10;
      final outerR = radius - 3;

      final p1 = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final p2 = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      canvas.drawLine(p1, p2, majorTickPaint);

      // Major tick text label
      final textSpan = TextSpan(
        text: label,
        style: TextStyle(
          color: (isDark ? Colors.white : Colors.black)
              .withValues(alpha: 0.45),
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textR = radius - 20;
      final textX = center.dx + textR * cos(angle) - textPainter.width / 2;
      final textY = center.dy + textR * sin(angle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // Minor ticks
    final minorTickPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 36; i++) {
      final fraction = i / 36.0;
      final angle = startAngle + sweepTotalAngle * fraction;
      final innerR = radius - 6;
      final outerR = radius - 3;

      final p1 = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final p2 = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      canvas.drawLine(p1, p2, minorTickPaint);
    }

    // 3. Active Filled Arc (Trails from 0 up to needle)
    final clampedProgress = progress.clamp(0.0, 1.0);
    final activeAngle = sweepTotalAngle * clampedProgress;

    if (activeAngle > 0.005) {
      final activeArcPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        activeAngle,
        false,
        activeArcPaint,
      );
    }

    // 4. The Authentic Speedtest Needle
    final needleAngle = startAngle + sweepTotalAngle * progress;
    final needleLength = radius - 24;

    final needleTip = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    final perpAngle = needleAngle + pi / 2;
    const baseWidth = 3.2;

    final pLeft = Offset(
      center.dx + baseWidth * cos(perpAngle),
      center.dy + baseWidth * sin(perpAngle),
    );
    final pRight = Offset(
      center.dx - baseWidth * cos(perpAngle),
      center.dy - baseWidth * sin(perpAngle),
    );

    // Counterweight tail
    const tailLength = 12.0;
    final tailPoint = Offset(
      center.dx - tailLength * cos(needleAngle),
      center.dy - tailLength * sin(needleAngle),
    );

    final needlePath = Path()
      ..moveTo(needleTip.dx, needleTip.dy)
      ..lineTo(pLeft.dx, pLeft.dy)
      ..lineTo(tailPoint.dx, tailPoint.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..close();

    final needlePaint = Paint()
      ..color = (progress > 0.01) ? color : (isDark ? Colors.white70 : Colors.black45)
      ..style = PaintingStyle.fill;
    canvas.drawPath(needlePath, needlePaint);

    // 5. Center Hub Disc
    final hubOuterPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 9, hubOuterPaint);

    final hubBorderPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 9, hubBorderPaint);

    final hubCenterPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3.5, hubCenterPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeedtestDialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isDark != isDark ||
        oldDelegate.phase != phase;
  }
}
