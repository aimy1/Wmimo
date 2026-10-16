// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/utils/geo_asset_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class GeoAssetsScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "GeoAssetsScreen");
  }

  const GeoAssetsScreen({super.key});

  @override
  State<GeoAssetsScreen> createState() => _GeoAssetsScreenState();
}

class _GeoAssetsScreenState extends LasyRenderingState<GeoAssetsScreen> {
  List<GeoAssetInfo> _assets = [];
  bool _loading = true;
  String _selectedSourceId = "jsdelivr";
  final Map<String, double> _downloadProgress = {};
  final Map<String, bool> _isDownloading = {};
  bool _isUpdatingAll = false;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    setState(() => _loading = true);
    final list = await GeoAssetManager.getAssetsInfo();
    if (!mounted) return;
    setState(() {
      _assets = list;
      _loading = false;
    });
  }

  Future<void> _updateSingle(String fileName) async {
    setState(() {
      _isDownloading[fileName] = true;
      _downloadProgress[fileName] = 0.0;
    });

    final success = await GeoAssetManager.downloadAsset(
      fileName,
      sourceId: _selectedSourceId,
      onProgress: (p) {
        if (mounted) setState(() => _downloadProgress[fileName] = p);
      },
    );

    if (!mounted) return;
    setState(() {
      _isDownloading[fileName] = false;
    });

    final tcontext = Translations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "$fileName: ${tcontext.dns.updateSuccess}"
            : "$fileName: ${tcontext.dns.updateFailed}"),
        backgroundColor: success ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorRed,
      ),
    );

    await _loadAssets();
  }

  Future<void> _updateAll() async {
    setState(() => _isUpdatingAll = true);
    final tcontext = Translations.of(context);

    final results = await GeoAssetManager.updateAll(
      sourceId: _selectedSourceId,
      onProgress: (fileName, p) {
        if (mounted) {
          setState(() {
            _isDownloading[fileName] = true;
            _downloadProgress[fileName] = p;
          });
        }
      },
    );

    if (!mounted) return;
    setState(() {
      _isUpdatingAll = false;
      _isDownloading.clear();
    });

    final allOk = results.values.every((v) => v);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(allOk
            ? tcontext.dns.updateSuccess
            : "${tcontext.dns.updateSuccess}: ${results.values.where((v) => v).length}/${results.length}"),
        backgroundColor: allOk ? ThemeDefine.kColorGreenBright : Colors.orange,
      ),
    );

    await _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tcontext.dns.geoAssetsTitle,
          style: const TextStyle(
            fontWeight: ThemeConfig.kFontWeightTitle,
            fontSize: ThemeConfig.kFontSizeTitle,
          ),
        ),
        actions: [
          IconButton(
            tooltip: tcontext.dns.updateAll,
            icon: _isUpdatingAll
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            onPressed: _isUpdatingAll ? null : _updateAll,
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildSourceSelectorCard(tcontext, theme),
                  const SizedBox(height: 16),
                  ..._assets.map((asset) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildAssetCard(asset, tcontext, theme),
                      )),
                  const SizedBox(height: 8),
                  _buildAutoUpdateRulesetCard(tcontext, theme),
                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }

  Widget _buildSourceSelectorCard(Translations tcontext, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
      shape: RoundedRectangleBorder(
        borderRadius: ThemeDefine.kBorderRadius,
        side: BorderSide(color: theme.dividerColor.withAlpha(60)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.speed, size: 20, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  tcontext.dns.cdnSource,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              tcontext.dns.geoAssetsDesc,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Column(
              children: GeoAssetManager.cdnSources.map((source) {
                final isSelected = _selectedSourceId == source.id;
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _selectedSourceId = source.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.grey.withAlpha(50),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      color: isSelected ? Colors.blue.withAlpha(20) : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.blueAccent : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(source.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(source.description, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: _isUpdatingAll
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.download_for_offline_outlined),
              label: Text(tcontext.dns.updateAll),
              onPressed: _isUpdatingAll ? null : _updateAll,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard(GeoAssetInfo asset, Translations tcontext, ThemeData theme) {
    final downloading = _isDownloading[asset.fileName] == true;
    final progress = _downloadProgress[asset.fileName] ?? 0.0;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
      shape: RoundedRectangleBorder(
        borderRadius: ThemeDefine.kBorderRadius,
        side: BorderSide(color: theme.dividerColor.withAlpha(60)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            asset.displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: asset.exists
                                  ? Colors.green.withAlpha(30)
                                  : Colors.red.withAlpha(30),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: asset.exists
                                    ? Colors.green.withAlpha(80)
                                    : Colors.red.withAlpha(80),
                              ),
                            ),
                            child: Text(
                              asset.exists ? "Installed" : "Missing",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: asset.exists ? Colors.green.shade800 : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        asset.fileName,
                        style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: downloading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.file_download_outlined, color: Colors.blueAccent),
                  onPressed: (downloading || _isUpdatingAll)
                      ? null
                      : () => _updateSingle(asset.fileName),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              asset.description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildInfoBadge(Icons.storage_outlined, asset.formattedSize),
                const SizedBox(width: 12),
                _buildInfoBadge(Icons.access_time_outlined, asset.formattedModifiedTime),
              ],
            ),
            if (downloading) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                progress > 0 ? "${(progress * 100).toInt()}%" : "Downloading...",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAutoUpdateRulesetCard(Translations tcontext, ThemeData theme) {
    final ruleset = ClashSettingManager.getConfig().Extension?.Ruleset;
    final intervalHours = ((ruleset?.UpdateInterval ?? 2 * 24 * 3600) / 3600).round();

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
      shape: RoundedRectangleBorder(
        borderRadius: ThemeDefine.kBorderRadius,
        side: BorderSide(color: theme.dividerColor.withAlpha(60)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, size: 20, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  "Auto-Update Interval",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Background GeoX auto-update frequency: every $intervalHours hours (Clash.Meta engine).",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
