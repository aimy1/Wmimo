///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$WelcomeLanguageScreen$en WelcomeLanguageScreen = Translations$WelcomeLanguageScreen$en._(_root);
	late final Translations$BackupAndSyncWebdavScreen$en BackupAndSyncWebdavScreen = Translations$BackupAndSyncWebdavScreen$en._(_root);
	late final Translations$LaunchFailedScreen$en LaunchFailedScreen = Translations$LaunchFailedScreen$en._(_root);
	late final Translations$PerAppAndroidScreen$en PerAppAndroidScreen = Translations$PerAppAndroidScreen$en._(_root);
	late final Translations$UserAgreementScreen$en UserAgreementScreen = Translations$UserAgreementScreen$en._(_root);
	late final Translations$VersionUpdateScreen$en VersionUpdateScreen = Translations$VersionUpdateScreen$en._(_root);
	late final Translations$NetCheckScreen$en NetCheckScreen = Translations$NetCheckScreen$en._(_root);
	late final Translations$SpeedTestScreen$en SpeedTestScreen = Translations$SpeedTestScreen$en._(_root);
	late final Translations$loginScreen$en loginScreen = Translations$loginScreen$en._(_root);
	late final Translations$main$en main = Translations$main$en._(_root);
	late final Translations$meta$en meta = Translations$meta$en._(_root);
	late final Translations$permission$en permission = Translations$permission$en._(_root);
	late final Translations$tls$en tls = Translations$tls$en._(_root);
	late final Translations$tun$en tun = Translations$tun$en._(_root);
	late final Translations$dns$en dns = Translations$dns$en._(_root);
	late final Translations$sniffer$en sniffer = Translations$sniffer$en._(_root);
	late final Translations$profilePatchMode$en profilePatchMode = Translations$profilePatchMode$en._(_root);

	/// en: 'Protocol Sniff'
	String get protocolSniff => 'Protocol Sniff';

	/// en: 'The Sniff domain name override the connection target address'
	String get protocolSniffOverrideDestination => 'The Sniff domain name override the connection target address';

	/// en: 'The current device has not installed the Edge WebView2 runtime, so the page cannot be displayed. Please download and install the Edge WebView2 runtime (x64), restart the App and try again.'
	String get edgeRuntimeNotInstalled => 'The current device has not installed the Edge WebView2 runtime, so the page cannot be displayed. Please download and install the Edge WebView2 runtime (x64), restart the App and try again.';

	Map<String, String> get locales => {
		'en': 'English',
		'zh-CN': '简体中文',
		'zh-TW': '繁體中文',
		'ja': '日本語',
		'ko': '한국어',
		'ar': 'العربية',
		'ru': 'Русский',
		'fa': 'فارسی',
		'es': 'Español',
	};
}

// Path: WelcomeLanguageScreen
class Translations$WelcomeLanguageScreen$en {
	Translations$WelcomeLanguageScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome to Wmimo'
	String get welcomeTitle => 'Welcome to Wmimo';

	/// en: 'Select Language'
	String get selectLanguage => 'Select Language';

	/// en: 'Please select your preferred language. You can change it anytime in settings.'
	String get subtitle => 'Please select your preferred language. You can change it anytime in settings.';

	/// en: 'Get Started'
	String get start => 'Get Started';
}

// Path: BackupAndSyncWebdavScreen
class Translations$BackupAndSyncWebdavScreen$en {
	Translations$BackupAndSyncWebdavScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Server Url'
	String get webdavServerUrl => 'Server Url';

	/// en: 'Can not be empty'
	String get webdavRequired => 'Can not be empty';

	/// en: 'Login failed:'
	String get webdavLoginFailed => 'Login failed:';

	/// en: 'Failed to get file list:'
	String get webdavListFailed => 'Failed to get file list:';
}

// Path: LaunchFailedScreen
class Translations$LaunchFailedScreen$en {
	Translations$LaunchFailedScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'The app failed to start [Invalid process name], please reinstall the app to a separate directory'
	String get invalidProcess => 'The app failed to start [Invalid process name], please reinstall the app to a separate directory';

	/// en: 'The app failed to start [Failed to access the profile], please reinstall the app'
	String get invalidProfile => 'The app failed to start [Failed to access the profile], please reinstall the app';

	/// en: 'The app failed to start [Invalid version], please reinstall the app'
	String get invalidVersion => 'The app failed to start [Invalid version], please reinstall the app';

	/// en: 'The app failed to start [system version too low]'
	String get systemVersionLow => 'The app failed to start [system version too low]';

	/// en: 'The installation path is invalid, please reinstall it to a valid path'
	String get invalidInstallPath => 'The installation path is invalid, please reinstall it to a valid path';
}

// Path: PerAppAndroidScreen
class Translations$PerAppAndroidScreen$en {
	Translations$PerAppAndroidScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Per-App Proxy'
	String get title => 'Per-App Proxy';

	/// en: 'Whitelist Mode'
	String get whiteListMode => 'Whitelist Mode';

	/// en: 'When enabled: only the apps that have been checked are proxies; when not enabled: only the apps that are not checked are proxies'
	String get whiteListModeTip => 'When enabled: only the apps that have been checked are proxies; when not enabled: only the apps that are not checked are proxies';

	/// en: 'Manually Add Package Name'
	String get manualAddPackage => 'Manually Add Package Name';

	/// en: 'Enter package names to proxy (multiple supported, separated by spaces, commas or newlines, e.g.: org.telegram.messenger, com.google.android.youtube):'
	String get manualAddPackageHint => 'Enter package names to proxy (multiple supported, separated by spaces, commas or newlines, e.g.: org.telegram.messenger, com.google.android.youtube):';

	/// en: 'Quick Add Common Proxy Apps'
	String get quickAddPresets => 'Quick Add Common Proxy Apps';

	/// en: 'Save Selected'
	String get saveSelected => 'Save Selected';

	/// en: 'The system restricted reading the app list. Please tap 【Open System Permission Settings】 below to enable 'Get installed apps', or use preset apps directly without permission.'
	String get permissionRestrictedTip => 'The system restricted reading the app list. Please tap 【Open System Permission Settings】 below to enable \'Get installed apps\', or use preset apps directly without permission.';

	/// en: 'Open System Permission Settings'
	String get openSystemPermission => 'Open System Permission Settings';

	/// en: 'Quick Add Common Apps (Preset)'
	String get presetApps => 'Quick Add Common Apps (Preset)';

	/// en: 'Request Permission (System Dialog)'
	String get requestPermissionPopup => 'Request Permission (System Dialog)';
}

// Path: UserAgreementScreen
class Translations$UserAgreementScreen$en {
	Translations$UserAgreementScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your Privacy Comes First'
	String get privacyFirst => 'Your Privacy Comes First';

	/// en: 'Accept & Continue'
	String get agreeAndContinue => 'Accept & Continue';
}

// Path: VersionUpdateScreen
class Translations$VersionUpdateScreen$en {
	Translations$VersionUpdateScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'The new version[$p] is ready'
	String versionReady({required Object p}) => 'The new version[${p}] is ready';

	/// en: 'Restart To Update'
	String get update => 'Restart To Update';

	/// en: 'Not Now'
	String get cancel => 'Not Now';
}

// Path: NetCheckScreen
class Translations$NetCheckScreen$en {
	Translations$NetCheckScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Network Diagnostics'
	String get title => 'Network Diagnostics';

	/// en: 'Full Diagnostics'
	String get fullDiagnosticsTab => 'Full Diagnostics';

	/// en: 'Advanced Domain Query'
	String get advancedCheckTab => 'Advanced Domain Query';

	/// en: 'Start Diagnostics'
	String get startDiagnostics => 'Start Diagnostics';

	/// en: 'Retest'
	String get reDiagnostics => 'Retest';

	/// en: 'Diagnosing network pipeline...'
	String get diagnosing => 'Diagnosing network pipeline...';

	/// en: 'Health Score'
	String get healthScore => 'Health Score';

	/// en: 'Excellent'
	String get scorePerfect => 'Excellent';

	/// en: 'Good'
	String get scoreGood => 'Good';

	/// en: 'Warning'
	String get scoreWarning => 'Warning';

	/// en: 'Blocked'
	String get scoreCritical => 'Blocked';

	/// en: 'One-Click Auto Repair'
	String get oneClickRepair => 'One-Click Auto Repair';

	/// en: 'Auto-repair succeeded, network restored'
	String get repairSuccess => 'Auto-repair succeeded, network restored';

	/// en: 'Repair applied, manual verification may be needed'
	String get repairFailed => 'Repair applied, manual verification may be needed';

	/// en: 'Executing auto-repair...'
	String get repairing => 'Executing auto-repair...';

	/// en: '$count issue(s) found'
	String issueFound({required Object count}) => '${count} issue(s) found';

	/// en: 'All checks passed'
	String get noIssue => 'All checks passed';

	/// en: 'Technical Details'
	String get details => 'Technical Details';

	/// en: 'Copy Details'
	String get copyDetails => 'Copy Details';

	/// en: 'Diagnostic log copied to clipboard'
	String get detailsCopied => 'Diagnostic log copied to clipboard';

	/// en: 'Physical Network & Gateway'
	String get stepPhysical => 'Physical Network & Gateway';

	/// en: 'DNS & Fake-IP Engine'
	String get stepDns => 'DNS & Fake-IP Engine';

	/// en: 'Core Process & Ports'
	String get stepCore => 'Core Process & Ports';

	/// en: 'System Proxy Configuration'
	String get stepProxy => 'System Proxy Configuration';

	/// en: 'Internet End-to-End Handshake'
	String get stepHandshake => 'Internet End-to-End Handshake';

	/// en: 'Suggestion'
	String get suggestedAction => 'Suggestion';

	/// en: 'Repair Now'
	String get autoRepairAction => 'Repair Now';

	/// en: 'Please enter a domain'
	String get enterDomain => 'Please enter a domain';

	/// en: 'Checking...'
	String get checking => 'Checking...';

	/// en: 'A query failed: $p'
	String aQueryFailed({required Object p}) => 'A query failed: ${p}';

	/// en: 'AAAA query failed: $p'
	String aaaaQueryFailed({required Object p}) => 'AAAA query failed: ${p}';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'Failed'
	String get failed => 'Failed';

	/// en: 'Suspected DNS poisoning'
	String get suspectedPollution => 'Suspected DNS poisoning';

	/// en: 'Domain'
	String get domainLabel => 'Domain';

	/// en: 'Check'
	String get checkButton => 'Check';

	/// en: '1. DNS Query'
	String get dnsSection => '1. DNS Query';

	/// en: '2. HTTP (via TUN, enable TUN first)'
	String get directHttpSection => '2. HTTP (via TUN, enable TUN first)';

	/// en: '3. HTTP (via Proxy, port: $p)'
	String proxyHttpSection({required Object p}) => '3. HTTP (via Proxy, port: ${p})';

	/// en: 'TUN is not enabled'
	String get tunNotEnabled => 'TUN is not enabled';

	/// en: '4. Route Table'
	String get routeTableSection => '4. Route Table';

	/// en: 'Checks physical network adapter, local IP, and gateway connectivity'
	String get stepPhysicalDesc => 'Checks physical network adapter, local IP, and gateway connectivity';

	/// en: 'Verifies local DNS resolution latency and core DNS engine status'
	String get stepDnsDesc => 'Verifies local DNS resolution latency and core DNS engine status';

	/// en: 'Checks Mihomo process status and Mixed-Port / API listening ports'
	String get stepCoreDesc => 'Checks Mihomo process status and Mixed-Port / API listening ports';

	/// en: 'Verifies system proxy settings and checks for residual zombie proxy settings'
	String get stepProxyDesc => 'Verifies system proxy settings and checks for residual zombie proxy settings';

	/// en: 'Tests end-to-end latency and reachability to global CDN via active node'
	String get stepHandshakeDesc => 'Tests end-to-end latency and reachability to global CDN via active node';

	/// en: 'NIC'
	String get shortStepPhysical => 'NIC';

	/// en: 'DNS'
	String get shortStepDns => 'DNS';

	/// en: 'Core'
	String get shortStepCore => 'Core';

	/// en: 'Proxy'
	String get shortStepProxy => 'Proxy';

	/// en: 'WAN'
	String get shortStepHandshake => 'WAN';

	/// en: 'Network connected ($p)'
	String valNicNormal({required Object p}) => 'Network connected (${p})';

	/// en: 'No available network interfaces found'
	String get valNicNone => 'No available network interfaces found';

	/// en: 'Local IP acquired, but external gateway timed out'
	String get valNicGatewayTimeout => 'Local IP acquired, but external gateway timed out';

	/// en: 'Network interface check error'
	String get valNicError => 'Network interface check error';

	/// en: 'DNS response normal ($p)'
	String valDnsNormal({required Object p}) => 'DNS response normal (${p})';

	/// en: 'DNS query returned empty list'
	String get valDnsEmpty => 'DNS query returned empty list';

	/// en: 'DNS query timed out or failed'
	String get valDnsTimeout => 'DNS query timed out or failed';

	/// en: 'Core healthy (Mixed Port: $port, Mode: $mode)'
	String valCoreNormal({required Object port, required Object mode}) => 'Core healthy (Mixed Port: ${port}, Mode: ${mode})';

	/// en: 'Core service is not running'
	String get valCoreNotRunning => 'Core service is not running';

	/// en: 'Port $p is occupied by another program'
	String valCorePortConflict({required Object p}) => 'Port ${p} is occupied by another program';

	/// en: 'Core unresponsive (API communication failed)'
	String get valCoreApiFailed => 'Core unresponsive (API communication failed)';

	/// en: 'Core check error'
	String get valCoreError => 'Core check error';

	/// en: 'System proxy active (127.0.0.1:$port)'
	String valProxyActive({required Object port}) => 'System proxy active (127.0.0.1:${port})';

	/// en: 'System proxy disabled (Direct / TUN / Manual mode)'
	String get valProxyDisabled => 'System proxy disabled (Direct / TUN / Manual mode)';

	/// en: 'Residual system proxy detected (blocking internet)'
	String get valProxyZombie => 'Residual system proxy detected (blocking internet)';

	/// en: 'System proxy failed to enable'
	String get valProxyFailed => 'System proxy failed to enable';

	/// en: 'System proxy status warning'
	String get valProxyWarning => 'System proxy status warning';

	/// en: 'Internet handshake normal ($node • $delay ms)'
	String valHandshakeNormal({required Object node, required Object delay}) => 'Internet handshake normal (${node} • ${delay} ms)';

	/// en: 'Current node [$node] handshake failed ($err)'
	String valHandshakeFailed({required Object node, required Object err}) => 'Current node [${node}] handshake failed (${err})';

	/// en: 'Core not started, skipped internet handshake test'
	String get valHandshakeSkipped => 'Core not started, skipped internet handshake test';

	/// en: 'Internet handshake error'
	String get valHandshakeError => 'Internet handshake error';

	/// en: 'Network card not connected to any network (cable unplugged, Wi-Fi off, or airplane mode)'
	String get issueNicDisconnected => 'Network card not connected to any network (cable unplugged, Wi-Fi off, or airplane mode)';

	/// en: 'Please check your Ethernet cable, Wi-Fi connection, or network adapter status'
	String get suggestNicCheck => 'Please check your Ethernet cable, Wi-Fi connection, or network adapter status';

	/// en: 'Try disabling and re-enabling the network adapter in system settings'
	String get suggestNicReset => 'Try disabling and re-enabling the network adapter in system settings';

	/// en: 'Connected to LAN, but external gateway unreachable (captive portal, login required, or router offline)'
	String get issueNicGatewayUnreachable => 'Connected to LAN, but external gateway unreachable (captive portal, login required, or router offline)';

	/// en: 'Check router status or open browser to complete captive portal / Web authentication'
	String get suggestNicGateway => 'Check router status or open browser to complete captive portal / Web authentication';

	/// en: 'Local DNS service not responding; possible DNS pollution or gateway hijacking'
	String get issueDnsPollution => 'Local DNS service not responding; possible DNS pollution or gateway hijacking';

	/// en: 'Reset system DNS or enable Smart Encrypted DNS (DoH/DoT) in Wmimo'
	String get suggestDnsReset => 'Reset system DNS or enable Smart Encrypted DNS (DoH/DoT) in Wmimo';

	/// en: 'Flush System DNS Cache'
	String get actionFlushDns => 'Flush System DNS Cache';

	/// en: 'DNS latency is high; consider enabling Smart Encrypted DNS'
	String get suggestDnsSlow => 'DNS latency is high; consider enabling Smart Encrypted DNS';

	/// en: 'Local DNS resolution failed; unable to resolve domain names to IP addresses'
	String get issueDnsFailed => 'Local DNS resolution failed; unable to resolve domain names to IP addresses';

	/// en: 'Click to flush DNS cache, or enable encrypted DNS in Wmimo settings'
	String get suggestDnsFlush => 'Click to flush DNS cache, or enable encrypted DNS in Wmimo settings';

