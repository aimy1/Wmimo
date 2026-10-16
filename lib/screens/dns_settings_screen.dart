// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/utils/dns_helper.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/list_add_screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class DnsSettingsScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "DnsSettingsScreen");
  }

  const DnsSettingsScreen({super.key});

  @override
  State<DnsSettingsScreen> createState() => _DnsSettingsScreenState();
}

class _DnsSettingsScreenState extends LasyRenderingState<DnsSettingsScreen> {
  final TextEditingController _testDomainController =
      TextEditingController(text: "google.com");
  bool _testingDns = false;
  DnsQueryResult? _testResult;
  bool _flushingCache = false;

  RawDNS get dns => ClashSettingManager.getConfig().DNS!;

  @override
  void dispose() {
    _testDomainController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    await ClashSettingManager.save();
    if (mounted) setState(() {});
  }

  Future<void> _flushDnsCache() async {
    setState(() => _flushingCache = true);
    final tcontext = Translations.of(context);
    final err = await ClashHttpApi.flushDnsCache();
    if (!mounted) return;
    setState(() => _flushingCache = false);

    final ok = err == null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? (tcontext.dns.flushCacheSuccess)
            : "${tcontext.meta.errorPrompt}: ${err.message}"),
        backgroundColor: ok ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorRed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _runDnsTest() async {
    final domain = _testDomainController.text.trim();
    if (domain.isEmpty) return;

    setState(() {
      _testingDns = true;
      _testResult = null;
    });

    final res = await DnsHelper.queryDnsTest(domain);
    if (!mounted) return;
    setState(() {
      _testingDns = false;
      _testResult = res;
    });
  }

