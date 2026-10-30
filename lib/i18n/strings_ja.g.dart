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
class TranslationsJa with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$WelcomeLanguageScreen$ja WelcomeLanguageScreen = _Translations$WelcomeLanguageScreen$ja._(_root);
	@override late final _Translations$BackupAndSyncWebdavScreen$ja BackupAndSyncWebdavScreen = _Translations$BackupAndSyncWebdavScreen$ja._(_root);
	@override late final _Translations$LaunchFailedScreen$ja LaunchFailedScreen = _Translations$LaunchFailedScreen$ja._(_root);
	@override late final _Translations$PerAppAndroidScreen$ja PerAppAndroidScreen = _Translations$PerAppAndroidScreen$ja._(_root);
	@override late final _Translations$UserAgreementScreen$ja UserAgreementScreen = _Translations$UserAgreementScreen$ja._(_root);
	@override late final _Translations$NetCheckScreen$ja NetCheckScreen = _Translations$NetCheckScreen$ja._(_root);
	@override late final _Translations$SpeedTestScreen$ja SpeedTestScreen = _Translations$SpeedTestScreen$ja._(_root);
	@override late final _Translations$VersionUpdateScreen$ja VersionUpdateScreen = _Translations$VersionUpdateScreen$ja._(_root);
	@override late final _Translations$loginScreen$ja loginScreen = _Translations$loginScreen$ja._(_root);
	@override late final _Translations$main$ja main = _Translations$main$ja._(_root);
	@override late final _Translations$meta$ja meta = _Translations$meta$ja._(_root);
	@override late final _Translations$permission$ja permission = _Translations$permission$ja._(_root);
	@override late final _Translations$tls$ja tls = _Translations$tls$ja._(_root);
	@override late final _Translations$tun$ja tun = _Translations$tun$ja._(_root);
	@override late final _Translations$dns$ja dns = _Translations$dns$ja._(_root);
	@override late final _Translations$sniffer$ja sniffer = _Translations$sniffer$ja._(_root);
	@override late final _Translations$profilePatchMode$ja profilePatchMode = _Translations$profilePatchMode$ja._(_root);
	@override String get protocolSniff => 'プロトコル検知';
	@override String get protocolSniffOverrideDestination => '検知されたドメイン名で接続先アドレスを上書きする';
	@override String get edgeRuntimeNotInstalled => '現在のデバイスには Edge WebView2 ランタイムがインストールされていないため、ページを表示できません。Edge WebView2 ランタイム (x64) をダウンロードしてインストールし、アプリを再起動してからもう一度お試しください。';
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
class _Translations$WelcomeLanguageScreen$ja implements Translations$WelcomeLanguageScreen$en {
	_Translations$WelcomeLanguageScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => 'Wmimo へようこそ';
	@override String get selectLanguage => '言語を選択';
	@override String get subtitle => 'ご希望の言語を選択してください。設定からいつでも変更できます。';
	@override String get start => '始める';
}

// Path: BackupAndSyncWebdavScreen
class _Translations$BackupAndSyncWebdavScreen$ja implements Translations$BackupAndSyncWebdavScreen$en {
	_Translations$BackupAndSyncWebdavScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get webdavServerUrl => 'サーバーURL';
	@override String get webdavRequired => '空にすることはできません';
	@override String get webdavLoginFailed => 'ログインに失敗しました:';
	@override String get webdavListFailed => 'ファイルリストの取得に失敗しました:';
}

// Path: LaunchFailedScreen
class _Translations$LaunchFailedScreen$ja implements Translations$LaunchFailedScreen$en {
	_Translations$LaunchFailedScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get invalidProcess => 'アプリの起動に失敗しました [無効なプロセス名]。アプリを別のディレクトリに再インストールしてください';
	@override String get invalidProfile => 'アプリの起動に失敗しました [プロファイルへのアクセスに失敗]。アプリを再インストールしてください';
	@override String get invalidVersion => 'アプリの起動に失敗しました [無効なバージョン]。アプリを再インストールしてください';
	@override String get systemVersionLow => 'アプリの起動に失敗しました [システムバージョンが低すぎます]';
	@override String get invalidInstallPath => 'インストールパスが無効です。有効なパスに再インストールしてください';
}

// Path: PerAppAndroidScreen
class _Translations$PerAppAndroidScreen$ja implements Translations$PerAppAndroidScreen$en {
	_Translations$PerAppAndroidScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アプリごとのプロキシ';
	@override String get whiteListMode => 'ホワイトリストモード';
	@override String get whiteListModeTip => '有効な場合：チェックされたアプリのみがプロキシされます。無効な場合：チェックされていないアプリのみがプロキシされます';
	@override String get manualAddPackage => 'パッケージ名を手動で追加';
	@override String get manualAddPackageHint => 'プロキシするパッケージ名を入力してください (空白、カンマ、改行で複数指定可能、例: org.telegram.messenger, com.google.android.youtube):';
	@override String get quickAddPresets => 'よく使うプロキシアプリをクイック追加';
	@override String get saveSelected => '選択項目を保存';
	@override String get permissionRestrictedTip => 'システムによりアプリ一覧の読み取りが制限されています。下の【システム権限設定を開く】をタップしてアプリ一覧取得権限を許可するか、権限不要のプリセットをご利用ください。';
	@override String get openSystemPermission => 'システム権限設定を開く';
	@override String get presetApps => 'よく使うアプリを追加 (権限不要プリセット)';
	@override String get requestPermissionPopup => '権限をリクエスト (システムダイアログ)';
}

// Path: UserAgreementScreen
class _Translations$UserAgreementScreen$ja implements Translations$UserAgreementScreen$en {
	_Translations$UserAgreementScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get privacyFirst => 'プライバシーを第一に';
	@override String get agreeAndContinue => '同意して続行';
}

// Path: NetCheckScreen
class _Translations$NetCheckScreen$ja implements Translations$NetCheckScreen$en {
	_Translations$NetCheckScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ネットワーク診断と修復';
	@override String get fullDiagnosticsTab => 'パイプライン診断';
	@override String get advancedCheckTab => 'ドメイン詳細クエリ';
	@override String get startDiagnostics => '診断を開始';
	@override String get reDiagnostics => '再診断';
	@override String get diagnosing => 'ネットワーク経路を診断中...';
	@override String get healthScore => '健全性スコア';
	@override String get scorePerfect => '非常に良好';
	@override String get scoreGood => '良好';
	@override String get scoreWarning => '警告あり';
	@override String get scoreCritical => '接続障害';
	@override String get oneClickRepair => 'ワンクリック自動修復';
	@override String get repairSuccess => '修復が完了し、ネットワークが復旧しました';
	@override String get repairFailed => '修復を実行しました。一部項目を手動で確認してください';
	@override String get repairing => '自動修復を実行中...';
	@override String issueFound({required Object count}) => '${count} 件の異常を検出';
	@override String get noIssue => 'すべての項目が正常です';
	@override String get details => '詳細ログ';
	@override String get copyDetails => 'ログをコピー';
	@override String get detailsCopied => '診断ログをクリップボードにコピーしました';
	@override String get stepPhysical => '物理NICとゲートウェイ';
	@override String get stepDns => 'DNS解決とFake-IP';
	@override String get stepCore => 'コアプロセスとポート';
	@override String get stepProxy => 'システムプロキシ設定';
	@override String get stepHandshake => 'インターネットハンドシェイク';
	@override String get suggestedAction => 'トラブルシューティング';
	@override String get autoRepairAction => '今すぐ修復';
	@override String get enterDomain => 'ドメインを入力してください';
	@override String get checking => '診断中...';
	@override String aQueryFailed({required Object p}) => 'A クエリ失敗: ${p}';
	@override String aaaaQueryFailed({required Object p}) => 'AAAA クエリ失敗: ${p}';
	@override String get success => '成功';
	@override String get failed => '失敗';
	@override String get suspectedPollution => 'DNS汚染の疑い';
	@override String get domainLabel => 'ドメイン';
	@override String get checkButton => '診断';
	@override String get dnsSection => '1. DNSクエリ';
	@override String get directHttpSection => '2. HTTP (TUN経由,先にTUNを有効化)';
	@override String proxyHttpSection({required Object p}) => '3. HTTP (プロキシ経由,ポート:${p})';
	@override String get tunNotEnabled => 'TUN が無効です';
	@override String get routeTableSection => '4. ルーティングテーブル';
	@override String get stepPhysicalDesc => '物理ネットワークカード、ローカルIP、ゲートウェイの接続性を検出';
	@override String get stepDnsDesc => 'ローカルDNS解決の遅延とコアDNS応答ステータスを検証';
	@override String get stepCoreDesc => 'Mihomoプロセスの稼働状態とMixed-Port/APIポートのリッスンを検出';
	@override String get stepProxyDesc => 'システムプロキシ設定の一貫性を検証し残留プロキシをチェック';
	@override String get stepHandshakeDesc => 'アクティブなノードを経由してグローバルCDNへの実効遅延と到達性を測定';
	@override String get shortStepPhysical => 'NIC';
	@override String get shortStepDns => 'DNS';
	@override String get shortStepCore => 'コア';
	@override String get shortStepProxy => 'プロキシ';
	@override String get shortStepHandshake => 'WAN';
	@override String valNicNormal({required Object p}) => 'ネットワーク接続正常 (${p})';
	@override String get valNicNone => '利用可能なネットワークインターフェースが見つかりません';
	@override String get valNicGatewayTimeout => 'ローカルIPは取得されましたが、外部ゲートウェイがタイムアウトしました';
	@override String get valNicError => 'ネットワークインターフェース検査エラー';
	@override String valDnsNormal({required Object p}) => 'DNS応答正常 (${p})';
	@override String get valDnsEmpty => 'DNSクエリが空のリストを返しました';
	@override String get valDnsTimeout => 'DNSクエリがタイムアウトまたは失敗しました';
	@override String valCoreNormal({required Object port, required Object mode}) => 'コア正常稼働中 (Mixed Port: ${port}, モード: ${mode})';
	@override String get valCoreNotRunning => 'コアサービスが停止しています';
	@override String valCorePortConflict({required Object p}) => 'ポート ${p} は外部プログラムによって占有されています';
	@override String get valCoreApiFailed => 'コアプロセスが無応答 (API通信失敗)';
	@override String get valCoreError => 'コア検査エラー';
	@override String valProxyActive({required Object port}) => 'システムプロキシ有効 (127.0.0.1:${port})';
	@override String get valProxyDisabled => 'システムプロキシ無効 (直連/TUN/手動モード)';
	@override String get valProxyZombie => '残留システムプロキシを検出 (ネット不通の原因)';
	@override String get valProxyFailed => 'システムプロキシの有効化に失敗しました';
	@override String get valProxyWarning => 'システムプロキシ状態の読み取り警告';
	@override String valHandshakeNormal({required Object node, required Object delay}) => '公衆回線ハンドシェイク良好 (${node} • ${delay} ms)';
	@override String valHandshakeFailed({required Object node, required Object err}) => '現在のノード [${node}] ハンドシェイク失敗 (${err})';
	@override String get valHandshakeSkipped => 'コア未起動のため、公衆回線テストをスキップ';
	@override String get valHandshakeError => '公衆回線ハンドシェイク異常';
	@override String get issueNicDisconnected => 'ネットワークカードが未接続です (LANケーブル未接続、Wi-Fi切断、機内モード)';
	@override String get suggestNicCheck => 'LANケーブル、Wi-Fi接続、またはネットワークアダプターの状態を確認してください';
	@override String get suggestNicReset => 'システム設定でネットワークアダプターを無効化してから再度有効にしてみてください';
	@override String get issueNicGatewayUnreachable => 'LANには接続されていますが、外部ルーターにアクセスできません (認証ポータルまたはルーター切断)';
	@override String get suggestNicGateway => 'ルーターのインジケーターを確認するか、ブラウザを開いてWeb認証が必要か確認してください';
	@override String get issueDnsPollution => 'ローカルDNSサービスが無応答です。DNS汚染またはハイジャックの可能性があります';
	@override String get suggestDnsReset => 'システムDNSをリセットするか、Wmimoで暗号化DNS (DoH/DoT) を有効にしてください';
	@override String get actionFlushDns => 'システムDNSキャッシュをフラッシュ';
	@override String get suggestDnsSlow => 'DNS解決の遅延が大きいため、暗号化DNSの有効化をおすすめします';
	@override String get issueDnsFailed => 'ローカルDNS解決に失敗しました。ドメインをIPアドレスに変換できません';
	@override String get suggestDnsFlush => 'DNSキャッシュをフラッシュするか、Wmimo設定で暗号化DNSを有効にしてください';
	@override String get issueCorePortConflict => 'ポート競合が検出されました！他のプロキシソフトまたはサービスが占有しています';
	@override String get suggestCoreChangePort => '他のプロキシソフトを終了するか、Wmimo設定でポート番号を変更してください';
	@override String get actionRestartCore => 'コアを再起動';
	@override String get issueCoreStopped => 'Wmimoコアプロセスが停止しています';
	@override String get suggestCoreStart => 'ホーム画面の接続スイッチを入れるか、下の【コア起動】をクリックしてください';
	@override String get actionStartCore => 'コアプロセスを起動';
	@override String get issueCoreFrozen => 'コアプロセスが応答しないか、API認証が一致しません';
	@override String get suggestCoreRestart => '【コア再起動】をクリックしてサービスを復旧してください';
	@override String get suggestCoreReinstall => 'コアの再起動またはドライバの再インストールをお試しください';
	@override String get issueProxyZombie => '停止したポートに残留プロキシが転送しており、通信が遮断されています';
	@override String get suggestProxyReset => '下の【システムプロキシのクリーンとリセット】をクリックして復旧してください';
	@override String get actionResetProxy => 'プロキシをクリーン＆リセット';
	@override String get issueProxyBlocked => 'システムプロキシが反映されません。セキュリティソフトや権限を確認してください';
	@override String get suggestProxyReapply => '下のボタンをクリックしてシステムプロキシの強制適用をお試しください';
	@override String get actionReapplyProxy => 'システムプロキシを再適用';
	@override String get issueProxyRead => 'システムプロキシ設定の読み取り中に非致命的なエラーが発生しました';
	@override String get issueHandshakeBlocked => '選択中のプロキシノードがインターネットに接続できません。通信が遮断されています';
	@override String get suggestHandshakeSwitch => 'ノードがメンテナンス中または到達不能です。別のノードに切り替えてください';
	@override String suggestHandshakeSlow({required Object delay}) => 'ノード遅延が高めです (${delay} ms)。速度測定を行い近いノードを選択してください';
	@override String get suggestHandshakeCheck => 'ノード設定を確認するか、測定先を変更してください';
	@override String get conclusionPerfect => '全ルート良好！すべてのネットワークノードとプロキシ設定が正常です。';
	@override String get conclusionGood => '全ルート概ね正常です。軽微な遅延や警告が検出されました。詳細をご確認ください。';
	@override String get conclusionWarning => '一部のネットワークまたはプロキシに異常が検出されました。下の【一括修復】をお試しください。';
	@override String get conclusionCritical => '重大なネットワーク遮断！ローカル回線が切断されているか、コアが阻害されています。';
}