	/// en: 'Port conflict detected! Another proxy app or service is occupying the port'
	String get issueCorePortConflict => 'Port conflict detected! Another proxy app or service is occupying the port';

	/// en: 'Close other proxy clients completely, or change the port in Wmimo settings'
	String get suggestCoreChangePort => 'Close other proxy clients completely, or change the port in Wmimo settings';

	/// en: 'Restart Core'
	String get actionRestartCore => 'Restart Core';

	/// en: 'Wmimo core process is currently stopped'
	String get issueCoreStopped => 'Wmimo core process is currently stopped';

	/// en: 'Click the connect switch on the home screen or click Start Core below'
	String get suggestCoreStart => 'Click the connect switch on the home screen or click Start Core below';

	/// en: 'Start Core Process'
	String get actionStartCore => 'Start Core Process';

	/// en: 'Core process is unresponsive or API authentication mismatched'
	String get issueCoreFrozen => 'Core process is unresponsive or API authentication mismatched';

	/// en: 'Restart the core to recover service'
	String get suggestCoreRestart => 'Restart the core to recover service';

	/// en: 'Try restarting the core or reinstalling service drivers'
	String get suggestCoreReinstall => 'Try restarting the core or reinstalling service drivers';

	/// en: 'Residual system proxy forwards traffic to an inactive port, causing internet loss'
	String get issueProxyZombie => 'Residual system proxy forwards traffic to an inactive port, causing internet loss';

	/// en: 'Click Clean & Reset System Proxy below to immediately restore internet access'
	String get suggestProxyReset => 'Click Clean & Reset System Proxy below to immediately restore internet access';

	/// en: 'Clean & Reset System Proxy'
	String get actionResetProxy => 'Clean & Reset System Proxy';

	/// en: 'System proxy not applied, possibly blocked by antivirus or permission limits'
	String get issueProxyBlocked => 'System proxy not applied, possibly blocked by antivirus or permission limits';

	/// en: 'Click below to re-register and force apply system proxy'
	String get suggestProxyReapply => 'Click below to re-register and force apply system proxy';

	/// en: 'Re-apply System Proxy'
	String get actionReapplyProxy => 'Re-apply System Proxy';

	/// en: 'Non-fatal exception reading system proxy settings'
	String get issueProxyRead => 'Non-fatal exception reading system proxy settings';

	/// en: 'Current proxy node cannot connect to internet; handshake failed or blocked'
	String get issueHandshakeBlocked => 'Current proxy node cannot connect to internet; handshake failed or blocked';

	/// en: 'Node may be down or unreachable; please switch to another node'
	String get suggestHandshakeSwitch => 'Node may be down or unreachable; please switch to another node';

	/// en: 'High node latency ($delay ms); consider testing and selecting a closer node'
	String suggestHandshakeSlow({required Object delay}) => 'High node latency (${delay} ms); consider testing and selecting a closer node';

	/// en: 'Check node configuration or change latency test target'
	String get suggestHandshakeCheck => 'Check node configuration or change latency test target';

	/// en: 'Pipeline excellent! All network nodes and proxy configs are fully operational.'
	String get conclusionPerfect => 'Pipeline excellent! All network nodes and proxy configs are fully operational.';

	/// en: 'Pipeline generally normal, minor non-critical latency or warnings detected.'
	String get conclusionGood => 'Pipeline generally normal, minor non-critical latency or warnings detected.';

	/// en: 'Issues detected in network or proxy pipeline; please use One-Click Repair below.'
	String get conclusionWarning => 'Issues detected in network or proxy pipeline; please use One-Click Repair below.';

	/// en: 'Severe network blockage! Local network disconnected or proxy core blocked.'
	String get conclusionCritical => 'Severe network blockage! Local network disconnected or proxy core blocked.';
}

// Path: SpeedTestScreen
class Translations$SpeedTestScreen$en {
	Translations$SpeedTestScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Speed Test'
	String get title => 'Speed Test';

	/// en: 'Start Test'
	String get startTest => 'Start Test';

	/// en: 'Stop Test'
	String get stopTest => 'Stop Test';

	/// en: 'Retest'
	String get reTest => 'Retest';

	/// en: 'Ready'
	String get ready => 'Ready';

	/// en: 'Testing Ping & Jitter...'
	String get testingPing => 'Testing Ping & Jitter...';

	/// en: 'Testing Download Speed...'
	String get testingDownload => 'Testing Download Speed...';

	/// en: 'Testing Upload Speed...'
	String get testingUpload => 'Testing Upload Speed...';

	/// en: 'Test Completed'
	String get completed => 'Test Completed';

	/// en: 'Stopped'
	String get stopped => 'Stopped';

	/// en: 'Ping'
	String get ping => 'Ping';

	/// en: 'Jitter'
	String get jitter => 'Jitter';

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'Upload'
	String get upload => 'Upload';

	/// en: 'Current Proxy'
	String get currentProxy => 'Current Proxy';

	/// en: 'Direct Mode'
	String get directConnection => 'Direct Mode';

	/// en: 'Speed Test Server'
	String get server => 'Speed Test Server';

	/// en: 'Server Location'
	String get serverLocation => 'Server Location';

	/// en: 'Real-time Speed Curve'
	String get realtimeSpeed => 'Real-time Speed Curve';

	/// en: 'Peak Speed'
	String get peakSpeed => 'Peak Speed';

	/// en: 'Avg Speed'
	String get avgSpeed => 'Avg Speed';

	/// en: 'History'
	String get testHistory => 'History';

	/// en: 'Clear History'
	String get clearHistory => 'Clear History';
}

// Path: loginScreen
class Translations$loginScreen$en {
	Translations$loginScreen$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Register Account'
	String get register => 'Register Account';

	/// en: 'Forgot Password'
	String get forgotPassword => 'Forgot Password';

	/// en: 'Provider'
	String get provider => 'Provider';

	/// en: 'Provider Code/Alias/URL'
	String get providerName => '${_root.loginScreen.provider} Code/Alias/URL';

	/// en: 'Please enter the Provider code/alias/URL'
	String get providerNameRequired => 'Please enter the ${_root.loginScreen.provider} code/alias/URL';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Please enter account'
	String get accountRequired => 'Please enter account';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Please enter email address'
	String get emailRequired => 'Please enter email address';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Please enter password'
	String get passwordRequired => 'Please enter password';

	/// en: 'Please enter valid email address'
	String get validEmailRequired => 'Please enter valid email address';

	/// en: 'Password length at least $minLength characters'
	String passwordMinLength({required Object minLength}) => 'Password length at least ${minLength} characters';

	/// en: 'Unsupported Provider'
	String get unsupportedProvider => 'Unsupported ${_root.loginScreen.provider}';

	/// en: 'Unsupported Provider type'
	String get unsupportedProviderType => 'Unsupported ${_root.loginScreen.provider} type';

	/// en: 'Login feature is not activated'
	String get unActivedProvider => 'Login feature is not activated';

	/// en: 'Please request the provider code/alias from your Provider. For Provider integration, please refer to: $p'
	String providerLoginSupportRequired({required Object p}) => 'Please request the provider code/alias from your ${_root.loginScreen.provider}.\nFor ${_root.loginScreen.provider} integration, please refer to: ${p}';

	/// en: 'Disclaimer: Provider is a third-party service and is not affiliated with this app'
	String get providerDisclaimer => 'Disclaimer: ${_root.loginScreen.provider} is a third-party service and is not affiliated with this app';

	/// en: 'Failed to create session, check provider or account'
	String get createSessionFailed => 'Failed to create session, check provider or account';
}

// Path: main
class Translations$main$en {
	Translations$main$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$main$tray$en tray = Translations$main$tray$en._(_root);
}

// Path: meta
class Translations$meta$en {
	Translations$meta$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enable'
	String get enable => 'Enable';

	/// en: 'Disable'
	String get disable => 'Disable';

	/// en: 'Open'
	String get open => 'Open';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Quit'
	String get quit => 'Quit';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Added successfully'
	String get addSuccess => 'Added successfully';

	/// en: 'Add failed:$p'
	String addFailed({required Object p}) => 'Add failed:${p}';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Are you sure to delete?'
	String get removeConfirm => 'Are you sure to delete?';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'View'
	String get view => 'View';

	/// en: 'Remark'
	String get remark => 'Remark';

	/// en: 'Default'
	String get byDefault => 'Default';

	/// en: 'Edit Remark'
	String get editRemark => 'Edit Remark';

	/// en: 'More'
	String get more => 'More';

	/// en: 'Info'
	String get tips => 'Info';

	/// en: 'Select All'
	String get selectAll => 'Select All';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Paste'
	String get paste => 'Paste';

	/// en: 'Cut'
	String get cut => 'Cut';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Ok'
	String get ok => 'Ok';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'FAQ'
	String get faq => 'FAQ';

	/// en: 'Document'
	String get doc => 'Document';

	/// en: 'HTML Toolset'
	String get htmlTools => 'HTML Toolset';

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Days'
	String get days => 'Days';

	/// en: 'Hours'
	String get hours => 'Hours';

	/// en: 'Minutes'
	String get minutes => 'Minutes';

	/// en: 'Seconds'
	String get seconds => 'Seconds';

	/// en: 'Milliseconds'
	String get milliseconds => 'Milliseconds';

	/// en: 'Protocol'
	String get protocol => 'Protocol';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Custom'
	String get custom => 'Custom';

	/// en: 'Connect'
	String get connect => 'Connect';

	/// en: 'Disconnect'
	String get disconnect => 'Disconnect';

	/// en: 'Connected'
	String get connected => 'Connected';

	/// en: 'Disconnected'
	String get disconnected => 'Disconnected';

	/// en: 'Connecting'
	String get connecting => 'Connecting';

	/// en: 'Connect Timeout'
	String get connectTimeout => 'Connect Timeout';

	/// en: 'Timeout'
	String get timeout => 'Timeout';

	/// en: 'Timeout Duration'
	String get timeoutDuration => 'Timeout Duration';

	/// en: 'Latency'
	String get latency => 'Latency';

	/// en: 'Latency Test'
	String get latencyTest => 'Latency Test';

	/// en: 'Network Check'
	String get networkCheck => 'Network Check';

	/// en: 'Speed Test'
	String get speedTest => 'Speed Test';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Retry?'
	String get retry => 'Retry?';

	/// en: 'Update'
	String get update => 'Update';

	/// en: 'Update interval'
	String get updateInterval => 'Update interval';

	/// en: 'Update failed:$p'
	String updateFailed({required Object p}) => 'Update failed:${p}';

	/// en: 'Minimum: 5m'
	String get updateInterval5mTips => 'Minimum: 5m';

	/// en: 'Prefer provider settings'
	String get updateIntervalPreferByProfile => 'Prefer provider settings';

	/// en: 'None'
	String get none => 'None';

	/// en: 'Reset'
	String get reset => 'Reset';

	/// en: 'Are you sure you want to reset all app settings?'
	String get resetConfirm => 'Are you sure you want to reset all app settings?';

	/// en: 'App settings have been reset to defaults'
	String get resetSuccess => 'App settings have been reset to defaults';

	/// en: 'Are you sure you want to reset core settings and override configurations?'
	String get resetCoreConfirm => 'Are you sure you want to reset core settings and override configurations?';

	/// en: 'Core settings have been reset to defaults'
	String get resetCoreSuccess => 'Core settings have been reset to defaults';

	/// en: 'Authentication'
	String get authentication => 'Authentication';

	/// en: 'Submit'
	String get submit => 'Submit';

	/// en: 'User'
	String get user => 'User';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Decrypt Password'
	String get decryptPassword => 'Decrypt Password';

	/// en: 'Required'
	String get required => 'Required';

	/// en: 'Continue'
	String get go => 'Continue';

	/// en: 'sudo password (required for TUN mode)'
	String get sudoPassword => 'sudo password (required for TUN mode)';

	/// en: 'Other'
	String get other => 'Other';

	/// en: 'DNS'
	String get dns => 'DNS';

	/// en: 'URL'
	String get url => 'URL';

	/// en: 'Invalid URL'
	String get urlInvalid => 'Invalid URL';

	/// en: 'Link can not be empty'
	String get urlCannotEmpty => 'Link can not be empty';

	/// en: 'URL is too long (>8182)'
	String get urlTooLong => 'URL is too long (>8182)';

	/// en: 'Copy Link'
	String get copyUrl => 'Copy Link';

	/// en: 'Open Link'
	String get openUrl => 'Open Link';

	/// en: 'Share Link'
	String get shareUrl => 'Share Link';

	/// en: 'Note: After modifying the configuration, you need to reconnect to take effect'
	String get coreSettingTips => 'Note: After modifying the configuration, you need to reconnect to take effect';

	/// en: 'Overwrite'
	String get overwrite => 'Overwrite';

	/// en: 'Custom Overwrite'
	String get overwriteCustom => 'Custom Overwrite';

	/// en: 'Append Overwrite'
	String get overwriteAppend => 'Append Overwrite';

	/// en: 'Original Profile <- Custom Overwrite <- App Overwrite'
	String get overwriteTips => 'Original Profile <- Custom Overwrite <- App Overwrite';

	/// en: 'Do not overwrite'
	String get noOverwrite => 'Do not overwrite';

	/// en: 'Overwrite Settings'
	String get overwriteSettings => 'Overwrite Settings';

	/// en: 'Routing Templates'
	String get diversionTemplates => 'Routing Templates';

	/// en: 'Rule Sets (RuleSet)'
	String get ruleProviders => 'Rule Sets (RuleSet)';

	/// en: 'Rule Templates'
	String get ruleTemplates => 'Rule Templates';

	/// en: 'Group Templates'
	String get proxyGroupsTemplates => 'Group Templates';

	/// en: 'Proxy Groups'
	String get proxyGroups => 'Proxy Groups';

	/// en: 'Proxy Node list'
	String get proxyNodeList => 'Proxy Node list';

	/// en: 'The following proxy nodes have expired and have been automatically removed: $p'
	String proxyNodeFailure({required Object p}) => 'The following proxy nodes have expired and have been automatically removed: ${p}';

	/// en: 'External Controller'
	String get externalController => 'External Controller';

	/// en: 'Secret'
	String get secret => 'Secret';

	/// en: 'TCP Concurrent Handshake'
	String get tcpConcurrent => 'TCP Concurrent Handshake';

	/// en: 'TLS Global Fingerprint'
	String get globalClientFingerprint => 'TLS Global Fingerprint';

	/// en: 'LAN device access'
	String get allowLanAccess => 'LAN device access';

	/// en: 'Mixed Proxy Port'
	String get mixedPort => 'Mixed Proxy Port';

	/// en: 'Log Level'
	String get logLevel => 'Log Level';

	/// en: 'Find Process Mode'
	String get findProcessMode => 'Find Process Mode';

	/// en: 'TCP Keep-alive Interval'
	String get tcpkeepAliveInterval => 'TCP Keep-alive Interval';

	/// en: 'Delay Test URL'
	String get delayTestUrl => 'Delay Test URL';

	/// en: 'Delay Test Timeout(ms)'
	String get delayTestTimeout => 'Delay Test Timeout(ms)';

	/// en: 'TUN'
	String get tun => 'TUN';

	/// en: 'NTP'
	String get ntp => 'NTP';

	/// en: 'TLS'
	String get tls => 'TLS';

	/// en: 'GEO'
	String get geo => 'GEO';

	/// en: 'Downloading Geo RuleSet by proxy'
	String get geoDownloadByProxy => 'Downloading Geo RuleSet by proxy';

	/// en: 'Geosite/Geoip will be converted into the corresponding RuleSet'
	String get geoRulesetTips => 'Geosite/Geoip will be converted into the corresponding RuleSet';

	/// en: 'Due to iOS system memory limitations, IP-ASN and SRC-IP-ASN rules will be ignored on iOS.'
	String get asnNotSupportInIosTips => 'Due to iOS system memory limitations, IP-ASN and SRC-IP-ASN rules will be ignored on iOS.';

	/// en: 'Sniffer'
	String get sniffer => 'Sniffer';

	/// en: 'UserAgent'
	String get userAgent => 'UserAgent';

	/// en: 'Launch at Startup'
	String get launchAtStartup => 'Launch at Startup';

	/// en: 'Please restart Wmimo as administrator'
	String get launchAtStartupRunAsAdmin => 'Please restart Wmimo as administrator';

	/// en: 'The TUN mode requires system administrator permissions, please restart the app as an administrator'
	String get tunModeRunAsAdmin => 'The TUN mode requires system administrator permissions, please restart the app as an administrator';

	/// en: 'Would you like to temporarily switch to [System Proxy Mode] to continue connecting?'
	String get tunSwitchToSystemProxy => 'Would you like to temporarily switch to [System Proxy Mode] to continue connecting?';

	/// en: 'Failed to create TUN virtual adapter: Access is denied. TUN mode requires administrator privileges. Please right-click and choose [Run as administrator], or turn off TUN mode in the main screen/core settings and connect using system proxy.'
	String get tunCreateAdapterFailedAdmin => 'Failed to create TUN virtual adapter: Access is denied.\nTUN mode requires administrator privileges. Please right-click and choose [Run as administrator], or turn off TUN mode in the main screen/core settings and connect using system proxy.';

