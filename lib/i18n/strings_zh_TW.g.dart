///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsZhTw with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZhTw({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zhTw,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-TW>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsZhTw _root = this; // ignore: unused_field

	@override 
	TranslationsZhTw $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhTw(meta: meta ?? this.$meta);

	// Translations
	@override late final Translations$WelcomeLanguageScreen$zh_TW WelcomeLanguageScreen = Translations$WelcomeLanguageScreen$zh_TW.internal(_root);
	@override late final Translations$BackupAndSyncWebdavScreen$zh_TW BackupAndSyncWebdavScreen = Translations$BackupAndSyncWebdavScreen$zh_TW.internal(_root);
	@override late final Translations$LaunchFailedScreen$zh_TW LaunchFailedScreen = Translations$LaunchFailedScreen$zh_TW.internal(_root);
	@override late final Translations$PerAppAndroidScreen$zh_TW PerAppAndroidScreen = Translations$PerAppAndroidScreen$zh_TW.internal(_root);
	@override late final Translations$UserAgreementScreen$zh_TW UserAgreementScreen = Translations$UserAgreementScreen$zh_TW.internal(_root);
	@override late final Translations$NetCheckScreen$zh_TW NetCheckScreen = Translations$NetCheckScreen$zh_TW.internal(_root);
	@override late final Translations$SpeedTestScreen$zh_TW SpeedTestScreen = Translations$SpeedTestScreen$zh_TW.internal(_root);
	@override late final Translations$VersionUpdateScreen$zh_TW VersionUpdateScreen = Translations$VersionUpdateScreen$zh_TW.internal(_root);
	@override late final Translations$loginScreen$zh_TW loginScreen = Translations$loginScreen$zh_TW.internal(_root);
	@override late final Translations$main$zh_TW main = Translations$main$zh_TW.internal(_root);
	@override late final Translations$meta$zh_TW meta = Translations$meta$zh_TW.internal(_root);
	@override late final Translations$permission$zh_TW permission = Translations$permission$zh_TW.internal(_root);
	@override late final Translations$tls$zh_TW tls = Translations$tls$zh_TW.internal(_root);
	@override late final Translations$tun$zh_TW tun = Translations$tun$zh_TW.internal(_root);
	@override late final Translations$dns$zh_TW dns = Translations$dns$zh_TW.internal(_root);
	@override late final Translations$sniffer$zh_TW sniffer = Translations$sniffer$zh_TW.internal(_root);
	@override late final Translations$profilePatchMode$zh_TW profilePatchMode = Translations$profilePatchMode$zh_TW.internal(_root);
	@override String get protocolSniff => '協議探測';
	@override String get protocolSniffOverrideDestination => '探測的域名覆蓋連接目標地址';
	@override String get edgeRuntimeNotInstalled => '目前裝置尚未安裝 Edge WebView2 執行階段，無法顯示頁面，請下載安裝 Edge WebView2 執行階段 (x64) 後，重新啟動 App 再試';
	@override Map<String, String> get locales => {
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
class Translations$WelcomeLanguageScreen$zh_TW implements Translations$WelcomeLanguageScreen$en {
	Translations$WelcomeLanguageScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => '歡迎使用 Wmimo';
	@override String get selectLanguage => '選擇軟體語言';
	@override String get subtitle => '請選擇您的首選語言，您隨時可以在設定中更改';
	@override String get start => '進入應用';
}

// Path: BackupAndSyncWebdavScreen
class Translations$BackupAndSyncWebdavScreen$zh_TW implements Translations$BackupAndSyncWebdavScreen$en {
	Translations$BackupAndSyncWebdavScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get webdavServerUrl => '伺服器地址';
	@override String get webdavRequired => '不能為空';
	@override String get webdavLoginFailed => '登入失敗:';
	@override String get webdavListFailed => '取得檔案清單失敗:';
}

// Path: LaunchFailedScreen
class Translations$LaunchFailedScreen$zh_TW implements Translations$LaunchFailedScreen$en {
	Translations$LaunchFailedScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get invalidProcess => '應用程式啟動失敗 [無效的處理程序名稱]，請重新安裝應用程式至獨立目錄';
	@override String get invalidProfile => '應用啟動失敗[訪問設定檔失敗],請重新安裝應用';
	@override String get invalidVersion => '應用啟動失敗[無效版本],請重新安裝應用';
	@override String get systemVersionLow => '應用啟動失敗[系統版本過低]';
	@override String get invalidInstallPath => '無效的安裝路徑,請重新安裝到有效路徑';
}

// Path: PerAppAndroidScreen
class Translations$PerAppAndroidScreen$zh_TW implements Translations$PerAppAndroidScreen$en {
	Translations$PerAppAndroidScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '分應用代理';
	@override String get whiteListMode => '白名單模式';
	@override String get whiteListModeTip => '啟用後:僅代理已勾選的App;未啟用:僅代理未勾選的App';
	@override String get manualAddPackage => '手動新增應用程式套件名稱';
	@override String get manualAddPackageHint => '請輸入需要代理的應用程式套件名稱（支援多個，使用空格、逗號或換行分隔，例如：org.telegram.messenger, com.google.android.youtube）：';
	@override String get quickAddPresets => '捷徑新增常用代理應用程式';
	@override String get saveSelected => '儲存所選';
	@override String get permissionRestrictedTip => '目前系統限制了讀取軟體列表。請點擊下方【前往系統權限設定頁】開啟「取得應用程式列表」，或直接使用免授權的「常用應用程式預設」一鍵代理。';
	@override String get openSystemPermission => '前往系統權限設定頁';
	@override String get presetApps => '捷徑新增常用應用程式 (免授權預設)';
	@override String get requestPermissionPopup => '嘗試一鍵申請權限 (系統彈窗)';
}

// Path: UserAgreementScreen
class Translations$UserAgreementScreen$zh_TW implements Translations$UserAgreementScreen$en {
	Translations$UserAgreementScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get privacyFirst => '您的隱私很重要';
	@override String get agreeAndContinue => '接受並繼續';
}

// Path: NetCheckScreen
class Translations$NetCheckScreen$zh_TW implements Translations$NetCheckScreen$en {
	Translations$NetCheckScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '網路鏈路體檢與診斷';
	@override String get fullDiagnosticsTab => '一鍵鏈路體檢';
	@override String get advancedCheckTab => '進階單網域排查';
	@override String get startDiagnostics => '開始全鏈路體檢';
	@override String get reDiagnostics => '重新體檢';
	@override String get diagnosing => '正在全面診斷鏈路...';
	@override String get healthScore => '健康評分';
	@override String get scorePerfect => '鏈路極佳';
	@override String get scoreGood => '基本良好';
	@override String get scoreWarning => '存在警告';
	@override String get scoreCritical => '鏈路受阻';
	@override String get oneClickRepair => '一鍵智慧自愈';
	@override String get repairSuccess => '自愈修復成功，網路已恢復正常';
	@override String get repairFailed => '部分項目可能需手動確認';
	@override String get repairing => '正在執行自愈修復...';
	@override String issueFound({required Object count}) => '發現 ${count} 處異常';
	@override String get noIssue => '全項檢測正常';
	@override String get details => '技術詳情';
	@override String get copyDetails => '複製日誌';
	@override String get detailsCopied => '診斷日誌已複製到剪貼簿';
	@override String get stepPhysical => '實體網卡與閘道';
	@override String get stepDns => 'DNS 解析與 Fake-IP';
	@override String get stepCore => '核心服務與連接埠';
	@override String get stepProxy => '系統代理設定';
	@override String get stepHandshake => '公網端到端交握';
	@override String get suggestedAction => '排障建議';
	@override String get autoRepairAction => '立即修復';
	@override String get enterDomain => '請輸入網域名稱';
	@override String get checking => '檢測中...';
	@override String aQueryFailed({required Object p}) => 'A 查詢失敗: ${p}';
	@override String aaaaQueryFailed({required Object p}) => 'AAAA 查詢失敗: ${p}';
	@override String get success => '成功';
	@override String get failed => '失敗';
	@override String get suspectedPollution => '疑似被污染';
	@override String get domainLabel => '網域名稱';
	@override String get checkButton => '檢測';
	@override String get dnsSection => '1. DNS查詢';
	@override String get directHttpSection => '2. HTTP (經由TUN,請先啟用TUN)';
	@override String proxyHttpSection({required Object p}) => '3. HTTP (經由代理,連接埠:${p})';
	@override String get tunNotEnabled => 'TUN 未啟用';
	@override String get routeTableSection => '4. 路由表';
	@override String get stepPhysicalDesc => '檢測實體網卡狀態、本機區域網路 IP 與本機閘道連線能力';
	@override String get stepDnsDesc => '驗證本地域名解析線路耗時與核心 DNS 回應狀態';
	@override String get stepCoreDesc => '檢測 Mihomo 行程存活狀態與 Mixed-Port/API 連接埠監聽';
	@override String get stepProxyDesc => '驗證系統底層代理是否正確對齊並排查殘留斷網隱患';
	@override String get stepHandshakeDesc => '透過啟動代理節點向全球 CDN 測定實際端對端延遲與可用性';
	@override String get shortStepPhysical => '網卡';
	@override String get shortStepDns => 'DNS';
	@override String get shortStepCore => '核心';
	@override String get shortStepProxy => '代理';
	@override String get shortStepHandshake => '公網';
	@override String valNicNormal({required Object p}) => '網卡連線正常 (${p})';
	@override String get valNicNone => '未找到可用網路介面';
	@override String get valNicGatewayTimeout => '區域網路 IP 已獲取，但外部閘道連線逾時';
	@override String get valNicError => '網路介面檢查異常';
	@override String valDnsNormal({required Object p}) => 'DNS 回應正常 (${p})';
	@override String get valDnsEmpty => 'DNS 查詢傳回空清單';
	@override String get valDnsTimeout => 'DNS 查詢逾時或失敗';
	@override String valCoreNormal({required Object port, required Object mode}) => '核心運作良好 (混合埠: ${port}, 模式: ${mode})';
	@override String get valCoreNotRunning => '核心服務未執行';
	@override String valCorePortConflict({required Object p}) => '連接埠 ${p} 已被外部程式占用';
	@override String get valCoreApiFailed => '核心行程無回應 (API 埠通訊失敗)';
	@override String get valCoreError => '核心檢測異常';
	@override String valProxyActive({required Object port}) => '系統代理已生效 (127.0.0.1:${port})';
	@override String get valProxyDisabled => '系統代理未啟用（目前走直連/TUN/手動模式）';
	@override String get valProxyZombie => '檢測到殘留系統代理（導致斷網）';
	@override String get valProxyFailed => '系統代理未能成功啟用';
	@override String get valProxyWarning => '系統代理狀態讀取警告';
	@override String valHandshakeNormal({required Object node, required Object delay}) => '公網連線暢通 (${node} • ${delay} ms)';
	@override String valHandshakeFailed({required Object node, required Object err}) => '目前節點 [${node}] 連線失敗 (${err})';
	@override String get valHandshakeSkipped => '核心未啟動，略過公網握手測試';
	@override String get valHandshakeError => '公網握手發生異常';
	@override String get issueNicDisconnected => '本機網卡未連線到任何網路（網路線拔出、Wi-Fi 未連或飛航模式）';
	@override String get suggestNicCheck => '請檢查電腦實體網路線連線、Wi-Fi 無線網路或網路介面卡狀態';
	@override String get suggestNicReset => '嘗試在系統設定中停用並重新啟用網路介面卡';
	@override String get issueNicGatewayUnreachable => '電腦已接入區域網路，但無法存取外部基礎路由（可能受限於校園網路/飯店認證或路由器斷網）';
	@override String get suggestNicGateway => '請檢查路由器光纖指示燈，或開啟瀏覽器確認是否需要 Web 登入認證';
	@override String get issueDnsPollution => '本地域名解析服務未回應，可能存在 DNS 污染或閘道劫持';
	@override String get suggestDnsReset => '建議重設系統 DNS 或在 Wmimo 中啟用智慧加密 DNS (DoH/DoT)';
	@override String get actionFlushDns => '重新整理系統 DNS 快取';
	@override String get suggestDnsSlow => 'DNS 解析耗時偏長，建議開啟 Smart Encrypted DNS 加速';
	@override String get issueDnsFailed => '本地 DNS 解析失敗，系統無法將網域名稱轉換為 IP 位址';
	@override String get suggestDnsFlush => '點擊一鍵重新整理系統 DNS 快取，或在 Wmimo 設定中啟用加密 DNS';
	@override String get issueCorePortConflict => '檢測到連接埠衝突！其他代理軟體或系統服務正在占用本應用程式連接埠';
	@override String get suggestCoreChangePort => '請完全退出其他代理客戶端，或在 Wmimo 設定中修改連接埠號';
	@override String get actionRestartCore => '一鍵重啟核心';
	@override String get issueCoreStopped => 'Wmimo 核心行程目前處於停止狀態';
	@override String get suggestCoreStart => '點擊主畫面連線開關或點擊下方【啟動核心】';
	@override String get actionStartCore => '啟動核心行程';
	@override String get issueCoreFrozen => '核心行程發生停滯或 API Secret 鑑權不符合';
	@override String get suggestCoreRestart => '建議點擊【一鍵重啟核心】恢復服務';
	@override String get suggestCoreReinstall => '嘗試重啟核心或重裝服務驅動程式';
	@override String get issueProxyZombie => '殘留的系統代理將流量轉發到未啟動的連接埠，導致斷網';
	@override String get suggestProxyReset => '點擊下方【一鍵清理並重設系統代理】，即可立即恢復上網';
	@override String get actionResetProxy => '一鍵清理並重設代理';
	@override String get issueProxyBlocked => '系統代理設定未生效，可能被第三方安全軟體攔截或權限受限';
	@override String get suggestProxyReapply => '點擊下方按鈕嘗試重新註冊並強制套用系統代理';
	@override String get actionReapplyProxy => '重新套用系統代理';
	@override String get issueProxyRead => '讀取系統代理設定時產生非致命異常';
	@override String get issueHandshakeBlocked => '目前選取的代理節點無法連線外部網際網路，握手失敗或被阻斷';
	@override String get suggestHandshakeSwitch => '該節點可能正在維護或無法連線，請切換至其他可用節點';
	@override String suggestHandshakeSlow({required Object delay}) => '節點延遲稍高 (${delay} ms)，建議測速選擇更近的邊緣節點';
	@override String get suggestHandshakeCheck => '檢查節點設定或更換測速目標';
	@override String get conclusionPerfect => '全線路極佳！所有網路節點與代理設定均正常暢通。';
	@override String get conclusionGood => '線路基本正常，檢測到部分非致命延遲或警告，建議查看詳情。';
	@override String get conclusionWarning => '檢測到部分網路或代理環節異常，請使用下方【一鍵修復】恢復。';
	@override String get conclusionCritical => '嚴重網路受阻！本地網路未連線或代理核心遭遇阻斷。';
}

// Path: SpeedTestScreen
class Translations$SpeedTestScreen$zh_TW implements Translations$SpeedTestScreen$en {
	Translations$SpeedTestScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '網路測速';
	@override String get startTest => '開始測速';
	@override String get stopTest => '停止測速';
	@override String get reTest => '重新測速';
	@override String get ready => '準備就緒';
	@override String get testingPing => '正在測試延遲與抖動...';
	@override String get testingDownload => '正在測試下載頻寬...';
	@override String get testingUpload => '正在測試上傳頻寬...';
	@override String get completed => '測速完成';
	@override String get stopped => '已停止';
	@override String get ping => '延遲';
	@override String get jitter => '抖動';
	@override String get download => '下載速度';
	@override String get upload => '上傳速度';
	@override String get currentProxy => '當前代理';
	@override String get directConnection => '直連模式';
	@override String get server => '測速伺服器';
	@override String get serverLocation => '伺服器位置';
	@override String get realtimeSpeed => '即時頻寬曲線';
	@override String get peakSpeed => '峰值速率';
	@override String get avgSpeed => '平均速率';
	@override String get testHistory => '測速歷史';
	@override String get clearHistory => '清空歷史';
}

// Path: VersionUpdateScreen
class Translations$VersionUpdateScreen$zh_TW implements Translations$VersionUpdateScreen$en {
	Translations$VersionUpdateScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String versionReady({required Object p}) => '新版本[${p}]已就緒';
	@override String get update => '重新啟動更新';
	@override String get cancel => '暫不更新';
}

// Path: loginScreen
class Translations$loginScreen$zh_TW implements Translations$loginScreen$en {
	Translations$loginScreen$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get login => '登入';
	@override String get register => '註冊賬號';
	@override String get forgotPassword => '忘記密碼';
	@override String get provider => '服務商';
	@override String get providerName => '${_root.loginScreen.provider}編碼/別名/URL';
	@override String get providerNameRequired => '請輸入${_root.loginScreen.provider}編碼/別名/URL';
	@override String get account => '賬號';
	@override String get accountRequired => '請輸入賬號';
	@override String get email => '郵箱';
	@override String get emailRequired => '請輸入郵箱地址';
	@override String get password => '密碼';
	@override String get passwordRequired => '請輸入密碼';
	@override String get validEmailRequired => '請輸入有效的郵箱地址';
	@override String passwordMinLength({required Object minLength}) => '密碼長度至少${minLength}位';
	@override String get unsupportedProvider => '不支援的${_root.loginScreen.provider}';
	@override String get unsupportedProviderType => '不支援的${_root.loginScreen.provider}類型';
	@override String get unActivedProvider => '登入功能未啟用';
	@override String providerLoginSupportRequired({required Object p}) => '編碼/別名請向${_root.loginScreen.provider}索取\n${_root.loginScreen.provider}接入請參考:${p}';
	@override String get providerDisclaimer => '免責聲明:${_root.loginScreen.provider}為第三方服務,與本App無關';
	@override String get createSessionFailed => '建立工作階段失敗，請檢查服務商或帳號密碼';
}

// Path: main
class Translations$main$zh_TW implements Translations$main$en {
	Translations$main$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final Translations$main$tray$zh_TW tray = Translations$main$tray$zh_TW.internal(_root);
}

// Path: meta
class Translations$meta$zh_TW implements Translations$meta$en {
	Translations$meta$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get enable => '啟用';
	@override String get disable => '禁用';
	@override String get open => '打開';
	@override String get close => '關閉';
	@override String get quit => '退出';
	@override String get add => '添加';
	@override String get addSuccess => '添加成功';
	@override String addFailed({required Object p}) => '添加失敗:${p}';
	@override String get remove => '刪除';
	@override String get removeConfirm => '確認刪除?';
	@override String get edit => '編輯';
	@override String get view => '查看';
	@override String get remark => '備註';
	@override String get byDefault => '預設';
	@override String get editRemark => '修改備註';
	@override String get more => '更多';
	@override String get tips => '提示';
	@override String get selectAll => '全選';
	@override String get copy => '複製';
	@override String get paste => '貼上';
	@override String get cut => '剪切';
	@override String get save => '儲存';
	@override String get ok => '確定';
	@override String get cancel => '取消';
	@override String get faq => '常見問題';
	@override String get doc => '說明文件';
	@override String get htmlTools => 'HTML工具集';
	@override String get download => '下載';
	@override String get loading => '載入中...';
	@override String get days => '天';
	@override String get hours => '時';
	@override String get minutes => '分';
	@override String get seconds => '秒';
	@override String get milliseconds => '毫秒';
	@override String get protocol => '協議';
	@override String get search => '搜索';
	@override String get custom => '自訂';
	@override String get connect => '連接';
	@override String get disconnect => '斷開';
	@override String get connected => '已連接';
	@override String get disconnected => '未連接';
	@override String get connecting => '連接中';
	@override String get connectTimeout => '連接超時';
	@override String get timeout => '超時';
	@override String get timeoutDuration => '超時時長';
	@override String get latency => '延遲';
	@override String get latencyTest => '延遲測速';
	@override String get networkCheck => '網路檢測';
	@override String get speedTest => '網路測速';
	@override String get language => '語言';
	@override String get next => '下一步';
	@override String get done => '完成';
	@override String get apply => '應用';
	@override String get refresh => '重新整理';
	@override String get retry => '是否重試?';
	@override String get update => '更新';
	@override String get updateInterval => '更新時間間隔';
	@override String get updateInterval5mTips => '最小:5m';
	@override String get updateIntervalPreferByProfile => '優先使用服務商(機場)設定';
	@override String updateFailed({required Object p}) => '更新失敗:${p}';
	@override String get none => '無';
	@override String get reset => '重設';
	@override String get resetConfirm => '確定重設所有應用程式設定嗎？';
	@override String get resetSuccess => '應用程式設定已重設為預設值';
	@override String get resetCoreConfirm => '確定重設核心設定與覆寫設定嗎？';
	@override String get resetCoreSuccess => '核心設定已重設為預設值';
	@override String get authentication => '授權';
	@override String get submit => '提交';
	@override String get user => '用戶';
	@override String get account => '賬號';
	@override String get password => '密碼';
	@override String get decryptPassword => '解密密碼';
	@override String get required => '必填';
	@override String get go => '繼續';
	@override String get sudoPassword => 'sudo 密碼(TUN模式需要)';
	@override String get other => '其他';
	@override String get dns => 'DNS';
	@override String get url => 'URL';
	@override String get urlInvalid => 'URL無效';
	@override String get urlCannotEmpty => 'URL不能為空';
	@override String get urlTooLong => 'URL過長(>8182)';
	@override String get copyUrl => '複製連結';
	@override String get openUrl => '打開連結';
	@override String get shareUrl => '分享連結';
	@override String get coreSettingTips => '注意：修改設定後，需要重新連線才會生效';
	@override String get overwrite => '覆寫';
	@override String get overwriteCustom => '自訂覆寫';
	@override String get overwriteAppend => '追加覆寫';
	@override String get overwriteTips => '原始設定<-自訂覆寫<-App覆寫';
	@override String get noOverwrite => '不覆寫';
	@override String get overwriteSettings => '覆寫設定';
	@override String get diversionTemplates => '分流模板';
	@override String get ruleProviders => '規則集 (RuleSet)';
	@override String get ruleTemplates => '規則模板';
	@override String get proxyGroupsTemplates => '策略組模板';
	@override String get proxyGroups => '策略組';
	@override String get proxyNodeList => '代理節點列表';
	@override String proxyNodeFailure({required Object p}) => '下列代理節點已失效,已自動移除:${p}';
	@override String get externalController => '外部控制';
	@override String get secret => '金鑰';
	@override String get tcpConcurrent => 'TCP併發握手';
	@override String get globalClientFingerprint => 'TLS 全域指紋';
	@override String get allowLanAccess => '允許區域網路裝置連入';
	@override String get mixedPort => '混合代理連接埠';
	@override String get logLevel => '日誌等級';
	@override String get findProcessMode => '處理程序比對模式';
	@override String get tcpkeepAliveInterval => 'TCP保活時間間隔';
	@override String get delayTestUrl => '延遲測試URL';
	@override String get delayTestTimeout => '延遲測試超時(ms)';
	@override String get tun => 'TUN';
	@override String get ntp => 'NTP';
	@override String get tls => 'TLS';
	@override String get geo => 'GEO';
	@override String get geoDownloadByProxy => '使用代理下載Geo RuleSet';
	@override String get geoRulesetTips => 'Geosite/Geoip 會被轉換成 對應的RuleSet';
	@override String get asnNotSupportInIosTips => '由於 iOS 系統記憶體限制，IP-ASN 及 SRC-IP-ASN 規則在 iOS 上將被略過';
	@override String get sniffer => '嗅探';
	@override String get userAgent => 'UserAgent';
	@override String get launchAtStartup => '開機啟動';
	@override String get launchAtStartupRunAsAdmin => '請以管理員身份重新啟動Wmimo';
	@override String get tunModeRunAsAdmin => 'TUN模式需要系統管理員權限,請以管理員身份重新啟動應用';
	@override String get tunSwitchToSystemProxy => '是否臨時切換為【系統代理模式】繼續連線？';
	@override String get tunCreateAdapterFailedAdmin => 'TUN 虛擬網卡建立失敗: Access is denied。\nTUN 模式需要管理員權限，請右鍵選擇【以管理員身分執行】應用，或在主畫面/核心設定中關閉 TUN 模式並使用系統代理連線。';
	@override String get portableMode => '便攜模式';
	@override String get portableModeDisableTips => '如需結束免安裝便攜模式，請結束 [Wmimo] 後，手動刪除 [wmimo.exe] 同目錄下的 [portable] 資料夾即可';
	@override String get systemProxy => '系統代理';
	@override String get autoConnectAfterLaunch => '啟動後自動連接';
	@override String get autoConnectAtBoot => '系統啟動後自動連接';
	@override String get autoConnectAtBootTips => '需要系統支援，部分系統可能還需要開啟 [開機自動啟動]';
	@override String get hideAfterLaunch => '啟動後隱藏視窗';
	@override String get autoSetSystemProxy => '連線後自動設定系統代理';
	@override String get bypassSystemProxy => '允許略過系統代理的網域名稱';
	@override String get excludeFromRecent => '從[最近任務]中隱藏';
	@override String get wakeLock => '喚醒鎖';
	@override String get hideVpn => '隱藏 VPN 圖示';
	@override String get hideVpnTips => '開啟IPv6會導致此功能失效';
	@override String get hideDockIcon => '隱藏 Dock 圖示';
	@override String get showTrayTraffic => '系統匣顯示流量資訊';
	@override String get website => '官網';
	@override String get homePage => '主頁';
	@override String get rule => '規則';
	@override String get global => '全域';
	@override String get direct => '直連';
	@override String get block => '攔截';
	@override String get qrcode => 'QR Code';
	@override String get qrcodeTooLong => '文本過長,無法展示';
	@override String get qrcodeShare => '分享 QR Code';
	@override String get textToQrcode => '文字轉 QR Code';
	@override String get qrcodeScan => '掃描 QR Code';
	@override String get qrcodeScanResult => '掃描結果';
	@override String get qrcodeScanFromImage => '開啟 QR Code 圖片';
	@override String get qrcodeScanFromClipboard => '剪貼簿識別';
	@override String get qrcodeRecognized => 'QR Code 辨識成功';
	@override String get qrcodeDropHint => '點擊上方按鈕擷取螢幕或選取圖片';
	@override String get confirmImport => '確認匯入';
	@override String get reScan => '重新掃描';
	@override String get qrcodeScanResultFailed => '解析圖片失敗，請確認截圖為有效的 QR Code';
	@override String get qrcodeScanResultEmpty => '掃描結果為空';
	@override String get screenshot => '截圖';
	@override String get backupAndSync => '備份與同步';
	@override String get importSuccess => '匯入成功';
	@override String get rewriteConfirm => '該檔案將覆寫本機現有設定，是否繼續？';
	@override String get importAndExport => '匯入/匯出';
	@override String get import => '匯入';
	@override String get importFromUrl => '從URL匯入';
	@override String get export => '匯出';
	@override String get send => '發送';
	@override String get receive => '接收';
	@override String get sendConfirm => '確認發送?';
	@override String get continueConnectConfirm => '是否繼續連接?';
	@override String get termOfUse => '使用條款';
	@override String get privacyPolicy => '隱私政策';
	@override String get log => '日誌';
	@override String get coreLog => '核心日誌';
	@override String get core => '核心';
	@override String get help => '幫助';
	@override String get tutorial => '使用教程';
	@override String get board => '面板';
	@override String get boardOnline => '使用線上儀表板';
	@override String get boardOnlineUrl => '線上儀表板網址';
	@override String get boardLocalPort => '本機儀表板連接埠';
	@override String get connections => '活動連接';
	@override String get closeAllConnections => '關閉全部連接';
	@override String get searchConnections => '搜尋連線 (網域名稱/IP/規則/處理程序)';
	@override String get noFilterResults => '沒有相符的連接';
	@override String get searchRules => '搜尋規則 (類型/特徵/目標代理)';
	@override String get searchProfiles => '搜尋設定檔 (名稱/連結/備註)';
	@override String get noMatchingProfiles => '未找到相符的訂閱設定檔';
	@override String get rules => '分流規則';
	@override String get clear => '清除';
	@override String get copySuccess => '複製成功';
	@override String get alwayOnVPN => '始終開啟連線';
	@override String get disableFontScaler => '停用字型縮放';
	@override String get autoOrientation => '跟隨螢幕旋轉';
	@override String get restartTakesEffect => '重新啟動後生效';
	@override String get reconnectTakesEffect => '重新連接後生效';
	@override String get runtimeProfile => '執行階段設定';
	@override String get willCompleteAfterRebootInstall => '請重新啟動裝置，以便完成系統擴充功能安裝';
	@override String get willCompleteAfterRebootUninstall => '請重新啟動裝置，以便完成系統擴充功能解除安裝';
	@override String get requestNeedsUserApproval => '1. 請在[系統設定]-[隱私權與安全性]裡[允許] Wmimo安裝系統擴充功能\n2. 在[系統設定]-[一般]-[登入項目與擴充功能-網路擴充功能]啟用[wmimoServiceSE]\n完成後重新連線';
	@override String get FullDiskAccessPermissionRequired => '請在[系統設定]-[隱私權與安全性]-[完全磁碟取用權限]裡開啟wmimoServiceSE權限後，重新連線';
	@override String get proxy => '代理';
	@override String get theme => '主題';
	@override String get tvMode => 'TV模式';
	@override String get autoUpdate => '自動更新';
	@override String get updateChannel => '自動更新通道';
	@override String get onlineCustomerService => '線上客服';
	@override String get subscriptionChannel => '訂閱頻道';
	@override String hasNewVersion({required Object p}) => '更新版本 ${p}';
	@override String get autoDownloadPkg => '自動下載更新包';
	@override String get devOptions => '開發者選項';
	@override String get joinUs => '加入我們';
	@override String get about => '關於';
	@override String get name => '名稱';
	@override String get version => '版本';
	@override String get notice => '通知';
	@override String get sort => '排序';
	@override String get recommended => '推薦';
	@override String innerError({required Object p}) => '內部錯誤:${p}';
	@override String get share => '分享';
	@override String get importFromClipboard => '從剪貼簿匯入';
	@override String get exportToClipboard => '匯出到剪貼簿';
	@override String get server => '伺服器';
	@override String get port => '連接埠';
	@override String get donate => '捐助';
	@override String get setting => '設定';
	@override String get settingCore => '核心設定';
	@override String get settingApp => '應用程式設定';
	@override String get coreOverwrite => '核心覆寫';
	@override String get iCloud => 'iCloud';
	@override String get webdav => 'Webdav';
	@override String get lanSync => '區域網路同步';
	@override String get lanSyncNotQuitTips => '同步完成前請勿離開此介面';
	@override String get deviceNoSpace => '磁盤空間不足';
	@override String get hideSystemApp => '隱藏系統應用';
	@override String get hideAppIcon => '隱藏應用程式圖示';
	@override String get openDir => '開啟檔案目錄';
	@override String get type => '類型';
	@override String get fileChoose => '選擇檔案';
	@override String get filePathCannotEmpty => '檔案路徑不能為空';
	@override String fileNotExist({required Object p}) => '檔案不存在:${p}';
	@override String fileTypeInvalid({required Object p}) => '無效的檔案類型:${p}';
	@override String get uwpExemption => 'UWP網路隔離豁免';
	@override String get getProfile => '取得訂閱';
	@override String get buyProfile => '購買訂閱';
	@override String get addProfile => '新增訂閱';
	@override String get myProfiles => '訂閱設定';
	@override String get profileEdit => '編輯訂閱設定';
	@override String get profileNeedActive => '請先將本設定設為目前設定，並開啟連線/重新連線';
	@override String get profileDownloadBackupChannel => '啟用備用下載通道';
	@override String get profileDownloadBackupChannelTips => 'Wmimo 提供的代理下載通道（不儲存任何資訊）';
	@override String get profileEditReloadAfterProfileUpdate => '設定更新後重新載入';
	@override String get profileRulesAppendApplePush => '附加 Apple 推送通知規則';
	@override String get profileRulesAppendProxyTips => '規則將自動設為原始設定中 [proxy-groups] 內第一個類型為 [url-test] 或 [select] 的代理';
	@override String get profileImport => '匯入設定檔案';
	@override String get profileAddUrlOrContent => '新增訂閱連結';
	@override String get profileUrlOrContent => '訂閱連結 / 節點內容';
	@override String get profileUrlOrContentHit => '訂閱連結或設定內容 [必填]';
	@override String get profileUrlOrContentCannotEmpty => '訂閱連結或內容不能為空';
	@override String get overview => '概覽';
	@override String get trafficStats => '流量統計';
	@override String get realtimeMonitor => '即時監控';
	@override String get realtimeUpload => '即時上傳';
	@override String get realtimeDownload => '即時下載';
	@override String get sessionUpload => '本次上傳';
	@override String get sessionDownload => '本次下載';
	@override String get planUsage => '套餐用量';
	@override String get memoryUsage => '記憶體佔用';
	@override String get remaining => '剩餘';
	@override String get expireTime => '到期時間';
	@override String get tunMode => 'TUN 模式';
	@override String daysAgo({required Object p}) => '${p}天前';
	@override String hoursAgo({required Object p}) => '${p}小時前';
	@override String get lessThanOneHourAgo => '< 1小時前';
	@override String get inUse => '使用中';
	@override String get remoteSubscription => '遠端訂閱';
	@override String get noTrafficData => '未提供用量統計';
	@override String get localProfile => '本機檔案';
	@override String get viewYamlConfig => '檢視 YAML 設定';
	@override String get editYamlConfig => '編輯 YAML 設定';
	@override String get copySubscriptionUrl => '複製訂閱連結';
	@override String get qrCode => 'QR Code';
	@override String get deleteProfile => '刪除設定';
	@override String get noProfilesYet => '暫無訂閱設定';
	@override String get addProfilePrompt => '點擊右上角 + 新增訂閱連結或匯入本機檔案';
	@override String get subscriptionUrlCopied => '訂閱連結已複製到剪貼簿';
	@override String autoGroupTip({required Object group, required Object type}) => '「${group}」屬於 ${type} 自動策略組，由系統按延遲/可用性自動優選節點。如需自選節點，請在「節點選擇」等手動策略組中切換。';
	@override String switchNodeFailed({required Object p}) => '切換節點失敗: ${p}';
	@override String nodeSelected({required Object p}) => '已選擇節點: ${p}';
	@override String get startingCoreAndTesting => '正在啟動代理核心並測速...';
	@override String chartMinutes({required Object p}) => '${p} 分鐘';
	@override String get chartUpload => '上傳';
	@override String get chartDownload => '下載';
	@override String get author => '作者';
	@override String get githubRepo => '開原始碼倉庫';
	@override String get openSourceLicense => '開源許可證';
	@override String get submitFeedback => '提交反饋與建議';
	@override String get copiedToClipboard => '已複製到剪貼簿';
	@override String get autoScrollEnabled => '已開啟自動捲動';
	@override String get autoScrollDisabled => '已關閉自動捲動';
	@override String get pauseLogs => '暫停即時日誌';
	@override String get resumeLogs => '恢復即時日誌';
	@override String get scrollToLatest => '滾至最新';
	@override String get scrollToBottom => '滾至底部';
	@override String newLogsCount({required Object p}) => '(${p} 條新日誌)';
	@override String get copiedLogContent => '已複製日誌內容';
	@override String get copyLog => '複製日誌';
	@override String get noLogsPrompt => '暫無日誌，啟動代理後將即時捕獲核心日誌';
	@override String get searchLogsHint => ' (IP, 網域名稱, 規則, 錯誤...)';
	@override String get offlinePreviewPrompt => '離線設定預覽中，開啟代理後可進行分流與節點測速';
	@override String get manualSelect => '手動選擇';
	@override String get autoSelect => '自動選擇';
	@override String get speedTestGroup => '策略群組測速';
	@override String get pause => '暫停';
	@override String get resume => '恢復';
	@override String get ipInfo => 'IP 資訊';
	@override String get ipFetching => '正在取得 IP 資訊...';
	@override String get ipCopied => 'IP 位址已複製到剪貼簿';
	@override String get ipLocation => '位置';
	@override String get ipIsp => '服務商';
	@override String get ipTapToFetch => '點擊取得 IP 資訊';
	@override String get ipProxy => '代理出口';
	@override String get ipDirect => '本機直連';
	@override String get ipAsn => '自治系統';
	@override String get ipOrg => '歸屬組織';
	@override String get ipTimezone => '時區';
	@override String get ipCoordinates => '座標';
	@override String get ipMoreDetails => '更多詳細資訊';
	@override String get ipLessDetails => '收起詳細資訊';
	@override String get collapseAll => '收合所有代理群組';
	@override String get expandAll => '展開所有代理群組';
	@override String get donateTitle => '💖 請作者喝杯咖啡';
	@override String get donateThankYou => 'ฅ^•ﻌ•^ฅ 你的每一份投餵，都是 Wmimo 不斷打磨與更新的最大動力呀 ~ ☕✨';
	@override String get tokenCurrency => '幣種';
	@override String get networkChain => '網路';
	@override String get depositAddress => 'APTOS 收款位址';
	@override String get clickToCopy => '點擊複製';
	@override String get copyAddressBtn => '複製位址 ✨';
	@override String get donateAddressCopied => '( ੭ ˙ᗜ˙ )੭ 位址已複製！非常感謝你的投餵與陪伴~ 💖';
	@override String get donateTip => '💡 提示：支援 Bybit 或任意 Aptos 相容錢包掃碼轉帳';
	@override String get qrcodeParsing => '正在解析...';
	@override String get qrcodeNotFound => '未偵測到 QR Code';
	@override String get qrcodeSupportHint => '支援解析各類訂閱、節點及設定 QR Code 圖片';
	@override String get qrcodeCameraHint => '將 QR Code 放入框內即可自動掃描';
	@override String get flashlight => '手電筒';
	@override String get screenshotDesc => '擷取螢幕';
	@override String get fromImageDesc => '本機圖片';
	@override String get fromClipboardDesc => '讀取連結';
	@override String get errorPrompt => '錯誤提示';
	@override String get copied => '已複製';
	@override String get sortAndFilterNodes => '節點排序與篩選';
	@override String get sortOptions => '排序方式';
	@override String get sortDefault => '預設排序';
	@override String get sortLatency => '延遲排序';
	@override String get sortName => '按名稱 A-Z';
	@override String get sortRegion => '按地區分組';
	@override String get filterOptions => '篩選選項';
	@override String portableUpdateTip({required Object version}) => '偵測到目前為免安裝便攜模式：\n便攜版本暫不支援應用程式內覆寫更新，請前往官網或儲存庫下載最新免安裝壓縮檔覆蓋解壓縮。\n\n最新版本: v${version}';
	@override String get portableModeTipTitle => '便攜模式提示';
	@override String get noNodesToSpeedTest => '無可用節點，無需測速';
	@override String alreadyLatestVersion({required Object version}) => '已是最新版本 (v${version})';
	@override String get checkUpdateFailed => '檢查更新失敗，請檢查網路連線';
	@override String get hideTimeoutNodes => '隱藏逾時與不可用節點';
	@override String get hideTimeoutNodesDesc => '自動過濾測速失敗或連線逾時的節點';
	@override String get speedtestScenario => '目前測速目標場景';
	@override String get speedtestScenarioSwitch => '測速目標場景切換';
	@override String get speedtestScenarioDesc => '選擇不同服務測試節點的真實可用性與連線延遲';
	@override String get speedtestAllNodes => '全量極速測速';
	@override String get retestTimeoutNodes => '僅重測逾時節點';
	@override String switchedTargetScenario({required Object target}) => '已切換測速目標場景: ${target}';
	@override String get notTested => '未測速';
	@override String get timeoutOrFailed => '逾時 / 無法連線';
	@override String get identifiedRegion => '識別地區';
	@override String get nodeProtocol => '節點協定';
	@override String get currentLatency => '目前延遲';
	@override String get testScenario => '測速場景';
	@override String get belongsToGroup => '所屬分組';
	@override String get copyNodeName => '複製名稱';
	@override String get nodeNameCopied => '已複製節點名稱';
	@override String get testSingleNode => '單獨測速';
	@override String get selectThisNode => '選擇此節點';
	@override String get allNodesNormal => '所有節點均正常可用，無需重測';
	@override String get customUrlPrompt => '自訂 URL (如 http://...)';
	@override String get customTarget => '自訂目標';
	@override String get downloadFailedTip => '下載更新安裝檔失敗，請檢查網路或點擊下方前往網頁下載。';
	@override String discoveredNewVersion({required Object version}) => '發現新版本: v${version}';
	@override String get preparingUpdate => '正在準備啟動更新...';
	@override String get downloadingPackage => '安裝檔正在下載中，請稍候...';
	@override String get downloadUpdateNow => '立即下載更新';
	@override String get downloadFromWeb => '前往網頁下載安裝檔';
	@override String get switchSource => '切換源';
	@override String get serverSwitch => '測速伺服器切換';
	@override String get autoDetectBest => '自動探測最優';
	@override String get serverSwitchDesc => '選擇不同的測速 CDN 源或自訂節點進行多鏈路測速';
	@override String autoSelectedBest({required Object server, required Object ping}) => '已自動選擇最優測速源: ${server} (${ping} ms)';
	@override String get networkGradeTitle => '網路體質綜合評分';
	@override String get copyReport => '複製測速報告';
	@override String get reportCopied => '測速報告已複製到剪貼簿，可直接貼上分享';
	@override String get gamingExperience => '電競體驗';
	@override String get streamingExperience => '超清串流媒體';
	@override String get meetingExperience => '遠端視訊';
	@override String get customSpeedtestUrl => '自訂測速下載 URL (https://...)';
	@override String get customSpeedtestSource => '自訂測速源';
	@override String get userSpecifiedUrl => '使用者指定 URL';
	@override String cannotBeEmpty({required Object item}) => '${item}不能為空';
	@override String alreadyExists({required Object item}) => '${item}已存在';
	@override String installFailedWithCode({required Object installer, required Object code}) => '安裝 ${installer} 失敗，錯誤碼: ${code}';
	@override String get resetSystemProxy => '修復網路 / 重設系統代理';
	@override String get resetSystemProxyDesc => '清理殘留系統代理設定並重新整理網路，解決異常結束後無法上網問題';
	@override String get resetSystemProxySuccess => '系統代理已清理並重設，網路已恢復正常';
	@override String get networkDiagnostics => '網路鏈路體檢與智慧診斷';
	@override String get networkDiagnosticsDesc => '一鍵逐步診斷網卡、DNS、核心連接埠與代理健康狀態並智慧自愈';
	@override String get sortLatencyDesc => '延遲由高到低';
	@override String get sortNameDesc => '名稱 Z-A';
	@override String get sortMultiplier => '倍率由低到高';
	@override String get uwpLoopback => 'UWP 迴環代理豁免工具';
	@override String get uwpLoopbackDesc => '一鍵豁免應用程式市集、Xbox、Minecraft 等 UWP 應用程式走本機代理';
	@override String get uwpExemptAllCommon => '一鍵豁免常用應用';
	@override String get uwpApplySuccess => 'UWP 迴環代理豁免規則已生效';
	@override String get common => '常用';
	@override String get exempted => '已豁免';
	@override String get notExempted => '未豁免';
	@override String get deselectAll => '全不選';
	@override String get userApps => '使用者應用';
	@override String get systemApps => '系統應用';
	@override String get selectedOnly => '已選取';
	@override String get proxySelectedMode => '僅代理選取的應用';
	@override String get proxySelectedModeDesc => '已選應用走代理，其餘應用直連';
	@override String get bypassSelectedMode => '繞過選取的應用';
	@override String get bypassSelectedModeDesc => '已選應用直連，其餘應用走代理';
	@override String get invertSelection => '反選';
	@override String get all => '全部';
	@override String get showAppIcon => '顯示應用程式圖示';
	@override String get proxySelection => '節點選擇';
	@override String get regionHk => '🇭🇰 香港節點';
	@override String get regionJp => '🇯🇵 日本節點';
	@override String get regionSg => '🇸🇬 新加坡節點';
	@override String get regionTw => '🇹🇼 台灣節點';
	@override String get regionUs => '🇺🇸 美國節點';
	@override String get regionKr => '🇰🇷 韓國節點';
	@override String get macMoveToApplications => '請先將 Wmimo 拖入【應用程式】(Applications) 資料夾後再開啟執行';
	@override String get notifCurrentNode => '目前節點';
	@override String get notifMode => '運行模式';
	@override String get notifPort => '埠號';
	@override String get notifProfile => '配置訂閱';
	@override String get notifDisconnect => '中斷連線';
	@override String get notifSwitchNode => '切換節點';
	@override String get notifVpnConnected => 'VPN 代理已連線';
	@override String get connectionDetails => '連線詳情';
	@override String get sourceAddress => '來源位址';
	@override String get destinationAddress => '目標位址';
	@override String get host => '網域名稱';
	@override String get process => '關聯處理程序';
	@override String get processPath => '處理程序完整路徑';
	@override String get proxyChain => '代理鏈路';
	@override String get networkProtocol => '傳輸協定';
	@override String get trafficUpload => '上傳流量';
	@override String get trafficDownload => '下載流量';
	@override String get connectionDuration => '持續時間';
	@override String get connectionStart => '發起時間';
	@override String get copyHost => '複製網域名稱';
	@override String get copyAllDetails => '複製全部資訊';
	@override String get closeThisConnection => '中斷此連線';
	@override String get sortByDownload => '依下載流量';
	@override String get sortByUpload => '依上傳流量';
	@override String get sortBySpeed => '依即時速率';
	@override String get sortByDuration => '依連線時長';
	@override String get sortByHost => '依目標網域';
	@override String get realtimeSpeed => '即時速率';
	@override String get totalUpload => '上傳總量';
	@override String get totalDownload => '下載總量';
	@override String get activeConnections => '活躍連線';
	@override String get openInFolder => '在資料夾中顯示';
	@override String get openProfilesDir => '開啟設定目錄';
	@override String get profilePatches => '設定覆寫';
	@override String nodeCount({required Object p}) => '${p} 個節點';
	@override String get copyFilePath => '複製檔案路徑';
	@override String get duplicateProfile => '建立複本';
	@override String get useThisProfile => '使用此設定';
	@override String get websiteTest => '網站測試';
	@override String get testAll => '測試全部';
	@override String get addTestWebsite => '新增測試網站';
	@override String get websiteName => '網站名稱';
	@override String get websiteUrl => '測試 URL';
	@override String get websiteNameHint => '網站名稱 (如: Cloudflare)';
	@override String get websiteInputEmpty => '請輸入網站名稱與 URL';
	@override String get autoRefresh => '自動重新整理';
	@override String get currentProfile => '目前設定';
	@override String get quickActions => '捷徑工具';
	@override String get fastest => '最低延遲';
	@override String get hideTimeout => '隱藏超時';
	@override String get filteredTimeout => '已過濾超時';
	@override String get tunDeviceCreateFailed => 'TUN 虛擬網卡建立失敗';
	@override String get test => '測試';
	@override String get addWebsite => '新增網站';
	@override String get maxWebsitesReached => '最多支援新增 6 個測試網站';
	@override String get sideBySideLayout => '並列排版';
	@override String get sideBySideLayoutTips => '開啟後首頁卡片與訂閱列表在寬螢幕下採用並列排版，關閉則保持單列垂直排版';
	@override String get homeCardsManage => '首頁卡片管理';
	@override String get homeCardsManageTips => '自訂首頁顯示的卡片模組與顯隱狀態';
	@override String get cardTrafficChart => '流量統計圖表';
	@override String get cardWebsiteTest => '網站連通測試';
	@override String get cardIpInfo => 'IP 與出口資訊';
	@override String get cardSubscription => '方案與到期資訊';
	@override String get cardQuickActions => '快捷工具入口';
	@override String get resetDefaultCards => '恢復預設卡片';
}

// Path: permission
class Translations$permission$zh_TW implements Translations$permission$en {
	Translations$permission$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get camera => '相機';
	@override String get screen => '螢幕錄製';
	@override String get appQuery => '取得應用程式列表';
	@override String request({required Object p}) => '開啟[${p}]權限';
	@override String requestNeed({required Object p}) => '請開啟[${p}]權限';
}

// Path: tls
class Translations$tls$zh_TW implements Translations$tls$en {
	Translations$tls$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get insecure => '略過憑證驗證';
	@override String get certificate => '憑證';
	@override String get privateKey => '私鑰';
	@override String get customTrustCert => '自訂信任憑證';
}

// Path: tun
class Translations$tun$zh_TW implements Translations$tun$en {
	Translations$tun$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get stack => '網路堆疊';
	@override String get stackGvisor => 'gVisor';
	@override String get stackGvisorDesc => '使用者空間網路棧，穩定性與相容性極佳';
	@override String get stackSystem => 'System';
	@override String get stackSystemDesc => '使用系統原生網路棧，效能高但依賴系統實現';
	@override String get stackMixed => 'Mixed';
	@override String get stackMixedDesc => '混合網路棧模式，兼顧效能與相容性';
	@override String get stackMips => 'MIPS (Mihomo IP Stack)';
	@override String get stackMipsDesc => 'Mihomo 自研高效能 IP 網路棧，高輸送量低延遲';
	@override String get inet4Address => 'IPv4位址段';
	@override String get inet6Address => 'IPv6位址段';
	@override String get dnsHijack => 'DNS劫持';
	@override String get strictRoute => '嚴格路由';
	@override String get tunDefaultRoute => '預設路由';
	@override String get icmpForward => 'ICMP 轉發';
	@override String get allowBypass => '允許應用程式略過 VPN';
	@override String get appendHttpProxy => '附加HTTP代理到VPN';
	@override String get bypassHttpProxyDomain => '允許略過 HTTP 代理的網域名稱';
}

// Path: dns
class Translations$dns$zh_TW implements Translations$dns$en {
	Translations$dns$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get listen => '監聽地址';
	@override String get fakeIp => 'fake-ip';
	@override String get fallback => 'Fallback';
	@override String get preferH3 => 'DoH H3優先';
	@override String get useHosts => '使用Hosts';
	@override String get useSystemHosts => '使用系統Hosts';
	@override String get enhancedMode => '增強模式';
	@override String get fakeIPFilterMode => '${_root.dns.fakeIp} 過濾模式';
	@override String get fakeIPFilter => '${_root.dns.fakeIp} 過濾';
	@override String get respectRules => '遵守[rules]規則';
	@override String get nameServer => '域名解析伺服器';
	@override String get defaultNameServer => '${_root.meta.byDefault} ${_root.dns.nameServer}';
	@override String get proxyNameServer => '${_root.meta.proxy} ${_root.dns.nameServer}';
	@override String get directNameServer => '${_root.meta.direct} ${_root.dns.nameServer}';
	@override String get fallbackNameServer => '${_root.dns.fallback} ${_root.dns.nameServer}';
	@override String get fallbackGeoIp => '${_root.dns.fallback} GeoIp';
	@override String get fallbackGeoIpCode => '${_root.dns.fallback} GeoIp 代碼';
	@override String get flushCache => '清空 DNS 快取';
	@override String get flushCacheSuccess => 'DNS 與 Fake-IP 快取已成功清空';
	@override String get presets => '快速預設方案';
	@override String get presetSpeed => '國內極速雙棧';
	@override String get presetSpeedDesc => '阿里 DoH3 + 騰訊 DoH，國內直連秒開，國外智慧分流';
	@override String get presetSecure => '安全防污染模式';
	@override String get presetSecureDesc => 'Cloudflare DoH3 + Google DoH，杜絕劫持與審查';
	@override String get presetAdGuard => '廣告攔截與純淨模式';
	@override String get presetAdGuardDesc => 'AdGuard DoQ + 阿里 DoH，深度淨化網路請求與隱私追蹤';
	@override String get overwriteDesc => '覆蓋訂閱設定檔中的 DNS 設定';
	@override String get enableDesc => '啟用自訂 DNS 解析器';
	@override String get resetFakeIpFilter => '恢復推薦過濾';
	@override String get resetFakeIpFilterConfirm => '確定恢復預設的 Fake-IP 過濾白名單列表嗎？';
	@override String get dnsTester => 'DNS 即時解析診斷';
	@override String get testQuery => '測試解析';
	@override String get fakeIpDetected => '命中 Fake-IP';
	@override String get realIpDetected => '真實公網 IP';
	@override String get addServer => '新增 DNS 伺服器';
	@override String get geoAssetsTitle => 'GEO 離線資料庫';
	@override String get geoAssetsDesc => '管理 GeoSite 網域分流庫、GeoIP 與 ASN 地理資訊庫';
	@override String get cdnSource => '下載加速鏡像源';
	@override String get updateAll => '全部更新';
	@override String get updateSuccess => '更新成功';
	@override String get updateFailed => '更新失敗';
	@override String get addPresetServer => '新增預設 DNS';
	@override String manageFakeIpFilter({required Object p}) => '管理過濾清單 (${p})';
	@override String fakeIpFilterDesc({required Object p}) => '${p} 條網域規則繞過 Fake-IP 解析，以避免網路隔離問題。';
}

// Path: sniffer
class Translations$sniffer$zh_TW implements Translations$sniffer$en {
	Translations$sniffer$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get overrideDest => '覆蓋';
}

// Path: profilePatchMode
class Translations$profilePatchMode$zh_TW implements Translations$profilePatchMode$en {
	Translations$profilePatchMode$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get currentSelected => '當前選擇';
	@override String get overwrite => '內置-覆寫';
	@override String get noOverwrite => '內置-不覆寫';
}

// Path: main.tray
class Translations$main$tray$zh_TW implements Translations$main$tray$en {
	Translations$main$tray$zh_TW.internal(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get menuOpen => '顯示主視窗';
	@override String get menuExit => '結束';
	@override String get coreDisconnected => '未連線';
	@override String get coreRunning => '已連線';
	@override String get startProxy => '啟動連線';
	@override String get stopProxy => '中斷連線';
	@override String get restartCore => '重新啟動核心';
	@override String get systemProxyItem => '系統代理';
	@override String get tunModeItem => 'TUN 模式';
	@override String get outboundMode => '代理模式';
	@override String get modeRule => '規則模式';
	@override String get modeGlobal => '全域模式';
	@override String get modeDirect => '直連模式';
	@override String get profilesMenu => '訂閱設定';
	@override String get updateAllProfiles => '更新全部訂閱';
	@override String get proxyNodes => '代理節點';
	@override String get tools => '實用工具';
	@override String get copyProxyCmd => '複製代理指令';
	@override String get delayTestAll => '全節點測速';
	@override String get openDashboard => '開啟儀表板';
	@override String get resetSystemProxy => '修復網路/重設系統代理';
	@override String get copyCmdPowerShell => 'PowerShell 代理指令';
	@override String get copyCmdCmd => 'CMD 代理指令';
	@override String get copyCmdBash => 'Bash/Zsh 代理指令';
}

/// The flat map containing all translations for locale <zh-TW>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhTw {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'WelcomeLanguageScreen.welcomeTitle' => '歡迎使用 Wmimo',
			'WelcomeLanguageScreen.selectLanguage' => '選擇軟體語言',
			'WelcomeLanguageScreen.subtitle' => '請選擇您的首選語言，您隨時可以在設定中更改',
			'WelcomeLanguageScreen.start' => '進入應用',
			'BackupAndSyncWebdavScreen.webdavServerUrl' => '伺服器地址',
			'BackupAndSyncWebdavScreen.webdavRequired' => '不能為空',
			'BackupAndSyncWebdavScreen.webdavLoginFailed' => '登入失敗:',
			'BackupAndSyncWebdavScreen.webdavListFailed' => '取得檔案清單失敗:',
			'LaunchFailedScreen.invalidProcess' => '應用程式啟動失敗 [無效的處理程序名稱]，請重新安裝應用程式至獨立目錄',
			'LaunchFailedScreen.invalidProfile' => '應用啟動失敗[訪問設定檔失敗],請重新安裝應用',
			'LaunchFailedScreen.invalidVersion' => '應用啟動失敗[無效版本],請重新安裝應用',
			'LaunchFailedScreen.systemVersionLow' => '應用啟動失敗[系統版本過低]',
			'LaunchFailedScreen.invalidInstallPath' => '無效的安裝路徑,請重新安裝到有效路徑',
			'PerAppAndroidScreen.title' => '分應用代理',
			'PerAppAndroidScreen.whiteListMode' => '白名單模式',
			'PerAppAndroidScreen.whiteListModeTip' => '啟用後:僅代理已勾選的App;未啟用:僅代理未勾選的App',
			'PerAppAndroidScreen.manualAddPackage' => '手動新增應用程式套件名稱',
			'PerAppAndroidScreen.manualAddPackageHint' => '請輸入需要代理的應用程式套件名稱（支援多個，使用空格、逗號或換行分隔，例如：org.telegram.messenger, com.google.android.youtube）：',
			'PerAppAndroidScreen.quickAddPresets' => '捷徑新增常用代理應用程式',
			'PerAppAndroidScreen.saveSelected' => '儲存所選',
			'PerAppAndroidScreen.permissionRestrictedTip' => '目前系統限制了讀取軟體列表。請點擊下方【前往系統權限設定頁】開啟「取得應用程式列表」，或直接使用免授權的「常用應用程式預設」一鍵代理。',
			'PerAppAndroidScreen.openSystemPermission' => '前往系統權限設定頁',
			'PerAppAndroidScreen.presetApps' => '捷徑新增常用應用程式 (免授權預設)',
			'PerAppAndroidScreen.requestPermissionPopup' => '嘗試一鍵申請權限 (系統彈窗)',
			'UserAgreementScreen.privacyFirst' => '您的隱私很重要',
			'UserAgreementScreen.agreeAndContinue' => '接受並繼續',
			'NetCheckScreen.title' => '網路鏈路體檢與診斷',
			'NetCheckScreen.fullDiagnosticsTab' => '一鍵鏈路體檢',
			'NetCheckScreen.advancedCheckTab' => '進階單網域排查',
			'NetCheckScreen.startDiagnostics' => '開始全鏈路體檢',
			'NetCheckScreen.reDiagnostics' => '重新體檢',
			'NetCheckScreen.diagnosing' => '正在全面診斷鏈路...',
			'NetCheckScreen.healthScore' => '健康評分',
			'NetCheckScreen.scorePerfect' => '鏈路極佳',
			'NetCheckScreen.scoreGood' => '基本良好',
			'NetCheckScreen.scoreWarning' => '存在警告',
			'NetCheckScreen.scoreCritical' => '鏈路受阻',
			'NetCheckScreen.oneClickRepair' => '一鍵智慧自愈',
			'NetCheckScreen.repairSuccess' => '自愈修復成功，網路已恢復正常',
			'NetCheckScreen.repairFailed' => '部分項目可能需手動確認',
			'NetCheckScreen.repairing' => '正在執行自愈修復...',
			'NetCheckScreen.issueFound' => ({required Object count}) => '發現 ${count} 處異常',
			'NetCheckScreen.noIssue' => '全項檢測正常',
			'NetCheckScreen.details' => '技術詳情',
			'NetCheckScreen.copyDetails' => '複製日誌',
			'NetCheckScreen.detailsCopied' => '診斷日誌已複製到剪貼簿',
			'NetCheckScreen.stepPhysical' => '實體網卡與閘道',
			'NetCheckScreen.stepDns' => 'DNS 解析與 Fake-IP',
			'NetCheckScreen.stepCore' => '核心服務與連接埠',
			'NetCheckScreen.stepProxy' => '系統代理設定',
			'NetCheckScreen.stepHandshake' => '公網端到端交握',
			'NetCheckScreen.suggestedAction' => '排障建議',
			'NetCheckScreen.autoRepairAction' => '立即修復',
			'NetCheckScreen.enterDomain' => '請輸入網域名稱',
			'NetCheckScreen.checking' => '檢測中...',
			'NetCheckScreen.aQueryFailed' => ({required Object p}) => 'A 查詢失敗: ${p}',
			'NetCheckScreen.aaaaQueryFailed' => ({required Object p}) => 'AAAA 查詢失敗: ${p}',
			'NetCheckScreen.success' => '成功',
			'NetCheckScreen.failed' => '失敗',
			'NetCheckScreen.suspectedPollution' => '疑似被污染',
			'NetCheckScreen.domainLabel' => '網域名稱',
			'NetCheckScreen.checkButton' => '檢測',
			'NetCheckScreen.dnsSection' => '1. DNS查詢',
			'NetCheckScreen.directHttpSection' => '2. HTTP (經由TUN,請先啟用TUN)',
			'NetCheckScreen.proxyHttpSection' => ({required Object p}) => '3. HTTP (經由代理,連接埠:${p})',
			'NetCheckScreen.tunNotEnabled' => 'TUN 未啟用',
			'NetCheckScreen.routeTableSection' => '4. 路由表',
			'NetCheckScreen.stepPhysicalDesc' => '檢測實體網卡狀態、本機區域網路 IP 與本機閘道連線能力',
			'NetCheckScreen.stepDnsDesc' => '驗證本地域名解析線路耗時與核心 DNS 回應狀態',
			'NetCheckScreen.stepCoreDesc' => '檢測 Mihomo 行程存活狀態與 Mixed-Port/API 連接埠監聽',
			'NetCheckScreen.stepProxyDesc' => '驗證系統底層代理是否正確對齊並排查殘留斷網隱患',
			'NetCheckScreen.stepHandshakeDesc' => '透過啟動代理節點向全球 CDN 測定實際端對端延遲與可用性',
			'NetCheckScreen.shortStepPhysical' => '網卡',
			'NetCheckScreen.shortStepDns' => 'DNS',
			'NetCheckScreen.shortStepCore' => '核心',
			'NetCheckScreen.shortStepProxy' => '代理',
			'NetCheckScreen.shortStepHandshake' => '公網',
			'NetCheckScreen.valNicNormal' => ({required Object p}) => '網卡連線正常 (${p})',
			'NetCheckScreen.valNicNone' => '未找到可用網路介面',
			'NetCheckScreen.valNicGatewayTimeout' => '區域網路 IP 已獲取，但外部閘道連線逾時',
			'NetCheckScreen.valNicError' => '網路介面檢查異常',
			'NetCheckScreen.valDnsNormal' => ({required Object p}) => 'DNS 回應正常 (${p})',
			'NetCheckScreen.valDnsEmpty' => 'DNS 查詢傳回空清單',
			'NetCheckScreen.valDnsTimeout' => 'DNS 查詢逾時或失敗',
			'NetCheckScreen.valCoreNormal' => ({required Object port, required Object mode}) => '核心運作良好 (混合埠: ${port}, 模式: ${mode})',
			'NetCheckScreen.valCoreNotRunning' => '核心服務未執行',
			'NetCheckScreen.valCorePortConflict' => ({required Object p}) => '連接埠 ${p} 已被外部程式占用',
			'NetCheckScreen.valCoreApiFailed' => '核心行程無回應 (API 埠通訊失敗)',
			'NetCheckScreen.valCoreError' => '核心檢測異常',
			'NetCheckScreen.valProxyActive' => ({required Object port}) => '系統代理已生效 (127.0.0.1:${port})',
			'NetCheckScreen.valProxyDisabled' => '系統代理未啟用（目前走直連/TUN/手動模式）',
			'NetCheckScreen.valProxyZombie' => '檢測到殘留系統代理（導致斷網）',
			'NetCheckScreen.valProxyFailed' => '系統代理未能成功啟用',
			'NetCheckScreen.valProxyWarning' => '系統代理狀態讀取警告',
			'NetCheckScreen.valHandshakeNormal' => ({required Object node, required Object delay}) => '公網連線暢通 (${node} • ${delay} ms)',
			'NetCheckScreen.valHandshakeFailed' => ({required Object node, required Object err}) => '目前節點 [${node}] 連線失敗 (${err})',
			'NetCheckScreen.valHandshakeSkipped' => '核心未啟動，略過公網握手測試',
			'NetCheckScreen.valHandshakeError' => '公網握手發生異常',
			'NetCheckScreen.issueNicDisconnected' => '本機網卡未連線到任何網路（網路線拔出、Wi-Fi 未連或飛航模式）',
			'NetCheckScreen.suggestNicCheck' => '請檢查電腦實體網路線連線、Wi-Fi 無線網路或網路介面卡狀態',
			'NetCheckScreen.suggestNicReset' => '嘗試在系統設定中停用並重新啟用網路介面卡',
			'NetCheckScreen.issueNicGatewayUnreachable' => '電腦已接入區域網路，但無法存取外部基礎路由（可能受限於校園網路/飯店認證或路由器斷網）',
			'NetCheckScreen.suggestNicGateway' => '請檢查路由器光纖指示燈，或開啟瀏覽器確認是否需要 Web 登入認證',
			'NetCheckScreen.issueDnsPollution' => '本地域名解析服務未回應，可能存在 DNS 污染或閘道劫持',
			'NetCheckScreen.suggestDnsReset' => '建議重設系統 DNS 或在 Wmimo 中啟用智慧加密 DNS (DoH/DoT)',
			'NetCheckScreen.actionFlushDns' => '重新整理系統 DNS 快取',
			'NetCheckScreen.suggestDnsSlow' => 'DNS 解析耗時偏長，建議開啟 Smart Encrypted DNS 加速',
			'NetCheckScreen.issueDnsFailed' => '本地 DNS 解析失敗，系統無法將網域名稱轉換為 IP 位址',
			'NetCheckScreen.suggestDnsFlush' => '點擊一鍵重新整理系統 DNS 快取，或在 Wmimo 設定中啟用加密 DNS',
			'NetCheckScreen.issueCorePortConflict' => '檢測到連接埠衝突！其他代理軟體或系統服務正在占用本應用程式連接埠',
			'NetCheckScreen.suggestCoreChangePort' => '請完全退出其他代理客戶端，或在 Wmimo 設定中修改連接埠號',
			'NetCheckScreen.actionRestartCore' => '一鍵重啟核心',
			'NetCheckScreen.issueCoreStopped' => 'Wmimo 核心行程目前處於停止狀態',
			'NetCheckScreen.suggestCoreStart' => '點擊主畫面連線開關或點擊下方【啟動核心】',
			'NetCheckScreen.actionStartCore' => '啟動核心行程',
			'NetCheckScreen.issueCoreFrozen' => '核心行程發生停滯或 API Secret 鑑權不符合',
			'NetCheckScreen.suggestCoreRestart' => '建議點擊【一鍵重啟核心】恢復服務',
			'NetCheckScreen.suggestCoreReinstall' => '嘗試重啟核心或重裝服務驅動程式',
			'NetCheckScreen.issueProxyZombie' => '殘留的系統代理將流量轉發到未啟動的連接埠，導致斷網',
			'NetCheckScreen.suggestProxyReset' => '點擊下方【一鍵清理並重設系統代理】，即可立即恢復上網',
			'NetCheckScreen.actionResetProxy' => '一鍵清理並重設代理',
			'NetCheckScreen.issueProxyBlocked' => '系統代理設定未生效，可能被第三方安全軟體攔截或權限受限',
			'NetCheckScreen.suggestProxyReapply' => '點擊下方按鈕嘗試重新註冊並強制套用系統代理',
			'NetCheckScreen.actionReapplyProxy' => '重新套用系統代理',
			'NetCheckScreen.issueProxyRead' => '讀取系統代理設定時產生非致命異常',
			'NetCheckScreen.issueHandshakeBlocked' => '目前選取的代理節點無法連線外部網際網路，握手失敗或被阻斷',
			'NetCheckScreen.suggestHandshakeSwitch' => '該節點可能正在維護或無法連線，請切換至其他可用節點',
			'NetCheckScreen.suggestHandshakeSlow' => ({required Object delay}) => '節點延遲稍高 (${delay} ms)，建議測速選擇更近的邊緣節點',
			'NetCheckScreen.suggestHandshakeCheck' => '檢查節點設定或更換測速目標',
			'NetCheckScreen.conclusionPerfect' => '全線路極佳！所有網路節點與代理設定均正常暢通。',
			'NetCheckScreen.conclusionGood' => '線路基本正常，檢測到部分非致命延遲或警告，建議查看詳情。',
			'NetCheckScreen.conclusionWarning' => '檢測到部分網路或代理環節異常，請使用下方【一鍵修復】恢復。',
			'NetCheckScreen.conclusionCritical' => '嚴重網路受阻！本地網路未連線或代理核心遭遇阻斷。',
			'SpeedTestScreen.title' => '網路測速',
			'SpeedTestScreen.startTest' => '開始測速',
			'SpeedTestScreen.stopTest' => '停止測速',
			'SpeedTestScreen.reTest' => '重新測速',
			'SpeedTestScreen.ready' => '準備就緒',
			'SpeedTestScreen.testingPing' => '正在測試延遲與抖動...',
			'SpeedTestScreen.testingDownload' => '正在測試下載頻寬...',
			'SpeedTestScreen.testingUpload' => '正在測試上傳頻寬...',
			'SpeedTestScreen.completed' => '測速完成',
			'SpeedTestScreen.stopped' => '已停止',
			'SpeedTestScreen.ping' => '延遲',
			'SpeedTestScreen.jitter' => '抖動',
			'SpeedTestScreen.download' => '下載速度',
			'SpeedTestScreen.upload' => '上傳速度',
			'SpeedTestScreen.currentProxy' => '當前代理',
			'SpeedTestScreen.directConnection' => '直連模式',
			'SpeedTestScreen.server' => '測速伺服器',
			'SpeedTestScreen.serverLocation' => '伺服器位置',
			'SpeedTestScreen.realtimeSpeed' => '即時頻寬曲線',
			'SpeedTestScreen.peakSpeed' => '峰值速率',
			'SpeedTestScreen.avgSpeed' => '平均速率',
			'SpeedTestScreen.testHistory' => '測速歷史',
			'SpeedTestScreen.clearHistory' => '清空歷史',
			'VersionUpdateScreen.versionReady' => ({required Object p}) => '新版本[${p}]已就緒',
			'VersionUpdateScreen.update' => '重新啟動更新',
			'VersionUpdateScreen.cancel' => '暫不更新',
			'loginScreen.login' => '登入',
			'loginScreen.register' => '註冊賬號',
			'loginScreen.forgotPassword' => '忘記密碼',
			'loginScreen.provider' => '服務商',
			'loginScreen.providerName' => '${_root.loginScreen.provider}編碼/別名/URL',
			'loginScreen.providerNameRequired' => '請輸入${_root.loginScreen.provider}編碼/別名/URL',
			'loginScreen.account' => '賬號',
			'loginScreen.accountRequired' => '請輸入賬號',
			'loginScreen.email' => '郵箱',
			'loginScreen.emailRequired' => '請輸入郵箱地址',
			'loginScreen.password' => '密碼',
			'loginScreen.passwordRequired' => '請輸入密碼',
			'loginScreen.validEmailRequired' => '請輸入有效的郵箱地址',
			'loginScreen.passwordMinLength' => ({required Object minLength}) => '密碼長度至少${minLength}位',
			'loginScreen.unsupportedProvider' => '不支援的${_root.loginScreen.provider}',
			'loginScreen.unsupportedProviderType' => '不支援的${_root.loginScreen.provider}類型',
			'loginScreen.unActivedProvider' => '登入功能未啟用',
			'loginScreen.providerLoginSupportRequired' => ({required Object p}) => '編碼/別名請向${_root.loginScreen.provider}索取\n${_root.loginScreen.provider}接入請參考:${p}',
			'loginScreen.providerDisclaimer' => '免責聲明:${_root.loginScreen.provider}為第三方服務,與本App無關',
			'loginScreen.createSessionFailed' => '建立工作階段失敗，請檢查服務商或帳號密碼',
			'main.tray.menuOpen' => '顯示主視窗',
			'main.tray.menuExit' => '結束',
			'main.tray.coreDisconnected' => '未連線',
			'main.tray.coreRunning' => '已連線',
			'main.tray.startProxy' => '啟動連線',
			'main.tray.stopProxy' => '中斷連線',
			'main.tray.restartCore' => '重新啟動核心',
			'main.tray.systemProxyItem' => '系統代理',
			'main.tray.tunModeItem' => 'TUN 模式',
			'main.tray.outboundMode' => '代理模式',
			'main.tray.modeRule' => '規則模式',
			'main.tray.modeGlobal' => '全域模式',
			'main.tray.modeDirect' => '直連模式',
			'main.tray.profilesMenu' => '訂閱設定',
			'main.tray.updateAllProfiles' => '更新全部訂閱',
			'main.tray.proxyNodes' => '代理節點',
			'main.tray.tools' => '實用工具',
			'main.tray.copyProxyCmd' => '複製代理指令',
			'main.tray.delayTestAll' => '全節點測速',
			'main.tray.openDashboard' => '開啟儀表板',
			'main.tray.resetSystemProxy' => '修復網路/重設系統代理',
			'main.tray.copyCmdPowerShell' => 'PowerShell 代理指令',
			'main.tray.copyCmdCmd' => 'CMD 代理指令',
			'main.tray.copyCmdBash' => 'Bash/Zsh 代理指令',
			'meta.enable' => '啟用',
			'meta.disable' => '禁用',
			'meta.open' => '打開',
			'meta.close' => '關閉',
			'meta.quit' => '退出',
			'meta.add' => '添加',
			'meta.addSuccess' => '添加成功',
			'meta.addFailed' => ({required Object p}) => '添加失敗:${p}',
			'meta.remove' => '刪除',
			'meta.removeConfirm' => '確認刪除?',
			'meta.edit' => '編輯',
			'meta.view' => '查看',
			'meta.remark' => '備註',
			'meta.byDefault' => '預設',
			'meta.editRemark' => '修改備註',
			'meta.more' => '更多',
			'meta.tips' => '提示',
			'meta.selectAll' => '全選',
			'meta.copy' => '複製',
			'meta.paste' => '貼上',
			'meta.cut' => '剪切',
			'meta.save' => '儲存',
			'meta.ok' => '確定',
			'meta.cancel' => '取消',
			'meta.faq' => '常見問題',
			'meta.doc' => '說明文件',
			'meta.htmlTools' => 'HTML工具集',
			'meta.download' => '下載',
			'meta.loading' => '載入中...',
			'meta.days' => '天',
			'meta.hours' => '時',
			'meta.minutes' => '分',
			'meta.seconds' => '秒',
			'meta.milliseconds' => '毫秒',
			'meta.protocol' => '協議',
			'meta.search' => '搜索',
			'meta.custom' => '自訂',
			'meta.connect' => '連接',
			'meta.disconnect' => '斷開',
			'meta.connected' => '已連接',
			'meta.disconnected' => '未連接',
			'meta.connecting' => '連接中',
			'meta.connectTimeout' => '連接超時',
			'meta.timeout' => '超時',
			'meta.timeoutDuration' => '超時時長',
			'meta.latency' => '延遲',
			'meta.latencyTest' => '延遲測速',
			'meta.networkCheck' => '網路檢測',
			'meta.speedTest' => '網路測速',
			'meta.language' => '語言',
			'meta.next' => '下一步',
			'meta.done' => '完成',
			'meta.apply' => '應用',
			'meta.refresh' => '重新整理',
			'meta.retry' => '是否重試?',
			'meta.update' => '更新',
			'meta.updateInterval' => '更新時間間隔',
			'meta.updateInterval5mTips' => '最小:5m',
			'meta.updateIntervalPreferByProfile' => '優先使用服務商(機場)設定',
			'meta.updateFailed' => ({required Object p}) => '更新失敗:${p}',
			'meta.none' => '無',
			'meta.reset' => '重設',
			'meta.resetConfirm' => '確定重設所有應用程式設定嗎？',
			'meta.resetSuccess' => '應用程式設定已重設為預設值',
			'meta.resetCoreConfirm' => '確定重設核心設定與覆寫設定嗎？',
			'meta.resetCoreSuccess' => '核心設定已重設為預設值',
			'meta.authentication' => '授權',
			'meta.submit' => '提交',
			'meta.user' => '用戶',
			'meta.account' => '賬號',
			'meta.password' => '密碼',
			'meta.decryptPassword' => '解密密碼',
			'meta.required' => '必填',
			'meta.go' => '繼續',
			'meta.sudoPassword' => 'sudo 密碼(TUN模式需要)',
			'meta.other' => '其他',
			'meta.dns' => 'DNS',
			'meta.url' => 'URL',
			'meta.urlInvalid' => 'URL無效',
			'meta.urlCannotEmpty' => 'URL不能為空',
			'meta.urlTooLong' => 'URL過長(>8182)',
			'meta.copyUrl' => '複製連結',
			'meta.openUrl' => '打開連結',
			'meta.shareUrl' => '分享連結',
			'meta.coreSettingTips' => '注意：修改設定後，需要重新連線才會生效',
			'meta.overwrite' => '覆寫',
			'meta.overwriteCustom' => '自訂覆寫',
			'meta.overwriteAppend' => '追加覆寫',
			'meta.overwriteTips' => '原始設定<-自訂覆寫<-App覆寫',
			'meta.noOverwrite' => '不覆寫',
			'meta.overwriteSettings' => '覆寫設定',
			'meta.diversionTemplates' => '分流模板',
			'meta.ruleProviders' => '規則集 (RuleSet)',
			'meta.ruleTemplates' => '規則模板',
			'meta.proxyGroupsTemplates' => '策略組模板',
			'meta.proxyGroups' => '策略組',
			'meta.proxyNodeList' => '代理節點列表',
			'meta.proxyNodeFailure' => ({required Object p}) => '下列代理節點已失效,已自動移除:${p}',
			'meta.externalController' => '外部控制',
			'meta.secret' => '金鑰',
			'meta.tcpConcurrent' => 'TCP併發握手',
			'meta.globalClientFingerprint' => 'TLS 全域指紋',
			'meta.allowLanAccess' => '允許區域網路裝置連入',
			'meta.mixedPort' => '混合代理連接埠',
			'meta.logLevel' => '日誌等級',
			'meta.findProcessMode' => '處理程序比對模式',
			'meta.tcpkeepAliveInterval' => 'TCP保活時間間隔',
			'meta.delayTestUrl' => '延遲測試URL',
			'meta.delayTestTimeout' => '延遲測試超時(ms)',
			'meta.tun' => 'TUN',
			'meta.ntp' => 'NTP',
			'meta.tls' => 'TLS',
			'meta.geo' => 'GEO',
			'meta.geoDownloadByProxy' => '使用代理下載Geo RuleSet',
			'meta.geoRulesetTips' => 'Geosite/Geoip 會被轉換成 對應的RuleSet',
			'meta.asnNotSupportInIosTips' => '由於 iOS 系統記憶體限制，IP-ASN 及 SRC-IP-ASN 規則在 iOS 上將被略過',
			'meta.sniffer' => '嗅探',
			'meta.userAgent' => 'UserAgent',
			'meta.launchAtStartup' => '開機啟動',
			'meta.launchAtStartupRunAsAdmin' => '請以管理員身份重新啟動Wmimo',
			'meta.tunModeRunAsAdmin' => 'TUN模式需要系統管理員權限,請以管理員身份重新啟動應用',
			'meta.tunSwitchToSystemProxy' => '是否臨時切換為【系統代理模式】繼續連線？',
			'meta.tunCreateAdapterFailedAdmin' => 'TUN 虛擬網卡建立失敗: Access is denied。\nTUN 模式需要管理員權限，請右鍵選擇【以管理員身分執行】應用，或在主畫面/核心設定中關閉 TUN 模式並使用系統代理連線。',
			'meta.portableMode' => '便攜模式',
			'meta.portableModeDisableTips' => '如需結束免安裝便攜模式，請結束 [Wmimo] 後，手動刪除 [wmimo.exe] 同目錄下的 [portable] 資料夾即可',
			'meta.systemProxy' => '系統代理',
			'meta.autoConnectAfterLaunch' => '啟動後自動連接',
			'meta.autoConnectAtBoot' => '系統啟動後自動連接',
			'meta.autoConnectAtBootTips' => '需要系統支援，部分系統可能還需要開啟 [開機自動啟動]',
			'meta.hideAfterLaunch' => '啟動後隱藏視窗',
			'meta.autoSetSystemProxy' => '連線後自動設定系統代理',
			'meta.bypassSystemProxy' => '允許略過系統代理的網域名稱',
			'meta.excludeFromRecent' => '從[最近任務]中隱藏',
			'meta.wakeLock' => '喚醒鎖',
			'meta.hideVpn' => '隱藏 VPN 圖示',
			'meta.hideVpnTips' => '開啟IPv6會導致此功能失效',
			'meta.hideDockIcon' => '隱藏 Dock 圖示',
			'meta.showTrayTraffic' => '系統匣顯示流量資訊',
			'meta.website' => '官網',
			'meta.homePage' => '主頁',
			'meta.rule' => '規則',
			'meta.global' => '全域',
			'meta.direct' => '直連',
			'meta.block' => '攔截',
			'meta.qrcode' => 'QR Code',
			'meta.qrcodeTooLong' => '文本過長,無法展示',
			'meta.qrcodeShare' => '分享 QR Code',
			'meta.textToQrcode' => '文字轉 QR Code',
			'meta.qrcodeScan' => '掃描 QR Code',
			'meta.qrcodeScanResult' => '掃描結果',
			'meta.qrcodeScanFromImage' => '開啟 QR Code 圖片',
			'meta.qrcodeScanFromClipboard' => '剪貼簿識別',
			'meta.qrcodeRecognized' => 'QR Code 辨識成功',
			'meta.qrcodeDropHint' => '點擊上方按鈕擷取螢幕或選取圖片',
			'meta.confirmImport' => '確認匯入',
			'meta.reScan' => '重新掃描',
			'meta.qrcodeScanResultFailed' => '解析圖片失敗，請確認截圖為有效的 QR Code',
			'meta.qrcodeScanResultEmpty' => '掃描結果為空',
			'meta.screenshot' => '截圖',
			'meta.backupAndSync' => '備份與同步',
			'meta.importSuccess' => '匯入成功',
			'meta.rewriteConfirm' => '該檔案將覆寫本機現有設定，是否繼續？',
			'meta.importAndExport' => '匯入/匯出',
			'meta.import' => '匯入',
			'meta.importFromUrl' => '從URL匯入',
			'meta.export' => '匯出',
			'meta.send' => '發送',
			'meta.receive' => '接收',
			'meta.sendConfirm' => '確認發送?',
			'meta.continueConnectConfirm' => '是否繼續連接?',
			'meta.termOfUse' => '使用條款',
			'meta.privacyPolicy' => '隱私政策',
			'meta.log' => '日誌',
			'meta.coreLog' => '核心日誌',
			'meta.core' => '核心',
			'meta.help' => '幫助',
			'meta.tutorial' => '使用教程',
			'meta.board' => '面板',
			'meta.boardOnline' => '使用線上儀表板',
			'meta.boardOnlineUrl' => '線上儀表板網址',
			'meta.boardLocalPort' => '本機儀表板連接埠',
			'meta.connections' => '活動連接',
			'meta.closeAllConnections' => '關閉全部連接',
			'meta.searchConnections' => '搜尋連線 (網域名稱/IP/規則/處理程序)',
			'meta.noFilterResults' => '沒有相符的連接',
			'meta.searchRules' => '搜尋規則 (類型/特徵/目標代理)',
			'meta.searchProfiles' => '搜尋設定檔 (名稱/連結/備註)',
			'meta.noMatchingProfiles' => '未找到相符的訂閱設定檔',
			'meta.rules' => '分流規則',
			'meta.clear' => '清除',
			'meta.copySuccess' => '複製成功',
			'meta.alwayOnVPN' => '始終開啟連線',
			'meta.disableFontScaler' => '停用字型縮放',
			'meta.autoOrientation' => '跟隨螢幕旋轉',
			'meta.restartTakesEffect' => '重新啟動後生效',
			'meta.reconnectTakesEffect' => '重新連接後生效',
			'meta.runtimeProfile' => '執行階段設定',
			'meta.willCompleteAfterRebootInstall' => '請重新啟動裝置，以便完成系統擴充功能安裝',
			'meta.willCompleteAfterRebootUninstall' => '請重新啟動裝置，以便完成系統擴充功能解除安裝',
			'meta.requestNeedsUserApproval' => '1. 請在[系統設定]-[隱私權與安全性]裡[允許] Wmimo安裝系統擴充功能\n2. 在[系統設定]-[一般]-[登入項目與擴充功能-網路擴充功能]啟用[wmimoServiceSE]\n完成後重新連線',
			'meta.FullDiskAccessPermissionRequired' => '請在[系統設定]-[隱私權與安全性]-[完全磁碟取用權限]裡開啟wmimoServiceSE權限後，重新連線',
			'meta.proxy' => '代理',
			'meta.theme' => '主題',
			'meta.tvMode' => 'TV模式',
			'meta.autoUpdate' => '自動更新',
			'meta.updateChannel' => '自動更新通道',
			'meta.onlineCustomerService' => '線上客服',
			'meta.subscriptionChannel' => '訂閱頻道',
			'meta.hasNewVersion' => ({required Object p}) => '更新版本 ${p}',
			'meta.autoDownloadPkg' => '自動下載更新包',
			'meta.devOptions' => '開發者選項',
			'meta.joinUs' => '加入我們',
			'meta.about' => '關於',
			'meta.name' => '名稱',
			'meta.version' => '版本',
			'meta.notice' => '通知',
			'meta.sort' => '排序',
			'meta.recommended' => '推薦',
			'meta.innerError' => ({required Object p}) => '內部錯誤:${p}',
			'meta.share' => '分享',
			'meta.importFromClipboard' => '從剪貼簿匯入',
			'meta.exportToClipboard' => '匯出到剪貼簿',
			'meta.server' => '伺服器',
			'meta.port' => '連接埠',
			'meta.donate' => '捐助',
			'meta.setting' => '設定',
			'meta.settingCore' => '核心設定',
			'meta.settingApp' => '應用程式設定',
			'meta.coreOverwrite' => '核心覆寫',
			'meta.iCloud' => 'iCloud',
			'meta.webdav' => 'Webdav',
			'meta.lanSync' => '區域網路同步',
			'meta.lanSyncNotQuitTips' => '同步完成前請勿離開此介面',
			'meta.deviceNoSpace' => '磁盤空間不足',
			'meta.hideSystemApp' => '隱藏系統應用',
			'meta.hideAppIcon' => '隱藏應用程式圖示',
			'meta.openDir' => '開啟檔案目錄',
			'meta.type' => '類型',
			'meta.fileChoose' => '選擇檔案',
			'meta.filePathCannotEmpty' => '檔案路徑不能為空',
			'meta.fileNotExist' => ({required Object p}) => '檔案不存在:${p}',
			'meta.fileTypeInvalid' => ({required Object p}) => '無效的檔案類型:${p}',
			'meta.uwpExemption' => 'UWP網路隔離豁免',
			'meta.getProfile' => '取得訂閱',
			'meta.buyProfile' => '購買訂閱',
			'meta.addProfile' => '新增訂閱',
			'meta.myProfiles' => '訂閱設定',
			'meta.profileEdit' => '編輯訂閱設定',
			'meta.profileNeedActive' => '請先將本設定設為目前設定，並開啟連線/重新連線',
			'meta.profileDownloadBackupChannel' => '啟用備用下載通道',
			'meta.profileDownloadBackupChannelTips' => 'Wmimo 提供的代理下載通道（不儲存任何資訊）',
			'meta.profileEditReloadAfterProfileUpdate' => '設定更新後重新載入',
			'meta.profileRulesAppendApplePush' => '附加 Apple 推送通知規則',
			'meta.profileRulesAppendProxyTips' => '規則將自動設為原始設定中 [proxy-groups] 內第一個類型為 [url-test] 或 [select] 的代理',
			'meta.profileImport' => '匯入設定檔案',
			'meta.profileAddUrlOrContent' => '新增訂閱連結',
			'meta.profileUrlOrContent' => '訂閱連結 / 節點內容',
			'meta.profileUrlOrContentHit' => '訂閱連結或設定內容 [必填]',
			'meta.profileUrlOrContentCannotEmpty' => '訂閱連結或內容不能為空',
			'meta.overview' => '概覽',
			'meta.trafficStats' => '流量統計',
			'meta.realtimeMonitor' => '即時監控',
			'meta.realtimeUpload' => '即時上傳',
			'meta.realtimeDownload' => '即時下載',
			'meta.sessionUpload' => '本次上傳',
			'meta.sessionDownload' => '本次下載',
			'meta.planUsage' => '套餐用量',
			'meta.memoryUsage' => '記憶體佔用',
			'meta.remaining' => '剩餘',
			'meta.expireTime' => '到期時間',
			'meta.tunMode' => 'TUN 模式',
			'meta.daysAgo' => ({required Object p}) => '${p}天前',
			'meta.hoursAgo' => ({required Object p}) => '${p}小時前',
			'meta.lessThanOneHourAgo' => '< 1小時前',
			'meta.inUse' => '使用中',
			'meta.remoteSubscription' => '遠端訂閱',
			'meta.noTrafficData' => '未提供用量統計',
			'meta.localProfile' => '本機檔案',
			'meta.viewYamlConfig' => '檢視 YAML 設定',
			'meta.editYamlConfig' => '編輯 YAML 設定',
			'meta.copySubscriptionUrl' => '複製訂閱連結',
			'meta.qrCode' => 'QR Code',
			'meta.deleteProfile' => '刪除設定',
			'meta.noProfilesYet' => '暫無訂閱設定',
			'meta.addProfilePrompt' => '點擊右上角 + 新增訂閱連結或匯入本機檔案',
			'meta.subscriptionUrlCopied' => '訂閱連結已複製到剪貼簿',
			'meta.autoGroupTip' => ({required Object group, required Object type}) => '「${group}」屬於 ${type} 自動策略組，由系統按延遲/可用性自動優選節點。如需自選節點，請在「節點選擇」等手動策略組中切換。',
			'meta.switchNodeFailed' => ({required Object p}) => '切換節點失敗: ${p}',
			'meta.nodeSelected' => ({required Object p}) => '已選擇節點: ${p}',
			'meta.startingCoreAndTesting' => '正在啟動代理核心並測速...',
			'meta.chartMinutes' => ({required Object p}) => '${p} 分鐘',
			'meta.chartUpload' => '上傳',
			'meta.chartDownload' => '下載',
			'meta.author' => '作者',
			'meta.githubRepo' => '開原始碼倉庫',
			'meta.openSourceLicense' => '開源許可證',
			'meta.submitFeedback' => '提交反饋與建議',
			'meta.copiedToClipboard' => '已複製到剪貼簿',
			'meta.autoScrollEnabled' => '已開啟自動捲動',
			'meta.autoScrollDisabled' => '已關閉自動捲動',
			'meta.pauseLogs' => '暫停即時日誌',
			'meta.resumeLogs' => '恢復即時日誌',
			'meta.scrollToLatest' => '滾至最新',
			'meta.scrollToBottom' => '滾至底部',
			'meta.newLogsCount' => ({required Object p}) => '(${p} 條新日誌)',
			'meta.copiedLogContent' => '已複製日誌內容',
			'meta.copyLog' => '複製日誌',
			'meta.noLogsPrompt' => '暫無日誌，啟動代理後將即時捕獲核心日誌',
			'meta.searchLogsHint' => ' (IP, 網域名稱, 規則, 錯誤...)',
			_ => null,
		} ?? switch (path) {
			'meta.offlinePreviewPrompt' => '離線設定預覽中，開啟代理後可進行分流與節點測速',
			'meta.manualSelect' => '手動選擇',
			'meta.autoSelect' => '自動選擇',
			'meta.speedTestGroup' => '策略群組測速',
			'meta.pause' => '暫停',
			'meta.resume' => '恢復',
			'meta.ipInfo' => 'IP 資訊',
			'meta.ipFetching' => '正在取得 IP 資訊...',
			'meta.ipCopied' => 'IP 位址已複製到剪貼簿',
			'meta.ipLocation' => '位置',
			'meta.ipIsp' => '服務商',
			'meta.ipTapToFetch' => '點擊取得 IP 資訊',
			'meta.ipProxy' => '代理出口',
			'meta.ipDirect' => '本機直連',
			'meta.ipAsn' => '自治系統',
			'meta.ipOrg' => '歸屬組織',
			'meta.ipTimezone' => '時區',
			'meta.ipCoordinates' => '座標',
			'meta.ipMoreDetails' => '更多詳細資訊',
			'meta.ipLessDetails' => '收起詳細資訊',
			'meta.collapseAll' => '收合所有代理群組',
			'meta.expandAll' => '展開所有代理群組',
			'meta.donateTitle' => '💖 請作者喝杯咖啡',
			'meta.donateThankYou' => 'ฅ^•ﻌ•^ฅ 你的每一份投餵，都是 Wmimo 不斷打磨與更新的最大動力呀 ~ ☕✨',
			'meta.tokenCurrency' => '幣種',
			'meta.networkChain' => '網路',
			'meta.depositAddress' => 'APTOS 收款位址',
			'meta.clickToCopy' => '點擊複製',
			'meta.copyAddressBtn' => '複製位址 ✨',
			'meta.donateAddressCopied' => '( ੭ ˙ᗜ˙ )੭ 位址已複製！非常感謝你的投餵與陪伴~ 💖',
			'meta.donateTip' => '💡 提示：支援 Bybit 或任意 Aptos 相容錢包掃碼轉帳',
			'meta.qrcodeParsing' => '正在解析...',
			'meta.qrcodeNotFound' => '未偵測到 QR Code',
			'meta.qrcodeSupportHint' => '支援解析各類訂閱、節點及設定 QR Code 圖片',
			'meta.qrcodeCameraHint' => '將 QR Code 放入框內即可自動掃描',
			'meta.flashlight' => '手電筒',
			'meta.screenshotDesc' => '擷取螢幕',
			'meta.fromImageDesc' => '本機圖片',
			'meta.fromClipboardDesc' => '讀取連結',
			'meta.errorPrompt' => '錯誤提示',
			'meta.copied' => '已複製',
			'meta.sortAndFilterNodes' => '節點排序與篩選',
			'meta.sortOptions' => '排序方式',
			'meta.sortDefault' => '預設排序',
			'meta.sortLatency' => '延遲排序',
			'meta.sortName' => '按名稱 A-Z',
			'meta.sortRegion' => '按地區分組',
			'meta.filterOptions' => '篩選選項',
			'meta.portableUpdateTip' => ({required Object version}) => '偵測到目前為免安裝便攜模式：\n便攜版本暫不支援應用程式內覆寫更新，請前往官網或儲存庫下載最新免安裝壓縮檔覆蓋解壓縮。\n\n最新版本: v${version}',
			'meta.portableModeTipTitle' => '便攜模式提示',
			'meta.noNodesToSpeedTest' => '無可用節點，無需測速',
			'meta.alreadyLatestVersion' => ({required Object version}) => '已是最新版本 (v${version})',
			'meta.checkUpdateFailed' => '檢查更新失敗，請檢查網路連線',
			'meta.hideTimeoutNodes' => '隱藏逾時與不可用節點',
			'meta.hideTimeoutNodesDesc' => '自動過濾測速失敗或連線逾時的節點',
			'meta.speedtestScenario' => '目前測速目標場景',
			'meta.speedtestScenarioSwitch' => '測速目標場景切換',
			'meta.speedtestScenarioDesc' => '選擇不同服務測試節點的真實可用性與連線延遲',
			'meta.speedtestAllNodes' => '全量極速測速',
			'meta.retestTimeoutNodes' => '僅重測逾時節點',
			'meta.switchedTargetScenario' => ({required Object target}) => '已切換測速目標場景: ${target}',
			'meta.notTested' => '未測速',
			'meta.timeoutOrFailed' => '逾時 / 無法連線',
			'meta.identifiedRegion' => '識別地區',
			'meta.nodeProtocol' => '節點協定',
			'meta.currentLatency' => '目前延遲',
			'meta.testScenario' => '測速場景',
			'meta.belongsToGroup' => '所屬分組',
			'meta.copyNodeName' => '複製名稱',
			'meta.nodeNameCopied' => '已複製節點名稱',
			'meta.testSingleNode' => '單獨測速',
			'meta.selectThisNode' => '選擇此節點',
			'meta.allNodesNormal' => '所有節點均正常可用，無需重測',
			'meta.customUrlPrompt' => '自訂 URL (如 http://...)',
			'meta.customTarget' => '自訂目標',
			'meta.downloadFailedTip' => '下載更新安裝檔失敗，請檢查網路或點擊下方前往網頁下載。',
			'meta.discoveredNewVersion' => ({required Object version}) => '發現新版本: v${version}',
			'meta.preparingUpdate' => '正在準備啟動更新...',
			'meta.downloadingPackage' => '安裝檔正在下載中，請稍候...',
			'meta.downloadUpdateNow' => '立即下載更新',
			'meta.downloadFromWeb' => '前往網頁下載安裝檔',
			'meta.switchSource' => '切換源',
			'meta.serverSwitch' => '測速伺服器切換',
			'meta.autoDetectBest' => '自動探測最優',
			'meta.serverSwitchDesc' => '選擇不同的測速 CDN 源或自訂節點進行多鏈路測速',
			'meta.autoSelectedBest' => ({required Object server, required Object ping}) => '已自動選擇最優測速源: ${server} (${ping} ms)',
			'meta.networkGradeTitle' => '網路體質綜合評分',
			'meta.copyReport' => '複製測速報告',
			'meta.reportCopied' => '測速報告已複製到剪貼簿，可直接貼上分享',
			'meta.gamingExperience' => '電競體驗',
			'meta.streamingExperience' => '超清串流媒體',
			'meta.meetingExperience' => '遠端視訊',
			'meta.customSpeedtestUrl' => '自訂測速下載 URL (https://...)',
			'meta.customSpeedtestSource' => '自訂測速源',
			'meta.userSpecifiedUrl' => '使用者指定 URL',
			'meta.cannotBeEmpty' => ({required Object item}) => '${item}不能為空',
			'meta.alreadyExists' => ({required Object item}) => '${item}已存在',
			'meta.installFailedWithCode' => ({required Object installer, required Object code}) => '安裝 ${installer} 失敗，錯誤碼: ${code}',
			'meta.resetSystemProxy' => '修復網路 / 重設系統代理',
			'meta.resetSystemProxyDesc' => '清理殘留系統代理設定並重新整理網路，解決異常結束後無法上網問題',
			'meta.resetSystemProxySuccess' => '系統代理已清理並重設，網路已恢復正常',
			'meta.networkDiagnostics' => '網路鏈路體檢與智慧診斷',
			'meta.networkDiagnosticsDesc' => '一鍵逐步診斷網卡、DNS、核心連接埠與代理健康狀態並智慧自愈',
			'meta.sortLatencyDesc' => '延遲由高到低',
			'meta.sortNameDesc' => '名稱 Z-A',
			'meta.sortMultiplier' => '倍率由低到高',
			'meta.uwpLoopback' => 'UWP 迴環代理豁免工具',
			'meta.uwpLoopbackDesc' => '一鍵豁免應用程式市集、Xbox、Minecraft 等 UWP 應用程式走本機代理',
			'meta.uwpExemptAllCommon' => '一鍵豁免常用應用',
			'meta.uwpApplySuccess' => 'UWP 迴環代理豁免規則已生效',
			'meta.common' => '常用',
			'meta.exempted' => '已豁免',
			'meta.notExempted' => '未豁免',
			'meta.deselectAll' => '全不選',
			'meta.userApps' => '使用者應用',
			'meta.systemApps' => '系統應用',
			'meta.selectedOnly' => '已選取',
			'meta.proxySelectedMode' => '僅代理選取的應用',
			'meta.proxySelectedModeDesc' => '已選應用走代理，其餘應用直連',
			'meta.bypassSelectedMode' => '繞過選取的應用',
			'meta.bypassSelectedModeDesc' => '已選應用直連，其餘應用走代理',
			'meta.invertSelection' => '反選',
			'meta.all' => '全部',
			'meta.showAppIcon' => '顯示應用程式圖示',
			'meta.proxySelection' => '節點選擇',
			'meta.regionHk' => '🇭🇰 香港節點',
			'meta.regionJp' => '🇯🇵 日本節點',
			'meta.regionSg' => '🇸🇬 新加坡節點',
			'meta.regionTw' => '🇹🇼 台灣節點',
			'meta.regionUs' => '🇺🇸 美國節點',
			'meta.regionKr' => '🇰🇷 韓國節點',
			'meta.macMoveToApplications' => '請先將 Wmimo 拖入【應用程式】(Applications) 資料夾後再開啟執行',
			'meta.notifCurrentNode' => '目前節點',
			'meta.notifMode' => '運行模式',
			'meta.notifPort' => '埠號',
			'meta.notifProfile' => '配置訂閱',
			'meta.notifDisconnect' => '中斷連線',
			'meta.notifSwitchNode' => '切換節點',
			'meta.notifVpnConnected' => 'VPN 代理已連線',
			'meta.connectionDetails' => '連線詳情',
			'meta.sourceAddress' => '來源位址',
			'meta.destinationAddress' => '目標位址',
			'meta.host' => '網域名稱',
			'meta.process' => '關聯處理程序',
			'meta.processPath' => '處理程序完整路徑',
			'meta.proxyChain' => '代理鏈路',
			'meta.networkProtocol' => '傳輸協定',
			'meta.trafficUpload' => '上傳流量',
			'meta.trafficDownload' => '下載流量',
			'meta.connectionDuration' => '持續時間',
			'meta.connectionStart' => '發起時間',
			'meta.copyHost' => '複製網域名稱',
			'meta.copyAllDetails' => '複製全部資訊',
			'meta.closeThisConnection' => '中斷此連線',
			'meta.sortByDownload' => '依下載流量',
			'meta.sortByUpload' => '依上傳流量',
			'meta.sortBySpeed' => '依即時速率',
			'meta.sortByDuration' => '依連線時長',
			'meta.sortByHost' => '依目標網域',
			'meta.realtimeSpeed' => '即時速率',
			'meta.totalUpload' => '上傳總量',
			'meta.totalDownload' => '下載總量',
			'meta.activeConnections' => '活躍連線',
			'meta.openInFolder' => '在資料夾中顯示',
			'meta.openProfilesDir' => '開啟設定目錄',
			'meta.profilePatches' => '設定覆寫',
			'meta.nodeCount' => ({required Object p}) => '${p} 個節點',
			'meta.copyFilePath' => '複製檔案路徑',
			'meta.duplicateProfile' => '建立複本',
			'meta.useThisProfile' => '使用此設定',
			'meta.websiteTest' => '網站測試',
			'meta.testAll' => '測試全部',
			'meta.addTestWebsite' => '新增測試網站',
			'meta.websiteName' => '網站名稱',
			'meta.websiteUrl' => '測試 URL',
			'meta.websiteNameHint' => '網站名稱 (如: Cloudflare)',
			'meta.websiteInputEmpty' => '請輸入網站名稱與 URL',
			'meta.autoRefresh' => '自動重新整理',
			'meta.currentProfile' => '目前設定',
			'meta.quickActions' => '捷徑工具',
			'meta.fastest' => '最低延遲',
			'meta.hideTimeout' => '隱藏超時',
			'meta.filteredTimeout' => '已過濾超時',
			'meta.tunDeviceCreateFailed' => 'TUN 虛擬網卡建立失敗',
			'meta.test' => '測試',
			'meta.addWebsite' => '新增網站',
			'meta.maxWebsitesReached' => '最多支援新增 6 個測試網站',
			'meta.sideBySideLayout' => '並列排版',
			'meta.sideBySideLayoutTips' => '開啟後首頁卡片與訂閱列表在寬螢幕下採用並列排版，關閉則保持單列垂直排版',
			'meta.homeCardsManage' => '首頁卡片管理',
			'meta.homeCardsManageTips' => '自訂首頁顯示的卡片模組與顯隱狀態',
			'meta.cardTrafficChart' => '流量統計圖表',
			'meta.cardWebsiteTest' => '網站連通測試',
			'meta.cardIpInfo' => 'IP 與出口資訊',
			'meta.cardSubscription' => '方案與到期資訊',
			'meta.cardQuickActions' => '快捷工具入口',
			'meta.resetDefaultCards' => '恢復預設卡片',
			'permission.camera' => '相機',
			'permission.screen' => '螢幕錄製',
			'permission.appQuery' => '取得應用程式列表',
			'permission.request' => ({required Object p}) => '開啟[${p}]權限',
			'permission.requestNeed' => ({required Object p}) => '請開啟[${p}]權限',
			'tls.insecure' => '略過憑證驗證',
			'tls.certificate' => '憑證',
			'tls.privateKey' => '私鑰',
			'tls.customTrustCert' => '自訂信任憑證',
			'tun.stack' => '網路堆疊',
			'tun.stackGvisor' => 'gVisor',
			'tun.stackGvisorDesc' => '使用者空間網路棧，穩定性與相容性極佳',
			'tun.stackSystem' => 'System',
			'tun.stackSystemDesc' => '使用系統原生網路棧，效能高但依賴系統實現',
			'tun.stackMixed' => 'Mixed',
			'tun.stackMixedDesc' => '混合網路棧模式，兼顧效能與相容性',
			'tun.stackMips' => 'MIPS (Mihomo IP Stack)',
			'tun.stackMipsDesc' => 'Mihomo 自研高效能 IP 網路棧，高輸送量低延遲',
			'tun.inet4Address' => 'IPv4位址段',
			'tun.inet6Address' => 'IPv6位址段',
			'tun.dnsHijack' => 'DNS劫持',
			'tun.strictRoute' => '嚴格路由',
			'tun.tunDefaultRoute' => '預設路由',
			'tun.icmpForward' => 'ICMP 轉發',
			'tun.allowBypass' => '允許應用程式略過 VPN',
			'tun.appendHttpProxy' => '附加HTTP代理到VPN',
			'tun.bypassHttpProxyDomain' => '允許略過 HTTP 代理的網域名稱',
			'dns.listen' => '監聽地址',
			'dns.fakeIp' => 'fake-ip',
			'dns.fallback' => 'Fallback',
			'dns.preferH3' => 'DoH H3優先',
			'dns.useHosts' => '使用Hosts',
			'dns.useSystemHosts' => '使用系統Hosts',
			'dns.enhancedMode' => '增強模式',
			'dns.fakeIPFilterMode' => '${_root.dns.fakeIp} 過濾模式',
			'dns.fakeIPFilter' => '${_root.dns.fakeIp} 過濾',
			'dns.respectRules' => '遵守[rules]規則',
			'dns.nameServer' => '域名解析伺服器',
			'dns.defaultNameServer' => '${_root.meta.byDefault} ${_root.dns.nameServer}',
			'dns.proxyNameServer' => '${_root.meta.proxy} ${_root.dns.nameServer}',
			'dns.directNameServer' => '${_root.meta.direct} ${_root.dns.nameServer}',
			'dns.fallbackNameServer' => '${_root.dns.fallback} ${_root.dns.nameServer}',
			'dns.fallbackGeoIp' => '${_root.dns.fallback} GeoIp',
			'dns.fallbackGeoIpCode' => '${_root.dns.fallback} GeoIp 代碼',
			'dns.flushCache' => '清空 DNS 快取',
			'dns.flushCacheSuccess' => 'DNS 與 Fake-IP 快取已成功清空',
			'dns.presets' => '快速預設方案',
			'dns.presetSpeed' => '國內極速雙棧',
			'dns.presetSpeedDesc' => '阿里 DoH3 + 騰訊 DoH，國內直連秒開，國外智慧分流',
			'dns.presetSecure' => '安全防污染模式',
			'dns.presetSecureDesc' => 'Cloudflare DoH3 + Google DoH，杜絕劫持與審查',
			'dns.presetAdGuard' => '廣告攔截與純淨模式',
			'dns.presetAdGuardDesc' => 'AdGuard DoQ + 阿里 DoH，深度淨化網路請求與隱私追蹤',
			'dns.overwriteDesc' => '覆蓋訂閱設定檔中的 DNS 設定',
			'dns.enableDesc' => '啟用自訂 DNS 解析器',
			'dns.resetFakeIpFilter' => '恢復推薦過濾',
			'dns.resetFakeIpFilterConfirm' => '確定恢復預設的 Fake-IP 過濾白名單列表嗎？',
			'dns.dnsTester' => 'DNS 即時解析診斷',
			'dns.testQuery' => '測試解析',
			'dns.fakeIpDetected' => '命中 Fake-IP',
			'dns.realIpDetected' => '真實公網 IP',
			'dns.addServer' => '新增 DNS 伺服器',
			'dns.geoAssetsTitle' => 'GEO 離線資料庫',
			'dns.geoAssetsDesc' => '管理 GeoSite 網域分流庫、GeoIP 與 ASN 地理資訊庫',
			'dns.cdnSource' => '下載加速鏡像源',
			'dns.updateAll' => '全部更新',
			'dns.updateSuccess' => '更新成功',
			'dns.updateFailed' => '更新失敗',
			'dns.addPresetServer' => '新增預設 DNS',
			'dns.manageFakeIpFilter' => ({required Object p}) => '管理過濾清單 (${p})',
			'dns.fakeIpFilterDesc' => ({required Object p}) => '${p} 條網域規則繞過 Fake-IP 解析，以避免網路隔離問題。',
			'sniffer.overrideDest' => '覆蓋',
			'profilePatchMode.currentSelected' => '當前選擇',
			'profilePatchMode.overwrite' => '內置-覆寫',
			'profilePatchMode.noOverwrite' => '內置-不覆寫',
			'protocolSniff' => '協議探測',
			'protocolSniffOverrideDestination' => '探測的域名覆蓋連接目標地址',
			'edgeRuntimeNotInstalled' => '目前裝置尚未安裝 Edge WebView2 執行階段，無法顯示頁面，請下載安裝 Edge WebView2 執行階段 (x64) 後，重新啟動 App 再試',
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