// Path: SpeedTestScreen
class _Translations$SpeedTestScreen$ja implements Translations$SpeedTestScreen$en {
	_Translations$SpeedTestScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'スピードテスト';
	@override String get startTest => 'テスト開始';
	@override String get stopTest => '停止';
	@override String get reTest => '再テスト';
	@override String get ready => '準備完了';
	@override String get testingPing => 'Ping & Jitter をテスト中...';
	@override String get testingDownload => 'ダウンロード速度をテスト中...';
	@override String get testingUpload => 'アップロード速度をテスト中...';
	@override String get completed => 'テスト完了';
	@override String get stopped => '停止しました';
	@override String get ping => 'Ping';
	@override String get jitter => 'Jitter';
	@override String get download => 'ダウンロード';
	@override String get upload => 'アップロード';
	@override String get currentProxy => '現在のプロキシ';
	@override String get directConnection => 'ダイレクト接続';
	@override String get server => '測定サーバー';
	@override String get serverLocation => 'サーバー位置';
	@override String get realtimeSpeed => 'リアルタイム速度グラフ';
	@override String get peakSpeed => 'ピーク速度';
	@override String get avgSpeed => '平均速度';
	@override String get testHistory => 'テスト履歴';
	@override String get clearHistory => '履歴をクリア';
}

// Path: VersionUpdateScreen
class _Translations$VersionUpdateScreen$ja implements Translations$VersionUpdateScreen$en {
	_Translations$VersionUpdateScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String versionReady({required Object p}) => '新しいバージョン [${p}] の準備ができました';
	@override String get update => '再起動して更新';
	@override String get cancel => '今はしない';
}

// Path: loginScreen
class _Translations$loginScreen$ja implements Translations$loginScreen$en {
	_Translations$loginScreen$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get login => 'ログイン';
	@override String get register => 'アカウント登録';
	@override String get forgotPassword => 'パスワードを忘れた';
	@override String get provider => 'プロバイダー';
	@override String get providerName => '${_root.loginScreen.provider}コード/別名/URL';
	@override String get providerNameRequired => '${_root.loginScreen.provider}コード/別名/URLを入力してください';
	@override String get account => 'アカウント';
	@override String get accountRequired => 'アカウントを入力してください';
	@override String get email => 'メール';
	@override String get emailRequired => 'メールアドレスを入力してください';
	@override String get password => 'パスワード';
	@override String get passwordRequired => 'パスワードを入力してください';
	@override String get validEmailRequired => '有効なメールアドレスを入力してください';
	@override String passwordMinLength({required Object minLength}) => 'パスワード長は最低${minLength}文字以上である必要があります';
	@override String get unsupportedProvider => 'サポートされていない${_root.loginScreen.provider}';
	@override String get unsupportedProviderType => 'サポートされていない${_root.loginScreen.provider}タイプ';
	@override String get unActivedProvider => 'ログイン機能は有効化されていません';
	@override String providerLoginSupportRequired({required Object p}) => 'プロバイダーのコード/別名は${_root.loginScreen.provider}にお問い合わせください。\n${_root.loginScreen.provider}連携は次をご参照ください: ${p}';
	@override String get providerDisclaimer => '免責事項:${_root.loginScreen.provider}はサードパーティサービスであり、本アプリとは無関係です';
	@override String get createSessionFailed => 'セッションの作成に失敗しました。プロバイダーまたはアカウントを確認してください';
}

// Path: main
class _Translations$main$ja implements Translations$main$en {
	_Translations$main$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$main$tray$ja tray = _Translations$main$tray$ja._(_root);
}