	/// en: 'Portable Mode'
	String get portableMode => 'Portable Mode';

	/// en: 'If you need to exit portable mode, please exit [Wmimo] and manually delete the [portable] folder in the same directory as [wmimo.exe]'
	String get portableModeDisableTips => 'If you need to exit portable mode, please exit [Wmimo] and manually delete the [portable] folder in the same directory as [wmimo.exe]';

	/// en: 'System Proxy'
	String get systemProxy => 'System Proxy';

	/// en: 'Auto Connection after Launch'
	String get autoConnectAfterLaunch => 'Auto Connection after Launch';

	/// en: 'Auto Connection after System Startup'
	String get autoConnectAtBoot => 'Auto Connection after System Startup';

	/// en: 'System support is required; some systems may also require [auto-start] to be enabled.'
	String get autoConnectAtBootTips => 'System support is required; some systems may also require [auto-start] to be enabled.';

	/// en: 'Hide window after startup'
	String get hideAfterLaunch => 'Hide window after startup';

	/// en: 'Auto Set System Proxy when Connected'
	String get autoSetSystemProxy => 'Auto Set System Proxy when Connected';

	/// en: 'Domain names that are allowed to bypass the system proxy'
	String get bypassSystemProxy => 'Domain names that are allowed to bypass the system proxy';

	/// en: 'Hide from [Recent Tasks]'
	String get excludeFromRecent => 'Hide from [Recent Tasks]';

	/// en: 'Wake Lock'
	String get wakeLock => 'Wake Lock';

	/// en: 'Hide VPN Icon'
	String get hideVpn => 'Hide VPN Icon';

	/// en: 'Enabling IPv6 will cause this function to fail'
	String get hideVpnTips => 'Enabling IPv6 will cause this function to fail';

	/// en: 'Hide Dock Icon'
	String get hideDockIcon => 'Hide Dock Icon';

	/// en: 'Show traffic info in tray'
	String get showTrayTraffic => 'Show traffic info in tray';

	/// en: 'Website'
	String get website => 'Website';

	/// en: 'Home Page'
	String get homePage => 'Home Page';

	/// en: 'Rule'
	String get rule => 'Rule';

	/// en: 'Global'
	String get global => 'Global';

	/// en: 'Direct'
	String get direct => 'Direct';

	/// en: 'Block'
	String get block => 'Block';

	/// en: 'QR Code'
	String get qrcode => 'QR Code';

	/// en: 'The text is too long to display'
	String get qrcodeTooLong => 'The text is too long to display';

	/// en: 'Share QR Code'
	String get qrcodeShare => 'Share QR Code';

	/// en: 'Text To QR Code'
	String get textToQrcode => 'Text To QR Code';

	/// en: 'Scan QR Code'
	String get qrcodeScan => 'Scan QR Code';

	/// en: 'Scan Result'
	String get qrcodeScanResult => 'Scan Result';

	/// en: 'Scan From Image'
	String get qrcodeScanFromImage => 'Scan From Image';

	/// en: 'From Clipboard'
	String get qrcodeScanFromClipboard => 'From Clipboard';

	/// en: 'QR Code Recognized'
	String get qrcodeRecognized => 'QR Code Recognized';

	/// en: 'Click buttons above to capture screen or select an image'
	String get qrcodeDropHint => 'Click buttons above to capture screen or select an image';

	/// en: 'Confirm Import'
	String get confirmImport => 'Confirm Import';

	/// en: 'Scan Again'
	String get reScan => 'Scan Again';

	/// en: 'Failed to parse the image, please make sure the screenshot is a valid QR code'
	String get qrcodeScanResultFailed => 'Failed to parse the image, please make sure the screenshot is a valid QR code';

	/// en: 'Scan Result is empty'
	String get qrcodeScanResultEmpty => 'Scan Result is empty';

	/// en: 'Screenshot'
	String get screenshot => 'Screenshot';

	/// en: 'Backup and Sync'
	String get backupAndSync => 'Backup and Sync';

	/// en: 'Import Success'
	String get importSuccess => 'Import Success';

	/// en: 'This file will overwrite the existing local configuration. Do you want to continue?'
	String get rewriteConfirm => 'This file will overwrite the existing local configuration. Do you want to continue?';

	/// en: 'Import and Export'
	String get importAndExport => 'Import and Export';

	/// en: 'Import'
	String get import => 'Import';

	/// en: 'Import from URL'
	String get importFromUrl => 'Import from URL';

	/// en: 'Export'
	String get export => 'Export';

	/// en: 'Send'
	String get send => 'Send';

	/// en: 'Receive'
	String get receive => 'Receive';

	/// en: 'Confirm to send?'
	String get sendConfirm => 'Confirm to send?';

	/// en: 'Continue to connect?'
	String get continueConnectConfirm => 'Continue to connect?';

	/// en: 'Terms of Service'
	String get termOfUse => 'Terms of Service';

	/// en: 'Privacy & Policy'
	String get privacyPolicy => 'Privacy & Policy';

	/// en: 'Log'
	String get log => 'Log';

	/// en: 'Core Logs'
	String get coreLog => 'Core Logs';

	/// en: 'Core'
	String get core => 'Core';

	/// en: 'Help'
	String get help => 'Help';

	/// en: 'Tutorial'
	String get tutorial => 'Tutorial';

	/// en: 'Board'
	String get board => 'Board';

	/// en: 'Use Online Board'
	String get boardOnline => 'Use Online Board';

	/// en: 'Online Board URL'
	String get boardOnlineUrl => 'Online Board URL';

	/// en: 'Local Board Port'
	String get boardLocalPort => 'Local Board Port';

	/// en: 'Connections'
	String get connections => 'Connections';

	/// en: 'Close All Connections'
	String get closeAllConnections => 'Close All Connections';

	/// en: 'Search connections (Domain/IP/Rule/Process)'
	String get searchConnections => 'Search connections (Domain/IP/Rule/Process)';

	/// en: 'No matching connections'
	String get noFilterResults => 'No matching connections';

	/// en: 'Search rules (Type/Payload/Proxy)'
	String get searchRules => 'Search rules (Type/Payload/Proxy)';

	/// en: 'Search profiles (Name/URL/Remark)'
	String get searchProfiles => 'Search profiles (Name/URL/Remark)';

	/// en: 'No matching profiles found'
	String get noMatchingProfiles => 'No matching profiles found';

	/// en: 'Routing Rules'
	String get rules => 'Routing Rules';

	/// en: 'Clear'
	String get clear => 'Clear';

	/// en: 'Copied to clipboard'
	String get copySuccess => 'Copied to clipboard';

	/// en: 'Always-on Connection'
	String get alwayOnVPN => 'Always-on Connection';

	/// en: 'Disable Font scaling(Restart takes effect)'
	String get disableFontScaler => 'Disable Font scaling(Restart takes effect)';

	/// en: 'Rotate with the screen'
	String get autoOrientation => 'Rotate with the screen';

	/// en: 'Restart takes effect'
	String get restartTakesEffect => 'Restart takes effect';

	/// en: 'Reconnect takes effect'
	String get reconnectTakesEffect => 'Reconnect takes effect';

	/// en: 'Runtime Profile'
	String get runtimeProfile => 'Runtime Profile';

	/// en: 'Please restart your device to complete the system extension installation'
	String get willCompleteAfterRebootInstall => 'Please restart your device to complete the system extension installation';

	/// en: 'Please restart your device to complete the the system extension uninstallation'
	String get willCompleteAfterRebootUninstall => 'Please restart your device to complete the the system extension uninstallation';

	/// en: '1. Please [Allow] Wmimo to install system extensions in [System Settings]-[Privacy and Security] 2. [System Settings]-[General]-[Login Items Extensions]-[Network Extension] enable [wmimoServiceSE] reconnect after completion'
	String get requestNeedsUserApproval => '1. Please [Allow] Wmimo to install system extensions in [System Settings]-[Privacy and Security]\n2. [System Settings]-[General]-[Login Items Extensions]-[Network Extension] enable [wmimoServiceSE]\nreconnect after completion';

	/// en: 'Please enable wmimoServiceSE permission in [System Settings]-[Privacy and Security]-[Full Disk Access] and reconnect.'
	String get FullDiskAccessPermissionRequired => 'Please enable wmimoServiceSE permission in [System Settings]-[Privacy and Security]-[Full Disk Access] and reconnect.';

	/// en: 'Proxy'
	String get proxy => 'Proxy';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'TV Mode'
	String get tvMode => 'TV Mode';

	/// en: 'Auto Update'
	String get autoUpdate => 'Auto Update';

	/// en: 'Auto Update Channel'
	String get updateChannel => 'Auto Update Channel';

	/// en: 'Online Customer Service'
	String get onlineCustomerService => 'Online Customer Service';

	/// en: 'Subscription Channel'
	String get subscriptionChannel => 'Subscription Channel';

	/// en: 'Update Version $p'
	String hasNewVersion({required Object p}) => 'Update Version ${p}';

	/// en: 'Auto Download Update Packages'
	String get autoDownloadPkg => 'Auto Download Update Packages';

	/// en: 'Developer Options'
	String get devOptions => 'Developer Options';

	/// en: 'Join Us'
	String get joinUs => 'Join Us';

	/// en: 'About'
	String get about => 'About';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Version'
	String get version => 'Version';

	/// en: 'Notice'
	String get notice => 'Notice';

	/// en: 'Reorder'
	String get sort => 'Reorder';

	/// en: 'Recommend'
	String get recommended => 'Recommend';

	/// en: 'Inner Error:$p'
	String innerError({required Object p}) => 'Inner Error:${p}';

	/// en: 'Share'
	String get share => 'Share';

	/// en: 'Import From Clipboard'
	String get importFromClipboard => 'Import From Clipboard';

	/// en: 'Export to Clipboard'
	String get exportToClipboard => 'Export to Clipboard';

	/// en: 'Server'
	String get server => 'Server';

	/// en: 'Port'
	String get port => 'Port';

	/// en: 'Donate'
	String get donate => 'Donate';

	/// en: 'Settings'
	String get setting => 'Settings';

	/// en: 'Core Settings'
	String get settingCore => 'Core Settings';

	/// en: 'App Settings'
	String get settingApp => 'App Settings';

	/// en: 'Core Overwrite'
	String get coreOverwrite => 'Core Overwrite';

	/// en: 'iCloud'
	String get iCloud => 'iCloud';

	/// en: 'Webdav'
	String get webdav => 'Webdav';

	/// en: 'LAN Sync'
	String get lanSync => 'LAN Sync';

	/// en: 'Do not exit this interface before synchronization is completed'
	String get lanSyncNotQuitTips => 'Do not exit this interface before synchronization is completed';

	/// en: 'Not enough disk space'
	String get deviceNoSpace => 'Not enough disk space';

	/// en: 'Hide System Apps'
	String get hideSystemApp => 'Hide System Apps';

	/// en: 'Hide App Icons'
	String get hideAppIcon => 'Hide App Icons';

	/// en: 'Open File Directory'
	String get openDir => 'Open File Directory';

	/// en: 'Type'
	String get type => 'Type';

	/// en: 'Select File'
	String get fileChoose => 'Select File';

	/// en: 'The file path can not be empty'
	String get filePathCannotEmpty => 'The file path can not be empty';

	/// en: 'File does not exist:$p'
	String fileNotExist({required Object p}) => 'File does not exist:${p}';

	/// en: 'Invalid file type:$p'
	String fileTypeInvalid({required Object p}) => 'Invalid file type:${p}';

	/// en: 'UWP Network Isolation Exemptions'
	String get uwpExemption => 'UWP Network Isolation Exemptions';

	/// en: 'Get Subscription'
	String get getProfile => 'Get Subscription';

	/// en: 'Buy Subscription'
	String get buyProfile => 'Buy Subscription';

	/// en: 'Add Subscription'
	String get addProfile => 'Add Subscription';

	/// en: 'Subscriptions'
	String get myProfiles => 'Subscriptions';

	/// en: 'Edit Profile'
	String get profileEdit => 'Edit Profile';

	/// en: 'Please set this profile as the current profile first, then start/reconnect'
	String get profileNeedActive => 'Please set this profile as the current profile first, then start/reconnect';

	/// en: 'Enable backup download channel'
	String get profileDownloadBackupChannel => 'Enable backup download channel';

	/// en: 'Proxy download channel provided by Wmimo (no information is stored)'
	String get profileDownloadBackupChannelTips => 'Proxy download channel provided by Wmimo (no information is stored)';

	/// en: 'Reload after Profile update'
	String get profileEditReloadAfterProfileUpdate => 'Reload after Profile update';

	/// en: 'Append Apple Push Notification rules'
	String get profileRulesAppendApplePush => 'Append Apple Push Notification rules';

	/// en: 'Rules will be automatically set to the first proxy in [proxy-groups] of the original config with type [url-test] or [select]'
	String get profileRulesAppendProxyTips => 'Rules will be automatically set to the first proxy in [proxy-groups] of the original config with type [url-test] or [select]';

	/// en: 'Import Profile'
	String get profileImport => 'Import Profile';

	/// en: 'Add Subscription URL'
	String get profileAddUrlOrContent => 'Add Subscription URL';

	/// en: 'Subscription URL / Content'
	String get profileUrlOrContent => 'Subscription URL / Content';

	/// en: 'Subscription URL or Content [Required]'
	String get profileUrlOrContentHit => 'Subscription URL or Content [Required]';

	/// en: 'Subscription URL or content cannot be empty'
	String get profileUrlOrContentCannotEmpty => 'Subscription URL or content cannot be empty';

	/// en: 'Overview'
	String get overview => 'Overview';

	/// en: 'Traffic Statistics'
	String get trafficStats => 'Traffic Statistics';

	/// en: 'Real-time Monitor'
	String get realtimeMonitor => 'Real-time Monitor';

	/// en: 'Real-time Upload'
	String get realtimeUpload => 'Real-time Upload';

	/// en: 'Real-time Download'
	String get realtimeDownload => 'Real-time Download';

	/// en: 'Session Upload'
	String get sessionUpload => 'Session Upload';

	/// en: 'Session Download'
	String get sessionDownload => 'Session Download';

	/// en: 'Plan Usage'
	String get planUsage => 'Plan Usage';

	/// en: 'Memory'
	String get memoryUsage => 'Memory';

	/// en: 'Remaining'
	String get remaining => 'Remaining';

	/// en: 'Expire Time'
	String get expireTime => 'Expire Time';

	/// en: 'TUN Mode'
	String get tunMode => 'TUN Mode';

	/// en: '$p days ago'
	String daysAgo({required Object p}) => '${p} days ago';

	/// en: '$p hours ago'
	String hoursAgo({required Object p}) => '${p} hours ago';

	/// en: '< 1 hour ago'
	String get lessThanOneHourAgo => '< 1 hour ago';

	/// en: 'In Use'
	String get inUse => 'In Use';

	/// en: 'Remote Subscription'
	String get remoteSubscription => 'Remote Subscription';

	/// en: 'No usage statistics provided'
	String get noTrafficData => 'No usage statistics provided';

	/// en: 'Local File'
	String get localProfile => 'Local File';

	/// en: 'View YAML Config'
	String get viewYamlConfig => 'View YAML Config';

	/// en: 'Edit YAML Config'
	String get editYamlConfig => 'Edit YAML Config';

	/// en: 'Copy Subscription URL'
	String get copySubscriptionUrl => 'Copy Subscription URL';

	/// en: 'QR Code'
	String get qrCode => 'QR Code';

	/// en: 'Delete Profile'
	String get deleteProfile => 'Delete Profile';

	/// en: 'No Subscriptions Yet'
	String get noProfilesYet => 'No Subscriptions Yet';

	/// en: 'Click + in the top right to add a URL or import a file'
	String get addProfilePrompt => 'Click + in the top right to add a URL or import a file';

	/// en: 'Subscription URL copied to clipboard'
	String get subscriptionUrlCopied => 'Subscription URL copied to clipboard';

	/// en: '[$group] is an auto policy group ($type), which automatically selects nodes based on latency/availability. To manually select a node, please switch in manual policy groups.'
	String autoGroupTip({required Object group, required Object type}) => '[${group}] is an auto policy group (${type}), which automatically selects nodes based on latency/availability. To manually select a node, please switch in manual policy groups.';

	/// en: 'Failed to switch node: $p'
	String switchNodeFailed({required Object p}) => 'Failed to switch node: ${p}';

	/// en: 'Selected node: $p'
	String nodeSelected({required Object p}) => 'Selected node: ${p}';

	/// en: 'Starting core and testing latency...'
	String get startingCoreAndTesting => 'Starting core and testing latency...';

	/// en: '$p min'
	String chartMinutes({required Object p}) => '${p} min';

	/// en: 'Upload'
	String get chartUpload => 'Upload';

	/// en: 'Download'
	String get chartDownload => 'Download';

	/// en: 'Author'
	String get author => 'Author';

