// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/utils/geo_asset_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class GeoAssetsScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "GeoAssetsScreen");
  }

  const GeoAssetsScreen({super.key});

  @override
  State<GeoAssetsScreen> createState() => _GeoAssetsScreenState();
}

class _GeoAssetsScreenState extends LasyRenderingState<GeoAssetsScreen> {
  static const List<int> _kIntervalHourOptions = [24, 48, 72, 168];

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
        content: Text(
          success
              ? "$fileName: ${tcontext.dns.updateSuccess}"
              : "$fileName: ${tcontext.dns.updateFailed}",
        ),
        backgroundColor:
            success ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorRed,
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
        content: Text(
          allOk
              ? tcontext.dns.updateSuccess
              : "${tcontext.dns.updateSuccess}: ${results.values.where((v) => v).length}/${results.length}",
        ),
        backgroundColor:
            allOk ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorAmber,
      ),
    );

    await _loadAssets();
  }

  String _localizedSourceName(GeoCdnSource source, Translations tcontext) {
    switch (source.id) {
      case "jsdelivr":
        return tcontext.dns.cdnJsdelivrName;
      case "fastgit":
        return tcontext.dns.cdnFastgitName;
      case "github":
      default:
        return tcontext.dns.cdnGithubName;
    }
  }

  String _localizedSourceDesc(GeoCdnSource source, Translations tcontext) {
    switch (source.id) {
      case "jsdelivr":
        return tcontext.dns.cdnJsdelivrDesc;
      case "fastgit":
        return tcontext.dns.cdnFastgitDesc;
      case "github":
      default:
        return tcontext.dns.cdnGithubDesc;
    }
  }

  String _localizedAssetName(GeoAssetInfo asset, Translations tcontext) {
    switch (asset.fileName) {
      case "geosite.dat":
        return tcontext.dns.assetGeositeName;
      case "geoip.dat":
        return tcontext.dns.assetGeoipName;
      case "country.mmdb":
        return tcontext.dns.assetCountryName;
      case "ASN.mmdb":
        return tcontext.dns.assetAsnName;
      default:
        return asset.displayName;
    }
  }

  String _localizedAssetDesc(GeoAssetInfo asset, Translations tcontext) {
    switch (asset.fileName) {
      case "geosite.dat":
        return tcontext.dns.assetGeositeDesc;
      case "geoip.dat":
        return tcontext.dns.assetGeoipDesc;
      case "country.mmdb":
        return tcontext.dns.assetCountryDesc;
      case "ASN.mmdb":
        return tcontext.dns.assetAsnDesc;
      default:
        return asset.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.dns.geoAssetsTitle,
        actions: [
          IconButton(
            tooltip: tcontext.dns.updateAll,
            icon: _isUpdatingAll
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded, size: 20),
            onPressed: _isUpdatingAll ? null : _updateAll,
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                children: [
                  _buildSourceSelectorCard(tcontext, theme, isDark),
                  const SizedBox(height: 12),
                  ..._assets.map(
                    (asset) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildAssetCard(
                        asset,
                        tcontext,
                        theme,
                        isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildAutoUpdateRulesetCard(tcontext, theme, isDark),
                ],
              ),
      ),
    );
  }

  Widget _buildSourceSelectorCard(
    Translations tcontext,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                size: 19,
                color: ThemeDefine.kColorBlue,
              ),
              const SizedBox(width: 8),
              Text(
                tcontext.dns.cdnSource,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            tcontext.dns.geoAssetsDesc,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: GeoAssetManager.cdnSources.map((source) {
              final isSelected = _selectedSourceId == source.id;
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedSourceId = source.id);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3.5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? ThemeDefine.kColorBlue.withValues(alpha: 0.6)
                          : (isDark
                              ? ThemeDefine.kColorDarkBorder
                              : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.2 : 0.8,
                    ),
                    color: isSelected
                        ? ThemeDefine.kColorBlue
                            .withValues(alpha: isDark ? 0.16 : 0.08)
                        : (isDark
                            ? ThemeDefine.kColorDarkInner
                            : const Color(0xFFF8FAFC)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected
                            ? ThemeDefine.kColorBlue
                            : ThemeDefine.kColorGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _localizedSourceName(source, tcontext),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isSelected
                                    ? ThemeDefine.kColorBlue
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              _localizedSourceDesc(source, tcontext),
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.58),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeDefine.kColorBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: _isUpdatingAll
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download_for_offline_outlined, size: 18),
            label: Text(
              tcontext.dns.updateAll,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: _isUpdatingAll ? null : _updateAll,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(
    GeoAssetInfo asset,
    Translations tcontext,
    ThemeData theme,
    bool isDark,
  ) {
    final downloading = _isDownloading[asset.fileName] == true;
    final progress = _downloadProgress[asset.fileName] ?? 0.0;
    final statusColor =
        asset.exists ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorRed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _localizedAssetName(asset, tcontext),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            asset.exists
                                ? tcontext.dns.geoInstalled
                                : tcontext.dns.geoNotInstalled,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      asset.fileName,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: tcontext.meta.update,
                icon: downloading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.file_download_outlined,
                        color: ThemeDefine.kColorBlue,
                      ),
                onPressed: (downloading || _isUpdatingAll)
                    ? null
                    : () => _updateSingle(asset.fileName),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _localizedAssetDesc(asset, tcontext),
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildInfoBadge(
                Icons.storage_outlined,
                (!asset.exists || asset.sizeBytes <= 0)
                    ? tcontext.dns.geoNotInstalled
                    : asset.formattedSize,
                theme,
              ),
              const SizedBox(width: 14),
              _buildInfoBadge(
                Icons.access_time_outlined,
                asset.modifiedTime == null
                    ? tcontext.dns.geoNeverUpdated
                    : asset.formattedModifiedTime,
                theme,
              ),
            ],
          ),
          if (downloading) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                minHeight: 5,
                color: ThemeDefine.kColorBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              progress > 0
                  ? "${(progress * 100).toInt()}%"
                  : tcontext.dns.geoDownloading,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, ThemeData theme) {
    final color = theme.colorScheme.onSurface.withValues(alpha: 0.55);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.5, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontFamily: 'monospace',
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAutoUpdateRulesetCard(
    Translations tcontext,
    ThemeData theme,
    bool isDark,
  ) {
    final ruleset = ClashSettingManager.getConfig().Extension?.Ruleset;
    final currentHours =
        ((ruleset?.UpdateInterval ?? 2 * 24 * 3600) / 3600).round();
    final enableProxy = ruleset?.EnableProxy ?? false;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 19,
                color: ThemeDefine.kColorBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tcontext.meta.updateInterval,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Wrap(
                spacing: 6,
                children: _kIntervalHourOptions.map((hours) {
                  final selected = currentHours == hours;
                  final label = hours >= 168
                      ? tcontext.dns.geoIntervalDays(p: (hours ~/ 24).toString())
                      : tcontext.dns.geoIntervalHours(p: hours.toString());
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      if (ruleset == null) return;
                      HapticFeedback.selectionClick();
                      setState(() {
                        ruleset.UpdateInterval = hours * 3600;
                      });
                      await ClashSettingManager.save();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? ThemeDefine.kColorBlue
                            : (isDark
                                ? ThemeDefine.kColorDarkInner
                                : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            height: 1,
            color: isDark
                ? ThemeDefine.kColorDarkBorder
                : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  tcontext.meta.geoDownloadByProxy,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: Transform.scale(
                  scale: 0.84,
                  alignment: Alignment.centerRight,
                  child: Switch.adaptive(
                    value: enableProxy,
                    activeThumbColor: Colors.white,
                    activeTrackColor: ThemeDefine.kColorBlue,
                    onChanged: (val) async {
                      if (ruleset == null) return;
                      HapticFeedback.selectionClick();
                      setState(() {
                        ruleset.EnableProxy = val;
                      });
                      await ClashSettingManager.save();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