// Path: meta
class _Translations$meta$ja implements Translations$meta$en {
	_Translations$meta$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get enable => '有効';
	@override String get disable => '無効';
	@override String get open => '開く';
	@override String get close => '閉じる';
	@override String get quit => '終了';
	@override String get add => '追加';
	@override String get addSuccess => '正常に追加されました';
	@override String addFailed({required Object p}) => '追加に失敗しました: ${p}';
	@override String get remove => '削除';
	@override String get removeConfirm => '本当に削除しますか？';
	@override String get edit => '編集';
	@override String get view => '表示';
	@override String get remark => '備考';
	@override String get byDefault => 'デフォルト';
	@override String get editRemark => '備考を編集';
	@override String get more => '詳細';
	@override String get tips => '情報';
	@override String get selectAll => 'すべて選択';
	@override String get copy => 'コピー';
	@override String get paste => '貼り付け';
	@override String get cut => '切り取り';
	@override String get save => '保存';
	@override String get ok => 'OK';
	@override String get cancel => 'キャンセル';
	@override String get faq => 'よくある質問';
	@override String get doc => 'ドキュメント';
	@override String get htmlTools => 'HTMLツールセット';
	@override String get download => 'ダウンロード';
	@override String get loading => '読み込み中...';
	@override String get days => '日';
	@override String get hours => '時間';
	@override String get minutes => '分';
	@override String get seconds => '秒';
	@override String get milliseconds => 'ミリ秒';
	@override String get protocol => 'プロトコル';
	@override String get search => '検索';
	@override String get custom => 'カスタム';
	@override String get connect => '接続';
	@override String get disconnect => '切断';
	@override String get connected => '接続済み';
	@override String get disconnected => '切断済み';
	@override String get connecting => '接続中';
	@override String get connectTimeout => '接続タイムアウト';
	@override String get timeout => 'タイムアウト';
	@override String get timeoutDuration => 'タイムアウト時間';
	@override String get latency => 'レイテンシ';
	@override String get latencyTest => '遅延テスト';
	@override String get networkCheck => 'ネットワーク診断';
	@override String get speedTest => 'スピードテスト';
	@override String get language => '言語';
	@override String get next => '次へ';
	@override String get done => '完了';
	@override String get apply => '適用';
	@override String get refresh => '更新';
	@override String get retry => '再試行しますか？';
	@override String get update => '更新';
	@override String get updateInterval => '更新間隔';
	@override String updateFailed({required Object p}) => '更新に失敗しました: ${p}';
	@override String get updateInterval5mTips => '最小: 5分';
	@override String get updateIntervalPreferByProfile => 'プロバイダーの設定を優先';
	@override String get none => 'なし';
	@override String get reset => 'リセット';
	@override String get resetConfirm => 'すべてのアプリ設定をリセットしてもよろしいですか？';
	@override String get resetSuccess => 'アプリ設定が初期値にリセットされました';
	@override String get resetCoreConfirm => 'コア設定と上書き設定をリセットしてもよろしいですか？';
	@override String get resetCoreSuccess => 'コア設定が初期値にリセットされました';
	@override String get authentication => '認証';
	@override String get submit => '送信';
	@override String get user => 'ユーザー';
	@override String get account => 'アカウント';
	@override String get password => 'パスワード';
	@override String get decryptPassword => '複号化パスワード';
	@override String get required => '必須';
	@override String get go => '続行';
	@override String get sudoPassword => 'sudo パスワード (TUNモードで必要)';
	@override String get other => 'その他';
	@override String get dns => 'DNS';
	@override String get url => 'URL';
	@override String get urlInvalid => '無効なURL';
	@override String get urlCannotEmpty => 'リンクを空にすることはできません';
	@override String get urlTooLong => 'URLが長すぎます (>8182)';
	@override String get copyUrl => 'リンクをコピー';
	@override String get openUrl => 'リンクを開く';
	@override String get shareUrl => 'リンクを共有';
	@override String get coreSettingTips => '注意：設定を変更した後、有効にするには再接続する必要があります';
	@override String get overwrite => '上書き';
	@override String get overwriteCustom => 'カスタム上書き';
	@override String get overwriteAppend => '追加上書き';
	@override String get overwriteTips => 'オリジナルプロファイル <- カスタム上書き <- アプリ上書き';
	@override String get noOverwrite => '上書きしない';
	@override String get overwriteSettings => '上書き設定';
	@override String get diversionTemplates => 'ルーティングテンプレート';
	@override String get ruleProviders => 'ルールセット (RuleSet)';
	@override String get ruleTemplates => 'ルールテンプレート';
	@override String get proxyGroupsTemplates => 'グループテンプレート';
	@override String get proxyGroups => 'プロキシグループ';
	@override String get proxyNodeList => 'プロキシノードリスト';
	@override String proxyNodeFailure({required Object p}) => '以下のプロキシノードは期限切れのため自動的に削除されました: ${p}';
	@override String get externalController => '外部コントローラー';
	@override String get secret => 'シークレット';
	@override String get tcpConcurrent => 'TCP並行ハンドシェイク';
	@override String get globalClientFingerprint => 'TLSグローバルフィンガープリント';
	@override String get allowLanAccess => 'LANデバイスアクセス';
	@override String get mixedPort => '混合プロキシポート';
	@override String get logLevel => 'ログレベル';
	@override String get findProcessMode => 'プロセスマッチングモード';
	@override String get tcpkeepAliveInterval => 'TCPキープアライブ間隔';
	@override String get delayTestUrl => '遅延テストURL';
	@override String get delayTestTimeout => '遅延テストタイムアウト(ms)';
	@override String get tun => 'TUN';
	@override String get ntp => 'NTP';
	@override String get tls => 'TLS';
	@override String get geo => 'GEO';
	@override String get geoDownloadByProxy => 'プロキシ経由でGeo RuleSetをダウンロード';
	@override String get geoRulesetTips => 'Geosite/Geoipは対応するRuleSetに変換されます';
	@override String get asnNotSupportInIosTips => 'iOSシステムのメモリ制限により、IP-ASNおよびSRC-IP-ASNルールはiOSでは無視されます。';
	@override String get sniffer => 'スニッファー';
	@override String get userAgent => 'UserAgent';
	@override String get launchAtStartup => 'スタートアップ時に起動';
	@override String get launchAtStartupRunAsAdmin => 'Wmimoを管理者として再起動してください';
	@override String get tunModeRunAsAdmin => 'TUNモードにはシステム管理者権限が必要です。アプリを管理者として再起動してください';
	@override String get tunSwitchToSystemProxy => '一時的に【システムプロキシモード】に切り替えて接続を続行しますか？';
	@override String get tunCreateAdapterFailedAdmin => 'TUN 仮想ネットワークアダプターの作成に失敗しました: Access is denied。\nTUN モードには管理者権限が必要です。右クリックして【管理者として実行】を選択するか、メイン画面/コア設定で TUN モードをオフにしてシステムプロキシで接続してください。';
	@override String get portableMode => 'ポータブルモード';
	@override String get portableModeDisableTips => 'ポータブルモードを終了する必要がある場合は、[Wmimo]を終了し、[wmimo.exe]と同じディレクトリにある[portable]フォルダを手動で削除してください';
	@override String get systemProxy => 'システムプロキシ';
	@override String get autoConnectAfterLaunch => '起動後に自動接続';
	@override String get autoConnectAtBoot => 'システム起動後に自動接続';
	@override String get autoConnectAtBootTips => 'システムのサポートが必要です。一部のシステムでは[自動起動]を有効にする必要がある場合があります。';
	@override String get hideAfterLaunch => '起動後にウィンドウを隠す';
	@override String get autoSetSystemProxy => '接続時にシステムプロキシを自動設定';
	@override String get bypassSystemProxy => 'システムプロキシをバイパスすることを許可するドメイン名';
	@override String get excludeFromRecent => '[最近のタスク]から隠す';
	@override String get wakeLock => 'スリープ防止';
	@override String get hideVpn => 'VPNアイコンを隠す';
	@override String get hideVpnTips => 'IPv6を有効にすると、この機能は失敗します';
	@override String get hideDockIcon => 'Dockアイコンを隠す';
	@override String get showTrayTraffic => 'トレイに通信量情報を表示';
	@override String get website => 'ウェブサイト';
	@override String get homePage => 'ホームページ';
	@override String get rule => 'ルール';
	@override String get global => 'グローバル';
	@override String get direct => '直通';
	@override String get block => 'ブロック';
	@override String get qrcode => 'QRコード';
	@override String get qrcodeTooLong => 'テキストが長すぎて表示できません';
	@override String get qrcodeShare => 'QRコードを共有';
	@override String get textToQrcode => 'テキストをQRコードに変換';
	@override String get qrcodeScan => 'QRコードをスキャン';
	@override String get qrcodeScanResult => 'スキャン結果';
	@override String get qrcodeScanFromImage => '画像からスキャン';
	@override String get qrcodeScanFromClipboard => 'クリップボードから読取';
	@override String get qrcodeRecognized => 'QRコードを認識しました';
	@override String get qrcodeDropHint => '上のボタンをクリックして画面キャプチャまたは画像を選択';
	@override String get confirmImport => 'インポートを確認';
	@override String get reScan => '再スキャン';
	@override String get qrcodeScanResultFailed => '画像の解析に失敗しました。スクリーンショットが有効なQRコードであることを確認してください';
	@override String get qrcodeScanResultEmpty => 'スキャン結果が空です';
	@override String get screenshot => 'スクリーンショット';
	@override String get backupAndSync => 'バックアップと同期';
	@override String get importSuccess => 'インポート成功';
	@override String get rewriteConfirm => 'このファイルは既存のローカル設定を上書きします。続行しますか？';
	@override String get importAndExport => 'インポートとエクスポート';
	@override String get import => 'インポート';
	@override String get importFromUrl => 'URLからインポート';
	@override String get export => 'エクスポート';
	@override String get send => '送信';
	@override String get receive => '受信';
	@override String get sendConfirm => '送信を確認しますか？';
	@override String get continueConnectConfirm => '接続を続行しますか？';
	@override String get termOfUse => '利用規約';
	@override String get privacyPolicy => 'プライバシーポリシー';
	@override String get log => 'ログ';
	@override String get coreLog => 'コアログ';
	@override String get core => 'コア';
	@override String get help => 'ヘルプ';
	@override String get tutorial => 'チュートリアル';
	@override String get board => 'ボード';
	@override String get boardOnline => 'オンラインボードを使用';
	@override String get boardOnlineUrl => 'オンラインボードURL';
	@override String get boardLocalPort => 'ローカルボードポート';
	@override String get connections => '接続';
	@override String get closeAllConnections => 'すべての接続を閉じる';
	@override String get searchConnections => '接続を検索 (ドメイン/IP/ルール/プロセス)';
	@override String get noFilterResults => '一致する接続がありません';
	@override String get searchRules => 'ルールを検索 (タイプ/ペイロード/プロキシ)';
	@override String get searchProfiles => 'プロファイルを検索 (名前/URL/備考)';
	@override String get searchProxies => 'プロキシを検索 (名前/地域/正規表現)';
	@override String get noMatchingProfiles => '一致するプロファイルが見つかりません';
	@override String get rules => 'ルーティングルール';
	@override String get clear => 'クリア';
	@override String get copySuccess => 'コピーしました';
	@override String get alwayOnVPN => '常時接続';
	@override String get disableFontScaler => 'フォントスケーリングを無効にする（再起動後に有効）';
	@override String get autoOrientation => '画面に合わせて回転';
	@override String get restartTakesEffect => '再起動後に有効';
	@override String get reconnectTakesEffect => '再接続後に有効';
	@override String get runtimeProfile => '実行時プロファイル';
	@override String get willCompleteAfterRebootInstall => 'システム拡張機能のインストールを完了するには、デバイスを再起動してください';
	@override String get willCompleteAfterRebootUninstall => 'システム拡張機能のアンインストールを完了するには、デバイスを再起動してください';
	@override String get requestNeedsUserApproval => '1. [システム設定]-[プライバシーとセキュリティ]でWmimoによるシステム拡張機能のインストールを[許可]してください\n2. [システム設定]-[一般]-[ログイン項目と拡張機能]-[ネットワーク拡張機能]で[wmimoServiceSE]を有効にしてください\n完了後に再接続してください';
	@override String get FullDiskAccessPermissionRequired => '[システム設定]-[プライバシーとセキュリティ]-[フルディスクアクセス]でwmimoServiceSEの権限を有効にし、再接続してください。';
	@override String get proxy => 'プロキシ';
	@override String get theme => 'テーマ';
	@override String get tvMode => 'TVモード';
	@override String get autoUpdate => '自動更新';
	@override String get updateChannel => '自動更新チャンネル';
	@override String get onlineCustomerService => 'オンラインカスタマーサポート';
	@override String get subscriptionChannel => '購読チャンネル';
	@override String hasNewVersion({required Object p}) => 'バージョン ${p} に更新';
	@override String get autoDownloadPkg => '更新パッケージを自動ダウンロード';
	@override String get devOptions => '開発者オプション';
	@override String get joinUs => 'コミュニティに参加';
	@override String get about => 'このアプリについて';
	@override String get name => '名前';
	@override String get version => 'バージョン';
	@override String get notice => 'お知らせ';
	@override String get sort => '並べ替え';
	@override String get recommended => 'おすすめ';
	@override String innerError({required Object p}) => '内部エラー: ${p}';
	@override String get share => '共有';
	@override String get importFromClipboard => 'クリップボードからインポート';
	@override String get exportToClipboard => 'クリップボードにエクスポート';
	@override String get server => 'サーバー';
	@override String get port => 'ポート';
	@override String get donate => '寄付';
	@override String get setting => '設定';
	@override String get settingCore => 'コア設定';
	@override String get settingApp => 'アプリ設定';
	@override String get coreOverwrite => 'コア上書き設定';
	@override String get iCloud => 'iCloud';
	@override String get webdav => 'Webdav';
	@override String get lanSync => 'LAN同期';
	@override String get lanSyncNotQuitTips => '同期が完了するまでこのインターフェースを終了しないでください';
	@override String get deviceNoSpace => 'ディスク容量不足';
	@override String get hideSystemApp => 'システムアプリを隠す';
	@override String get hideAppIcon => 'アプリアイコンを隠す';
	@override String get openDir => 'ファイルディレクトリを開く';
	@override String get type => 'タイプ';
	@override String get fileChoose => 'ファイルを選択';
	@override String get filePathCannotEmpty => 'ファイルパスを空にすることはできません';
	@override String fileNotExist({required Object p}) => 'ファイルが存在しません: ${p}';
	@override String fileTypeInvalid({required Object p}) => '無効なファイルタイプ: ${p}';
	@override String get uwpExemption => 'UWPネットワーク分離免除';
	@override String get getProfile => 'サブスクリプションを取得';
	@override String get buyProfile => 'サブスクリプションを購入';
	@override String get addProfile => 'サブスクリプションを追加';
	@override String get myProfiles => 'サブスクリプション設定';
	@override String get profileEdit => 'サブスクリプション設定を編集';
	@override String get profileNeedActive => '先にこのプロファイルを現在のプロファイルに設定し、接続/再接続してください';
	@override String get profileDownloadBackupChannel => 'バックアップダウンロードチャネルを有効化';
	@override String get profileDownloadBackupChannelTips => 'Wmimo が提供するプロキシダウンロードチャネル（情報は一切保存されません）';
	@override String get profileEditReloadAfterProfileUpdate => 'プロファイル更新後にリロード';
	@override String get profileRulesAppendApplePush => 'Appleプッシュ通知ルールを追加';
	@override String get profileRulesAppendProxyTips => 'ルールは元の設定の [proxy-groups] 内で、タイプが [url-test] または [select] の最初のプロキシに自動設定されます';
	@override String get profileImport => 'プロファイルファイルをインポート';
	@override String get profileAddUrlOrContent => 'サブスクリプションURLを追加';
	@override String get profileUrlOrContent => 'サブスクリプションURL / ノード内容';
	@override String get profileUrlOrContentHit => 'サブスクリプションURLまたは内容 [必須]';
	@override String get profileUrlOrContentCannotEmpty => 'サブスクリプションURLまたは内容は空にできません';
	@override String get overview => '概要';
	@override String get trafficStats => 'トラフィック統計';
	@override String get realtimeMonitor => 'リアルタイム監視';
	@override String get realtimeUpload => 'リアルタイム送信';
	@override String get realtimeDownload => 'リアルタイム受信';
	@override String get sessionUpload => '今回の送信';
	@override String get sessionDownload => '今回の受信';
	@override String get planUsage => 'プラン使用量';
	@override String get memoryUsage => 'メモリ使用量';
	@override String get remaining => '残り';
	@override String get expireTime => '有効期限';
	@override String get tunMode => 'TUN モード';
	@override String daysAgo({required Object p}) => '${p}日前';
	@override String hoursAgo({required Object p}) => '${p}時間前';
	@override String get lessThanOneHourAgo => '1時間以内';
	@override String get inUse => '使用中';
	@override String get remoteSubscription => 'リモートサブスクリプション';
	@override String get noTrafficData => '利用統計なし';
	@override String get localProfile => 'ローカルファイル';
	@override String get viewYamlConfig => 'YAML設定を表示';
	@override String get editYamlConfig => 'YAML設定を編集';
	@override String get copySubscriptionUrl => 'サブスクリプションURLをコピー';
	@override String get qrCode => 'QRコード';
	@override String get deleteProfile => '設定を削除';
	@override String get noProfilesYet => 'サブスクリプション設定がありません';
	@override String get addProfilePrompt => '右上の + をクリックしてURLを追加またはファイルをインポート';
	@override String get subscriptionUrlCopied => 'サブスクリプションURLがクリップボードにコピーされました';
	@override String autoGroupTip({required Object group, required Object type}) => '「${group}」は ${type} 自動ポリシーグループです。システムが遅延/可用性に基づいて自動的にノードを選択します。手動で選択する場合は「ノード選択」グループで切り替えてください。';
	@override String switchNodeFailed({required Object p}) => 'ノードの切り替えに失敗しました: ${p}';
	@override String nodeSelected({required Object p}) => '選択されたノード: ${p}';
	@override String get startingCoreAndTesting => 'コアを起動してレイテンシをテスト中...';
	@override String chartMinutes({required Object p}) => '${p} 分';
	@override String get chartUpload => 'アップロード';
	@override String get chartDownload => 'ダウンロード';
	@override String get author => '作成者';
	@override String get githubRepo => 'オープンソースリポジトリ';
	@override String get openSourceLicense => 'オープンソースライセンス';
	@override String get submitFeedback => 'フィードバックと問題の報告';
	@override String get copiedToClipboard => 'クリップボードにコピーしました';
	@override String get autoScrollEnabled => '自動スクロール有効';
	@override String get autoScrollDisabled => '自動スクロール無効';
	@override String get pauseLogs => 'リアルタイムログを一時停止';
	@override String get resumeLogs => 'リアルタイムログを再開';
	@override String get scrollToLatest => '最新までスクロール';
	@override String get scrollToBottom => '最下部へスクロール';
	@override String newLogsCount({required Object p}) => '(${p} 件の新しいログ)';
	@override String get copiedLogContent => 'ログ内容をコピーしました';
	@override String get copyLog => 'ログをコピー';
	@override String get noLogsPrompt => 'ログはまだありません。プロキシ起動後にリアルタイムログが表示されます。';
	@override String get searchLogsHint => ' (IP, ドメイン, ルール, エラー...)';
	@override String get offlinePreviewPrompt => 'オフラインプレビュー中。プロキシを開始してルーティングと速度テストを有効化します。';
	@override String get manualSelect => '手動選択';
	@override String get autoSelect => '自動選択';
	@override String get speedTestGroup => 'グループ速度テスト';
	@override String get pause => '一時停止';
	@override String get resume => '再開';
	@override String get ipInfo => 'IP 情報';
	@override String get ipFetching => 'IP情報を取得中...';
	@override String get ipCopied => 'IPアドレスをクリップボードにコピーしました';
	@override String get ipLocation => '位置';
	@override String get ipIsp => 'プロバイダ';
	@override String get ipTapToFetch => 'タップしてIP情報を取得';
	@override String get ipProxy => 'プロキシ出口';
	@override String get ipDirect => 'ローカル直結';
	@override String get ipAsn => 'ASN';
	@override String get ipOrg => '組織';
	@override String get ipTimezone => 'タイムゾーン';
	@override String get ipCoordinates => '座標';
	@override String get ipMoreDetails => '詳細情報';
	@override String get ipLessDetails => '折りたたむ';
	@override String get collapseAll => 'すべてのグループを折りたたむ';
	@override String get expandAll => 'すべてのグループを展開';
	@override String get donateTitle => '💖 開発者にコーヒーをおごる';
	@override String get donateThankYou => 'ฅ^•ﻌ•^ฅ 皆様のご支援が、Wmimoを磨き続ける最大の力になります ~ ☕✨';
	@override String get tokenCurrency => '通貨';
	@override String get networkChain => 'ネットワーク';
	@override String get depositAddress => 'APTOS 受取先アドレス';
	@override String get clickToCopy => 'クリックしてコピー';
	@override String get copyAddressBtn => 'アドレスをコピー ✨';
	@override String get donateAddressCopied => '( ੭ ˙ᗜ˙ )੭ アドレスをコピーしました！応援ありがとうございます~ 💖';
	@override String get donateTip => '💡 ヒント：BybitまたはAptos互換ウォレットでのスキャンに対応';
	@override String get qrcodeParsing => 'QRコードを解析中...';
	@override String get qrcodeNotFound => 'QRコードが検出されませんでした';
	@override String get qrcodeSupportHint => '各種サブスクリプション、ノード、設定QRコードの解析に対応';
	@override String get qrcodeCameraHint => 'フレーム内にQRコードを合わせると自動でスキャンします';
	@override String get flashlight => 'フラッシュ';
	@override String get screenshotDesc => '画面キャプチャ';
	@override String get fromImageDesc => '画像ファイル';
	@override String get fromClipboardDesc => 'クリップボード';
	@override String get errorPrompt => 'エラー';
	@override String get copied => 'コピー完了';
	@override String get sortAndFilterNodes => 'ノードの並べ替えと絞り込み';
	@override String get sortOptions => '並べ替え';
	@override String get sortDefault => 'デフォルト順';
	@override String get sortLatency => '遅延順';
	@override String get sortName => '名前順 (A-Z)';
	@override String get sortRegion => '地域別グループ';
	@override String get filterOptions => '絞り込みオプション';
	@override String portableUpdateTip({required Object version}) => 'ポータブル版を検出しました：\nポータブル版はアプリ内上書き更新に対応していません。公式サイトまたはリポジトリから最新のZIPをダウンロードして解凍・上書きしてください。\n\n最新バージョン: v${version}';
	@override String get portableModeTipTitle => 'ポータブル版のヒント';
	@override String get noNodesToSpeedTest => 'テスト可能なノードがありません';
	@override String alreadyLatestVersion({required Object version}) => '最新バージョンです (v${version})';
	@override String get checkUpdateFailed => 'アップデート確認に失敗しました。ネットワーク接続を確認してください';
	@override String get hideTimeoutNodes => 'タイムアウトおよび利用不可ノードを非表示';
	@override String get hideTimeoutNodesDesc => 'テスト失敗またはタイムアウトしたノードを自動で非表示にします';
	@override String get speedtestScenario => '現在のスピードテストシナリオ';
	@override String get speedtestScenarioSwitch => 'スピードテストシナリオの切替';
	@override String get speedtestScenarioDesc => '異なるサービスを選択して接続遅延と稼働状況をテスト';
	@override String get speedtestAllNodes => '全ノード測定';
	@override String get retestTimeoutNodes => 'タイムアウトノードのみ再測定';
	@override String switchedTargetScenario({required Object target}) => 'テストシナリオを切り替えました: ${target}';
	@override String get notTested => '未測定';
	@override String get timeoutOrFailed => 'タイムアウト / 接続不可';
	@override String get identifiedRegion => '地域';
	@override String get nodeProtocol => 'プロトコル';
	@override String get currentLatency => '遅延';
	@override String get testScenario => 'テストシナリオ';
	@override String get belongsToGroup => 'グループ';
	@override String get copyNodeName => '名前をコピー';
	@override String get nodeNameCopied => 'ノード名をコピーしました';
	@override String get testSingleNode => '個別テスト';
	@override String get selectThisNode => 'このノードを選択';
	@override String get allNodesNormal => 'すべてのノードが正常に動作しています。再テストは不要です';
	@override String get customUrlPrompt => 'カスタムURL (例: http://...)';
	@override String get customTarget => 'カスタムターゲット';
	@override String get downloadFailedTip => 'インストーラーのダウンロードに失敗しました。ネットワークを確認するか、Webサイトからダウンロードしてください。';
	@override String discoveredNewVersion({required Object version}) => '新しいバージョンが見つかりました: v${version}';
	@override String get preparingUpdate => 'アップデートの準備中...';
	@override String get downloadingPackage => 'インストーラーをダウンロード中、しばらくお待ちください...';
	@override String get downloadUpdateNow => '今すぐアップデートをダウンロード';
	@override String get downloadFromWeb => 'Webサイトからダウンロード';
	@override String get switchSource => '切替';
	@override String get serverSwitch => '測定サーバーの切替';
	@override String get autoDetectBest => '最適なサーバーを自動検出';
	@override String get serverSwitchDesc => 'CDNまたはカスタムターゲットを選択して接続をテスト';
	@override String autoSelectedBest({required Object server, required Object ping}) => '最適なサーバーを選択しました: ${server} (${ping} ms)';
	@override String get networkGradeTitle => 'ネットワーク総合評価';
	@override String get copyReport => 'レポートをコピー';
	@override String get reportCopied => 'レポートをコピーしました。共有できます';
	@override String get gamingExperience => 'オンラインゲーム';
	@override String get streamingExperience => '動画ストリーミング';
	@override String get meetingExperience => 'ビデオ会議';
	@override String get customSpeedtestUrl => 'カスタム測定URL (https://...)';
	@override String get customSpeedtestSource => 'カスタム測定サーバー';
	@override String get userSpecifiedUrl => 'ユーザー指定URL';
	@override String cannotBeEmpty({required Object item}) => '${item}を入力してください';
	@override String alreadyExists({required Object item}) => '${item}は既に存在します';
	@override String installFailedWithCode({required Object installer, required Object code}) => '${installer}のインストールに失敗しました (コード: ${code})';
	@override String get resetSystemProxy => 'ネットワーク修復 / プロキシをリセット';
	@override String get resetSystemProxyDesc => '残留したプロキシ設定をクリアし、異常終了後の接続問題を解決します';
	@override String get resetSystemProxySuccess => 'システムプロキシがリセットされ、ネットワークが復旧しました';
	@override String get networkDiagnostics => 'ネットワーク診断とスマート修復';
	@override String get networkDiagnosticsDesc => 'NIC、DNS、コアポート、プロキシの正常性をワンクリックで診断・自動修復';
	@override String get sortLatencyDesc => 'レイテンシ降順';
	@override String get sortNameDesc => '名前 Z-A';
	@override String get sortMultiplier => '倍率昇順';
	@override String get uwpLoopback => 'UWP ループバック免除ツール';
	@override String get uwpLoopbackDesc => 'Microsoft Store、Xbox、MinecraftなどのUWPアプリにローカルプロキシを許可';
	@override String get uwpExemptAllCommon => '推奨アプリを一括免除';
	@override String get uwpApplySuccess => 'UWPループバック免除ルールが適用されました';
	@override String get common => '常用';
	@override String get exempted => '免除済み';
	@override String get notExempted => '未免除';
	@override String get deselectAll => '全選択解除';
	@override String get userApps => 'ユーザーアプリ';
	@override String get systemApps => 'システムアプリ';
	@override String get selectedOnly => '選択済み';
	@override String get proxySelectedMode => '選択アプリのみプロキシ';
	@override String get proxySelectedModeDesc => '選択したアプリのみプロキシを経由し、その他は直接接続します';
	@override String get bypassSelectedMode => '選択アプリをバイパス';
	@override String get bypassSelectedModeDesc => '選択したアプリは直接接続し、その他はプロキシを経由します';
	@override String get invertSelection => '選択反転';
	@override String get all => 'すべて';
	@override String get showAppIcon => 'アプリアイコンを表示';
	@override String get proxySelection => 'プロキシ選択';
	@override String get regionHk => '🇭🇰 香港';
	@override String get regionJp => '🇯🇵 日本';
	@override String get regionSg => '🇸🇬 シンガポール';
	@override String get regionTw => '🇹🇼 台湾';
	@override String get regionUs => '🇺🇸 アメリカ';
	@override String get regionKr => '🇰🇷 韓国';
	@override String get macMoveToApplications => 'Wmimoを「アプリケーション」フォルダに移動してから起動してください';
	@override String get notifCurrentNode => '現在のノード';
	@override String get notifMode => '動作モード';
	@override String get notifPort => 'ポート';
	@override String get notifProfile => 'プロファイル';
	@override String get notifDisconnect => '切断';
	@override String get notifSwitchNode => 'ノード切替';
	@override String get notifVpnConnected => 'VPN プロキシ接続中';
	@override String get connectionDetails => '接続詳細';
	@override String get sourceAddress => '送信元アドレス';
	@override String get destinationAddress => '宛先アドレス';
	@override String get host => 'ホスト名';
	@override String get process => 'プロセス';
	@override String get processPath => 'プロセスパス';
	@override String get proxyChain => 'プロキシチェーン';
	@override String get networkProtocol => 'プロトコル';
	@override String get trafficUpload => 'アップロード量';
	@override String get trafficDownload => 'ダウンロード量';
	@override String get connectionDuration => '接続時間';
	@override String get connectionStart => '開始時間';
	@override String get copyHost => 'ホストをコピー';
	@override String get copyAllDetails => '詳細をすべてコピー';
	@override String get closeThisConnection => 'この接続を切断';
	@override String get sortByDownload => 'ダウンロード順';
	@override String get sortByUpload => 'アップロード順';
	@override String get sortBySpeed => '速度順';
	@override String get sortByDuration => '接続時間順';
	@override String get sortByHost => 'ホスト順';
	@override String get realtimeSpeed => 'リアルタイム速度';
	@override String get totalUpload => '総アップロード';
	@override String get totalDownload => '総ダウンロード';
	@override String get activeConnections => 'アクティブ';
	@override String get openInFolder => 'フォルダで表示';
	@override String get openProfilesDir => '設定フォルダを開く';
	@override String get profilePatches => 'プロファイル上書き';
	@override String nodeCount({required Object p}) => '${p} 個のノード';
	@override String get copyFilePath => 'ファイルパスをコピー';
	@override String get duplicateProfile => '複製を作成';
	@override String get useThisProfile => 'このプロファイルを使用';
	@override String get websiteTest => 'ウェブサイトテスト';
	@override String get testAll => 'すべてテスト';
	@override String get addTestWebsite => 'テストサイトを追加';
	@override String get websiteName => 'サイト名';
	@override String get websiteUrl => 'テスト URL';
	@override String get websiteNameHint => 'サイト名 (例: Cloudflare)';
	@override String get websiteInputEmpty => 'サイト名と URL を入力してください';
	@override String get autoRefresh => '自動更新';
	@override String get currentProfile => '現在のプロファイル';
	@override String get quickActions => 'クイックツール';
	@override String get fastest => '最低遅延';
	@override String get hideTimeout => 'タイムアウト非表示';
	@override String get filteredTimeout => 'タイムアウト除外済';
	@override String get tunDeviceCreateFailed => 'TUN 仮想ネットワークアダプターの作成に失敗しました';
	@override String get test => 'テスト';
	@override String get addWebsite => 'サイトを追加';
	@override String get maxWebsitesReached => '最大6つのテストWebサイトを追加できます';
	@override String get sideBySideLayout => '並列レイアウト';
	@override String get sideBySideLayoutTips => 'ワイド画面でホームカードとサブスクリプションリストを並列表示します';
	@override String get homeCardsManage => 'ホームカード管理';
	@override String get homeCardsManageTips => 'ホーム画面に表示するカードの表示・非表示をカスタマイズします';
	@override String get cardTrafficChart => 'トラフィック統計グラフ';
	@override String get cardWebsiteTest => 'ウェブサイト接続テスト';
	@override String get cardIpInfo => 'IP・出口情報';
	@override String get cardSubscription => 'プラン・有効期限情報';
	@override String get cardQuickActions => 'クイックツール';
	@override String get resetDefaultCards => 'デフォルトに戻す';
	@override String get collapseAllCards => 'すべて折りたたむ';
	@override String get expandAllCards => 'すべて展開';
}