	/// en: 'Open Source Repository'
	String get githubRepo => 'Open Source Repository';

	/// en: 'License'
	String get openSourceLicense => 'License';

	/// en: 'Feedback & Issues'
	String get submitFeedback => 'Feedback & Issues';

	/// en: 'Copied to clipboard'
	String get copiedToClipboard => 'Copied to clipboard';

	/// en: 'Auto-scroll enabled'
	String get autoScrollEnabled => 'Auto-scroll enabled';

	/// en: 'Auto-scroll disabled'
	String get autoScrollDisabled => 'Auto-scroll disabled';

	/// en: 'Pause live logs'
	String get pauseLogs => 'Pause live logs';

	/// en: 'Resume live logs'
	String get resumeLogs => 'Resume live logs';

	/// en: 'Scroll to latest'
	String get scrollToLatest => 'Scroll to latest';

	/// en: 'Scroll to bottom'
	String get scrollToBottom => 'Scroll to bottom';

	/// en: '($p new logs)'
	String newLogsCount({required Object p}) => '(${p} new logs)';

	/// en: 'Log content copied'
	String get copiedLogContent => 'Log content copied';

	/// en: 'Copy Log'
	String get copyLog => 'Copy Log';

	/// en: 'No logs yet. Core logs will appear after starting proxy.'
	String get noLogsPrompt => 'No logs yet. Core logs will appear after starting proxy.';

	/// en: ' (IP, Domain, Rule, Error...)'
	String get searchLogsHint => ' (IP, Domain, Rule, Error...)';

	/// en: 'Offline preview mode. Start proxy to enable routing and latency testing.'
	String get offlinePreviewPrompt => 'Offline preview mode. Start proxy to enable routing and latency testing.';

	/// en: 'Manual'
	String get manualSelect => 'Manual';

	/// en: 'Auto Select'
	String get autoSelect => 'Auto Select';

	/// en: 'Test Group Latency'
	String get speedTestGroup => 'Test Group Latency';

	/// en: 'Pause'
	String get pause => 'Pause';

	/// en: 'Resume'
	String get resume => 'Resume';

	/// en: 'IP Info'
	String get ipInfo => 'IP Info';

	/// en: 'Fetching IP info...'
	String get ipFetching => 'Fetching IP info...';

	/// en: 'IP address copied to clipboard'
	String get ipCopied => 'IP address copied to clipboard';

	/// en: 'Location'
	String get ipLocation => 'Location';

	/// en: 'Provider'
	String get ipIsp => 'Provider';

	/// en: 'Tap to fetch IP info'
	String get ipTapToFetch => 'Tap to fetch IP info';

	/// en: 'Proxy Exit'
	String get ipProxy => 'Proxy Exit';

	/// en: 'Local Direct'
	String get ipDirect => 'Local Direct';

	/// en: 'ASN'
	String get ipAsn => 'ASN';

	/// en: 'Organization'
	String get ipOrg => 'Organization';

	/// en: 'Timezone'
	String get ipTimezone => 'Timezone';

	/// en: 'Coordinates'
	String get ipCoordinates => 'Coordinates';

	/// en: 'More Details'
	String get ipMoreDetails => 'More Details';

	/// en: 'Collapse'
	String get ipLessDetails => 'Collapse';

	/// en: 'Collapse All Groups'
	String get collapseAll => 'Collapse All Groups';

	/// en: 'Expand All Groups'
	String get expandAll => 'Expand All Groups';

	/// en: '💖 Buy Author a Coffee'
	String get donateTitle => '💖 Buy Author a Coffee';

	/// en: 'ฅ^•ﻌ•^ฅ Every donation is our greatest motivation to keep polishing Wmimo ~ ☕✨'
	String get donateThankYou => 'ฅ^•ﻌ•^ฅ Every donation is our greatest motivation to keep polishing Wmimo ~ ☕✨';

	/// en: 'Token'
	String get tokenCurrency => 'Token';

	/// en: 'Network'
	String get networkChain => 'Network';

	/// en: 'APTOS Deposit Address'
	String get depositAddress => 'APTOS Deposit Address';

	/// en: 'Click to copy'
	String get clickToCopy => 'Click to copy';

	/// en: 'Copy Address ✨'
	String get copyAddressBtn => 'Copy Address ✨';

	/// en: '( ੭ ˙ᗜ˙ )੭ Address copied! Thank you so much for your support and company~ 💖'
	String get donateAddressCopied => '( ੭ ˙ᗜ˙ )੭ Address copied! Thank you so much for your support and company~ 💖';

	/// en: '💡 Tip: Supports scanning via Bybit or any Aptos-compatible wallet'
	String get donateTip => '💡 Tip: Supports scanning via Bybit or any Aptos-compatible wallet';

	/// en: 'Parsing QR code...'
	String get qrcodeParsing => 'Parsing QR code...';

	/// en: 'No QR code detected'
	String get qrcodeNotFound => 'No QR code detected';

	/// en: 'Supports subscription, node and config QR codes'
	String get qrcodeSupportHint => 'Supports subscription, node and config QR codes';

	/// en: 'Align QR code within the frame to scan automatically'
	String get qrcodeCameraHint => 'Align QR code within the frame to scan automatically';

	/// en: 'Flashlight'
	String get flashlight => 'Flashlight';

	/// en: 'Capture screen'
	String get screenshotDesc => 'Capture screen';

	/// en: 'Local image'
	String get fromImageDesc => 'Local image';

	/// en: 'Read clipboard'
	String get fromClipboardDesc => 'Read clipboard';

	/// en: 'Error'
	String get errorPrompt => 'Error';

	/// en: 'Copied'
	String get copied => 'Copied';

	/// en: 'Sort & Filter Nodes'
	String get sortAndFilterNodes => 'Sort & Filter Nodes';

	/// en: 'Sort Options'
	String get sortOptions => 'Sort Options';

	/// en: 'Default'
	String get sortDefault => 'Default';

	/// en: 'Sort Latency'
	String get sortLatency => 'Sort Latency';

	/// en: 'Name A-Z'
	String get sortName => 'Name A-Z';

	/// en: 'Region'
	String get sortRegion => 'Region';

	/// en: 'Filter Options'
	String get filterOptions => 'Filter Options';

	/// en: 'Portable mode detected: In-app auto-update is not supported in portable mode. Please download the latest portable ZIP from the repository and extract to overwrite. Latest version: v$version'
	String portableUpdateTip({required Object version}) => 'Portable mode detected:\nIn-app auto-update is not supported in portable mode. Please download the latest portable ZIP from the repository and extract to overwrite.\n\nLatest version: v${version}';

	/// en: 'Portable Mode Notice'
	String get portableModeTipTitle => 'Portable Mode Notice';

	/// en: 'No available nodes to test'
	String get noNodesToSpeedTest => 'No available nodes to test';

	/// en: 'Already the latest version (v$version)'
	String alreadyLatestVersion({required Object version}) => 'Already the latest version (v${version})';

	/// en: 'Failed to check for updates, please check your network connection'
	String get checkUpdateFailed => 'Failed to check for updates, please check your network connection';

	/// en: 'Hide Timed-out & Offline Nodes'
	String get hideTimeoutNodes => 'Hide Timed-out & Offline Nodes';

	/// en: 'Automatically filter unreachable nodes'
	String get hideTimeoutNodesDesc => 'Automatically filter unreachable nodes';

	/// en: 'Speedtest Target Scenario'
	String get speedtestScenario => 'Speedtest Target Scenario';

	/// en: 'Speedtest Target Scenario'
	String get speedtestScenarioSwitch => 'Speedtest Target Scenario';

	/// en: 'Select targets to test real connectivity and latency'
	String get speedtestScenarioDesc => 'Select targets to test real connectivity and latency';

	/// en: 'Test All Nodes'
	String get speedtestAllNodes => 'Test All Nodes';

	/// en: 'Retest Timed-out Nodes'
	String get retestTimeoutNodes => 'Retest Timed-out Nodes';

	/// en: 'Switched target scenario: $target'
	String switchedTargetScenario({required Object target}) => 'Switched target scenario: ${target}';

	/// en: 'Not tested'
	String get notTested => 'Not tested';

	/// en: 'Timeout / Unreachable'
	String get timeoutOrFailed => 'Timeout / Unreachable';

	/// en: 'Region'
	String get identifiedRegion => 'Region';

	/// en: 'Protocol'
	String get nodeProtocol => 'Protocol';

	/// en: 'Latency'
	String get currentLatency => 'Latency';

	/// en: 'Test Scenario'
	String get testScenario => 'Test Scenario';

	/// en: 'Group'
	String get belongsToGroup => 'Group';

	/// en: 'Copy Name'
	String get copyNodeName => 'Copy Name';

	/// en: 'Node name copied'
	String get nodeNameCopied => 'Node name copied';

	/// en: 'Test Node'
	String get testSingleNode => 'Test Node';

	/// en: 'Select Node'
	String get selectThisNode => 'Select Node';

	/// en: 'All nodes are available, no retest needed'
	String get allNodesNormal => 'All nodes are available, no retest needed';

	/// en: 'Custom URL (e.g. http://...)'
	String get customUrlPrompt => 'Custom URL (e.g. http://...)';

	/// en: 'Custom Target'
	String get customTarget => 'Custom Target';

	/// en: 'Failed to download update package. Please check network or download from website.'
	String get downloadFailedTip => 'Failed to download update package. Please check network or download from website.';

	/// en: 'Discovered new version: v$version'
	String discoveredNewVersion({required Object version}) => 'Discovered new version: v${version}';

	/// en: 'Preparing to start update...'
	String get preparingUpdate => 'Preparing to start update...';

	/// en: 'Downloading update package, please wait...'
	String get downloadingPackage => 'Downloading update package, please wait...';

	/// en: 'Download Update Now'
	String get downloadUpdateNow => 'Download Update Now';

	/// en: 'Download from Website'
	String get downloadFromWeb => 'Download from Website';

	/// en: 'Switch'
	String get switchSource => 'Switch';

	/// en: 'Speed Test Server'
	String get serverSwitch => 'Speed Test Server';

	/// en: 'Auto Detect Best'
	String get autoDetectBest => 'Auto Detect Best';

	/// en: 'Select CDN or custom target to test connectivity'
	String get serverSwitchDesc => 'Select CDN or custom target to test connectivity';

	/// en: 'Auto-selected best server: $server ($ping ms)'
	String autoSelectedBest({required Object server, required Object ping}) => 'Auto-selected best server: ${server} (${ping} ms)';

	/// en: 'Network Quality Score'
	String get networkGradeTitle => 'Network Quality Score';

	/// en: 'Copy Report'
	String get copyReport => 'Copy Report';

	/// en: 'Report copied to clipboard, ready to share'
	String get reportCopied => 'Report copied to clipboard, ready to share';

	/// en: 'Gaming'
	String get gamingExperience => 'Gaming';

	/// en: 'Streaming'
	String get streamingExperience => 'Streaming';

	/// en: 'Conferencing'
	String get meetingExperience => 'Conferencing';

	/// en: 'Custom download URL (https://...)'
	String get customSpeedtestUrl => 'Custom download URL (https://...)';

	/// en: 'Custom Server'
	String get customSpeedtestSource => 'Custom Server';

	/// en: 'User Specified URL'
	String get userSpecifiedUrl => 'User Specified URL';

	/// en: '$item cannot be empty'
	String cannotBeEmpty({required Object item}) => '${item} cannot be empty';

	/// en: '$item already exists'
	String alreadyExists({required Object item}) => '${item} already exists';

	/// en: 'Failed to install $installer, exit code: $code'
	String installFailedWithCode({required Object installer, required Object code}) => 'Failed to install ${installer}, exit code: ${code}';

	/// en: 'Repair Network / Reset System Proxy'
	String get resetSystemProxy => 'Repair Network / Reset System Proxy';

	/// en: 'Clear residual system proxy settings and refresh network to fix offline issues after abnormal exits'
	String get resetSystemProxyDesc => 'Clear residual system proxy settings and refresh network to fix offline issues after abnormal exits';

	/// en: 'System proxy cleared and reset, network restored'
	String get resetSystemProxySuccess => 'System proxy cleared and reset, network restored';

	/// en: 'Network Diagnostics & Auto-Repair'
	String get networkDiagnostics => 'Network Diagnostics & Auto-Repair';

	/// en: 'Diagnose network interface, DNS, core ports, and proxy health with one-click repair'
	String get networkDiagnosticsDesc => 'Diagnose network interface, DNS, core ports, and proxy health with one-click repair';

	/// en: 'Highest Latency'
	String get sortLatencyDesc => 'Highest Latency';

	/// en: 'Name Z-A'
	String get sortNameDesc => 'Name Z-A';

	/// en: 'Lowest Multiplier'
	String get sortMultiplier => 'Lowest Multiplier';

	/// en: 'UWP Loopback Exemption Utility'
	String get uwpLoopback => 'UWP Loopback Exemption Utility';

	/// en: 'Exempt Microsoft Store, Xbox, Minecraft, and UWP apps to use local proxy'
	String get uwpLoopbackDesc => 'Exempt Microsoft Store, Xbox, Minecraft, and UWP apps to use local proxy';

	/// en: 'Exempt Recommended'
	String get uwpExemptAllCommon => 'Exempt Recommended';

	/// en: 'UWP loopback exemptions applied successfully'
	String get uwpApplySuccess => 'UWP loopback exemptions applied successfully';

	/// en: 'Common'
	String get common => 'Common';

	/// en: 'Exempted'
	String get exempted => 'Exempted';

	/// en: 'Not Exempted'
	String get notExempted => 'Not Exempted';

	/// en: 'Deselect All'
	String get deselectAll => 'Deselect All';

	/// en: 'User Apps'
	String get userApps => 'User Apps';

	/// en: 'System Apps'
	String get systemApps => 'System Apps';

	/// en: 'Selected'
	String get selectedOnly => 'Selected';

	/// en: 'Proxy Selected Apps Only'
	String get proxySelectedMode => 'Proxy Selected Apps Only';

	/// en: 'Selected apps route through proxy, others connect directly'
	String get proxySelectedModeDesc => 'Selected apps route through proxy, others connect directly';

	/// en: 'Bypass Selected Apps'
	String get bypassSelectedMode => 'Bypass Selected Apps';

	/// en: 'Selected apps connect directly, others route through proxy'
	String get bypassSelectedModeDesc => 'Selected apps connect directly, others route through proxy';

	/// en: 'Invert Selection'
	String get invertSelection => 'Invert Selection';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Show App Icon'
	String get showAppIcon => 'Show App Icon';

	/// en: 'Proxy Selection'
	String get proxySelection => 'Proxy Selection';

	/// en: '🇭🇰 Hong Kong'
	String get regionHk => '🇭🇰 Hong Kong';

	/// en: '🇯🇵 Japan'
	String get regionJp => '🇯🇵 Japan';

	/// en: '🇸🇬 Singapore'
	String get regionSg => '🇸🇬 Singapore';

	/// en: '🇹🇼 Taiwan'
	String get regionTw => '🇹🇼 Taiwan';

	/// en: '🇺🇸 United States'
	String get regionUs => '🇺🇸 United States';

	/// en: '🇰🇷 South Korea'
	String get regionKr => '🇰🇷 South Korea';

	/// en: 'Please move Wmimo into Applications folder before launching'
	String get macMoveToApplications => 'Please move Wmimo into Applications folder before launching';

	/// en: 'Node'
	String get notifCurrentNode => 'Node';

	/// en: 'Mode'
	String get notifMode => 'Mode';

	/// en: 'Port'
	String get notifPort => 'Port';

	/// en: 'Profile'
	String get notifProfile => 'Profile';

	/// en: 'Disconnect'
	String get notifDisconnect => 'Disconnect';

	/// en: 'Switch Node'
	String get notifSwitchNode => 'Switch Node';

	/// en: 'VPN Proxy Connected'
	String get notifVpnConnected => 'VPN Proxy Connected';

	/// en: 'Connection Details'
	String get connectionDetails => 'Connection Details';

	/// en: 'Source Address'
	String get sourceAddress => 'Source Address';

	/// en: 'Destination Address'
	String get destinationAddress => 'Destination Address';

	/// en: 'Host'
	String get host => 'Host';

	/// en: 'Process'
	String get process => 'Process';

	/// en: 'Process Path'
	String get processPath => 'Process Path';

	/// en: 'Proxy Chain'
	String get proxyChain => 'Proxy Chain';

	/// en: 'Protocol'
	String get networkProtocol => 'Protocol';

	/// en: 'Upload Traffic'
	String get trafficUpload => 'Upload Traffic';

	/// en: 'Download Traffic'
	String get trafficDownload => 'Download Traffic';

	/// en: 'Duration'
	String get connectionDuration => 'Duration';

	/// en: 'Start Time'
	String get connectionStart => 'Start Time';

	/// en: 'Copy Host'
	String get copyHost => 'Copy Host';

	/// en: 'Copy All Details'
	String get copyAllDetails => 'Copy All Details';

	/// en: 'Close Connection'
	String get closeThisConnection => 'Close Connection';