  void _showApplyPresetDialog(String schemeId, String title, String desc) async {
    final tcontext = Translations.of(context);
    final confirmed = await DialogUtils.showConfirmDialog(
      context,
      "$title (${tcontext.dns.presets})\n\n$desc",
    );
    if (confirmed == true) {
      DnsHelper.applyScheme(schemeId: schemeId);
      await _saveSettings();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${tcontext.dns.updateSuccess}: $title"),
          backgroundColor: ThemeDefine.kColorGreenBright,
        ),
      );
    }
  }

  void _showAddPresetServerDialog(List<String> targetList, String listTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            final tcontext = Translations.of(context);
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${tcontext.dns.addServer} ($listTitle)",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: DnsHelper.presetServers.length,
                    itemBuilder: (context, idx) {
                      final item = DnsHelper.presetServers[idx];
                      final alreadyAdded = targetList.contains(item.address);
                      return ListTile(
                        leading: _buildProtocolBadge(item.address),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          "${item.address}\n${item.description}",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            alreadyAdded ? Icons.check_circle : Icons.add_circle_outline,
                            color: alreadyAdded ? Colors.green : Theme.of(context).primaryColor,
                          ),
                          onPressed: () async {
                            if (!alreadyAdded) {
                              targetList.add(item.address);
                              await _saveSettings();
                              Navigator.pop(ctx);
                              setState(() {});
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProtocolBadge(String server) {
    final badge = DnsHelper.getProtocolBadge(server);
    Color color;
    switch (badge) {
      case "DoH":
        color = Colors.blue;
        break;
      case "DoT":
        color = Colors.purple;
        break;
      case "DoQ":
        color = Colors.deepOrange;
        break;
      default:
        color = Colors.teal;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(100), width: 0.8),
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tcontext.meta.dns,
          style: const TextStyle(
            fontWeight: ThemeConfig.kFontWeightTitle,
            fontSize: ThemeConfig.kFontSizeTitle,
          ),
        ),
        actions: [
          IconButton(
            tooltip: tcontext.dns.flushCache,
            icon: _flushingCache
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cleaning_services_outlined),
            onPressed: _flushingCache ? null : _flushDnsCache,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _buildCoreCard(tcontext, theme),
            const SizedBox(height: 16),
            _buildPresetSchemesCard(tcontext, theme),
            const SizedBox(height: 16),
            _buildServerListsCard(tcontext, theme),
            const SizedBox(height: 16),
            _buildFakeIpFilterCard(tcontext, theme),
            const SizedBox(height: 16),
            _buildDnsQuerySandboxCard(tcontext, theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCoreCard(Translations tcontext, ThemeData theme) {
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
                const Icon(Icons.dns_outlined, size: 22, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  tcontext.meta.dns,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(tcontext.meta.overwrite, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                tcontext.dns.overwriteDesc,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              value: dns.OverWrite ?? true,
              onChanged: (val) async {
                dns.OverWrite = val;
                await _saveSettings();
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(tcontext.meta.enable, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                tcontext.dns.enableDesc,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              value: dns.Enable ?? true,
              onChanged: (val) async {
                dns.Enable = val;
                await _saveSettings();
              },
            ),
            const Divider(height: 20),
            Text(
              tcontext.dns.enhancedMode,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Fake-IP")),
                    selected: (dns.EnhancedMode ?? ClashDnsEnhancedMode.fakeIp.name) ==
                        ClashDnsEnhancedMode.fakeIp.name,
                    onSelected: (selected) async {
                      if (selected) {
                        dns.EnhancedMode = ClashDnsEnhancedMode.fakeIp.name;
                        await _saveSettings();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Redir-Host")),
                    selected: dns.EnhancedMode == ClashDnsEnhancedMode.redirHost.name,
                    onSelected: (selected) async {
                      if (selected) {
                        dns.EnhancedMode = ClashDnsEnhancedMode.redirHost.name;
                        await _saveSettings();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("Normal")),
                    selected: dns.EnhancedMode == ClashDnsEnhancedMode.normal.name,
                    onSelected: (selected) async {
                      if (selected) {
                        dns.EnhancedMode = ClashDnsEnhancedMode.normal.name;
                        await _saveSettings();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: Text("HTTP/3 (DoH3)"),
                  selected: dns.PreferH3 == true,
                  onSelected: (val) async {
                    dns.PreferH3 = val;
                    await _saveSettings();
                  },
                ),
                FilterChip(
                  label: Text("IPv6 DNS"),
                  selected: dns.IPv6 == true,
                  onSelected: (val) async {
                    dns.IPv6 = val;
                    await _saveSettings();
                  },
                ),
                FilterChip(
                  label: Text(tcontext.dns.useSystemHosts),
                  selected: dns.UseSystemHosts == true,
                  onSelected: (val) async {
                    dns.UseSystemHosts = val;
                    await _saveSettings();
                  },
                ),
                FilterChip(
                  label: Text(tcontext.dns.respectRules),
                  selected: dns.RespectRules == true,
                  onSelected: (val) async {
                    dns.RespectRules = val;
                    await _saveSettings();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetSchemesCard(Translations tcontext, ThemeData theme) {
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
                const Icon(Icons.auto_awesome, size: 20, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  tcontext.dns.presets,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPresetTile(
              icon: Icons.bolt,
              iconColor: Colors.amber,
              title: tcontext.dns.presetSpeed,
              desc: tcontext.dns.presetSpeedDesc,
              onTap: () => _showApplyPresetDialog(
                "cn_speed",
                tcontext.dns.presetSpeed,
                tcontext.dns.presetSpeedDesc,
              ),
            ),
            const SizedBox(height: 8),
            _buildPresetTile(
              icon: Icons.shield_outlined,
              iconColor: Colors.blue,
              title: tcontext.dns.presetSecure,
              desc: tcontext.dns.presetSecureDesc,
              onTap: () => _showApplyPresetDialog(
                "anti_pollution",
                tcontext.dns.presetSecure,
                tcontext.dns.presetSecureDesc,
              ),
            ),
            const SizedBox(height: 8),
            _buildPresetTile(
              icon: Icons.block,
              iconColor: Colors.teal,
              title: tcontext.dns.presetAdGuard,
              desc: tcontext.dns.presetAdGuardDesc,
              onTap: () => _showApplyPresetDialog(
                "adguard_privacy",
                tcontext.dns.presetAdGuard,
                tcontext.dns.presetAdGuardDesc,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withAlpha(60)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconColor.withAlpha(30),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildServerListsCard(Translations tcontext, ThemeData theme) {
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
                const Icon(Icons.list_alt, size: 20, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  tcontext.dns.nameServer,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildServerRow(
              title: tcontext.dns.nameServer,
              subtitle: "Nameserver",
              servers: dns.NameServer ??= [],
            ),
            const Divider(height: 16),
            _buildServerRow(
              title: tcontext.dns.fallbackNameServer,
              subtitle: "Fallback",
              servers: dns.Fallback ??= [],
            ),
            const Divider(height: 16),
            _buildServerRow(
              title: tcontext.dns.directNameServer,
              subtitle: "Direct NameServer",
              servers: dns.DirectNameServer ??= [],
            ),
            const Divider(height: 16),
            _buildServerRow(
              title: tcontext.dns.defaultNameServer,
              subtitle: "Default NameServer",
              servers: dns.DefaultNameserver ??= [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerRow({
    required String title,
    required String subtitle,
    required List<String> servers,
  }) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            settings: ListAddScreen.routSettings(subtitle),
            builder: (context) => ListAddScreen(
              title: title,
              data: servers,
              onChanged: (_) => _saveSettings(),
            ),
          ),
        );
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    "${servers.length} configured ($subtitle)",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.playlist_add, color: Colors.blue),
              tooltip: "Add Preset Server",
              onPressed: () => _showAddPresetServerDialog(servers, title),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFakeIpFilterCard(Translations tcontext, ThemeData theme) {
    dns.FakeIPFilter ??= [];
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
                Row(
                  children: [
                    const Icon(Icons.filter_alt_outlined, size: 20, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Text(
                      tcontext.dns.fakeIPFilter,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.restore, size: 16),
                  label: Text(tcontext.dns.resetFakeIpFilter, style: const TextStyle(fontSize: 12)),
                  onPressed: () async {
                    final confirmed = await DialogUtils.showConfirmDialog(
                      context,
                      "${tcontext.dns.resetFakeIpFilter}\n\n${tcontext.dns.resetFakeIpFilterConfirm}",
                    );
                    if (confirmed == true) {
                      DnsHelper.resetFakeIpFilterToDefaults();
                      await _saveSettings();
                    }
                  },
                ),
              ],
            ),
            Text(
              "${dns.FakeIPFilter!.length} domain rules bypass Fake-IP resolution to avoid network isolation issues.",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.edit_note, size: 20),
              label: Text("Manage Filter List (${dns.FakeIPFilter!.length})"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: ListAddScreen.routSettings("FakeIPFilter"),
                    builder: (context) => ListAddScreen(
                      title: tcontext.dns.fakeIPFilter,
                      data: dns.FakeIPFilter!,
                      onChanged: (_) => _saveSettings(),
                    ),
                  ),
                );
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDnsQuerySandboxCard(Translations tcontext, ThemeData theme) {
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
                const Icon(Icons.troubleshoot, size: 20, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  tcontext.dns.dnsTester,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _testDomainController,
                    decoration: InputDecoration(
                      hintText: "e.g. google.com or bilibili.com",
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: _testingDns ? null : _runDnsTest,
                  child: _testingDns
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(tcontext.dns.testQuery),
                ),
              ],
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testResult!.success
                      ? Colors.green.withAlpha(20)
                      : Colors.red.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _testResult!.success
                        ? Colors.green.withAlpha(80)
                        : Colors.red.withAlpha(80),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _testResult!.domain,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _testResult!.isFakeIp
                                    ? Colors.amber.withAlpha(40)
                                    : Colors.blue.withAlpha(40),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _testResult!.isFakeIp
                                    ? tcontext.dns.fakeIpDetected
                                    : tcontext.dns.realIpDetected,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _testResult!.isFakeIp
                                      ? Colors.amber.shade900
                                      : Colors.blue.shade900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${_testResult!.latencyMs} ms",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (_testResult!.ips.isNotEmpty)
                      Text(
                        _testResult!.ips.join(", "),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                      )
                    else if (_testResult!.error != null)
                      Text(
                        "${tcontext.meta.errorPrompt}: ${_testResult!.error}",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