// Path: permission
class _Translations$permission$ja implements Translations$permission$en {
	_Translations$permission$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get camera => 'カメラ';
	@override String get screen => '画面録画';
	@override String get appQuery => 'アプリケーションリストを取得';
	@override String request({required Object p}) => '[${p}] 権限をオンにする';
	@override String requestNeed({required Object p}) => '[${p}] 権限をオンにしてください';
}

// Path: tls
class _Translations$tls$ja implements Translations$tls$en {
	_Translations$tls$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get insecure => '証明書の検証をスキップ';
	@override String get certificate => '証明書';
	@override String get privateKey => '秘密鍵';
	@override String get customTrustCert => 'カスタム証明書';
}

// Path: tun
class _Translations$tun$ja implements Translations$tun$en {
	_Translations$tun$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get stack => 'ネットワークスタック';
	@override String get stackGvisor => 'gVisor';
	@override String get stackGvisorDesc => 'ユーザースペースのネットワークスタック、優れた安定性と互換性';
	@override String get stackSystem => 'System';
	@override String get stackSystemDesc => 'OSネイティブのネットワークスタック、高性能ですがシステム実装に依存';
	@override String get stackMixed => 'Mixed';
	@override String get stackMixedDesc => '混合スタックモード、パフォーマンスと互換性のバランス';
	@override String get stackMips => 'MIPS (Mihomo IP Stack)';
	@override String get stackMipsDesc => 'Mihomo独自開発の高性能IPスタック、高スループットと低遅延';
	@override String get inet4Address => 'IPv4アドレス範囲';
	@override String get inet6Address => 'IPv6アドレス範囲';
	@override String get dnsHijack => 'DNSハイジャック';
	@override String get strictRoute => '厳格なルート';
	@override String get tunDefaultRoute => 'デフォルトルート';
	@override String get icmpForward => 'ICMP転送';
	@override String get allowBypass => 'アプリがVPNをバイパスすることを許可する';
	@override String get appendHttpProxy => 'VPNにHTTPプロキシを追加する';
	@override String get bypassHttpProxyDomain => 'HTTPプロキシをバイパスすることを許可するドメイン';
}

// Path: dns
class _Translations$dns$ja implements Translations$dns$en {
	_Translations$dns$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get listen => 'リスニングアドレス';
	@override String get fakeIp => 'fake-ip';
	@override String get fallback => 'フォールバック';
	@override String get preferH3 => 'DoH H3を優先';
	@override String get useHosts => 'Hostsを使用';
	@override String get useSystemHosts => 'システムHostsを使用';
	@override String get enhancedMode => '拡張モード';
	@override String get fakeIPFilterMode => '${_root.dns.fakeIp} フィルターモード';
	@override String get fakeIPFilter => '${_root.dns.fakeIp} フィルター';
	@override String get respectRules => 'ルールを尊重する';
	@override String get nameServer => 'ネームサーバー';
	@override String get defaultNameServer => '${_root.meta.byDefault} ${_root.dns.nameServer}';
	@override String get proxyNameServer => '${_root.meta.proxy} ${_root.dns.nameServer}';
	@override String get directNameServer => '${_root.meta.direct} ${_root.dns.nameServer}';
	@override String get fallbackNameServer => '${_root.dns.fallback} ${_root.dns.nameServer}';
	@override String get fallbackGeoIp => '${_root.dns.fallback} GeoIp';
	@override String get fallbackGeoIpCode => '${_root.dns.fallback} GeoIpCode';
	@override String get flushCache => 'DNSキャッシュをクリア';
	@override String get flushCacheSuccess => 'DNSとFake-IPキャッシュが正常にクリアされました';
	@override String get presets => 'クイックDNSプリセット';
	@override String get presetSpeed => '高速デュアルスタック';
	@override String get presetSpeedDesc => 'AliDNS DoH3 + DNSPod DoH：国内は即時接続、海外はスマートルーティング';
	@override String get presetSecure => '汚染防止＆プライバシーモード';
	@override String get presetSecureDesc => 'Cloudflare DoH3 + Google DoH：ハイジャックと検閲を防止';
	@override String get presetAdGuard => 'AdGuard 広告ブロック＆クリーン';
	@override String get presetAdGuardDesc => 'AdGuard DoQ + AliDNS DoH：リクエストのフィルタリングと追跡防止';
	@override String get overwriteDesc => 'プロファイル内のDNS設定を上書き';
	@override String get enableDesc => 'カスタムDNSリゾルバを有効化';
	@override String get resetFakeIpFilter => '初期値に戻す';
	@override String get resetFakeIpFilterConfirm => '推奨されるFake-IPフィルタリストを復元しますか？';
	@override String get dnsTester => 'DNSリアルタイム診断';
	@override String get testQuery => 'テスト';
	@override String get fakeIpDetected => 'Fake-IP ヒット';
	@override String get realIpDetected => '実IPアドレス';
	@override String get addServer => 'DNSサーバーを追加';
	@override String get geoAssetsTitle => 'GEOオフラインデータベース';
	@override String get geoAssetsDesc => 'GeoSiteドメインルール、GeoIPおよびASNデータベースの管理';
	@override String get cdnSource => 'ダウンロードCDNミラー';
	@override String get updateAll => 'すべて更新';
	@override String get updateSuccess => '更新に成功しました';
	@override String get updateFailed => '更新に失敗しました';
	@override String get addPresetServer => 'プリセットDNSを追加';
	@override String manageFakeIpFilter({required Object p}) => 'フィルターリストを管理 (${p})';
	@override String fakeIpFilterDesc({required Object p}) => '${p} 個のドメインルールがFake-IP解決をバイパスし、ネットワーク分離問題を回避します。';
}

// Path: sniffer
class _Translations$sniffer$ja implements Translations$sniffer$en {
	_Translations$sniffer$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get overrideDest => '上書き';
}

// Path: profilePatchMode
class _Translations$profilePatchMode$ja implements Translations$profilePatchMode$en {
	_Translations$profilePatchMode$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get currentSelected => '現在選択中';
	@override String get overwrite => '内蔵 - 上書き';
	@override String get noOverwrite => '内蔵 - 上書きなし';
}