	/// en: 'By Download'
	String get sortByDownload => 'By Download';

	/// en: 'By Upload'
	String get sortByUpload => 'By Upload';

	/// en: 'By Speed'
	String get sortBySpeed => 'By Speed';

	/// en: 'By Duration'
	String get sortByDuration => 'By Duration';

	/// en: 'By Host'
	String get sortByHost => 'By Host';

	/// en: 'Real-time Speed'
	String get realtimeSpeed => 'Real-time Speed';

	/// en: 'Total Upload'
	String get totalUpload => 'Total Upload';

	/// en: 'Total Download'
	String get totalDownload => 'Total Download';

	/// en: 'Active'
	String get activeConnections => 'Active';

	/// en: 'Show in Folder'
	String get openInFolder => 'Show in Folder';

	/// en: 'Open Profiles Directory'
	String get openProfilesDir => 'Open Profiles Directory';

	/// en: 'Profile Overwrites'
	String get profilePatches => 'Profile Overwrites';

	/// en: '$p Nodes'
	String nodeCount({required Object p}) => '${p} Nodes';

	/// en: 'Copy File Path'
	String get copyFilePath => 'Copy File Path';

	/// en: 'Duplicate Profile'
	String get duplicateProfile => 'Duplicate Profile';

	/// en: 'Use This Profile'
	String get useThisProfile => 'Use This Profile';

	/// en: 'Website Test'
	String get websiteTest => 'Website Test';

	/// en: 'Test All'
	String get testAll => 'Test All';

	/// en: 'Add Test Website'
	String get addTestWebsite => 'Add Test Website';

	/// en: 'Website Name'
	String get websiteName => 'Website Name';

	/// en: 'Test URL'
	String get websiteUrl => 'Test URL';

	/// en: 'Website name (e.g. Cloudflare)'
	String get websiteNameHint => 'Website name (e.g. Cloudflare)';

	/// en: 'Please enter website name and URL'
	String get websiteInputEmpty => 'Please enter website name and URL';

	/// en: 'Auto Refresh'
	String get autoRefresh => 'Auto Refresh';

	/// en: 'Current Profile'
	String get currentProfile => 'Current Profile';

	/// en: 'Quick Actions'
	String get quickActions => 'Quick Actions';

	/// en: 'Fastest'
	String get fastest => 'Fastest';

	/// en: 'Hide Timeout'
	String get hideTimeout => 'Hide Timeout';

	/// en: 'Filtered Timeout'
	String get filteredTimeout => 'Filtered Timeout';

	/// en: 'Failed to create TUN virtual network adapter'
	String get tunDeviceCreateFailed => 'Failed to create TUN virtual network adapter';

	/// en: 'Test'
	String get test => 'Test';

	/// en: 'Add Website'
	String get addWebsite => 'Add Website';
}

// Path: permission
class Translations$permission$en {
	Translations$permission$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Camera'
	String get camera => 'Camera';

	/// en: 'Screen Recording'
	String get screen => 'Screen Recording';

	/// en: 'Get Application List'
	String get appQuery => 'Get Application List';

	/// en: 'Turn on [$p] permission'
	String request({required Object p}) => 'Turn on [${p}] permission';

	/// en: 'Please Turn on [$p] permission'
	String requestNeed({required Object p}) => 'Please Turn on [${p}] permission';
}

// Path: tls
class Translations$tls$en {
	Translations$tls$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Skip Certificate Verification'
	String get insecure => 'Skip Certificate Verification';

	/// en: 'Certificate'
	String get certificate => 'Certificate';

	/// en: 'Private Key'
	String get privateKey => 'Private Key';

	/// en: 'Custom Certifactes'
	String get customTrustCert => 'Custom Certifactes';
}

// Path: tun
class Translations$tun$en {
	Translations$tun$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Network stack'
	String get stack => 'Network stack';

	/// en: 'gVisor'
	String get stackGvisor => 'gVisor';

	/// en: 'User-space network stack, high stability and compatibility'
	String get stackGvisorDesc => 'User-space network stack, high stability and compatibility';

	/// en: 'System'
	String get stackSystem => 'System';

	/// en: 'OS native network stack, high performance but depends on system'
	String get stackSystemDesc => 'OS native network stack, high performance but depends on system';

	/// en: 'Mixed'
	String get stackMixed => 'Mixed';

	/// en: 'Mixed stack mode, balancing performance and compatibility'
	String get stackMixedDesc => 'Mixed stack mode, balancing performance and compatibility';

	/// en: 'MIPS (Mihomo IP Stack)'
	String get stackMips => 'MIPS (Mihomo IP Stack)';

	/// en: 'Mihomo high-performance IP stack with high throughput and low latency'
	String get stackMipsDesc => 'Mihomo high-performance IP stack with high throughput and low latency';

	/// en: 'IPv4 Gateway Address'
	String get inet4Address => 'IPv4 Gateway Address';

	/// en: 'IPv6 Gateway Address'
	String get inet6Address => 'IPv6 Gateway Address';

	/// en: 'DNS Hijack'
	String get dnsHijack => 'DNS Hijack';

	/// en: 'Strict Route'
	String get strictRoute => 'Strict Route';

	/// en: 'Default Route'
	String get tunDefaultRoute => 'Default Route';

	/// en: 'ICMP Forwarding'
	String get icmpForward => 'ICMP Forwarding';

	/// en: 'Allow Apps to Bypass VPN'
	String get allowBypass => 'Allow Apps to Bypass VPN';

	/// en: 'Append HTTP Proxy to VPN'
	String get appendHttpProxy => 'Append HTTP Proxy to VPN';

	/// en: 'Domains allowed to bypass HTTP proxy'
	String get bypassHttpProxyDomain => 'Domains allowed to bypass HTTP proxy';
}

// Path: dns
class Translations$dns$en {
	Translations$dns$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Listen'
	String get listen => 'Listen';

	/// en: 'fake-ip'
	String get fakeIp => 'fake-ip';

	/// en: 'Fallback'
	String get fallback => 'Fallback';

	/// en: 'Prefer DoH H3'
	String get preferH3 => 'Prefer DoH H3';

	/// en: 'Use Hosts'
	String get useHosts => 'Use Hosts';

	/// en: 'Use System Hosts'
	String get useSystemHosts => 'Use System Hosts';

	/// en: 'Enhanced Mode'
	String get enhancedMode => 'Enhanced Mode';

	/// en: 'fake-ip Filter Mode'
	String get fakeIPFilterMode => '${_root.dns.fakeIp} Filter Mode';

	/// en: 'fake-ip Filter'
	String get fakeIPFilter => 'fake-ip Filter';

	/// en: 'Respect Rules'
	String get respectRules => 'Respect Rules';

	/// en: 'NameServer'
	String get nameServer => 'NameServer';

	/// en: 'Default NameServer'
	String get defaultNameServer => '${_root.meta.byDefault} ${_root.dns.nameServer}';

	/// en: 'Proxy NameServer'
	String get proxyNameServer => '${_root.meta.proxy} ${_root.dns.nameServer}';

	/// en: 'Direct NameServer'
	String get directNameServer => '${_root.meta.direct} ${_root.dns.nameServer}';

	/// en: 'Fallback NameServer'
	String get fallbackNameServer => '${_root.dns.fallback} ${_root.dns.nameServer}';

	/// en: 'Fallback GeoIp'
	String get fallbackGeoIp => '${_root.dns.fallback} GeoIp';

	/// en: 'Fallback GeoIpCode'
	String get fallbackGeoIpCode => '${_root.dns.fallback} GeoIpCode';

	/// en: 'Flush DNS Cache'
	String get flushCache => 'Flush DNS Cache';

	/// en: 'DNS and Fake-IP cache flushed successfully'
	String get flushCacheSuccess => 'DNS and Fake-IP cache flushed successfully';

	/// en: 'Quick DNS Presets'
	String get presets => 'Quick DNS Presets';

	/// en: 'High-Speed Dual Stack'
	String get presetSpeed => 'High-Speed Dual Stack';

	/// en: 'AliDNS DoH3 + DNSPod DoH: Instant domestic connection, smart split routing'
	String get presetSpeedDesc => 'AliDNS DoH3 + DNSPod DoH: Instant domestic connection, smart split routing';

	/// en: 'Anti-Pollution & Privacy'
	String get presetSecure => 'Anti-Pollution & Privacy';

	/// en: 'Cloudflare DoH3 + Google DoH: Eliminate DNS hijacking and censorship'
	String get presetSecureDesc => 'Cloudflare DoH3 + Google DoH: Eliminate DNS hijacking and censorship';

	/// en: 'AdGuard Ad-Blocking & Clean'
	String get presetAdGuard => 'AdGuard Ad-Blocking & Clean';

	/// en: 'AdGuard DoQ + AliDNS DoH: Deep request filtering and privacy protection'
	String get presetAdGuardDesc => 'AdGuard DoQ + AliDNS DoH: Deep request filtering and privacy protection';

	/// en: 'Override DNS configuration from subscription profiles'
	String get overwriteDesc => 'Override DNS configuration from subscription profiles';

	/// en: 'Enable custom DNS resolver'
	String get enableDesc => 'Enable custom DNS resolver';

	/// en: 'Restore Defaults'
	String get resetFakeIpFilter => 'Restore Defaults';

	/// en: 'Are you sure you want to restore the recommended Fake-IP filter list?'
	String get resetFakeIpFilterConfirm => 'Are you sure you want to restore the recommended Fake-IP filter list?';

	/// en: 'Live DNS Query Diagnostic'
	String get dnsTester => 'Live DNS Query Diagnostic';

	/// en: 'Test'
	String get testQuery => 'Test';

	/// en: 'Fake-IP Matched'
	String get fakeIpDetected => 'Fake-IP Matched';

	/// en: 'Real Public IP'
	String get realIpDetected => 'Real Public IP';

	/// en: 'Add DNS Server'
	String get addServer => 'Add DNS Server';

	/// en: 'GEO Offline Databases'
	String get geoAssetsTitle => 'GEO Offline Databases';

	/// en: 'Manage GeoSite domain ruleset, GeoIP and ASN databases'
	String get geoAssetsDesc => 'Manage GeoSite domain ruleset, GeoIP and ASN databases';

	/// en: 'Download CDN Mirror'
	String get cdnSource => 'Download CDN Mirror';

	/// en: 'Update All'
	String get updateAll => 'Update All';

	/// en: 'Update succeeded'
	String get updateSuccess => 'Update succeeded';

	/// en: 'Update failed'
	String get updateFailed => 'Update failed';

	/// en: 'Add Preset DNS'
	String get addPresetServer => 'Add Preset DNS';

	/// en: 'Manage Filter List ($p)'
	String manageFakeIpFilter({required Object p}) => 'Manage Filter List (${p})';

	/// en: '$p domain rules bypass Fake-IP resolution to avoid network isolation issues.'
	String fakeIpFilterDesc({required Object p}) => '${p} domain rules bypass Fake-IP resolution to avoid network isolation issues.';
}

// Path: sniffer
class Translations$sniffer$en {
	Translations$sniffer$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Override'
	String get overrideDest => 'Override';
}

// Path: profilePatchMode
class Translations$profilePatchMode$en {
	Translations$profilePatchMode$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Current Selected'
	String get currentSelected => 'Current Selected';

	/// en: 'Built-in Overwrite'
	String get overwrite => 'Built-in Overwrite';

	/// en: 'Built-in - no Overwrite'
	String get noOverwrite => 'Built-in - no Overwrite';
}

// Path: main.tray
class Translations$main$tray$en {
	Translations$main$tray$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Show Window'
	String get menuOpen => 'Show Window';

	/// en: 'Exit'
	String get menuExit => 'Exit';

	/// en: 'Disconnected'
	String get coreDisconnected => 'Disconnected';

	/// en: 'Connected'
	String get coreRunning => 'Connected';

	/// en: 'Connect'
	String get startProxy => 'Connect';

	/// en: 'Disconnect'
	String get stopProxy => 'Disconnect';

	/// en: 'Restart Core'
	String get restartCore => 'Restart Core';

	/// en: 'System Proxy'
	String get systemProxyItem => 'System Proxy';

	/// en: 'TUN Mode'
	String get tunModeItem => 'TUN Mode';

	/// en: 'Proxy Mode'
	String get outboundMode => 'Proxy Mode';

	/// en: 'Rule'
	String get modeRule => 'Rule';

	/// en: 'Global'
	String get modeGlobal => 'Global';

	/// en: 'Direct'
	String get modeDirect => 'Direct';

	/// en: 'Profiles'
	String get profilesMenu => 'Profiles';

	/// en: 'Update All Profiles'
	String get updateAllProfiles => 'Update All Profiles';

	/// en: 'Proxy Nodes'
	String get proxyNodes => 'Proxy Nodes';

	/// en: 'Tools'
	String get tools => 'Tools';

	/// en: 'Copy Proxy Command'
	String get copyProxyCmd => 'Copy Proxy Command';

	/// en: 'Speed Test All Nodes'
	String get delayTestAll => 'Speed Test All Nodes';

	/// en: 'Open Dashboard'
	String get openDashboard => 'Open Dashboard';

	/// en: 'Repair Network / Reset System Proxy'
	String get resetSystemProxy => 'Repair Network / Reset System Proxy';

	/// en: 'PowerShell Command'
	String get copyCmdPowerShell => 'PowerShell Command';

	/// en: 'CMD Command'
	String get copyCmdCmd => 'CMD Command';

	/// en: 'Bash/Zsh Command'
	String get copyCmdBash => 'Bash/Zsh Command';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'WelcomeLanguageScreen.welcomeTitle' => 'Welcome to Wmimo',
			'WelcomeLanguageScreen.selectLanguage' => 'Select Language',
			'WelcomeLanguageScreen.subtitle' => 'Please select your preferred language. You can change it anytime in settings.',
			'WelcomeLanguageScreen.start' => 'Get Started',
			'BackupAndSyncWebdavScreen.webdavServerUrl' => 'Server Url',
			'BackupAndSyncWebdavScreen.webdavRequired' => 'Can not be empty',
			'BackupAndSyncWebdavScreen.webdavLoginFailed' => 'Login failed:',
			'BackupAndSyncWebdavScreen.webdavListFailed' => 'Failed to get file list:',
			'LaunchFailedScreen.invalidProcess' => 'The app failed to start [Invalid process name], please reinstall the app to a separate directory',
			'LaunchFailedScreen.invalidProfile' => 'The app failed to start [Failed to access the profile], please reinstall the app',
			'LaunchFailedScreen.invalidVersion' => 'The app failed to start [Invalid version], please reinstall the app',
			'LaunchFailedScreen.systemVersionLow' => 'The app failed to start [system version too low]',
			'LaunchFailedScreen.invalidInstallPath' => 'The installation path is invalid, please reinstall it to a valid path',
			'PerAppAndroidScreen.title' => 'Per-App Proxy',
			'PerAppAndroidScreen.whiteListMode' => 'Whitelist Mode',
			'PerAppAndroidScreen.whiteListModeTip' => 'When enabled: only the apps that have been checked are proxies; when not enabled: only the apps that are not checked are proxies',
			'PerAppAndroidScreen.manualAddPackage' => 'Manually Add Package Name',
			'PerAppAndroidScreen.manualAddPackageHint' => 'Enter package names to proxy (multiple supported, separated by spaces, commas or newlines, e.g.: org.telegram.messenger, com.google.android.youtube):',
			'PerAppAndroidScreen.quickAddPresets' => 'Quick Add Common Proxy Apps',
			'PerAppAndroidScreen.saveSelected' => 'Save Selected',
			'PerAppAndroidScreen.permissionRestrictedTip' => 'The system restricted reading the app list. Please tap 【Open System Permission Settings】 below to enable \'Get installed apps\', or use preset apps directly without permission.',
			'PerAppAndroidScreen.openSystemPermission' => 'Open System Permission Settings',
			'PerAppAndroidScreen.presetApps' => 'Quick Add Common Apps (Preset)',
			'PerAppAndroidScreen.requestPermissionPopup' => 'Request Permission (System Dialog)',
			'UserAgreementScreen.privacyFirst' => 'Your Privacy Comes First',
			'UserAgreementScreen.agreeAndContinue' => 'Accept & Continue',
			'VersionUpdateScreen.versionReady' => ({required Object p}) => 'The new version[${p}] is ready',
			'VersionUpdateScreen.update' => 'Restart To Update',
			'VersionUpdateScreen.cancel' => 'Not Now',
			'NetCheckScreen.title' => 'Network Diagnostics',
			'NetCheckScreen.fullDiagnosticsTab' => 'Full Diagnostics',
			'NetCheckScreen.advancedCheckTab' => 'Advanced Domain Query',
			'NetCheckScreen.startDiagnostics' => 'Start Diagnostics',
			'NetCheckScreen.reDiagnostics' => 'Retest',
			'NetCheckScreen.diagnosing' => 'Diagnosing network pipeline...',
			'NetCheckScreen.healthScore' => 'Health Score',
			'NetCheckScreen.scorePerfect' => 'Excellent',
			'NetCheckScreen.scoreGood' => 'Good',
			'NetCheckScreen.scoreWarning' => 'Warning',
			'NetCheckScreen.scoreCritical' => 'Blocked',
			'NetCheckScreen.oneClickRepair' => 'One-Click Auto Repair',
			'NetCheckScreen.repairSuccess' => 'Auto-repair succeeded, network restored',
			'NetCheckScreen.repairFailed' => 'Repair applied, manual verification may be needed',
			'NetCheckScreen.repairing' => 'Executing auto-repair...',
			'NetCheckScreen.issueFound' => ({required Object count}) => '${count} issue(s) found',
			'NetCheckScreen.noIssue' => 'All checks passed',
			'NetCheckScreen.details' => 'Technical Details',
			'NetCheckScreen.copyDetails' => 'Copy Details',
			'NetCheckScreen.detailsCopied' => 'Diagnostic log copied to clipboard',
			'NetCheckScreen.stepPhysical' => 'Physical Network & Gateway',
			'NetCheckScreen.stepDns' => 'DNS & Fake-IP Engine',
			'NetCheckScreen.stepCore' => 'Core Process & Ports',
			'NetCheckScreen.stepProxy' => 'System Proxy Configuration',
			'NetCheckScreen.stepHandshake' => 'Internet End-to-End Handshake',
			'NetCheckScreen.suggestedAction' => 'Suggestion',
			'NetCheckScreen.autoRepairAction' => 'Repair Now',
			'NetCheckScreen.enterDomain' => 'Please enter a domain',
			'NetCheckScreen.checking' => 'Checking...',
			'NetCheckScreen.aQueryFailed' => ({required Object p}) => 'A query failed: ${p}',
			'NetCheckScreen.aaaaQueryFailed' => ({required Object p}) => 'AAAA query failed: ${p}',
			'NetCheckScreen.success' => 'Success',
			'NetCheckScreen.failed' => 'Failed',
			'NetCheckScreen.suspectedPollution' => 'Suspected DNS poisoning',
			'NetCheckScreen.domainLabel' => 'Domain',
			'NetCheckScreen.checkButton' => 'Check',
			'NetCheckScreen.dnsSection' => '1. DNS Query',
			'NetCheckScreen.directHttpSection' => '2. HTTP (via TUN, enable TUN first)',
			'NetCheckScreen.proxyHttpSection' => ({required Object p}) => '3. HTTP (via Proxy, port: ${p})',
			'NetCheckScreen.tunNotEnabled' => 'TUN is not enabled',
			'NetCheckScreen.routeTableSection' => '4. Route Table',
			'NetCheckScreen.stepPhysicalDesc' => 'Checks physical network adapter, local IP, and gateway connectivity',
			'NetCheckScreen.stepDnsDesc' => 'Verifies local DNS resolution latency and core DNS engine status',
			'NetCheckScreen.stepCoreDesc' => 'Checks Mihomo process status and Mixed-Port / API listening ports',
			'NetCheckScreen.stepProxyDesc' => 'Verifies system proxy settings and checks for residual zombie proxy settings',
			'NetCheckScreen.stepHandshakeDesc' => 'Tests end-to-end latency and reachability to global CDN via active node',
			'NetCheckScreen.shortStepPhysical' => 'NIC',
			'NetCheckScreen.shortStepDns' => 'DNS',
			'NetCheckScreen.shortStepCore' => 'Core',
			'NetCheckScreen.shortStepProxy' => 'Proxy',
			'NetCheckScreen.shortStepHandshake' => 'WAN',
			'NetCheckScreen.valNicNormal' => ({required Object p}) => 'Network connected (${p})',
			'NetCheckScreen.valNicNone' => 'No available network interfaces found',
			'NetCheckScreen.valNicGatewayTimeout' => 'Local IP acquired, but external gateway timed out',
			'NetCheckScreen.valNicError' => 'Network interface check error',
			'NetCheckScreen.valDnsNormal' => ({required Object p}) => 'DNS response normal (${p})',
			'NetCheckScreen.valDnsEmpty' => 'DNS query returned empty list',
			'NetCheckScreen.valDnsTimeout' => 'DNS query timed out or failed',
			'NetCheckScreen.valCoreNormal' => ({required Object port, required Object mode}) => 'Core healthy (Mixed Port: ${port}, Mode: ${mode})',
			'NetCheckScreen.valCoreNotRunning' => 'Core service is not running',
			'NetCheckScreen.valCorePortConflict' => ({required Object p}) => 'Port ${p} is occupied by another program',
			'NetCheckScreen.valCoreApiFailed' => 'Core unresponsive (API communication failed)',
			'NetCheckScreen.valCoreError' => 'Core check error',
			'NetCheckScreen.valProxyActive' => ({required Object port}) => 'System proxy active (127.0.0.1:${port})',
			'NetCheckScreen.valProxyDisabled' => 'System proxy disabled (Direct / TUN / Manual mode)',
			'NetCheckScreen.valProxyZombie' => 'Residual system proxy detected (blocking internet)',
			'NetCheckScreen.valProxyFailed' => 'System proxy failed to enable',
			'NetCheckScreen.valProxyWarning' => 'System proxy status warning',
			'NetCheckScreen.valHandshakeNormal' => ({required Object node, required Object delay}) => 'Internet handshake normal (${node} • ${delay} ms)',
			'NetCheckScreen.valHandshakeFailed' => ({required Object node, required Object err}) => 'Current node [${node}] handshake failed (${err})',
			'NetCheckScreen.valHandshakeSkipped' => 'Core not started, skipped internet handshake test',
			'NetCheckScreen.valHandshakeError' => 'Internet handshake error',
			'NetCheckScreen.issueNicDisconnected' => 'Network card not connected to any network (cable unplugged, Wi-Fi off, or airplane mode)',
			'NetCheckScreen.suggestNicCheck' => 'Please check your Ethernet cable, Wi-Fi connection, or network adapter status',
			'NetCheckScreen.suggestNicReset' => 'Try disabling and re-enabling the network adapter in system settings',
			'NetCheckScreen.issueNicGatewayUnreachable' => 'Connected to LAN, but external gateway unreachable (captive portal, login required, or router offline)',
			'NetCheckScreen.suggestNicGateway' => 'Check router status or open browser to complete captive portal / Web authentication',
			'NetCheckScreen.issueDnsPollution' => 'Local DNS service not responding; possible DNS pollution or gateway hijacking',
			'NetCheckScreen.suggestDnsReset' => 'Reset system DNS or enable Smart Encrypted DNS (DoH/DoT) in Wmimo',
			'NetCheckScreen.actionFlushDns' => 'Flush System DNS Cache',
			'NetCheckScreen.suggestDnsSlow' => 'DNS latency is high; consider enabling Smart Encrypted DNS',
			'NetCheckScreen.issueDnsFailed' => 'Local DNS resolution failed; unable to resolve domain names to IP addresses',
			'NetCheckScreen.suggestDnsFlush' => 'Click to flush DNS cache, or enable encrypted DNS in Wmimo settings',
			'NetCheckScreen.issueCorePortConflict' => 'Port conflict detected! Another proxy app or service is occupying the port',
			'NetCheckScreen.suggestCoreChangePort' => 'Close other proxy clients completely, or change the port in Wmimo settings',
			'NetCheckScreen.actionRestartCore' => 'Restart Core',
			'NetCheckScreen.issueCoreStopped' => 'Wmimo core process is currently stopped',
			'NetCheckScreen.suggestCoreStart' => 'Click the connect switch on the home screen or click Start Core below',
			'NetCheckScreen.actionStartCore' => 'Start Core Process',
			'NetCheckScreen.issueCoreFrozen' => 'Core process is unresponsive or API authentication mismatched',
			'NetCheckScreen.suggestCoreRestart' => 'Restart the core to recover service',
			'NetCheckScreen.suggestCoreReinstall' => 'Try restarting the core or reinstalling service drivers',
			'NetCheckScreen.issueProxyZombie' => 'Residual system proxy forwards traffic to an inactive port, causing internet loss',
			'NetCheckScreen.suggestProxyReset' => 'Click Clean & Reset System Proxy below to immediately restore internet access',
			'NetCheckScreen.actionResetProxy' => 'Clean & Reset System Proxy',
			'NetCheckScreen.issueProxyBlocked' => 'System proxy not applied, possibly blocked by antivirus or permission limits',
			'NetCheckScreen.suggestProxyReapply' => 'Click below to re-register and force apply system proxy',
			'NetCheckScreen.actionReapplyProxy' => 'Re-apply System Proxy',
			'NetCheckScreen.issueProxyRead' => 'Non-fatal exception reading system proxy settings',
			'NetCheckScreen.issueHandshakeBlocked' => 'Current proxy node cannot connect to internet; handshake failed or blocked',
			'NetCheckScreen.suggestHandshakeSwitch' => 'Node may be down or unreachable; please switch to another node',
			'NetCheckScreen.suggestHandshakeSlow' => ({required Object delay}) => 'High node latency (${delay} ms); consider testing and selecting a closer node',
			'NetCheckScreen.suggestHandshakeCheck' => 'Check node configuration or change latency test target',
			'NetCheckScreen.conclusionPerfect' => 'Pipeline excellent! All network nodes and proxy configs are fully operational.',
			'NetCheckScreen.conclusionGood' => 'Pipeline generally normal, minor non-critical latency or warnings detected.',
			'NetCheckScreen.conclusionWarning' => 'Issues detected in network or proxy pipeline; please use One-Click Repair below.',
			'NetCheckScreen.conclusionCritical' => 'Severe network blockage! Local network disconnected or proxy core blocked.',
			'SpeedTestScreen.title' => 'Speed Test',
			'SpeedTestScreen.startTest' => 'Start Test',
			'SpeedTestScreen.stopTest' => 'Stop Test',
			'SpeedTestScreen.reTest' => 'Retest',
			'SpeedTestScreen.ready' => 'Ready',
			'SpeedTestScreen.testingPing' => 'Testing Ping & Jitter...',
			'SpeedTestScreen.testingDownload' => 'Testing Download Speed...',
			'SpeedTestScreen.testingUpload' => 'Testing Upload Speed...',
			'SpeedTestScreen.completed' => 'Test Completed',
			'SpeedTestScreen.stopped' => 'Stopped',
			'SpeedTestScreen.ping' => 'Ping',
			'SpeedTestScreen.jitter' => 'Jitter',
			'SpeedTestScreen.download' => 'Download',
			'SpeedTestScreen.upload' => 'Upload',
			'SpeedTestScreen.currentProxy' => 'Current Proxy',
			'SpeedTestScreen.directConnection' => 'Direct Mode',
			'SpeedTestScreen.server' => 'Speed Test Server',
			'SpeedTestScreen.serverLocation' => 'Server Location',
			'SpeedTestScreen.realtimeSpeed' => 'Real-time Speed Curve',
			'SpeedTestScreen.peakSpeed' => 'Peak Speed',
			'SpeedTestScreen.avgSpeed' => 'Avg Speed',
			'SpeedTestScreen.testHistory' => 'History',
			'SpeedTestScreen.clearHistory' => 'Clear History',
			'loginScreen.login' => 'Login',
			'loginScreen.register' => 'Register Account',
			'loginScreen.forgotPassword' => 'Forgot Password',
			'loginScreen.provider' => 'Provider',
			'loginScreen.providerName' => '${_root.loginScreen.provider} Code/Alias/URL',
			'loginScreen.providerNameRequired' => 'Please enter the ${_root.loginScreen.provider} code/alias/URL',
			'loginScreen.account' => 'Account',
			'loginScreen.accountRequired' => 'Please enter account',
			'loginScreen.email' => 'Email',
			'loginScreen.emailRequired' => 'Please enter email address',
			'loginScreen.password' => 'Password',
			'loginScreen.passwordRequired' => 'Please enter password',
			'loginScreen.validEmailRequired' => 'Please enter valid email address',
			'loginScreen.passwordMinLength' => ({required Object minLength}) => 'Password length at least ${minLength} characters',
			'loginScreen.unsupportedProvider' => 'Unsupported ${_root.loginScreen.provider}',
			'loginScreen.unsupportedProviderType' => 'Unsupported ${_root.loginScreen.provider} type',
			'loginScreen.unActivedProvider' => 'Login feature is not activated',
			'loginScreen.providerLoginSupportRequired' => ({required Object p}) => 'Please request the provider code/alias from your ${_root.loginScreen.provider}.\nFor ${_root.loginScreen.provider} integration, please refer to: ${p}',
			'loginScreen.providerDisclaimer' => 'Disclaimer: ${_root.loginScreen.provider} is a third-party service and is not affiliated with this app',
			'loginScreen.createSessionFailed' => 'Failed to create session, check provider or account',
			'main.tray.menuOpen' => 'Show Window',
			'main.tray.menuExit' => 'Exit',
			'main.tray.coreDisconnected' => 'Disconnected',
			'main.tray.coreRunning' => 'Connected',
			'main.tray.startProxy' => 'Connect',
			'main.tray.stopProxy' => 'Disconnect',
			'main.tray.restartCore' => 'Restart Core',
			'main.tray.systemProxyItem' => 'System Proxy',
			'main.tray.tunModeItem' => 'TUN Mode',
			'main.tray.outboundMode' => 'Proxy Mode',
			'main.tray.modeRule' => 'Rule',
			'main.tray.modeGlobal' => 'Global',
			'main.tray.modeDirect' => 'Direct',
			'main.tray.profilesMenu' => 'Profiles',
			'main.tray.updateAllProfiles' => 'Update All Profiles',
			'main.tray.proxyNodes' => 'Proxy Nodes',
			'main.tray.tools' => 'Tools',
			'main.tray.copyProxyCmd' => 'Copy Proxy Command',
			'main.tray.delayTestAll' => 'Speed Test All Nodes',
			'main.tray.openDashboard' => 'Open Dashboard',
			'main.tray.resetSystemProxy' => 'Repair Network / Reset System Proxy',
			'main.tray.copyCmdPowerShell' => 'PowerShell Command',
			'main.tray.copyCmdCmd' => 'CMD Command',
			'main.tray.copyCmdBash' => 'Bash/Zsh Command',
			'meta.enable' => 'Enable',
			'meta.disable' => 'Disable',
			'meta.open' => 'Open',
			'meta.close' => 'Close',
			'meta.quit' => 'Quit',
			'meta.add' => 'Add',
			'meta.addSuccess' => 'Added successfully',
			'meta.addFailed' => ({required Object p}) => 'Add failed:${p}',
			'meta.remove' => 'Remove',
			'meta.removeConfirm' => 'Are you sure to delete?',
			'meta.edit' => 'Edit',
			'meta.view' => 'View',
			'meta.remark' => 'Remark',
			'meta.byDefault' => 'Default',
			'meta.editRemark' => 'Edit Remark',
			'meta.more' => 'More',
			'meta.tips' => 'Info',
			'meta.selectAll' => 'Select All',
			'meta.copy' => 'Copy',
			'meta.paste' => 'Paste',
			'meta.cut' => 'Cut',
			'meta.save' => 'Save',
			'meta.ok' => 'Ok',
			'meta.cancel' => 'Cancel',
			'meta.faq' => 'FAQ',
			'meta.doc' => 'Document',
			'meta.htmlTools' => 'HTML Toolset',
			'meta.download' => 'Download',
			'meta.loading' => 'Loading...',
			'meta.days' => 'Days',
			'meta.hours' => 'Hours',
			'meta.minutes' => 'Minutes',
			'meta.seconds' => 'Seconds',
			'meta.milliseconds' => 'Milliseconds',
			'meta.protocol' => 'Protocol',
			'meta.search' => 'Search',
			'meta.custom' => 'Custom',
			'meta.connect' => 'Connect',
			'meta.disconnect' => 'Disconnect',
			'meta.connected' => 'Connected',
			'meta.disconnected' => 'Disconnected',
			'meta.connecting' => 'Connecting',
			'meta.connectTimeout' => 'Connect Timeout',
			'meta.timeout' => 'Timeout',
			'meta.timeoutDuration' => 'Timeout Duration',
			'meta.latency' => 'Latency',
			'meta.latencyTest' => 'Latency Test',
			'meta.networkCheck' => 'Network Check',
			'meta.speedTest' => 'Speed Test',
			'meta.language' => 'Language',
			'meta.next' => 'Next',
			'meta.done' => 'Done',
			'meta.apply' => 'Apply',
			'meta.refresh' => 'Refresh',
			'meta.retry' => 'Retry?',
			'meta.update' => 'Update',
			'meta.updateInterval' => 'Update interval',
			'meta.updateFailed' => ({required Object p}) => 'Update failed:${p}',
			'meta.updateInterval5mTips' => 'Minimum: 5m',
			'meta.updateIntervalPreferByProfile' => 'Prefer provider settings',
			'meta.none' => 'None',
			'meta.reset' => 'Reset',
			'meta.resetConfirm' => 'Are you sure you want to reset all app settings?',
			'meta.resetSuccess' => 'App settings have been reset to defaults',
			'meta.resetCoreConfirm' => 'Are you sure you want to reset core settings and override configurations?',
			'meta.resetCoreSuccess' => 'Core settings have been reset to defaults',
			'meta.authentication' => 'Authentication',
			'meta.submit' => 'Submit',
			'meta.user' => 'User',
			'meta.account' => 'Account',
			'meta.password' => 'Password',
			'meta.decryptPassword' => 'Decrypt Password',
			'meta.required' => 'Required',
			'meta.go' => 'Continue',
			'meta.sudoPassword' => 'sudo password (required for TUN mode)',
			'meta.other' => 'Other',
			'meta.dns' => 'DNS',
			'meta.url' => 'URL',
			'meta.urlInvalid' => 'Invalid URL',
			'meta.urlCannotEmpty' => 'Link can not be empty',
			'meta.urlTooLong' => 'URL is too long (>8182)',
			'meta.copyUrl' => 'Copy Link',
			'meta.openUrl' => 'Open Link',
			'meta.shareUrl' => 'Share Link',
			'meta.coreSettingTips' => 'Note: After modifying the configuration, you need to reconnect to take effect',
			'meta.overwrite' => 'Overwrite',
			'meta.overwriteCustom' => 'Custom Overwrite',
			'meta.overwriteAppend' => 'Append Overwrite',
			'meta.overwriteTips' => 'Original Profile <- Custom Overwrite <- App Overwrite',
			'meta.noOverwrite' => 'Do not overwrite',
			'meta.overwriteSettings' => 'Overwrite Settings',
			'meta.diversionTemplates' => 'Routing Templates',
			'meta.ruleProviders' => 'Rule Sets (RuleSet)',
			'meta.ruleTemplates' => 'Rule Templates',
			'meta.proxyGroupsTemplates' => 'Group Templates',
			'meta.proxyGroups' => 'Proxy Groups',
			'meta.proxyNodeList' => 'Proxy Node list',
			'meta.proxyNodeFailure' => ({required Object p}) => 'The following proxy nodes have expired and have been automatically removed: ${p}',
			'meta.externalController' => 'External Controller',
			'meta.secret' => 'Secret',
			'meta.tcpConcurrent' => 'TCP Concurrent Handshake',
			'meta.globalClientFingerprint' => 'TLS Global Fingerprint',
			'meta.allowLanAccess' => 'LAN device access',
			'meta.mixedPort' => 'Mixed Proxy Port',
			'meta.logLevel' => 'Log Level',
			'meta.findProcessMode' => 'Find Process Mode',
			'meta.tcpkeepAliveInterval' => 'TCP Keep-alive Interval',
			'meta.delayTestUrl' => 'Delay Test URL',
			'meta.delayTestTimeout' => 'Delay Test Timeout(ms)',
			'meta.tun' => 'TUN',
			'meta.ntp' => 'NTP',
			'meta.tls' => 'TLS',
			'meta.geo' => 'GEO',
			'meta.geoDownloadByProxy' => 'Downloading Geo RuleSet by proxy',
			'meta.geoRulesetTips' => 'Geosite/Geoip will be converted into the corresponding RuleSet',
			'meta.asnNotSupportInIosTips' => 'Due to iOS system memory limitations, IP-ASN and SRC-IP-ASN rules will be ignored on iOS.',
			'meta.sniffer' => 'Sniffer',
			'meta.userAgent' => 'UserAgent',
			'meta.launchAtStartup' => 'Launch at Startup',
			'meta.launchAtStartupRunAsAdmin' => 'Please restart Wmimo as administrator',
			'meta.tunModeRunAsAdmin' => 'The TUN mode requires system administrator permissions, please restart the app as an administrator',
			'meta.tunSwitchToSystemProxy' => 'Would you like to temporarily switch to [System Proxy Mode] to continue connecting?',
			'meta.tunCreateAdapterFailedAdmin' => 'Failed to create TUN virtual adapter: Access is denied.\nTUN mode requires administrator privileges. Please right-click and choose [Run as administrator], or turn off TUN mode in the main screen/core settings and connect using system proxy.',
			'meta.portableMode' => 'Portable Mode',
			'meta.portableModeDisableTips' => 'If you need to exit portable mode, please exit [Wmimo] and manually delete the [portable] folder in the same directory as [wmimo.exe]',
			'meta.systemProxy' => 'System Proxy',
			'meta.autoConnectAfterLaunch' => 'Auto Connection after Launch',
			'meta.autoConnectAtBoot' => 'Auto Connection after System Startup',
			'meta.autoConnectAtBootTips' => 'System support is required; some systems may also require [auto-start] to be enabled.',
			'meta.hideAfterLaunch' => 'Hide window after startup',
			'meta.autoSetSystemProxy' => 'Auto Set System Proxy when Connected',
			'meta.bypassSystemProxy' => 'Domain names that are allowed to bypass the system proxy',
			'meta.excludeFromRecent' => 'Hide from [Recent Tasks]',
			'meta.wakeLock' => 'Wake Lock',
			'meta.hideVpn' => 'Hide VPN Icon',
			'meta.hideVpnTips' => 'Enabling IPv6 will cause this function to fail',
			'meta.hideDockIcon' => 'Hide Dock Icon',
			'meta.showTrayTraffic' => 'Show traffic info in tray',
			'meta.website' => 'Website',
			'meta.homePage' => 'Home Page',
			'meta.rule' => 'Rule',
			'meta.global' => 'Global',
			'meta.direct' => 'Direct',
			'meta.block' => 'Block',
			'meta.qrcode' => 'QR Code',
			'meta.qrcodeTooLong' => 'The text is too long to display',
			'meta.qrcodeShare' => 'Share QR Code',
			'meta.textToQrcode' => 'Text To QR Code',
			'meta.qrcodeScan' => 'Scan QR Code',
			'meta.qrcodeScanResult' => 'Scan Result',
			'meta.qrcodeScanFromImage' => 'Scan From Image',
			'meta.qrcodeScanFromClipboard' => 'From Clipboard',
			'meta.qrcodeRecognized' => 'QR Code Recognized',
			'meta.qrcodeDropHint' => 'Click buttons above to capture screen or select an image',
			'meta.confirmImport' => 'Confirm Import',
			'meta.reScan' => 'Scan Again',
			'meta.qrcodeScanResultFailed' => 'Failed to parse the image, please make sure the screenshot is a valid QR code',
			'meta.qrcodeScanResultEmpty' => 'Scan Result is empty',
			'meta.screenshot' => 'Screenshot',
			'meta.backupAndSync' => 'Backup and Sync',
			'meta.importSuccess' => 'Import Success',
			'meta.rewriteConfirm' => 'This file will overwrite the existing local configuration. Do you want to continue?',
			'meta.importAndExport' => 'Import and Export',
			'meta.import' => 'Import',
			'meta.importFromUrl' => 'Import from URL',
			'meta.export' => 'Export',
			'meta.send' => 'Send',
			'meta.receive' => 'Receive',
			'meta.sendConfirm' => 'Confirm to send?',
			'meta.continueConnectConfirm' => 'Continue to connect?',
			'meta.termOfUse' => 'Terms of Service',
			'meta.privacyPolicy' => 'Privacy & Policy',
			'meta.log' => 'Log',
			'meta.coreLog' => 'Core Logs',
			'meta.core' => 'Core',
			'meta.help' => 'Help',
			'meta.tutorial' => 'Tutorial',
			'meta.board' => 'Board',
			'meta.boardOnline' => 'Use Online Board',
			'meta.boardOnlineUrl' => 'Online Board URL',
			'meta.boardLocalPort' => 'Local Board Port',
			'meta.connections' => 'Connections',
			'meta.closeAllConnections' => 'Close All Connections',
			'meta.searchConnections' => 'Search connections (Domain/IP/Rule/Process)',
			'meta.noFilterResults' => 'No matching connections',
			'meta.searchRules' => 'Search rules (Type/Payload/Proxy)',
			'meta.searchProfiles' => 'Search profiles (Name/URL/Remark)',
			'meta.noMatchingProfiles' => 'No matching profiles found',
			'meta.rules' => 'Routing Rules',
			'meta.clear' => 'Clear',
			'meta.copySuccess' => 'Copied to clipboard',
			'meta.alwayOnVPN' => 'Always-on Connection',
			'meta.disableFontScaler' => 'Disable Font scaling(Restart takes effect)',
			'meta.autoOrientation' => 'Rotate with the screen',
			'meta.restartTakesEffect' => 'Restart takes effect',
			'meta.reconnectTakesEffect' => 'Reconnect takes effect',
			'meta.runtimeProfile' => 'Runtime Profile',
			'meta.willCompleteAfterRebootInstall' => 'Please restart your device to complete the system extension installation',
			'meta.willCompleteAfterRebootUninstall' => 'Please restart your device to complete the the system extension uninstallation',
			'meta.requestNeedsUserApproval' => '1. Please [Allow] Wmimo to install system extensions in [System Settings]-[Privacy and Security]\n2. [System Settings]-[General]-[Login Items Extensions]-[Network Extension] enable [wmimoServiceSE]\nreconnect after completion',
			'meta.FullDiskAccessPermissionRequired' => 'Please enable wmimoServiceSE permission in [System Settings]-[Privacy and Security]-[Full Disk Access] and reconnect.',
			'meta.proxy' => 'Proxy',
			'meta.theme' => 'Theme',
			'meta.tvMode' => 'TV Mode',
			'meta.autoUpdate' => 'Auto Update',
			'meta.updateChannel' => 'Auto Update Channel',
			'meta.onlineCustomerService' => 'Online Customer Service',
			'meta.subscriptionChannel' => 'Subscription Channel',
			'meta.hasNewVersion' => ({required Object p}) => 'Update Version ${p}',
			'meta.autoDownloadPkg' => 'Auto Download Update Packages',
			'meta.devOptions' => 'Developer Options',
			'meta.joinUs' => 'Join Us',
			'meta.about' => 'About',
			'meta.name' => 'Name',
			'meta.version' => 'Version',
			'meta.notice' => 'Notice',
			'meta.sort' => 'Reorder',
			'meta.recommended' => 'Recommend',
			'meta.innerError' => ({required Object p}) => 'Inner Error:${p}',
			'meta.share' => 'Share',
			'meta.importFromClipboard' => 'Import From Clipboard',
			'meta.exportToClipboard' => 'Export to Clipboard',
			'meta.server' => 'Server',
			'meta.port' => 'Port',
			'meta.donate' => 'Donate',
			'meta.setting' => 'Settings',
			'meta.settingCore' => 'Core Settings',
			'meta.settingApp' => 'App Settings',
			'meta.coreOverwrite' => 'Core Overwrite',
			'meta.iCloud' => 'iCloud',
			'meta.webdav' => 'Webdav',
			'meta.lanSync' => 'LAN Sync',
			'meta.lanSyncNotQuitTips' => 'Do not exit this interface before synchronization is completed',
			'meta.deviceNoSpace' => 'Not enough disk space',
			'meta.hideSystemApp' => 'Hide System Apps',
			'meta.hideAppIcon' => 'Hide App Icons',
			'meta.openDir' => 'Open File Directory',
			'meta.type' => 'Type',
			'meta.fileChoose' => 'Select File',
			'meta.filePathCannotEmpty' => 'The file path can not be empty',
			'meta.fileNotExist' => ({required Object p}) => 'File does not exist:${p}',
			'meta.fileTypeInvalid' => ({required Object p}) => 'Invalid file type:${p}',
			'meta.uwpExemption' => 'UWP Network Isolation Exemptions',
			'meta.getProfile' => 'Get Subscription',
			'meta.buyProfile' => 'Buy Subscription',
			'meta.addProfile' => 'Add Subscription',
			'meta.myProfiles' => 'Subscriptions',
			'meta.profileEdit' => 'Edit Profile',
			'meta.profileNeedActive' => 'Please set this profile as the current profile first, then start/reconnect',
			'meta.profileDownloadBackupChannel' => 'Enable backup download channel',
			'meta.profileDownloadBackupChannelTips' => 'Proxy download channel provided by Wmimo (no information is stored)',
			'meta.profileEditReloadAfterProfileUpdate' => 'Reload after Profile update',
			'meta.profileRulesAppendApplePush' => 'Append Apple Push Notification rules',
			'meta.profileRulesAppendProxyTips' => 'Rules will be automatically set to the first proxy in [proxy-groups] of the original config with type [url-test] or [select]',
			'meta.profileImport' => 'Import Profile',
			'meta.profileAddUrlOrContent' => 'Add Subscription URL',
			'meta.profileUrlOrContent' => 'Subscription URL / Content',
			'meta.profileUrlOrContentHit' => 'Subscription URL or Content [Required]',
			'meta.profileUrlOrContentCannotEmpty' => 'Subscription URL or content cannot be empty',
			'meta.overview' => 'Overview',
			'meta.trafficStats' => 'Traffic Statistics',
			'meta.realtimeMonitor' => 'Real-time Monitor',
			'meta.realtimeUpload' => 'Real-time Upload',
			'meta.realtimeDownload' => 'Real-time Download',
			'meta.sessionUpload' => 'Session Upload',
			'meta.sessionDownload' => 'Session Download',
			'meta.planUsage' => 'Plan Usage',
			'meta.memoryUsage' => 'Memory',
			'meta.remaining' => 'Remaining',
			'meta.expireTime' => 'Expire Time',
			'meta.tunMode' => 'TUN Mode',
			'meta.daysAgo' => ({required Object p}) => '${p} days ago',
			'meta.hoursAgo' => ({required Object p}) => '${p} hours ago',
			'meta.lessThanOneHourAgo' => '< 1 hour ago',
			'meta.inUse' => 'In Use',
			'meta.remoteSubscription' => 'Remote Subscription',
			'meta.noTrafficData' => 'No usage statistics provided',
			'meta.localProfile' => 'Local File',
			'meta.viewYamlConfig' => 'View YAML Config',
			'meta.editYamlConfig' => 'Edit YAML Config',
			'meta.copySubscriptionUrl' => 'Copy Subscription URL',
			'meta.qrCode' => 'QR Code',
			'meta.deleteProfile' => 'Delete Profile',
			'meta.noProfilesYet' => 'No Subscriptions Yet',
			'meta.addProfilePrompt' => 'Click + in the top right to add a URL or import a file',
			'meta.subscriptionUrlCopied' => 'Subscription URL copied to clipboard',
			'meta.autoGroupTip' => ({required Object group, required Object type}) => '[${group}] is an auto policy group (${type}), which automatically selects nodes based on latency/availability. To manually select a node, please switch in manual policy groups.',
			'meta.switchNodeFailed' => ({required Object p}) => 'Failed to switch node: ${p}',
			'meta.nodeSelected' => ({required Object p}) => 'Selected node: ${p}',
			'meta.startingCoreAndTesting' => 'Starting core and testing latency...',
			'meta.chartMinutes' => ({required Object p}) => '${p} min',
			'meta.chartUpload' => 'Upload',
			'meta.chartDownload' => 'Download',
			'meta.author' => 'Author',
			'meta.githubRepo' => 'Open Source Repository',
			'meta.openSourceLicense' => 'License',
			'meta.submitFeedback' => 'Feedback & Issues',
			'meta.copiedToClipboard' => 'Copied to clipboard',
			'meta.autoScrollEnabled' => 'Auto-scroll enabled',
			'meta.autoScrollDisabled' => 'Auto-scroll disabled',
			'meta.pauseLogs' => 'Pause live logs',
			'meta.resumeLogs' => 'Resume live logs',
			'meta.scrollToLatest' => 'Scroll to latest',
			'meta.scrollToBottom' => 'Scroll to bottom',
			'meta.newLogsCount' => ({required Object p}) => '(${p} new logs)',
			'meta.copiedLogContent' => 'Log content copied',
			'meta.copyLog' => 'Copy Log',
			'meta.noLogsPrompt' => 'No logs yet. Core logs will appear after starting proxy.',
			'meta.searchLogsHint' => ' (IP, Domain, Rule, Error...)',
			_ => null,
		} ?? switch (path) {
			'meta.offlinePreviewPrompt' => 'Offline preview mode. Start proxy to enable routing and latency testing.',
			'meta.manualSelect' => 'Manual',
			'meta.autoSelect' => 'Auto Select',
			'meta.speedTestGroup' => 'Test Group Latency',
			'meta.pause' => 'Pause',
			'meta.resume' => 'Resume',
			'meta.ipInfo' => 'IP Info',
			'meta.ipFetching' => 'Fetching IP info...',
			'meta.ipCopied' => 'IP address copied to clipboard',
			'meta.ipLocation' => 'Location',
			'meta.ipIsp' => 'Provider',
			'meta.ipTapToFetch' => 'Tap to fetch IP info',
			'meta.ipProxy' => 'Proxy Exit',
			'meta.ipDirect' => 'Local Direct',
			'meta.ipAsn' => 'ASN',
			'meta.ipOrg' => 'Organization',
			'meta.ipTimezone' => 'Timezone',
			'meta.ipCoordinates' => 'Coordinates',
			'meta.ipMoreDetails' => 'More Details',
			'meta.ipLessDetails' => 'Collapse',
			'meta.collapseAll' => 'Collapse All Groups',
			'meta.expandAll' => 'Expand All Groups',
			'meta.donateTitle' => '💖 Buy Author a Coffee',
			'meta.donateThankYou' => 'ฅ^•ﻌ•^ฅ Every donation is our greatest motivation to keep polishing Wmimo ~ ☕✨',
			'meta.tokenCurrency' => 'Token',
			'meta.networkChain' => 'Network',
			'meta.depositAddress' => 'APTOS Deposit Address',
			'meta.clickToCopy' => 'Click to copy',
			'meta.copyAddressBtn' => 'Copy Address ✨',
			'meta.donateAddressCopied' => '( ੭ ˙ᗜ˙ )੭ Address copied! Thank you so much for your support and company~ 💖',
			'meta.donateTip' => '💡 Tip: Supports scanning via Bybit or any Aptos-compatible wallet',
			'meta.qrcodeParsing' => 'Parsing QR code...',
			'meta.qrcodeNotFound' => 'No QR code detected',
			'meta.qrcodeSupportHint' => 'Supports subscription, node and config QR codes',
			'meta.qrcodeCameraHint' => 'Align QR code within the frame to scan automatically',
			'meta.flashlight' => 'Flashlight',
			'meta.screenshotDesc' => 'Capture screen',
			'meta.fromImageDesc' => 'Local image',
			'meta.fromClipboardDesc' => 'Read clipboard',
			'meta.errorPrompt' => 'Error',
			'meta.copied' => 'Copied',
			'meta.sortAndFilterNodes' => 'Sort & Filter Nodes',
			'meta.sortOptions' => 'Sort Options',
			'meta.sortDefault' => 'Default',
			'meta.sortLatency' => 'Sort Latency',
			'meta.sortName' => 'Name A-Z',
			'meta.sortRegion' => 'Region',
			'meta.filterOptions' => 'Filter Options',
			'meta.portableUpdateTip' => ({required Object version}) => 'Portable mode detected:\nIn-app auto-update is not supported in portable mode. Please download the latest portable ZIP from the repository and extract to overwrite.\n\nLatest version: v${version}',
			'meta.portableModeTipTitle' => 'Portable Mode Notice',
			'meta.noNodesToSpeedTest' => 'No available nodes to test',
			'meta.alreadyLatestVersion' => ({required Object version}) => 'Already the latest version (v${version})',
			'meta.checkUpdateFailed' => 'Failed to check for updates, please check your network connection',
			'meta.hideTimeoutNodes' => 'Hide Timed-out & Offline Nodes',
			'meta.hideTimeoutNodesDesc' => 'Automatically filter unreachable nodes',
			'meta.speedtestScenario' => 'Speedtest Target Scenario',
			'meta.speedtestScenarioSwitch' => 'Speedtest Target Scenario',
			'meta.speedtestScenarioDesc' => 'Select targets to test real connectivity and latency',
			'meta.speedtestAllNodes' => 'Test All Nodes',
			'meta.retestTimeoutNodes' => 'Retest Timed-out Nodes',
			'meta.switchedTargetScenario' => ({required Object target}) => 'Switched target scenario: ${target}',
			'meta.notTested' => 'Not tested',
			'meta.timeoutOrFailed' => 'Timeout / Unreachable',
			'meta.identifiedRegion' => 'Region',
			'meta.nodeProtocol' => 'Protocol',
			'meta.currentLatency' => 'Latency',
			'meta.testScenario' => 'Test Scenario',
			'meta.belongsToGroup' => 'Group',
			'meta.copyNodeName' => 'Copy Name',
			'meta.nodeNameCopied' => 'Node name copied',
			'meta.testSingleNode' => 'Test Node',
			'meta.selectThisNode' => 'Select Node',
			'meta.allNodesNormal' => 'All nodes are available, no retest needed',
			'meta.customUrlPrompt' => 'Custom URL (e.g. http://...)',
			'meta.customTarget' => 'Custom Target',
			'meta.downloadFailedTip' => 'Failed to download update package. Please check network or download from website.',
			'meta.discoveredNewVersion' => ({required Object version}) => 'Discovered new version: v${version}',
			'meta.preparingUpdate' => 'Preparing to start update...',
			'meta.downloadingPackage' => 'Downloading update package, please wait...',
			'meta.downloadUpdateNow' => 'Download Update Now',
			'meta.downloadFromWeb' => 'Download from Website',
			'meta.switchSource' => 'Switch',
			'meta.serverSwitch' => 'Speed Test Server',
			'meta.autoDetectBest' => 'Auto Detect Best',
			'meta.serverSwitchDesc' => 'Select CDN or custom target to test connectivity',
			'meta.autoSelectedBest' => ({required Object server, required Object ping}) => 'Auto-selected best server: ${server} (${ping} ms)',
			'meta.networkGradeTitle' => 'Network Quality Score',
			'meta.copyReport' => 'Copy Report',
			'meta.reportCopied' => 'Report copied to clipboard, ready to share',
			'meta.gamingExperience' => 'Gaming',
			'meta.streamingExperience' => 'Streaming',
			'meta.meetingExperience' => 'Conferencing',
			'meta.customSpeedtestUrl' => 'Custom download URL (https://...)',
			'meta.customSpeedtestSource' => 'Custom Server',
			'meta.userSpecifiedUrl' => 'User Specified URL',
			'meta.cannotBeEmpty' => ({required Object item}) => '${item} cannot be empty',
			'meta.alreadyExists' => ({required Object item}) => '${item} already exists',
			'meta.installFailedWithCode' => ({required Object installer, required Object code}) => 'Failed to install ${installer}, exit code: ${code}',
			'meta.resetSystemProxy' => 'Repair Network / Reset System Proxy',
			'meta.resetSystemProxyDesc' => 'Clear residual system proxy settings and refresh network to fix offline issues after abnormal exits',
			'meta.resetSystemProxySuccess' => 'System proxy cleared and reset, network restored',
			'meta.networkDiagnostics' => 'Network Diagnostics & Auto-Repair',
			'meta.networkDiagnosticsDesc' => 'Diagnose network interface, DNS, core ports, and proxy health with one-click repair',
			'meta.sortLatencyDesc' => 'Highest Latency',
			'meta.sortNameDesc' => 'Name Z-A',
			'meta.sortMultiplier' => 'Lowest Multiplier',
			'meta.uwpLoopback' => 'UWP Loopback Exemption Utility',
			'meta.uwpLoopbackDesc' => 'Exempt Microsoft Store, Xbox, Minecraft, and UWP apps to use local proxy',
			'meta.uwpExemptAllCommon' => 'Exempt Recommended',
			'meta.uwpApplySuccess' => 'UWP loopback exemptions applied successfully',
			'meta.common' => 'Common',
			'meta.exempted' => 'Exempted',
			'meta.notExempted' => 'Not Exempted',
			'meta.deselectAll' => 'Deselect All',
			'meta.userApps' => 'User Apps',
			'meta.systemApps' => 'System Apps',
			'meta.selectedOnly' => 'Selected',
			'meta.proxySelectedMode' => 'Proxy Selected Apps Only',
			'meta.proxySelectedModeDesc' => 'Selected apps route through proxy, others connect directly',
			'meta.bypassSelectedMode' => 'Bypass Selected Apps',
			'meta.bypassSelectedModeDesc' => 'Selected apps connect directly, others route through proxy',
			'meta.invertSelection' => 'Invert Selection',
			'meta.all' => 'All',
			'meta.showAppIcon' => 'Show App Icon',
			'meta.proxySelection' => 'Proxy Selection',
			'meta.regionHk' => '🇭🇰 Hong Kong',
			'meta.regionJp' => '🇯🇵 Japan',
			'meta.regionSg' => '🇸🇬 Singapore',
			'meta.regionTw' => '🇹🇼 Taiwan',
			'meta.regionUs' => '🇺🇸 United States',
			'meta.regionKr' => '🇰🇷 South Korea',
			'meta.macMoveToApplications' => 'Please move Wmimo into Applications folder before launching',
			'meta.notifCurrentNode' => 'Node',
			'meta.notifMode' => 'Mode',
			'meta.notifPort' => 'Port',
			'meta.notifProfile' => 'Profile',
			'meta.notifDisconnect' => 'Disconnect',
			'meta.notifSwitchNode' => 'Switch Node',
			'meta.notifVpnConnected' => 'VPN Proxy Connected',
			'meta.connectionDetails' => 'Connection Details',
			'meta.sourceAddress' => 'Source Address',
			'meta.destinationAddress' => 'Destination Address',
			'meta.host' => 'Host',
			'meta.process' => 'Process',
			'meta.processPath' => 'Process Path',
			'meta.proxyChain' => 'Proxy Chain',
			'meta.networkProtocol' => 'Protocol',
			'meta.trafficUpload' => 'Upload Traffic',
			'meta.trafficDownload' => 'Download Traffic',
			'meta.connectionDuration' => 'Duration',
			'meta.connectionStart' => 'Start Time',
			'meta.copyHost' => 'Copy Host',
			'meta.copyAllDetails' => 'Copy All Details',
			'meta.closeThisConnection' => 'Close Connection',
			'meta.sortByDownload' => 'By Download',
			'meta.sortByUpload' => 'By Upload',
			'meta.sortBySpeed' => 'By Speed',
			'meta.sortByDuration' => 'By Duration',
			'meta.sortByHost' => 'By Host',
			'meta.realtimeSpeed' => 'Real-time Speed',
			'meta.totalUpload' => 'Total Upload',
			'meta.totalDownload' => 'Total Download',
			'meta.activeConnections' => 'Active',
			'meta.openInFolder' => 'Show in Folder',
			'meta.openProfilesDir' => 'Open Profiles Directory',
			'meta.profilePatches' => 'Profile Overwrites',
			'meta.nodeCount' => ({required Object p}) => '${p} Nodes',
			'meta.copyFilePath' => 'Copy File Path',
			'meta.duplicateProfile' => 'Duplicate Profile',
			'meta.useThisProfile' => 'Use This Profile',
			'meta.websiteTest' => 'Website Test',
			'meta.testAll' => 'Test All',
			'meta.addTestWebsite' => 'Add Test Website',
			'meta.websiteName' => 'Website Name',
			'meta.websiteUrl' => 'Test URL',
			'meta.websiteNameHint' => 'Website name (e.g. Cloudflare)',
			'meta.websiteInputEmpty' => 'Please enter website name and URL',
			'meta.autoRefresh' => 'Auto Refresh',
			'meta.currentProfile' => 'Current Profile',
			'meta.quickActions' => 'Quick Actions',
			'meta.fastest' => 'Fastest',
			'meta.hideTimeout' => 'Hide Timeout',
			'meta.filteredTimeout' => 'Filtered Timeout',
			'meta.tunDeviceCreateFailed' => 'Failed to create TUN virtual network adapter',
			'meta.test' => 'Test',
			'meta.addWebsite' => 'Add Website',
			'permission.camera' => 'Camera',
			'permission.screen' => 'Screen Recording',
			'permission.appQuery' => 'Get Application List',
			'permission.request' => ({required Object p}) => 'Turn on [${p}] permission',
			'permission.requestNeed' => ({required Object p}) => 'Please Turn on [${p}] permission',
			'tls.insecure' => 'Skip Certificate Verification',
			'tls.certificate' => 'Certificate',
			'tls.privateKey' => 'Private Key',
			'tls.customTrustCert' => 'Custom Certifactes',
			'tun.stack' => 'Network stack',
			'tun.stackGvisor' => 'gVisor',
			'tun.stackGvisorDesc' => 'User-space network stack, high stability and compatibility',
			'tun.stackSystem' => 'System',
			'tun.stackSystemDesc' => 'OS native network stack, high performance but depends on system',
			'tun.stackMixed' => 'Mixed',
			'tun.stackMixedDesc' => 'Mixed stack mode, balancing performance and compatibility',
			'tun.stackMips' => 'MIPS (Mihomo IP Stack)',
			'tun.stackMipsDesc' => 'Mihomo high-performance IP stack with high throughput and low latency',
			'tun.inet4Address' => 'IPv4 Gateway Address',
			'tun.inet6Address' => 'IPv6 Gateway Address',
			'tun.dnsHijack' => 'DNS Hijack',
			'tun.strictRoute' => 'Strict Route',
			'tun.tunDefaultRoute' => 'Default Route',
			'tun.icmpForward' => 'ICMP Forwarding',
			'tun.allowBypass' => 'Allow Apps to Bypass VPN',
			'tun.appendHttpProxy' => 'Append HTTP Proxy to VPN',
			'tun.bypassHttpProxyDomain' => 'Domains allowed to bypass HTTP proxy',
			'dns.listen' => 'Listen',
			'dns.fakeIp' => 'fake-ip',
			'dns.fallback' => 'Fallback',
			'dns.preferH3' => 'Prefer DoH H3',
			'dns.useHosts' => 'Use Hosts',
			'dns.useSystemHosts' => 'Use System Hosts',
			'dns.enhancedMode' => 'Enhanced Mode',
			'dns.fakeIPFilterMode' => '${_root.dns.fakeIp} Filter Mode',
			'dns.fakeIPFilter' => 'fake-ip Filter',
			'dns.respectRules' => 'Respect Rules',
			'dns.nameServer' => 'NameServer',
			'dns.defaultNameServer' => '${_root.meta.byDefault} ${_root.dns.nameServer}',
			'dns.proxyNameServer' => '${_root.meta.proxy} ${_root.dns.nameServer}',
			'dns.directNameServer' => '${_root.meta.direct} ${_root.dns.nameServer}',
			'dns.fallbackNameServer' => '${_root.dns.fallback} ${_root.dns.nameServer}',
			'dns.fallbackGeoIp' => '${_root.dns.fallback} GeoIp',
			'dns.fallbackGeoIpCode' => '${_root.dns.fallback} GeoIpCode',
			'dns.flushCache' => 'Flush DNS Cache',
			'dns.flushCacheSuccess' => 'DNS and Fake-IP cache flushed successfully',
			'dns.presets' => 'Quick DNS Presets',
			'dns.presetSpeed' => 'High-Speed Dual Stack',
			'dns.presetSpeedDesc' => 'AliDNS DoH3 + DNSPod DoH: Instant domestic connection, smart split routing',
			'dns.presetSecure' => 'Anti-Pollution & Privacy',
			'dns.presetSecureDesc' => 'Cloudflare DoH3 + Google DoH: Eliminate DNS hijacking and censorship',
			'dns.presetAdGuard' => 'AdGuard Ad-Blocking & Clean',
			'dns.presetAdGuardDesc' => 'AdGuard DoQ + AliDNS DoH: Deep request filtering and privacy protection',
			'dns.overwriteDesc' => 'Override DNS configuration from subscription profiles',
			'dns.enableDesc' => 'Enable custom DNS resolver',
			'dns.resetFakeIpFilter' => 'Restore Defaults',
			'dns.resetFakeIpFilterConfirm' => 'Are you sure you want to restore the recommended Fake-IP filter list?',
			'dns.dnsTester' => 'Live DNS Query Diagnostic',
			'dns.testQuery' => 'Test',
			'dns.fakeIpDetected' => 'Fake-IP Matched',
			'dns.realIpDetected' => 'Real Public IP',
			'dns.addServer' => 'Add DNS Server',
			'dns.geoAssetsTitle' => 'GEO Offline Databases',
			'dns.geoAssetsDesc' => 'Manage GeoSite domain ruleset, GeoIP and ASN databases',
			'dns.cdnSource' => 'Download CDN Mirror',
			'dns.updateAll' => 'Update All',
			'dns.updateSuccess' => 'Update succeeded',
			'dns.updateFailed' => 'Update failed',
			'dns.addPresetServer' => 'Add Preset DNS',
			'dns.manageFakeIpFilter' => ({required Object p}) => 'Manage Filter List (${p})',
			'dns.fakeIpFilterDesc' => ({required Object p}) => '${p} domain rules bypass Fake-IP resolution to avoid network isolation issues.',
			'sniffer.overrideDest' => 'Override',
			'profilePatchMode.currentSelected' => 'Current Selected',
			'profilePatchMode.overwrite' => 'Built-in Overwrite',
			'profilePatchMode.noOverwrite' => 'Built-in - no Overwrite',
			'protocolSniff' => 'Protocol Sniff',
			'protocolSniffOverrideDestination' => 'The Sniff domain name override the connection target address',
			'edgeRuntimeNotInstalled' => 'The current device has not installed the Edge WebView2 runtime, so the page cannot be displayed. Please download and install the Edge WebView2 runtime (x64), restart the App and try again.',
			'locales.en' => 'English',
			'locales.zh-CN' => '简体中文',
			'locales.zh-TW' => '繁體中文',
			'locales.ja' => '日本語',
			'locales.ko' => '한국어',
			'locales.ar' => 'العربية',
			'locales.ru' => 'Русский',
			'locales.fa' => 'فارسی',
			'locales.es' => 'Español',
			_ => null,
		};
	}
}