// Path: main.tray
class _Translations$main$tray$ja implements Translations$main$tray$en {
	_Translations$main$tray$ja._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get menuOpen => '開く';
	@override String get menuExit => '終了';
	@override String get coreDisconnected => 'Wmimo · コア未起動';
	@override String get coreRunning => 'Wmimo · コア実行中';
	@override String get startProxy => 'プロキシ接続を開始';
	@override String get stopProxy => 'プロキシ接続を切断';
	@override String get restartCore => 'プロキシコアを再起動';
	@override String get systemProxyItem => 'システムプロキシ';
	@override String get tunModeItem => 'TUN モード';
	@override String get outboundMode => 'アウトバウンドモード';
	@override String get modeRule => 'ルールルーティング';
	@override String get modeGlobal => 'グローバルプロキシ';
	@override String get modeDirect => 'ダイレクト接続';
	@override String get profilesMenu => 'サブスクリプション設定';
	@override String get updateAllProfiles => 'すべてのサブスクリプションを更新';
	@override String get proxyNodes => 'プロキシノード';
	@override String get tools => 'ツール';
	@override String get copyProxyCmd => 'ターミナルプロキシコマンドをコピー (CMD / Bash)';
	@override String get delayTestAll => '全ノードの遅延速度を測定';
	@override String get openDashboard => 'ダッシュボードを開く';
	@override String get resetSystemProxy => 'ネットワーク修復/プロキシをリセット';
	@override String get copyCmdPowerShell => 'PowerShell コマンド';
	@override String get copyCmdCmd => 'CMD コマンド';
	@override String get copyCmdBash => 'Bash/Zsh コマンド';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'WelcomeLanguageScreen.welcomeTitle' => 'Wmimo へようこそ',
			'WelcomeLanguageScreen.selectLanguage' => '言語を選択',
			'WelcomeLanguageScreen.subtitle' => 'ご希望の言語を選択してください。設定からいつでも変更できます。',
			'WelcomeLanguageScreen.start' => '始める',
			'BackupAndSyncWebdavScreen.webdavServerUrl' => 'サーバーURL',
			'BackupAndSyncWebdavScreen.webdavRequired' => '空にすることはできません',
			'BackupAndSyncWebdavScreen.webdavLoginFailed' => 'ログインに失敗しました:',
			'BackupAndSyncWebdavScreen.webdavListFailed' => 'ファイルリストの取得に失敗しました:',
			'LaunchFailedScreen.invalidProcess' => 'アプリの起動に失敗しました [無効なプロセス名]。アプリを別のディレクトリに再インストールしてください',
			'LaunchFailedScreen.invalidProfile' => 'アプリの起動に失敗しました [プロファイルへのアクセスに失敗]。アプリを再インストールしてください',
			'LaunchFailedScreen.invalidVersion' => 'アプリの起動に失敗しました [無効なバージョン]。アプリを再インストールしてください',
			'LaunchFailedScreen.systemVersionLow' => 'アプリの起動に失敗しました [システムバージョンが低すぎます]',
			'LaunchFailedScreen.invalidInstallPath' => 'インストールパスが無効です。有効なパスに再インストールしてください',
			'PerAppAndroidScreen.title' => 'アプリごとのプロキシ',
			'PerAppAndroidScreen.whiteListMode' => 'ホワイトリストモード',
			'PerAppAndroidScreen.whiteListModeTip' => '有効な場合：チェックされたアプリのみがプロキシされます。無効な場合：チェックされていないアプリのみがプロキシされます',
			'PerAppAndroidScreen.manualAddPackage' => 'パッケージ名を手動で追加',
			'PerAppAndroidScreen.manualAddPackageHint' => 'プロキシするパッケージ名を入力してください (空白、カンマ、改行で複数指定可能、例: org.telegram.messenger, com.google.android.youtube):',
			'PerAppAndroidScreen.quickAddPresets' => 'よく使うプロキシアプリをクイック追加',
			'PerAppAndroidScreen.saveSelected' => '選択項目を保存',
			'PerAppAndroidScreen.permissionRestrictedTip' => 'システムによりアプリ一覧の読み取りが制限されています。下の【システム権限設定を開く】をタップしてアプリ一覧取得権限を許可するか、権限不要のプリセットをご利用ください。',
			'PerAppAndroidScreen.openSystemPermission' => 'システム権限設定を開く',
			'PerAppAndroidScreen.presetApps' => 'よく使うアプリを追加 (権限不要プリセット)',
			'PerAppAndroidScreen.requestPermissionPopup' => '権限をリクエスト (システムダイアログ)',
			'UserAgreementScreen.privacyFirst' => 'プライバシーを第一に',
			'UserAgreementScreen.agreeAndContinue' => '同意して続行',
			'NetCheckScreen.title' => 'ネットワーク診断と修復',
			'NetCheckScreen.fullDiagnosticsTab' => 'パイプライン診断',
			'NetCheckScreen.advancedCheckTab' => 'ドメイン詳細クエリ',
			'NetCheckScreen.startDiagnostics' => '診断を開始',
			'NetCheckScreen.reDiagnostics' => '再診断',
			'NetCheckScreen.diagnosing' => 'ネットワーク経路を診断中...',
			'NetCheckScreen.healthScore' => '健全性スコア',
			'NetCheckScreen.scorePerfect' => '非常に良好',
			'NetCheckScreen.scoreGood' => '良好',
			'NetCheckScreen.scoreWarning' => '警告あり',
			'NetCheckScreen.scoreCritical' => '接続障害',
			'NetCheckScreen.oneClickRepair' => 'ワンクリック自動修復',
			'NetCheckScreen.repairSuccess' => '修復が完了し、ネットワークが復旧しました',
			'NetCheckScreen.repairFailed' => '修復を実行しました。一部項目を手動で確認してください',
			'NetCheckScreen.repairing' => '自動修復を実行中...',
			'NetCheckScreen.issueFound' => ({required Object count}) => '${count} 件の異常を検出',
			'NetCheckScreen.noIssue' => 'すべての項目が正常です',
			'NetCheckScreen.details' => '詳細ログ',
			'NetCheckScreen.copyDetails' => 'ログをコピー',
			'NetCheckScreen.detailsCopied' => '診断ログをクリップボードにコピーしました',
			'NetCheckScreen.stepPhysical' => '物理NICとゲートウェイ',
			'NetCheckScreen.stepDns' => 'DNS解決とFake-IP',
			'NetCheckScreen.stepCore' => 'コアプロセスとポート',
			'NetCheckScreen.stepProxy' => 'システムプロキシ設定',
			'NetCheckScreen.stepHandshake' => 'インターネットハンドシェイク',
			'NetCheckScreen.suggestedAction' => 'トラブルシューティング',
			'NetCheckScreen.autoRepairAction' => '今すぐ修復',
			'NetCheckScreen.enterDomain' => 'ドメインを入力してください',
			'NetCheckScreen.checking' => '診断中...',
			'NetCheckScreen.aQueryFailed' => ({required Object p}) => 'A クエリ失敗: ${p}',
			'NetCheckScreen.aaaaQueryFailed' => ({required Object p}) => 'AAAA クエリ失敗: ${p}',
			'NetCheckScreen.success' => '成功',
			'NetCheckScreen.failed' => '失敗',
			'NetCheckScreen.suspectedPollution' => 'DNS汚染の疑い',
			'NetCheckScreen.domainLabel' => 'ドメイン',
			'NetCheckScreen.checkButton' => '診断',
			'NetCheckScreen.dnsSection' => '1. DNSクエリ',
			'NetCheckScreen.directHttpSection' => '2. HTTP (TUN経由,先にTUNを有効化)',
			'NetCheckScreen.proxyHttpSection' => ({required Object p}) => '3. HTTP (プロキシ経由,ポート:${p})',
			'NetCheckScreen.tunNotEnabled' => 'TUN が無効です',
			'NetCheckScreen.routeTableSection' => '4. ルーティングテーブル',
			'NetCheckScreen.stepPhysicalDesc' => '物理ネットワークカード、ローカルIP、ゲートウェイの接続性を検出',
			'NetCheckScreen.stepDnsDesc' => 'ローカルDNS解決の遅延とコアDNS応答ステータスを検証',
			'NetCheckScreen.stepCoreDesc' => 'Mihomoプロセスの稼働状態とMixed-Port/APIポートのリッスンを検出',
			'NetCheckScreen.stepProxyDesc' => 'システムプロキシ設定の一貫性を検証し残留プロキシをチェック',
			'NetCheckScreen.stepHandshakeDesc' => 'アクティブなノードを経由してグローバルCDNへの実効遅延と到達性を測定',
			'NetCheckScreen.shortStepPhysical' => 'NIC',
			'NetCheckScreen.shortStepDns' => 'DNS',
			'NetCheckScreen.shortStepCore' => 'コア',
			'NetCheckScreen.shortStepProxy' => 'プロキシ',
			'NetCheckScreen.shortStepHandshake' => 'WAN',
			'NetCheckScreen.valNicNormal' => ({required Object p}) => 'ネットワーク接続正常 (${p})',
			'NetCheckScreen.valNicNone' => '利用可能なネットワークインターフェースが見つかりません',
			'NetCheckScreen.valNicGatewayTimeout' => 'ローカルIPは取得されましたが、外部ゲートウェイがタイムアウトしました',
			'NetCheckScreen.valNicError' => 'ネットワークインターフェース検査エラー',
			'NetCheckScreen.valDnsNormal' => ({required Object p}) => 'DNS応答正常 (${p})',
			'NetCheckScreen.valDnsEmpty' => 'DNSクエリが空のリストを返しました',
			'NetCheckScreen.valDnsTimeout' => 'DNSクエリがタイムアウトまたは失敗しました',
			'NetCheckScreen.valCoreNormal' => ({required Object port, required Object mode}) => 'コア正常稼働中 (Mixed Port: ${port}, モード: ${mode})',
			'NetCheckScreen.valCoreNotRunning' => 'コアサービスが停止しています',
			'NetCheckScreen.valCorePortConflict' => ({required Object p}) => 'ポート ${p} は外部プログラムによって占有されています',
			'NetCheckScreen.valCoreApiFailed' => 'コアプロセスが無応答 (API通信失敗)',
			'NetCheckScreen.valCoreError' => 'コア検査エラー',
			'NetCheckScreen.valProxyActive' => ({required Object port}) => 'システムプロキシ有効 (127.0.0.1:${port})',
			'NetCheckScreen.valProxyDisabled' => 'システムプロキシ無効 (直連/TUN/手動モード)',
			'NetCheckScreen.valProxyZombie' => '残留システムプロキシを検出 (ネット不通の原因)',
			'NetCheckScreen.valProxyFailed' => 'システムプロキシの有効化に失敗しました',
			'NetCheckScreen.valProxyWarning' => 'システムプロキシ状態の読み取り警告',
			'NetCheckScreen.valHandshakeNormal' => ({required Object node, required Object delay}) => '公衆回線ハンドシェイク良好 (${node} • ${delay} ms)',
			'NetCheckScreen.valHandshakeFailed' => ({required Object node, required Object err}) => '現在のノード [${node}] ハンドシェイク失敗 (${err})',
			'NetCheckScreen.valHandshakeSkipped' => 'コア未起動のため、公衆回線テストをスキップ',
			'NetCheckScreen.valHandshakeError' => '公衆回線ハンドシェイク異常',
			'NetCheckScreen.issueNicDisconnected' => 'ネットワークカードが未接続です (LANケーブル未接続、Wi-Fi切断、機内モード)',
			'NetCheckScreen.suggestNicCheck' => 'LANケーブル、Wi-Fi接続、またはネットワークアダプターの状態を確認してください',
			'NetCheckScreen.suggestNicReset' => 'システム設定でネットワークアダプターを無効化してから再度有効にしてみてください',
			'NetCheckScreen.issueNicGatewayUnreachable' => 'LANには接続されていますが、外部ルーターにアクセスできません (認証ポータルまたはルーター切断)',
			'NetCheckScreen.suggestNicGateway' => 'ルーターのインジケーターを確認するか、ブラウザを開いてWeb認証が必要か確認してください',
			'NetCheckScreen.issueDnsPollution' => 'ローカルDNSサービスが無応答です。DNS汚染またはハイジャックの可能性があります',
			'NetCheckScreen.suggestDnsReset' => 'システムDNSをリセットするか、Wmimoで暗号化DNS (DoH/DoT) を有効にしてください',
			'NetCheckScreen.actionFlushDns' => 'システムDNSキャッシュをフラッシュ',
			'NetCheckScreen.suggestDnsSlow' => 'DNS解決の遅延が大きいため、暗号化DNSの有効化をおすすめします',
			'NetCheckScreen.issueDnsFailed' => 'ローカルDNS解決に失敗しました。ドメインをIPアドレスに変換できません',
			'NetCheckScreen.suggestDnsFlush' => 'DNSキャッシュをフラッシュするか、Wmimo設定で暗号化DNSを有効にしてください',
			'NetCheckScreen.issueCorePortConflict' => 'ポート競合が検出されました！他のプロキシソフトまたはサービスが占有しています',
			'NetCheckScreen.suggestCoreChangePort' => '他のプロキシソフトを終了するか、Wmimo設定でポート番号を変更してください',
			'NetCheckScreen.actionRestartCore' => 'コアを再起動',
			'NetCheckScreen.issueCoreStopped' => 'Wmimoコアプロセスが停止しています',
			'NetCheckScreen.suggestCoreStart' => 'ホーム画面の接続スイッチを入れるか、下の【コア起動】をクリックしてください',
			'NetCheckScreen.actionStartCore' => 'コアプロセスを起動',
			'NetCheckScreen.issueCoreFrozen' => 'コアプロセスが応答しないか、API認証が一致しません',
			'NetCheckScreen.suggestCoreRestart' => '【コア再起動】をクリックしてサービスを復旧してください',
			'NetCheckScreen.suggestCoreReinstall' => 'コアの再起動またはドライバの再インストールをお試しください',
			'NetCheckScreen.issueProxyZombie' => '停止したポートに残留プロキシが転送しており、通信が遮断されています',
			'NetCheckScreen.suggestProxyReset' => '下の【システムプロキシのクリーンとリセット】をクリックして復旧してください',
			'NetCheckScreen.actionResetProxy' => 'プロキシをクリーン＆リセット',
			'NetCheckScreen.issueProxyBlocked' => 'システムプロキシが反映されません。セキュリティソフトや権限を確認してください',
			'NetCheckScreen.suggestProxyReapply' => '下のボタンをクリックしてシステムプロキシの強制適用をお試しください',
			'NetCheckScreen.actionReapplyProxy' => 'システムプロキシを再適用',
			'NetCheckScreen.issueProxyRead' => 'システムプロキシ設定の読み取り中に非致命的なエラーが発生しました',
			'NetCheckScreen.issueHandshakeBlocked' => '選択中のプロキシノードがインターネットに接続できません。通信が遮断されています',
			'NetCheckScreen.suggestHandshakeSwitch' => 'ノードがメンテナンス中または到達不能です。別のノードに切り替えてください',
			'NetCheckScreen.suggestHandshakeSlow' => ({required Object delay}) => 'ノード遅延が高めです (${delay} ms)。速度測定を行い近いノードを選択してください',
			'NetCheckScreen.suggestHandshakeCheck' => 'ノード設定を確認するか、測定先を変更してください',
			'NetCheckScreen.conclusionPerfect' => '全ルート良好！すべてのネットワークノードとプロキシ設定が正常です。',
			'NetCheckScreen.conclusionGood' => '全ルート概ね正常です。軽微な遅延や警告が検出されました。詳細をご確認ください。',
			'NetCheckScreen.conclusionWarning' => '一部のネットワークまたはプロキシに異常が検出されました。下の【一括修復】をお試しください。',
			'NetCheckScreen.conclusionCritical' => '重大なネットワーク遮断！ローカル回線が切断されているか、コアが阻害されています。',
			'SpeedTestScreen.title' => 'スピードテスト',
			'SpeedTestScreen.startTest' => 'テスト開始',
			'SpeedTestScreen.stopTest' => '停止',
			'SpeedTestScreen.reTest' => '再テスト',
			'SpeedTestScreen.ready' => '準備完了',
			'SpeedTestScreen.testingPing' => 'Ping & Jitter をテスト中...',
			'SpeedTestScreen.testingDownload' => 'ダウンロード速度をテスト中...',
			'SpeedTestScreen.testingUpload' => 'アップロード速度をテスト中...',
			'SpeedTestScreen.completed' => 'テスト完了',
			'SpeedTestScreen.stopped' => '停止しました',
			'SpeedTestScreen.ping' => 'Ping',
			'SpeedTestScreen.jitter' => 'Jitter',
			'SpeedTestScreen.download' => 'ダウンロード',
			'SpeedTestScreen.upload' => 'アップロード',
			'SpeedTestScreen.currentProxy' => '現在のプロキシ',
			'SpeedTestScreen.directConnection' => 'ダイレクト接続',
			'SpeedTestScreen.server' => '測定サーバー',
			'SpeedTestScreen.serverLocation' => 'サーバー位置',
			'SpeedTestScreen.realtimeSpeed' => 'リアルタイム速度グラフ',
			'SpeedTestScreen.peakSpeed' => 'ピーク速度',
			'SpeedTestScreen.avgSpeed' => '平均速度',
			'SpeedTestScreen.testHistory' => 'テスト履歴',
			'SpeedTestScreen.clearHistory' => '履歴をクリア',
			'VersionUpdateScreen.versionReady' => ({required Object p}) => '新しいバージョン [${p}] の準備ができました',
			'VersionUpdateScreen.update' => '再起動して更新',
			'VersionUpdateScreen.cancel' => '今はしない',
			'loginScreen.login' => 'ログイン',
			'loginScreen.register' => 'アカウント登録',
			'loginScreen.forgotPassword' => 'パスワードを忘れた',
			'loginScreen.provider' => 'プロバイダー',
			'loginScreen.providerName' => '${_root.loginScreen.provider}コード/別名/URL',
			'loginScreen.providerNameRequired' => '${_root.loginScreen.provider}コード/別名/URLを入力してください',
			'loginScreen.account' => 'アカウント',
			'loginScreen.accountRequired' => 'アカウントを入力してください',
			'loginScreen.email' => 'メール',
			'loginScreen.emailRequired' => 'メールアドレスを入力してください',
			'loginScreen.password' => 'パスワード',
			'loginScreen.passwordRequired' => 'パスワードを入力してください',
			'loginScreen.validEmailRequired' => '有効なメールアドレスを入力してください',
			'loginScreen.passwordMinLength' => ({required Object minLength}) => 'パスワード長は最低${minLength}文字以上である必要があります',
			'loginScreen.unsupportedProvider' => 'サポートされていない${_root.loginScreen.provider}',
			'loginScreen.unsupportedProviderType' => 'サポートされていない${_root.loginScreen.provider}タイプ',
			'loginScreen.unActivedProvider' => 'ログイン機能は有効化されていません',
			'loginScreen.providerLoginSupportRequired' => ({required Object p}) => 'プロバイダーのコード/別名は${_root.loginScreen.provider}にお問い合わせください。\n${_root.loginScreen.provider}連携は次をご参照ください: ${p}',
			'loginScreen.providerDisclaimer' => '免責事項:${_root.loginScreen.provider}はサードパーティサービスであり、本アプリとは無関係です',
			'loginScreen.createSessionFailed' => 'セッションの作成に失敗しました。プロバイダーまたはアカウントを確認してください',
			'main.tray.menuOpen' => '開く',
			'main.tray.menuExit' => '終了',
			'main.tray.coreDisconnected' => 'Wmimo · コア未起動',
			'main.tray.coreRunning' => 'Wmimo · コア実行中',
			'main.tray.startProxy' => 'プロキシ接続を開始',
			'main.tray.stopProxy' => 'プロキシ接続を切断',
			'main.tray.restartCore' => 'プロキシコアを再起動',
			'main.tray.systemProxyItem' => 'システムプロキシ',
			'main.tray.tunModeItem' => 'TUN モード',
			'main.tray.outboundMode' => 'アウトバウンドモード',
			'main.tray.modeRule' => 'ルールルーティング',
			'main.tray.modeGlobal' => 'グローバルプロキシ',
			'main.tray.modeDirect' => 'ダイレクト接続',
			'main.tray.profilesMenu' => 'サブスクリプション設定',
			'main.tray.updateAllProfiles' => 'すべてのサブスクリプションを更新',
			'main.tray.proxyNodes' => 'プロキシノード',
			'main.tray.tools' => 'ツール',
			'main.tray.copyProxyCmd' => 'ターミナルプロキシコマンドをコピー (CMD / Bash)',
			'main.tray.delayTestAll' => '全ノードの遅延速度を測定',
			'main.tray.openDashboard' => 'ダッシュボードを開く',
			'main.tray.resetSystemProxy' => 'ネットワーク修復/プロキシをリセット',
			'main.tray.copyCmdPowerShell' => 'PowerShell コマンド',
			'main.tray.copyCmdCmd' => 'CMD コマンド',
			'main.tray.copyCmdBash' => 'Bash/Zsh コマンド',
			'meta.enable' => '有効',
			'meta.disable' => '無効',
			'meta.open' => '開く',
			'meta.close' => '閉じる',
			'meta.quit' => '終了',
			'meta.add' => '追加',
			'meta.addSuccess' => '正常に追加されました',
			'meta.addFailed' => ({required Object p}) => '追加に失敗しました: ${p}',
			'meta.remove' => '削除',
			'meta.removeConfirm' => '本当に削除しますか？',
			'meta.edit' => '編集',
			'meta.view' => '表示',
			'meta.remark' => '備考',
			'meta.byDefault' => 'デフォルト',
			'meta.editRemark' => '備考を編集',
			'meta.more' => '詳細',
			'meta.tips' => '情報',
			'meta.selectAll' => 'すべて選択',
			'meta.copy' => 'コピー',
			'meta.paste' => '貼り付け',
			'meta.cut' => '切り取り',
			'meta.save' => '保存',
			'meta.ok' => 'OK',
			'meta.cancel' => 'キャンセル',
			'meta.faq' => 'よくある質問',
			'meta.doc' => 'ドキュメント',
			'meta.htmlTools' => 'HTMLツールセット',
			'meta.download' => 'ダウンロード',
			'meta.loading' => '読み込み中...',
			'meta.days' => '日',
			'meta.hours' => '時間',
			'meta.minutes' => '分',
			'meta.seconds' => '秒',
			'meta.milliseconds' => 'ミリ秒',
			'meta.protocol' => 'プロトコル',
			'meta.search' => '検索',
			'meta.custom' => 'カスタム',
			'meta.connect' => '接続',
			'meta.disconnect' => '切断',
			'meta.connected' => '接続済み',
			'meta.disconnected' => '切断済み',
			'meta.connecting' => '接続中',
			'meta.connectTimeout' => '接続タイムアウト',
			'meta.timeout' => 'タイムアウト',
			'meta.timeoutDuration' => 'タイムアウト時間',
			'meta.latency' => 'レイテンシ',
			'meta.latencyTest' => '遅延テスト',
			'meta.networkCheck' => 'ネットワーク診断',
			'meta.speedTest' => 'スピードテスト',
			'meta.language' => '言語',
			'meta.next' => '次へ',
			'meta.done' => '完了',
			'meta.apply' => '適用',
			'meta.refresh' => '更新',
			'meta.retry' => '再試行しますか？',
			'meta.update' => '更新',
			'meta.updateInterval' => '更新間隔',
			'meta.updateFailed' => ({required Object p}) => '更新に失敗しました: ${p}',
			'meta.updateInterval5mTips' => '最小: 5分',
			'meta.updateIntervalPreferByProfile' => 'プロバイダーの設定を優先',
			'meta.none' => 'なし',
			'meta.reset' => 'リセット',
			'meta.resetConfirm' => 'すべてのアプリ設定をリセットしてもよろしいですか？',
			'meta.resetSuccess' => 'アプリ設定が初期値にリセットされました',
			'meta.resetCoreConfirm' => 'コア設定と上書き設定をリセットしてもよろしいですか？',
			'meta.resetCoreSuccess' => 'コア設定が初期値にリセットされました',
			'meta.authentication' => '認証',
			'meta.submit' => '送信',
			'meta.user' => 'ユーザー',
			'meta.account' => 'アカウント',
			'meta.password' => 'パスワード',
			'meta.decryptPassword' => '複号化パスワード',
			'meta.required' => '必須',
			'meta.go' => '続行',
			'meta.sudoPassword' => 'sudo パスワード (TUNモードで必要)',
			'meta.other' => 'その他',
			'meta.dns' => 'DNS',
			'meta.url' => 'URL',
			'meta.urlInvalid' => '無効なURL',
			'meta.urlCannotEmpty' => 'リンクを空にすることはできません',
			'meta.urlTooLong' => 'URLが長すぎます (>8182)',
			'meta.copyUrl' => 'リンクをコピー',
			'meta.openUrl' => 'リンクを開く',
			'meta.shareUrl' => 'リンクを共有',
			'meta.coreSettingTips' => '注意：設定を変更した後、有効にするには再接続する必要があります',
			'meta.overwrite' => '上書き',
			'meta.overwriteCustom' => 'カスタム上書き',
			'meta.overwriteAppend' => '追加上書き',
			'meta.overwriteTips' => 'オリジナルプロファイル <- カスタム上書き <- アプリ上書き',
			'meta.noOverwrite' => '上書きしない',
			'meta.overwriteSettings' => '上書き設定',
			'meta.diversionTemplates' => 'ルーティングテンプレート',
			'meta.ruleProviders' => 'ルールセット (RuleSet)',
			'meta.ruleTemplates' => 'ルールテンプレート',
			'meta.proxyGroupsTemplates' => 'グループテンプレート',
			'meta.proxyGroups' => 'プロキシグループ',
			'meta.proxyNodeList' => 'プロキシノードリスト',
			'meta.proxyNodeFailure' => ({required Object p}) => '以下のプロキシノードは期限切れのため自動的に削除されました: ${p}',
			'meta.externalController' => '外部コントローラー',
			'meta.secret' => 'シークレット',
			'meta.tcpConcurrent' => 'TCP並行ハンドシェイク',
			'meta.globalClientFingerprint' => 'TLSグローバルフィンガープリント',
			'meta.allowLanAccess' => 'LANデバイスアクセス',
			'meta.mixedPort' => '混合プロキシポート',
			'meta.logLevel' => 'ログレベル',
			'meta.findProcessMode' => 'プロセスマッチングモード',
			'meta.tcpkeepAliveInterval' => 'TCPキープアライブ間隔',
			'meta.delayTestUrl' => '遅延テストURL',
			'meta.delayTestTimeout' => '遅延テストタイムアウト(ms)',
			'meta.tun' => 'TUN',
			'meta.ntp' => 'NTP',
			'meta.tls' => 'TLS',
			'meta.geo' => 'GEO',
			'meta.geoDownloadByProxy' => 'プロキシ経由でGeo RuleSetをダウンロード',
			'meta.geoRulesetTips' => 'Geosite/Geoipは対応するRuleSetに変換されます',
			'meta.asnNotSupportInIosTips' => 'iOSシステムのメモリ制限により、IP-ASNおよびSRC-IP-ASNルールはiOSでは無視されます。',
			'meta.sniffer' => 'スニッファー',
			'meta.userAgent' => 'UserAgent',
			'meta.launchAtStartup' => 'スタートアップ時に起動',
			'meta.launchAtStartupRunAsAdmin' => 'Wmimoを管理者として再起動してください',
			'meta.tunModeRunAsAdmin' => 'TUNモードにはシステム管理者権限が必要です。アプリを管理者として再起動してください',
			'meta.tunSwitchToSystemProxy' => '一時的に【システムプロキシモード】に切り替えて接続を続行しますか？',
			'meta.tunCreateAdapterFailedAdmin' => 'TUN 仮想ネットワークアダプターの作成に失敗しました: Access is denied。\nTUN モードには管理者権限が必要です。右クリックして【管理者として実行】を選択するか、メイン画面/コア設定で TUN モードをオフにしてシステムプロキシで接続してください。',
			'meta.portableMode' => 'ポータブルモード',
			'meta.portableModeDisableTips' => 'ポータブルモードを終了する必要がある場合は、[Wmimo]を終了し、[wmimo.exe]と同じディレクトリにある[portable]フォルダを手動で削除してください',
			'meta.systemProxy' => 'システムプロキシ',
			'meta.autoConnectAfterLaunch' => '起動後に自動接続',
			'meta.autoConnectAtBoot' => 'システム起動後に自動接続',
			'meta.autoConnectAtBootTips' => 'システムのサポートが必要です。一部のシステムでは[自動起動]を有効にする必要がある場合があります。',
			'meta.hideAfterLaunch' => '起動後にウィンドウを隠す',
			'meta.autoSetSystemProxy' => '接続時にシステムプロキシを自動設定',
			'meta.bypassSystemProxy' => 'システムプロキシをバイパスすることを許可するドメイン名',
			'meta.excludeFromRecent' => '[最近のタスク]から隠す',
			'meta.wakeLock' => 'スリープ防止',
			'meta.hideVpn' => 'VPNアイコンを隠す',
			'meta.hideVpnTips' => 'IPv6を有効にすると、この機能は失敗します',
			'meta.hideDockIcon' => 'Dockアイコンを隠す',
			'meta.showTrayTraffic' => 'トレイに通信量情報を表示',
			'meta.website' => 'ウェブサイト',
			'meta.homePage' => 'ホームページ',
			'meta.rule' => 'ルール',
			'meta.global' => 'グローバル',
			'meta.direct' => '直通',
			'meta.block' => 'ブロック',
			'meta.qrcode' => 'QRコード',
			'meta.qrcodeTooLong' => 'テキストが長すぎて表示できません',
			'meta.qrcodeShare' => 'QRコードを共有',
			'meta.textToQrcode' => 'テキストをQRコードに変換',
			'meta.qrcodeScan' => 'QRコードをスキャン',
			'meta.qrcodeScanResult' => 'スキャン結果',
			'meta.qrcodeScanFromImage' => '画像からスキャン',
			'meta.qrcodeScanFromClipboard' => 'クリップボードから読取',
			'meta.qrcodeRecognized' => 'QRコードを認識しました',
			'meta.qrcodeDropHint' => '上のボタンをクリックして画面キャプチャまたは画像を選択',
			'meta.confirmImport' => 'インポートを確認',
			'meta.reScan' => '再スキャン',
			'meta.qrcodeScanResultFailed' => '画像の解析に失敗しました。スクリーンショットが有効なQRコードであることを確認してください',
			'meta.qrcodeScanResultEmpty' => 'スキャン結果が空です',
			'meta.screenshot' => 'スクリーンショット',
			'meta.backupAndSync' => 'バックアップと同期',
			'meta.importSuccess' => 'インポート成功',
			'meta.rewriteConfirm' => 'このファイルは既存のローカル設定を上書きします。続行しますか？',
			'meta.importAndExport' => 'インポートとエクスポート',
			'meta.import' => 'インポート',
			'meta.importFromUrl' => 'URLからインポート',
			'meta.export' => 'エクスポート',
			'meta.send' => '送信',
			'meta.receive' => '受信',
			'meta.sendConfirm' => '送信を確認しますか？',
			'meta.continueConnectConfirm' => '接続を続行しますか？',
			'meta.termOfUse' => '利用規約',
			'meta.privacyPolicy' => 'プライバシーポリシー',
			'meta.log' => 'ログ',
			'meta.coreLog' => 'コアログ',
			'meta.core' => 'コア',
			'meta.help' => 'ヘルプ',
			'meta.tutorial' => 'チュートリアル',
			'meta.board' => 'ボード',
			'meta.boardOnline' => 'オンラインボードを使用',
			'meta.boardOnlineUrl' => 'オンラインボードURL',
			'meta.boardLocalPort' => 'ローカルボードポート',
			'meta.connections' => '接続',
			'meta.closeAllConnections' => 'すべての接続を閉じる',
			'meta.searchConnections' => '接続を検索 (ドメイン/IP/ルール/プロセス)',
			'meta.noFilterResults' => '一致する接続がありません',
			'meta.searchRules' => 'ルールを検索 (タイプ/ペイロード/プロキシ)',
			'meta.searchProfiles' => 'プロファイルを検索 (名前/URL/備考)',
			'meta.searchProxies' => 'プロキシを検索 (名前/地域/正規表現)',
			'meta.noMatchingProfiles' => '一致するプロファイルが見つかりません',
			'meta.rules' => 'ルーティングルール',
			'meta.clear' => 'クリア',
			'meta.copySuccess' => 'コピーしました',
			'meta.alwayOnVPN' => '常時接続',
			'meta.disableFontScaler' => 'フォントスケーリングを無効にする（再起動後に有効）',
			'meta.autoOrientation' => '画面に合わせて回転',
			'meta.restartTakesEffect' => '再起動後に有効',
			'meta.reconnectTakesEffect' => '再接続後に有効',
			'meta.runtimeProfile' => '実行時プロファイル',
			'meta.willCompleteAfterRebootInstall' => 'システム拡張機能のインストールを完了するには、デバイスを再起動してください',
			'meta.willCompleteAfterRebootUninstall' => 'システム拡張機能のアンインストールを完了するには、デバイスを再起動してください',
			'meta.requestNeedsUserApproval' => '1. [システム設定]-[プライバシーとセキュリティ]でWmimoによるシステム拡張機能のインストールを[許可]してください\n2. [システム設定]-[一般]-[ログイン項目と拡張機能]-[ネットワーク拡張機能]で[wmimoServiceSE]を有効にしてください\n完了後に再接続してください',
			'meta.FullDiskAccessPermissionRequired' => '[システム設定]-[プライバシーとセキュリティ]-[フルディスクアクセス]でwmimoServiceSEの権限を有効にし、再接続してください。',
			'meta.proxy' => 'プロキシ',
			'meta.theme' => 'テーマ',
			'meta.tvMode' => 'TVモード',
			'meta.autoUpdate' => '自動更新',
			'meta.updateChannel' => '自動更新チャンネル',
			'meta.onlineCustomerService' => 'オンラインカスタマーサポート',
			'meta.subscriptionChannel' => '購読チャンネル',
			'meta.hasNewVersion' => ({required Object p}) => 'バージョン ${p} に更新',
			'meta.autoDownloadPkg' => '更新パッケージを自動ダウンロード',
			'meta.devOptions' => '開発者オプション',
			'meta.joinUs' => 'コミュニティに参加',
			'meta.about' => 'このアプリについて',
			'meta.name' => '名前',
			'meta.version' => 'バージョン',
			'meta.notice' => 'お知らせ',
			'meta.sort' => '並べ替え',
			'meta.recommended' => 'おすすめ',
			'meta.innerError' => ({required Object p}) => '内部エラー: ${p}',
			'meta.share' => '共有',
			'meta.importFromClipboard' => 'クリップボードからインポート',
			'meta.exportToClipboard' => 'クリップボードにエクスポート',
			'meta.server' => 'サーバー',
			'meta.port' => 'ポート',
			'meta.donate' => '寄付',
			'meta.setting' => '設定',
			'meta.settingCore' => 'コア設定',
			'meta.settingApp' => 'アプリ設定',
			'meta.coreOverwrite' => 'コア上書き設定',
			'meta.iCloud' => 'iCloud',
			'meta.webdav' => 'Webdav',
			'meta.lanSync' => 'LAN同期',
			'meta.lanSyncNotQuitTips' => '同期が完了するまでこのインターフェースを終了しないでください',
			'meta.deviceNoSpace' => 'ディスク容量不足',
			'meta.hideSystemApp' => 'システムアプリを隠す',
			'meta.hideAppIcon' => 'アプリアイコンを隠す',
			'meta.openDir' => 'ファイルディレクトリを開く',
			'meta.type' => 'タイプ',
			'meta.fileChoose' => 'ファイルを選択',
			'meta.filePathCannotEmpty' => 'ファイルパスを空にすることはできません',
			'meta.fileNotExist' => ({required Object p}) => 'ファイルが存在しません: ${p}',
			'meta.fileTypeInvalid' => ({required Object p}) => '無効なファイルタイプ: ${p}',
			'meta.uwpExemption' => 'UWPネットワーク分離免除',
			'meta.getProfile' => 'サブスクリプションを取得',
			'meta.buyProfile' => 'サブスクリプションを購入',
			'meta.addProfile' => 'サブスクリプションを追加',
			'meta.myProfiles' => 'サブスクリプション設定',
			'meta.profileEdit' => 'サブスクリプション設定を編集',
			'meta.profileNeedActive' => '先にこのプロファイルを現在のプロファイルに設定し、接続/再接続してください',
			'meta.profileDownloadBackupChannel' => 'バックアップダウンロードチャネルを有効化',
			'meta.profileDownloadBackupChannelTips' => 'Wmimo が提供するプロキシダウンロードチャネル（情報は一切保存されません）',
			'meta.profileEditReloadAfterProfileUpdate' => 'プロファイル更新後にリロード',
			'meta.profileRulesAppendApplePush' => 'Appleプッシュ通知ルールを追加',
			'meta.profileRulesAppendProxyTips' => 'ルールは元の設定の [proxy-groups] 内で、タイプが [url-test] または [select] の最初のプロキシに自動設定されます',
			'meta.profileImport' => 'プロファイルファイルをインポート',
			'meta.profileAddUrlOrContent' => 'サブスクリプションURLを追加',
			'meta.profileUrlOrContent' => 'サブスクリプションURL / ノード内容',
			'meta.profileUrlOrContentHit' => 'サブスクリプションURLまたは内容 [必須]',
			'meta.profileUrlOrContentCannotEmpty' => 'サブスクリプションURLまたは内容は空にできません',
			'meta.overview' => '概要',
			'meta.trafficStats' => 'トラフィック統計',
			'meta.realtimeMonitor' => 'リアルタイム監視',
			'meta.realtimeUpload' => 'リアルタイム送信',
			'meta.realtimeDownload' => 'リアルタイム受信',
			'meta.sessionUpload' => '今回の送信',
			'meta.sessionDownload' => '今回の受信',
			'meta.planUsage' => 'プラン使用量',
			'meta.memoryUsage' => 'メモリ使用量',
			'meta.remaining' => '残り',
			'meta.expireTime' => '有効期限',
			'meta.tunMode' => 'TUN モード',
			'meta.daysAgo' => ({required Object p}) => '${p}日前',
			'meta.hoursAgo' => ({required Object p}) => '${p}時間前',
			'meta.lessThanOneHourAgo' => '1時間以内',
			'meta.inUse' => '使用中',
			'meta.remoteSubscription' => 'リモートサブスクリプション',
			'meta.noTrafficData' => '利用統計なし',
			'meta.localProfile' => 'ローカルファイル',
			'meta.viewYamlConfig' => 'YAML設定を表示',
			'meta.editYamlConfig' => 'YAML設定を編集',
			'meta.copySubscriptionUrl' => 'サブスクリプションURLをコピー',
			'meta.qrCode' => 'QRコード',
			'meta.deleteProfile' => '設定を削除',
			'meta.noProfilesYet' => 'サブスクリプション設定がありません',
			'meta.addProfilePrompt' => '右上の + をクリックしてURLを追加またはファイルをインポート',
			'meta.subscriptionUrlCopied' => 'サブスクリプションURLがクリップボードにコピーされました',
			'meta.autoGroupTip' => ({required Object group, required Object type}) => '「${group}」は ${type} 自動ポリシーグループです。システムが遅延/可用性に基づいて自動的にノードを選択します。手動で選択する場合は「ノード選択」グループで切り替えてください。',
			'meta.switchNodeFailed' => ({required Object p}) => 'ノードの切り替えに失敗しました: ${p}',
			'meta.nodeSelected' => ({required Object p}) => '選択されたノード: ${p}',
			'meta.startingCoreAndTesting' => 'コアを起動してレイテンシをテスト中...',
			'meta.chartMinutes' => ({required Object p}) => '${p} 分',
			'meta.chartUpload' => 'アップロード',
			'meta.chartDownload' => 'ダウンロード',
			'meta.author' => '作成者',
			'meta.githubRepo' => 'オープンソースリポジトリ',
			'meta.openSourceLicense' => 'オープンソースライセンス',
			'meta.submitFeedback' => 'フィードバックと問題の報告',
			'meta.copiedToClipboard' => 'クリップボードにコピーしました',
			'meta.autoScrollEnabled' => '自動スクロール有効',
			'meta.autoScrollDisabled' => '自動スクロール無効',
			'meta.pauseLogs' => 'リアルタイムログを一時停止',
			'meta.resumeLogs' => 'リアルタイムログを再開',
			'meta.scrollToLatest' => '最新までスクロール',
			'meta.scrollToBottom' => '最下部へスクロール',
			'meta.newLogsCount' => ({required Object p}) => '(${p} 件の新しいログ)',
			'meta.copiedLogContent' => 'ログ内容をコピーしました',
			'meta.copyLog' => 'ログをコピー',
			'meta.noLogsPrompt' => 'ログはまだありません。プロキシ起動後にリアルタイムログが表示されます。',
			_ => null,
		} ?? switch (path) {
			'meta.searchLogsHint' => ' (IP, ドメイン, ルール, エラー...)',
			'meta.offlinePreviewPrompt' => 'オフラインプレビュー中。プロキシを開始してルーティングと速度テストを有効化します。',
			'meta.manualSelect' => '手動選択',
			'meta.autoSelect' => '自動選択',
			'meta.speedTestGroup' => 'グループ速度テスト',
			'meta.pause' => '一時停止',
			'meta.resume' => '再開',
			'meta.ipInfo' => 'IP 情報',
			'meta.ipFetching' => 'IP情報を取得中...',
			'meta.ipCopied' => 'IPアドレスをクリップボードにコピーしました',
			'meta.ipLocation' => '位置',
			'meta.ipIsp' => 'プロバイダ',
			'meta.ipTapToFetch' => 'タップしてIP情報を取得',
			'meta.ipProxy' => 'プロキシ出口',
			'meta.ipDirect' => 'ローカル直結',
			'meta.ipAsn' => 'ASN',
			'meta.ipOrg' => '組織',
			'meta.ipTimezone' => 'タイムゾーン',
			'meta.ipCoordinates' => '座標',
			'meta.ipMoreDetails' => '詳細情報',
			'meta.ipLessDetails' => '折りたたむ',
			'meta.collapseAll' => 'すべてのグループを折りたたむ',
			'meta.expandAll' => 'すべてのグループを展開',
			'meta.donateTitle' => '💖 開発者にコーヒーをおごる',
			'meta.donateThankYou' => 'ฅ^•ﻌ•^ฅ 皆様のご支援が、Wmimoを磨き続ける最大の力になります ~ ☕✨',
			'meta.tokenCurrency' => '通貨',
			'meta.networkChain' => 'ネットワーク',
			'meta.depositAddress' => 'APTOS 受取先アドレス',
			'meta.clickToCopy' => 'クリックしてコピー',
			'meta.copyAddressBtn' => 'アドレスをコピー ✨',
			'meta.donateAddressCopied' => '( ੭ ˙ᗜ˙ )੭ アドレスをコピーしました！応援ありがとうございます~ 💖',
			'meta.donateTip' => '💡 ヒント：BybitまたはAptos互換ウォレットでのスキャンに対応',
			'meta.qrcodeParsing' => 'QRコードを解析中...',
			'meta.qrcodeNotFound' => 'QRコードが検出されませんでした',
			'meta.qrcodeSupportHint' => '各種サブスクリプション、ノード、設定QRコードの解析に対応',
			'meta.qrcodeCameraHint' => 'フレーム内にQRコードを合わせると自動でスキャンします',
			'meta.flashlight' => 'フラッシュ',
			'meta.screenshotDesc' => '画面キャプチャ',
			'meta.fromImageDesc' => '画像ファイル',
			'meta.fromClipboardDesc' => 'クリップボード',
			'meta.errorPrompt' => 'エラー',
			'meta.copied' => 'コピー完了',
			'meta.sortAndFilterNodes' => 'ノードの並べ替えと絞り込み',
			'meta.sortOptions' => '並べ替え',
			'meta.sortDefault' => 'デフォルト順',
			'meta.sortLatency' => '遅延順',
			'meta.sortName' => '名前順 (A-Z)',
			'meta.sortRegion' => '地域別グループ',
			'meta.filterOptions' => '絞り込みオプション',
			'meta.portableUpdateTip' => ({required Object version}) => 'ポータブル版を検出しました：\nポータブル版はアプリ内上書き更新に対応していません。公式サイトまたはリポジトリから最新のZIPをダウンロードして解凍・上書きしてください。\n\n最新バージョン: v${version}',
			'meta.portableModeTipTitle' => 'ポータブル版のヒント',
			'meta.noNodesToSpeedTest' => 'テスト可能なノードがありません',
			'meta.alreadyLatestVersion' => ({required Object version}) => '最新バージョンです (v${version})',
			'meta.checkUpdateFailed' => 'アップデート確認に失敗しました。ネットワーク接続を確認してください',
			'meta.hideTimeoutNodes' => 'タイムアウトおよび利用不可ノードを非表示',
			'meta.hideTimeoutNodesDesc' => 'テスト失敗またはタイムアウトしたノードを自動で非表示にします',
			'meta.speedtestScenario' => '現在のスピードテストシナリオ',
			'meta.speedtestScenarioSwitch' => 'スピードテストシナリオの切替',
			'meta.speedtestScenarioDesc' => '異なるサービスを選択して接続遅延と稼働状況をテスト',
			'meta.speedtestAllNodes' => '全ノード測定',
			'meta.retestTimeoutNodes' => 'タイムアウトノードのみ再測定',
			'meta.switchedTargetScenario' => ({required Object target}) => 'テストシナリオを切り替えました: ${target}',
			'meta.notTested' => '未測定',
			'meta.timeoutOrFailed' => 'タイムアウト / 接続不可',
			'meta.identifiedRegion' => '地域',
			'meta.nodeProtocol' => 'プロトコル',
			'meta.currentLatency' => '遅延',
			'meta.testScenario' => 'テストシナリオ',
			'meta.belongsToGroup' => 'グループ',
			'meta.copyNodeName' => '名前をコピー',
			'meta.nodeNameCopied' => 'ノード名をコピーしました',
			'meta.testSingleNode' => '個別テスト',
			'meta.selectThisNode' => 'このノードを選択',
			'meta.allNodesNormal' => 'すべてのノードが正常に動作しています。再テストは不要です',
			'meta.customUrlPrompt' => 'カスタムURL (例: http://...)',
			'meta.customTarget' => 'カスタムターゲット',
			'meta.downloadFailedTip' => 'インストーラーのダウンロードに失敗しました。ネットワークを確認するか、Webサイトからダウンロードしてください。',
			'meta.discoveredNewVersion' => ({required Object version}) => '新しいバージョンが見つかりました: v${version}',
			'meta.preparingUpdate' => 'アップデートの準備中...',
			'meta.downloadingPackage' => 'インストーラーをダウンロード中、しばらくお待ちください...',
			'meta.downloadUpdateNow' => '今すぐアップデートをダウンロード',
			'meta.downloadFromWeb' => 'Webサイトからダウンロード',
			'meta.switchSource' => '切替',
			'meta.serverSwitch' => '測定サーバーの切替',
			'meta.autoDetectBest' => '最適なサーバーを自動検出',
			'meta.serverSwitchDesc' => 'CDNまたはカスタムターゲットを選択して接続をテスト',
			'meta.autoSelectedBest' => ({required Object server, required Object ping}) => '最適なサーバーを選択しました: ${server} (${ping} ms)',
			'meta.networkGradeTitle' => 'ネットワーク総合評価',
			'meta.copyReport' => 'レポートをコピー',
			'meta.reportCopied' => 'レポートをコピーしました。共有できます',
			'meta.gamingExperience' => 'オンラインゲーム',
			'meta.streamingExperience' => '動画ストリーミング',
			'meta.meetingExperience' => 'ビデオ会議',
			'meta.customSpeedtestUrl' => 'カスタム測定URL (https://...)',
			'meta.customSpeedtestSource' => 'カスタム測定サーバー',
			'meta.userSpecifiedUrl' => 'ユーザー指定URL',
			'meta.cannotBeEmpty' => ({required Object item}) => '${item}を入力してください',
			'meta.alreadyExists' => ({required Object item}) => '${item}は既に存在します',
			'meta.installFailedWithCode' => ({required Object installer, required Object code}) => '${installer}のインストールに失敗しました (コード: ${code})',
			'meta.resetSystemProxy' => 'ネットワーク修復 / プロキシをリセット',
			'meta.resetSystemProxyDesc' => '残留したプロキシ設定をクリアし、異常終了後の接続問題を解決します',
			'meta.resetSystemProxySuccess' => 'システムプロキシがリセットされ、ネットワークが復旧しました',
			'meta.networkDiagnostics' => 'ネットワーク診断とスマート修復',
			'meta.networkDiagnosticsDesc' => 'NIC、DNS、コアポート、プロキシの正常性をワンクリックで診断・自動修復',
			'meta.sortLatencyDesc' => 'レイテンシ降順',
			'meta.sortNameDesc' => '名前 Z-A',
			'meta.sortMultiplier' => '倍率昇順',
			'meta.uwpLoopback' => 'UWP ループバック免除ツール',
			'meta.uwpLoopbackDesc' => 'Microsoft Store、Xbox、MinecraftなどのUWPアプリにローカルプロキシを許可',
			'meta.uwpExemptAllCommon' => '推奨アプリを一括免除',
			'meta.uwpApplySuccess' => 'UWPループバック免除ルールが適用されました',
			'meta.common' => '常用',
			'meta.exempted' => '免除済み',
			'meta.notExempted' => '未免除',
			'meta.deselectAll' => '全選択解除',
			'meta.userApps' => 'ユーザーアプリ',
			'meta.systemApps' => 'システムアプリ',
			'meta.selectedOnly' => '選択済み',
			'meta.proxySelectedMode' => '選択アプリのみプロキシ',
			'meta.proxySelectedModeDesc' => '選択したアプリのみプロキシを経由し、その他は直接接続します',
			'meta.bypassSelectedMode' => '選択アプリをバイパス',
			'meta.bypassSelectedModeDesc' => '選択したアプリは直接接続し、その他はプロキシを経由します',
			'meta.invertSelection' => '選択反転',
			'meta.all' => 'すべて',
			'meta.showAppIcon' => 'アプリアイコンを表示',
			'meta.proxySelection' => 'プロキシ選択',
			'meta.regionHk' => '🇭🇰 香港',
			'meta.regionJp' => '🇯🇵 日本',
			'meta.regionSg' => '🇸🇬 シンガポール',
			'meta.regionTw' => '🇹🇼 台湾',
			'meta.regionUs' => '🇺🇸 アメリカ',
			'meta.regionKr' => '🇰🇷 韓国',
			'meta.macMoveToApplications' => 'Wmimoを「アプリケーション」フォルダに移動してから起動してください',
			'meta.notifCurrentNode' => '現在のノード',
			'meta.notifMode' => '動作モード',
			'meta.notifPort' => 'ポート',
			'meta.notifProfile' => 'プロファイル',
			'meta.notifDisconnect' => '切断',
			'meta.notifSwitchNode' => 'ノード切替',
			'meta.notifVpnConnected' => 'VPN プロキシ接続中',
			'meta.connectionDetails' => '接続詳細',
			'meta.sourceAddress' => '送信元アドレス',
			'meta.destinationAddress' => '宛先アドレス',
			'meta.host' => 'ホスト名',
			'meta.process' => 'プロセス',
			'meta.processPath' => 'プロセスパス',
			'meta.proxyChain' => 'プロキシチェーン',
			'meta.networkProtocol' => 'プロトコル',
			'meta.trafficUpload' => 'アップロード量',
			'meta.trafficDownload' => 'ダウンロード量',
			'meta.connectionDuration' => '接続時間',
			'meta.connectionStart' => '開始時間',
			'meta.copyHost' => 'ホストをコピー',
			'meta.copyAllDetails' => '詳細をすべてコピー',
			'meta.closeThisConnection' => 'この接続を切断',
			'meta.sortByDownload' => 'ダウンロード順',
			'meta.sortByUpload' => 'アップロード順',
			'meta.sortBySpeed' => '速度順',
			'meta.sortByDuration' => '接続時間順',
			'meta.sortByHost' => 'ホスト順',
			'meta.realtimeSpeed' => 'リアルタイム速度',
			'meta.totalUpload' => '総アップロード',
			'meta.totalDownload' => '総ダウンロード',
			'meta.activeConnections' => 'アクティブ',
			'meta.openInFolder' => 'フォルダで表示',
			'meta.openProfilesDir' => '設定フォルダを開く',
			'meta.profilePatches' => 'プロファイル上書き',
			'meta.nodeCount' => ({required Object p}) => '${p} 個のノード',
			'meta.copyFilePath' => 'ファイルパスをコピー',
			'meta.duplicateProfile' => '複製を作成',
			'meta.useThisProfile' => 'このプロファイルを使用',
			'meta.websiteTest' => 'ウェブサイトテスト',
			'meta.testAll' => 'すべてテスト',
			'meta.addTestWebsite' => 'テストサイトを追加',
			'meta.websiteName' => 'サイト名',
			'meta.websiteUrl' => 'テスト URL',
			'meta.websiteNameHint' => 'サイト名 (例: Cloudflare)',
			'meta.websiteInputEmpty' => 'サイト名と URL を入力してください',
			'meta.autoRefresh' => '自動更新',
			'meta.currentProfile' => '現在のプロファイル',
			'meta.quickActions' => 'クイックツール',
			'meta.fastest' => '最低遅延',
			'meta.hideTimeout' => 'タイムアウト非表示',
			'meta.filteredTimeout' => 'タイムアウト除外済',
			'meta.tunDeviceCreateFailed' => 'TUN 仮想ネットワークアダプターの作成に失敗しました',
			'meta.test' => 'テスト',
			'meta.addWebsite' => 'サイトを追加',
			'meta.maxWebsitesReached' => '最大6つのテストWebサイトを追加できます',
			'meta.sideBySideLayout' => '並列レイアウト',
			'meta.sideBySideLayoutTips' => 'ワイド画面でホームカードとサブスクリプションリストを並列表示します',
			'meta.homeCardsManage' => 'ホームカード管理',
			'meta.homeCardsManageTips' => 'ホーム画面に表示するカードの表示・非表示をカスタマイズします',
			'meta.cardTrafficChart' => 'トラフィック統計グラフ',
			'meta.cardWebsiteTest' => 'ウェブサイト接続テスト',
			'meta.cardIpInfo' => 'IP・出口情報',
			'meta.cardSubscription' => 'プラン・有効期限情報',
			'meta.cardQuickActions' => 'クイックツール',
			'meta.resetDefaultCards' => 'デフォルトに戻す',
			'meta.collapseAllCards' => 'すべて折りたたむ',
			'meta.expandAllCards' => 'すべて展開',
			'permission.camera' => 'カメラ',
			'permission.screen' => '画面録画',
			'permission.appQuery' => 'アプリケーションリストを取得',
			'permission.request' => ({required Object p}) => '[${p}] 権限をオンにする',
			'permission.requestNeed' => ({required Object p}) => '[${p}] 権限をオンにしてください',
			'tls.insecure' => '証明書の検証をスキップ',
			'tls.certificate' => '証明書',
			'tls.privateKey' => '秘密鍵',
			'tls.customTrustCert' => 'カスタム証明書',
			'tun.stack' => 'ネットワークスタック',
			'tun.stackGvisor' => 'gVisor',
			'tun.stackGvisorDesc' => 'ユーザースペースのネットワークスタック、優れた安定性と互換性',
			'tun.stackSystem' => 'System',
			'tun.stackSystemDesc' => 'OSネイティブのネットワークスタック、高性能ですがシステム実装に依存',
			'tun.stackMixed' => 'Mixed',
			'tun.stackMixedDesc' => '混合スタックモード、パフォーマンスと互換性のバランス',
			'tun.stackMips' => 'MIPS (Mihomo IP Stack)',
			'tun.stackMipsDesc' => 'Mihomo独自開発の高性能IPスタック、高スループットと低遅延',
			'tun.inet4Address' => 'IPv4アドレス範囲',
			'tun.inet6Address' => 'IPv6アドレス範囲',
			'tun.dnsHijack' => 'DNSハイジャック',
			'tun.strictRoute' => '厳格なルート',
			'tun.tunDefaultRoute' => 'デフォルトルート',
			'tun.icmpForward' => 'ICMP転送',
			'tun.allowBypass' => 'アプリがVPNをバイパスすることを許可する',
			'tun.appendHttpProxy' => 'VPNにHTTPプロキシを追加する',
			'tun.bypassHttpProxyDomain' => 'HTTPプロキシをバイパスすることを許可するドメイン',
			'dns.listen' => 'リスニングアドレス',
			'dns.fakeIp' => 'fake-ip',
			'dns.fallback' => 'フォールバック',
			'dns.preferH3' => 'DoH H3を優先',
			'dns.useHosts' => 'Hostsを使用',
			'dns.useSystemHosts' => 'システムHostsを使用',
			'dns.enhancedMode' => '拡張モード',
			'dns.fakeIPFilterMode' => '${_root.dns.fakeIp} フィルターモード',
			'dns.fakeIPFilter' => '${_root.dns.fakeIp} フィルター',
			'dns.respectRules' => 'ルールを尊重する',
			'dns.nameServer' => 'ネームサーバー',
			'dns.defaultNameServer' => '${_root.meta.byDefault} ${_root.dns.nameServer}',
			'dns.proxyNameServer' => '${_root.meta.proxy} ${_root.dns.nameServer}',
			'dns.directNameServer' => '${_root.meta.direct} ${_root.dns.nameServer}',
			'dns.fallbackNameServer' => '${_root.dns.fallback} ${_root.dns.nameServer}',
			'dns.fallbackGeoIp' => '${_root.dns.fallback} GeoIp',
			'dns.fallbackGeoIpCode' => '${_root.dns.fallback} GeoIpCode',
			'dns.flushCache' => 'DNSキャッシュをクリア',
			'dns.flushCacheSuccess' => 'DNSとFake-IPキャッシュが正常にクリアされました',
			'dns.presets' => 'クイックDNSプリセット',
			'dns.presetSpeed' => '高速デュアルスタック',
			'dns.presetSpeedDesc' => 'AliDNS DoH3 + DNSPod DoH：国内は即時接続、海外はスマートルーティング',
			'dns.presetSecure' => '汚染防止＆プライバシーモード',
			'dns.presetSecureDesc' => 'Cloudflare DoH3 + Google DoH：ハイジャックと検閲を防止',
			'dns.presetAdGuard' => 'AdGuard 広告ブロック＆クリーン',
			'dns.presetAdGuardDesc' => 'AdGuard DoQ + AliDNS DoH：リクエストのフィルタリングと追跡防止',
			'dns.overwriteDesc' => 'プロファイル内のDNS設定を上書き',
			'dns.enableDesc' => 'カスタムDNSリゾルバを有効化',
			'dns.resetFakeIpFilter' => '初期値に戻す',
			'dns.resetFakeIpFilterConfirm' => '推奨されるFake-IPフィルタリストを復元しますか？',
			'dns.dnsTester' => 'DNSリアルタイム診断',
			'dns.testQuery' => 'テスト',
			'dns.fakeIpDetected' => 'Fake-IP ヒット',
			'dns.realIpDetected' => '実IPアドレス',
			'dns.addServer' => 'DNSサーバーを追加',
			'dns.geoAssetsTitle' => 'GEOオフラインデータベース',
			'dns.geoAssetsDesc' => 'GeoSiteドメインルール、GeoIPおよびASNデータベースの管理',
			'dns.cdnSource' => 'ダウンロードCDNミラー',
			'dns.updateAll' => 'すべて更新',
			'dns.updateSuccess' => '更新に成功しました',
			'dns.updateFailed' => '更新に失敗しました',
			'dns.addPresetServer' => 'プリセットDNSを追加',
			'dns.manageFakeIpFilter' => ({required Object p}) => 'フィルターリストを管理 (${p})',
			'dns.fakeIpFilterDesc' => ({required Object p}) => '${p} 個のドメインルールがFake-IP解決をバイパスし、ネットワーク分離問題を回避します。',
			'sniffer.overrideDest' => '上書き',
			'profilePatchMode.currentSelected' => '現在選択中',
			'profilePatchMode.overwrite' => '内蔵 - 上書き',
			'profilePatchMode.noOverwrite' => '内蔵 - 上書きなし',
			'protocolSniff' => 'プロトコル検知',
			'protocolSniffOverrideDestination' => '検知されたドメイン名で接続先アドレスを上書きする',
			'edgeRuntimeNotInstalled' => '現在のデバイスには Edge WebView2 ランタイムがインストールされていないため、ページを表示できません。Edge WebView2 ランタイム (x64) をダウンロードしてインストールし、アプリを再起動してからもう一度お試しください。',
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
