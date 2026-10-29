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
class TranslationsKo with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKo({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ko,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ko>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsKo _root = this; // ignore: unused_field

	@override 
	TranslationsKo $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKo(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$WelcomeLanguageScreen$ko WelcomeLanguageScreen = _Translations$WelcomeLanguageScreen$ko._(_root);
	@override late final _Translations$BackupAndSyncWebdavScreen$ko BackupAndSyncWebdavScreen = _Translations$BackupAndSyncWebdavScreen$ko._(_root);
	@override late final _Translations$LaunchFailedScreen$ko LaunchFailedScreen = _Translations$LaunchFailedScreen$ko._(_root);
	@override late final _Translations$PerAppAndroidScreen$ko PerAppAndroidScreen = _Translations$PerAppAndroidScreen$ko._(_root);
	@override late final _Translations$UserAgreementScreen$ko UserAgreementScreen = _Translations$UserAgreementScreen$ko._(_root);
	@override late final _Translations$NetCheckScreen$ko NetCheckScreen = _Translations$NetCheckScreen$ko._(_root);
	@override late final _Translations$SpeedTestScreen$ko SpeedTestScreen = _Translations$SpeedTestScreen$ko._(_root);
	@override late final _Translations$VersionUpdateScreen$ko VersionUpdateScreen = _Translations$VersionUpdateScreen$ko._(_root);
	@override late final _Translations$loginScreen$ko loginScreen = _Translations$loginScreen$ko._(_root);
	@override late final _Translations$main$ko main = _Translations$main$ko._(_root);
	@override late final _Translations$meta$ko meta = _Translations$meta$ko._(_root);
	@override late final _Translations$permission$ko permission = _Translations$permission$ko._(_root);
	@override late final _Translations$tls$ko tls = _Translations$tls$ko._(_root);
	@override late final _Translations$tun$ko tun = _Translations$tun$ko._(_root);
	@override late final _Translations$dns$ko dns = _Translations$dns$ko._(_root);
	@override late final _Translations$sniffer$ko sniffer = _Translations$sniffer$ko._(_root);
	@override late final _Translations$profilePatchMode$ko profilePatchMode = _Translations$profilePatchMode$ko._(_root);
	@override String get protocolSniff => '프로토콜 스니핑';
	@override String get protocolSniffOverrideDestination => '스니핑된 도메인 이름으로 연결 대상 주소 덮어쓰기';
	@override String get edgeRuntimeNotInstalled => '현재 장치에 Edge WebView2 런타임이 설치되어 있지 않아 페이지를 표시할 수 없습니다. Edge WebView2 런타임(x64)을 다운로드하여 설치하고 앱을 다시 시작한 후 다시 시도하십시오。';
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
class _Translations$WelcomeLanguageScreen$ko implements Translations$WelcomeLanguageScreen$en {
	_Translations$WelcomeLanguageScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => 'Wmimo에 오신 것을 환영합니다';
	@override String get selectLanguage => '언어 선택';
	@override String get subtitle => '원하시는 언어를 선택해 주세요. 설정에서 언제든지 변경할 수 있습니다.';
	@override String get start => '시작하기';
}

// Path: BackupAndSyncWebdavScreen
class _Translations$BackupAndSyncWebdavScreen$ko implements Translations$BackupAndSyncWebdavScreen$en {
	_Translations$BackupAndSyncWebdavScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get webdavServerUrl => '서버 URL';
	@override String get webdavRequired => '비워둘 수 없습니다';
	@override String get webdavLoginFailed => '로그인 실패:';
	@override String get webdavListFailed => '파일 목록을 가져오지 못했습니다:';
}

// Path: LaunchFailedScreen
class _Translations$LaunchFailedScreen$ko implements Translations$LaunchFailedScreen$en {
	_Translations$LaunchFailedScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get invalidProcess => '앱 시작 실패 [유효하지 않은 프로세스 이름], 앱을 별도의 디렉토리에 다시 설치하십시오';
	@override String get invalidProfile => '앱 시작 실패 [프로필 액세스 실패], 앱을 다시 설치하십시오';
	@override String get invalidVersion => '앱 시작 실패 [유효하지 않은 버전], 앱을 다시 설치하십시오';
	@override String get systemVersionLow => '앱 시작 실패 [시스템 버전이 너무 낮음]';
	@override String get invalidInstallPath => '설치 경로가 유효하지 않습니다. 유효한 경로에 다시 설치하십시오';
}

// Path: PerAppAndroidScreen
class _Translations$PerAppAndroidScreen$ko implements Translations$PerAppAndroidScreen$en {
	_Translations$PerAppAndroidScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '앱별 프록시';
	@override String get whiteListMode => '화이트리스트 모드';
	@override String get whiteListModeTip => '활성화 시: 체크된 앱만 프록시됩니다. 비활성화 시: 체크되지 않은 앱만 프록시됩니다';
	@override String get manualAddPackage => '패키지 이름 직접 추가';
	@override String get manualAddPackageHint => '프록시할 패키지 이름을 입력하세요 (공백, 쉼표 또는 줄바꿈으로 구분하여 여러 개 지원, 예: org.telegram.messenger, com.google.android.youtube):';
	@override String get quickAddPresets => '자주 쓰는 프록시 앱 빠른 추가';
	@override String get saveSelected => '선택 항목 저장';
	@override String get permissionRestrictedTip => '시스템에서 앱 목록 읽기가 제한되었습니다. 아래 【시스템 권한 설정 열기】를 눌러 앱 목록 접근 권한을 허용하거나 권한이 필요 없는 프리셋을 사용하세요.';
	@override String get openSystemPermission => '시스템 권한 설정으로 이동';
	@override String get presetApps => '자주 쓰는 앱 빠른 추가 (권한 불필요 프리셋)';
	@override String get requestPermissionPopup => '권한 요청 (시스템 팝업)';
}

// Path: UserAgreementScreen
class _Translations$UserAgreementScreen$ko implements Translations$UserAgreementScreen$en {
	_Translations$UserAgreementScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get privacyFirst => '개인 정보 보호 우선';
	@override String get agreeAndContinue => '동의 및 계속';
}

// Path: NetCheckScreen
class _Translations$NetCheckScreen$ko implements Translations$NetCheckScreen$en {
	_Translations$NetCheckScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '네트워크 진단 및 복구';
	@override String get fullDiagnosticsTab => '파이프라인 진단';
	@override String get advancedCheckTab => '고급 도메인 쿼리';
	@override String get startDiagnostics => '진단 시작';
	@override String get reDiagnostics => '재진단';
	@override String get diagnosing => '네트워크 경로 진단 중...';
	@override String get healthScore => '상태 점수';
	@override String get scorePerfect => '매우 우수';
	@override String get scoreGood => '양호';
	@override String get scoreWarning => '경고 발생';
	@override String get scoreCritical => '연결 차단';
	@override String get oneClickRepair => '원클릭 스마트 자동 복구';
	@override String get repairSuccess => '자동 복구가 완료되었으며 네트워크가 정상 복원되었습니다';
	@override String get repairFailed => '복구가 적용되었습니다. 일부 항목을 수동 확인하세요';
	@override String get repairing => '자동 복구 실행 중...';
	@override String issueFound({required Object count}) => '${count} 개 이상 감지';
	@override String get noIssue => '모든 검사 통과';
	@override String get details => '상세 로그';
	@override String get copyDetails => '로그 복사';
	@override String get detailsCopied => '진단 로그가 클립보드에 복사되었습니다';
	@override String get stepPhysical => '물리 랜카드 및 게이트웨이';
	@override String get stepDns => 'DNS 확인 및 Fake-IP';
	@override String get stepCore => '코어 프로세스 및 포트';
	@override String get stepProxy => '시스템 프록시 설정';
	@override String get stepHandshake => '인터넷 엔드투엔드 핸드셰이크';
	@override String get suggestedAction => '해결 제안';
	@override String get autoRepairAction => '지금 복구';
	@override String get enterDomain => '도메인 이름을 입력하세요';
	@override String get checking => '확인 중...';
	@override String aQueryFailed({required Object p}) => 'A 레코드 조회 실패: ${p}';
	@override String aaaaQueryFailed({required Object p}) => 'AAAA 레코드 조회 실패: ${p}';
	@override String get success => '성공';
	@override String get failed => '실패';
	@override String get suspectedPollution => 'DNS 오염 의심';
	@override String get domainLabel => '도메인';
	@override String get checkButton => '진단';
	@override String get dnsSection => '1. DNS 조회';
	@override String get directHttpSection => '2. HTTP (TUN 경유, 먼저 TUN을 활성화하세요)';
	@override String proxyHttpSection({required Object p}) => '3. HTTP (프록시 경유, 포트: ${p})';
	@override String get tunNotEnabled => 'TUN이 활성화되지 않았습니다';
	@override String get routeTableSection => '4. 라우팅 테이블';
	@override String get stepPhysicalDesc => '물리적 네트워크 카드, 로컬 IP 및 게이트웨이 연결 상태를 확인합니다';
	@override String get stepDnsDesc => '로컬 DNS 확인 지연 시간 및 코어 DNS 응답 상태를 확인합니다';
	@override String get stepCoreDesc => 'Mihomo 프로세스 상태 및 Mixed-Port/API 포트 수신 대기를 확인합니다';
	@override String get stepProxyDesc => '시스템 프록시 설정 일치 여부 및 잔류 프록시로 인한 네트워크 차단을 점검합니다';
	@override String get stepHandshakeDesc => '활성 프록시 노드를 통해 글로벌 CDN으로의 종단 간 지연 시간과 연결성을 측정합니다';
	@override String get shortStepPhysical => '랜카드';
	@override String get shortStepDns => 'DNS';
	@override String get shortStepCore => '코어';
	@override String get shortStepProxy => '프록시';
	@override String get shortStepHandshake => '공용망';
	@override String valNicNormal({required Object p}) => '네트워크 연결 정상 (${p})';
	@override String get valNicNone => '사용 가능한 네트워크 인터페이스를 찾을 수 없습니다';
	@override String get valNicGatewayTimeout => '로컬 IP는 할당되었으나 외부 게이트웨이 응답 시간이 초과되었습니다';
	@override String get valNicError => '네트워크 인터페이스 확인 오류';
	@override String valDnsNormal({required Object p}) => 'DNS 응답 정상 (${p})';
	@override String get valDnsEmpty => 'DNS 쿼리가 빈 목록을 반환했습니다';
	@override String get valDnsTimeout => 'DNS 쿼리 시간 초과 또는 실패';
	@override String valCoreNormal({required Object port, required Object mode}) => '코어 정상 작동 중 (혼합 포트: ${port}, 모드: ${mode})';
	@override String get valCoreNotRunning => '코어 서비스가 실행 중이지 않습니다';
	@override String valCorePortConflict({required Object p}) => '포트 ${p}이(가) 다른 프로그램에 의해 사용 중입니다';
	@override String get valCoreApiFailed => '코어 프로세스 응답 없음 (API 통신 실패)';
	@override String get valCoreError => '코어 검사 오류';
	@override String valProxyActive({required Object port}) => '시스템 프록시 적용됨 (127.0.0.1:${port})';
	@override String get valProxyDisabled => '시스템 프록시 비활성화됨 (직접 연결 / TUN / 수동 모드)';
	@override String get valProxyZombie => '잔류 시스템 프록시 감지됨 (인터넷 연결 끊김 원인)';
	@override String get valProxyFailed => '시스템 프록시를 활성화하지 못했습니다';
	@override String get valProxyWarning => '시스템 프록시 상태 읽기 경고';
	@override String valHandshakeNormal({required Object node, required Object delay}) => '공용망 핸드셰이크 정상 (${node} • ${delay} ms)';
	@override String valHandshakeFailed({required Object node, required Object err}) => '현재 노드 [${node}] 핸드셰이크 실패 (${err})';
	@override String get valHandshakeSkipped => '코어가 실행되지 않아 공용망 테스트를 건너뜁니다';
	@override String get valHandshakeError => '공용망 핸드셰이크 오류 발생';
	@override String get issueNicDisconnected => '네트워크 카드가 연결되지 않았습니다 (랜선 분리, Wi-Fi 미연결 또는 비행기 탑승 모드)';
	@override String get suggestNicCheck => '이더넷 케이블, Wi-Fi 연결 또는 네트워크 어댑터 상태를 확인하세요';
	@override String get suggestNicReset => '시스템 설정에서 네트워크 어댑터를 사용 안 함으로 설정한 후 다시 사용해 보세요';
	@override String get issueNicGatewayUnreachable => 'LAN에 연결되었으나 외부 게이트웨이에 접근할 수 없습니다 (인증 필요 또는 공유기 인터넷 끊김)';
	@override String get suggestNicGateway => '공유기 상태를 확인하거나 브라우저를 열어 웹 로그인 인증이 필요한지 확인하세요';
	@override String get issueDnsPollution => '로컬 DNS 서비스가 응답하지 않습니다. DNS 오염 또는 하이재킹 가능성이 있습니다';
	@override String get suggestDnsReset => '시스템 DNS를 재설정하거나 Wmimo에서 스마트 암호화 DNS(DoH/DoT)를 활성화하세요';
	@override String get actionFlushDns => '시스템 DNS 캐시 새로고침';
	@override String get suggestDnsSlow => 'DNS 응답 시간이 지연되고 있습니다. 스마트 암호화 DNS를 활성화하는 것을 권장합니다';
	@override String get issueDnsFailed => '로컬 DNS 확인 실패, 도메인 이름을 IP 주소로 변환할 수 없습니다';
	@override String get suggestDnsFlush => 'DNS 캐시를 새로고침하거나 Wmimo 설정에서 암호화 DNS를 활성화하세요';
	@override String get issueCorePortConflict => '포트 충돌 감지됨! 다른 프록시 소프트웨어나 서비스가 해당 포트를 사용 중입니다';
	@override String get suggestCoreChangePort => '다른 프록시 프로그램을 완전히 종료하거나 Wmimo 설정에서 포트를 변경하세요';
	@override String get actionRestartCore => '코어 재시작';
	@override String get issueCoreStopped => 'Wmimo 코어 프로세스가 현재 중지 상태입니다';
	@override String get suggestCoreStart => '홈 화면의 연결 스위치를 누르거나 아래의 [코어 시작]을 누르세요';
	@override String get actionStartCore => '코어 프로세스 시작';
	@override String get issueCoreFrozen => '코어 프로세스가 응답하지 않거나 API 인증 정보가 일치하지 않습니다';
	@override String get suggestCoreRestart => '[코어 재시작]을 클릭하여 서비스를 복구하세요';
	@override String get suggestCoreReinstall => '코어를 재시작하거나 서비스 드라이버를 재설치해 보세요';
	@override String get issueProxyZombie => '잔류 시스템 프록시가 비활성 포트로 트래픽을 전달하여 인터넷이 차단되었습니다';
	@override String get suggestProxyReset => '아래의 [시스템 프록시 정리 및 재설정]을 클릭하여 즉시 인터넷을 복구하세요';
	@override String get actionResetProxy => '프록시 정리 및 재설정';
	@override String get issueProxyBlocked => '시스템 프록시가 적용되지 않았습니다. 백신 프로그램의 차단이나 권한 제한일 수 있습니다';
	@override String get suggestProxyReapply => '아래 버튼을 눌러 시스템 프록시를 강제로 다시 적용해 보세요';
	@override String get actionReapplyProxy => '시스템 프록시 다시 적용';
	@override String get issueProxyRead => '시스템 프록시 설정을 읽는 중 경미한 예외가 발생했습니다';
	@override String get issueHandshakeBlocked => '선택된 프록시 노드가 인터넷에 연결할 수 없습니다. 연결이 차단되었을 수 있습니다';
	@override String get suggestHandshakeSwitch => '해당 노드가 점검 중이거나 연결할 수 없습니다. 다른 노드로 전환해 주세요';
	@override String suggestHandshakeSlow({required Object delay}) => '노드 지연 시간이 다소 높습니다 (${delay} ms). 속도 측정을 통해 더 가까운 노드를 선택하세요';
	@override String get suggestHandshakeCheck => '노드 설정을 확인하거나 테스트 대상을 변경하세요';
	@override String get conclusionPerfect => '전체 네트워크 최상! 모든 노드와 프록시 설정이 원활하게 연결되어 있습니다.';
	@override String get conclusionGood => '네트워크가 대체로 정상입니다. 경미한 지연이나 경고가 감지되었으니 상세 정보를 확인하세요.';
	@override String get conclusionWarning => '일부 네트워크 또는 프록시에 이상이 감지되었습니다. 아래의 [원클릭 복구]를 이용해 보세요.';
	@override String get conclusionCritical => '심각한 네트워크 차단! 로컬 네트워크가 끊겼거나 프록시 코어가 차단되었습니다.';
}

// Path: SpeedTestScreen
class _Translations$SpeedTestScreen$ko implements Translations$SpeedTestScreen$en {
	_Translations$SpeedTestScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get title => '속도 측정';
	@override String get startTest => '측정 시작';
	@override String get stopTest => '중지';
	@override String get reTest => '다시 측정';
	@override String get ready => '준비 완료';
	@override String get testingPing => 'Ping & 지터 측정 중...';
	@override String get testingDownload => '다운로드 속도 측정 중...';
	@override String get testingUpload => '업로드 속도 측정 중...';
	@override String get completed => '측정 완료';
	@override String get stopped => '중지됨';
	@override String get ping => '지연 시간';
	@override String get jitter => '지터';
	@override String get download => '다운로드';
	@override String get upload => '업로드';
	@override String get currentProxy => '현재 프록시';
	@override String get directConnection => '직접 연결';
	@override String get server => '측정 서버';
	@override String get serverLocation => '서버 위치';
	@override String get realtimeSpeed => '실시간 속도 그래프';
	@override String get peakSpeed => '최대 속도';
	@override String get avgSpeed => '평균 속도';
	@override String get testHistory => '측정 기록';
	@override String get clearHistory => '기록 삭제';
}

// Path: VersionUpdateScreen
class _Translations$VersionUpdateScreen$ko implements Translations$VersionUpdateScreen$en {
	_Translations$VersionUpdateScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String versionReady({required Object p}) => '새 버전 [${p}]이 준비되었습니다';
	@override String get update => '업데이트를 위해 재시작';
	@override String get cancel => '나중에';
}

// Path: loginScreen
class _Translations$loginScreen$ko implements Translations$loginScreen$en {
	_Translations$loginScreen$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get login => '로그인';
	@override String get register => '계정 가입';
	@override String get forgotPassword => '비밀번호 찾기';
	@override String get provider => '서비스 제공자';
	@override String get providerName => '${_root.loginScreen.provider} 코드/별칭/URL';
	@override String get providerNameRequired => '${_root.loginScreen.provider} 코드/별칭/URL을 입력하세요';
	@override String get account => '계정';
	@override String get accountRequired => '계정을 입력하세요';
	@override String get email => '이메일';
	@override String get emailRequired => '이메일 주소를 입력하세요';
	@override String get password => '비밀번호';
	@override String get passwordRequired => '비밀번호를 입력하세요';
	@override String get validEmailRequired => '유효한 이메일 주소를 입력하세요';
	@override String passwordMinLength({required Object minLength}) => '비밀번호 길이는 최소 ${minLength}자 이상이어야 합니다';
	@override String get unsupportedProvider => '지원되지 않는 ${_root.loginScreen.provider}';
	@override String get unsupportedProviderType => '지원되지 않는 ${_root.loginScreen.provider} 유형';
	@override String get unActivedProvider => '로그인 기능이 활성화되어 있지 않습니다';
	@override String providerLoginSupportRequired({required Object p}) => '공급자 코드/별칭은 ${_root.loginScreen.provider}에 문의해 주세요.\n${_root.loginScreen.provider} 연동은 다음을 참고하세요: ${p}';
	@override String get providerDisclaimer => '면책 조항: ${_root.loginScreen.provider}는 제3자 서비스이며, 본 앱과는 무관합니다';
	@override String get createSessionFailed => '세션 생성 실패, 제공업체 또는 계정을 확인하세요';
}

// Path: main
class _Translations$main$ko implements Translations$main$en {
	_Translations$main$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override late final _Translations$main$tray$ko tray = _Translations$main$tray$ko._(_root);
}

// Path: meta
class _Translations$meta$ko implements Translations$meta$en {
	_Translations$meta$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get enable => '활성화';
	@override String get disable => '비활성화';
	@override String get open => '열기';
	@override String get close => '닫기';
	@override String get quit => '종료';
	@override String get add => '추가';
	@override String get addSuccess => '성공적으로 추가되었습니다';
	@override String addFailed({required Object p}) => '추가 실패: ${p}';
	@override String get remove => '제거';
	@override String get removeConfirm => '정말로 삭제하시겠습니까?';
	@override String get edit => '편집';
	@override String get view => '보기';
	@override String get remark => '메모';
	@override String get byDefault => '기본값';
	@override String get editRemark => '메모 편집';
	@override String get more => '더 보기';
	@override String get tips => '정보';
	@override String get selectAll => '전체 선택';
	@override String get copy => '복사';
	@override String get paste => '반죽';
	@override String get cut => '자르다';
	@override String get save => '저장';
	@override String get ok => '확인';
	@override String get cancel => '취소';
	@override String get faq => '자주 묻는 질문';
	@override String get doc => '문서';
	@override String get htmlTools => 'HTML 툴셋';
	@override String get download => '다운로드';
	@override String get loading => '로드 중...';
	@override String get days => '일';
	@override String get hours => '시간';
	@override String get minutes => '분';
	@override String get seconds => '초';
	@override String get milliseconds => '밀리초';
	@override String get protocol => '프로토콜';
	@override String get search => '검색';
	@override String get custom => '사용자 정의';
	@override String get connect => '연결';
	@override String get disconnect => '연결 해제';
	@override String get connected => '연결됨';
	@override String get disconnected => '연결 해제됨';
	@override String get connecting => '연결 중';
	@override String get connectTimeout => '연결 시간 초과';
	@override String get timeout => '시간 초과';
	@override String get timeoutDuration => '시간 초과 기간';
	@override String get latency => '지연 시간';
	@override String get latencyTest => '지연 속도 테스트';
	@override String get networkCheck => '네트워크 점검';
	@override String get speedTest => '속도 측정';
	@override String get language => '언어';
	@override String get next => '다음';
	@override String get done => '완료';
	@override String get apply => '적용';
	@override String get refresh => '새로고침';
	@override String get retry => '다시 시도하시겠습니까?';
	@override String get update => '업데이트';
	@override String get updateInterval => '업데이트 간격';
	@override String updateFailed({required Object p}) => '업데이트 실패: ${p}';
	@override String get updateInterval5mTips => '최소: 5분';
	@override String get updateIntervalPreferByProfile => '공급자 설정 우선';
	@override String get none => '없음';
	@override String get reset => '초기화';
	@override String get resetConfirm => '모든 앱 설정을 초기화하시겠습니까?';
	@override String get resetSuccess => '앱 설정이 기본값으로 초기화되었습니다';
	@override String get resetCoreConfirm => '코어 설정 및 덮어쓰기 구성을 초기화하시겠습니까?';
	@override String get resetCoreSuccess => '코어 설정이 기본값으로 초기화되었습니다';
	@override String get authentication => '인증';
	@override String get submit => '제출';
	@override String get user => '사용자';
	@override String get account => '계정';
	@override String get password => '비밀번호';
	@override String get decryptPassword => '복호화 비밀번호';
	@override String get required => '필수';
	@override String get go => '계속';
	@override String get sudoPassword => 'sudo 비밀번호 (TUN 모드에 필요)';
	@override String get other => '기타';
	@override String get dns => 'DNS';
	@override String get url => 'URL';
	@override String get urlInvalid => '유효하지 않은 URL';
	@override String get urlCannotEmpty => '링크는 비워둘 수 없습니다';
	@override String get urlTooLong => 'URL이 너무 깁니다 (>8182)';
	@override String get copyUrl => '링크 복사';
	@override String get openUrl => '링크 열기';
	@override String get shareUrl => '링크 공유';
	@override String get coreSettingTips => '참고: 설정을 수정한 후 적용하려면 다시 연결해야 합니다';
	@override String get overwrite => '덮어쓰기';
	@override String get overwriteCustom => '사용자 정의 덮어쓰기';
	@override String get overwriteAppend => '추가 덮어쓰기';
	@override String get overwriteTips => '원본 프로필 <- 사용자 정의 덮어쓰기 <- 앱 덮어쓰기';
	@override String get noOverwrite => '덮어쓰지 않음';
	@override String get overwriteSettings => '덮어쓰기 설정';
	@override String get diversionTemplates => '분류 템플릿';
	@override String get ruleProviders => '규칙 세트 (RuleSet)';
	@override String get ruleTemplates => '규칙 템플릿';
	@override String get proxyGroupsTemplates => '그룹 템플릿';
	@override String get proxyGroups => '프록시 그룹';
	@override String get proxyNodeList => '프록시 노드 목록';
	@override String proxyNodeFailure({required Object p}) => '다음 프록시 노드가 만료되어 자동으로 제거되었습니다: ${p}';
	@override String get externalController => '외부 컨트롤러';
	@override String get secret => '비밀번호(Secret)';
	@override String get tcpConcurrent => 'TCP 동시 핸드셰이크';
	@override String get globalClientFingerprint => 'TLS 글로벌 핑거프린트';
	@override String get allowLanAccess => 'LAN 장치 액세스';
	@override String get mixedPort => '혼합 프록시 포트';
	@override String get logLevel => '로그 레벨';
	@override String get findProcessMode => '프로세스 매칭 모드';
	@override String get tcpkeepAliveInterval => 'TCP Keep-alive 간격';
	@override String get delayTestUrl => '지연 테스트 URL';
	@override String get delayTestTimeout => '지연 테스트 시간 초과(ms)';
	@override String get tun => 'TUN';
	@override String get ntp => 'NTP';
	@override String get tls => 'TLS';
	@override String get geo => 'GEO';
	@override String get geoDownloadByProxy => '프록시를 통해 Geo RuleSet 다운로드';
	@override String get geoRulesetTips => 'Geosite/Geoip는 해당 RuleSet으로 변환됩니다';
	@override String get asnNotSupportInIosTips => 'iOS 시스템 메모리 제한으로 인해 IP-ASN 및 SRC-IP-ASN 규칙은 iOS에서 무시됩니다.';
	@override String get sniffer => '스니퍼';
	@override String get userAgent => 'UserAgent';
	@override String get launchAtStartup => '시작 시 실행';
	@override String get launchAtStartupRunAsAdmin => 'Wmimo를 관리자 권한으로 다시 시작하십시오';
	@override String get tunModeRunAsAdmin => 'TUN 모드는 시스템 관리자 권한이 필요합니다. 앱을 관리자 권한으로 다시 시작하십시오';
	@override String get tunSwitchToSystemProxy => '임시로 [시스템 프록시 모드]로 전환하여 계속 연결하시겠습니까?';
	@override String get tunCreateAdapterFailedAdmin => 'TUN 가상 네트워크 어댑터 생성 실패: Access is denied.\nTUN 모드는 관리자 권한이 필요합니다. 마우스 우클릭 후 【관리자 권한으로 실행】을 선택하거나, 메인 화면/코어 설정에서 TUN 모드를 끄고 시스템 프록시를 사용하여 연결하십시오.';
	@override String get portableMode => '포터블 모드';
	@override String get portableModeDisableTips => '포터블 모드를 종료해야 하는 경우 [Wmimo]를 종료하고 [wmimo.exe]와 동일한 디렉토리에 있는 [portable] 폴더를 수동으로 삭제하십시오';
	@override String get systemProxy => '시스템 프록시';
	@override String get autoConnectAfterLaunch => '실행 후 자동 연결';
	@override String get autoConnectAtBoot => '시스템 시작 후 자동 연결';
	@override String get autoConnectAtBootTips => '시스템 지원이 필요합니다. 일부 시스템에서는 [자동 시작]을 활성화해야 할 수도 있습니다.';
	@override String get hideAfterLaunch => '실행 후 창 숨기기';
	@override String get autoSetSystemProxy => '연결 시 시스템 프록시 자동 설정';
	@override String get bypassSystemProxy => '시스템 프록시를 우회하도록 허용된 도메인 이름';
	@override String get excludeFromRecent => '[최근 작업]에서 숨기기';
	@override String get wakeLock => '절전 모드 방지';
	@override String get hideVpn => 'VPN 아이콘 숨기기';
	@override String get hideVpnTips => 'IPv6를 활성화하면 이 기능이 작동하지 않습니다';
	@override String get hideDockIcon => 'Dock 아이콘 숨기기';
	@override String get showTrayTraffic => '트레이에 트래픽 정보 표시';
	@override String get website => '웹사이트';
	@override String get homePage => '홈페이지';
	@override String get rule => '규칙';
	@override String get global => '글로벌';
	@override String get direct => '직접 연결';
	@override String get block => '차단';
	@override String get qrcode => 'QR 코드';
	@override String get qrcodeTooLong => '텍스트가 너무 길어 표시할 수 없습니다';
	@override String get qrcodeShare => 'QR 코드 공유';
	@override String get textToQrcode => '텍스트를 QR 코드로 변환';
	@override String get qrcodeScan => 'QR 코드 스캔';
	@override String get qrcodeScanResult => '스캔 결과';
	@override String get qrcodeScanFromImage => '이미지에서 스캔';
	@override String get qrcodeScanFromClipboard => '클립보드에서 읽기';
	@override String get qrcodeRecognized => 'QR 코드가 인식되었습니다';
	@override String get qrcodeDropHint => '위 버튼을 클릭하여 화면 캡처 또는 이미지 선택';
	@override String get confirmImport => '가져오기 확인';
	@override String get reScan => '다시 스캔';
	@override String get qrcodeScanResultFailed => '이미지 분석 실패. 스크린샷이 유효한 QR 코드인지 확인하십시오';
	@override String get qrcodeScanResultEmpty => '스캔 결과가 비어 있습니다';
	@override String get screenshot => '스크린샷';
	@override String get backupAndSync => '백업 및 동기화';
	@override String get importSuccess => '가져오기 성공';
	@override String get rewriteConfirm => '이 파일은 기존 로컬 설정을 덮어씁니다. 계속하시겠습니까?';
	@override String get importAndExport => '가져오기 및 내보내기';
	@override String get import => '가져오기';
	@override String get importFromUrl => 'URL에서 가져오기';
	@override String get export => '내보내기';
	@override String get send => '보내기';
	@override String get receive => '받기';
	@override String get sendConfirm => '보내기를 확인하시겠습니까?';
	@override String get continueConnectConfirm => '계속 연결하시겠습니까?';
	@override String get termOfUse => '서비스 약관';
	@override String get privacyPolicy => '개인정보 보호정책';
	@override String get log => '로그';
	@override String get coreLog => '코어 로그';
	@override String get core => '코어';
	@override String get help => '도움말';
	@override String get tutorial => '튜토리얼';
	@override String get board => '보드';
	@override String get boardOnline => '온라인 보드 사용';
	@override String get boardOnlineUrl => '온라인 보드 URL';
	@override String get boardLocalPort => '로컬 보드 포트';
	@override String get connections => '연결';
	@override String get closeAllConnections => '모든 연결 닫기';
	@override String get searchConnections => '연결 검색 (도메인/IP/규칙/프로세스)';
	@override String get noFilterResults => '일치하는 연결 없음';
	@override String get searchRules => '규칙 검색 (유형/페이로드/프록시)';
	@override String get searchProfiles => '프로필 검색 (이름/URL/비고)';
	@override String get noMatchingProfiles => '일치하는 프로필을 찾을 수 없습니다';
	@override String get rules => '분류 규칙';
	@override String get clear => '지우기';
	@override String get copySuccess => '복사되었습니다';
	@override String get alwayOnVPN => '상시 연결';
	@override String get disableFontScaler => '글꼴 크기 조정 비활성화 (재시작 후 적용)';
	@override String get autoOrientation => '화면 방향에 따라 회전';
	@override String get restartTakesEffect => '재시작 후 적용';
	@override String get reconnectTakesEffect => '다시 연결 후 적용';
	@override String get runtimeProfile => '런타임 프로필';
	@override String get willCompleteAfterRebootInstall => '시스템 확장 설치를 완료하려면 장치를 재시작하십시오';
	@override String get willCompleteAfterRebootUninstall => '시스템 확장 제거를 완료하려면 장치를 재시작하십시오';
	@override String get requestNeedsUserApproval => '1. [시스템 설정]-[개인정보 보호 및 보안]에서 Wmimo의 시스템 확장 설치를 [허용]하십시오\n2. [시스템 설정]-[일반]-[로그인 항목 및 확장 프로그램]-[네트워크 확장 프로그램]에서 [wmimoServiceSE]를 활성화하십시오\n완료 후 다시 연결하십시오';
	@override String get FullDiskAccessPermissionRequired => '[시스템 설정]-[개인정보 보호 및 보안]-[전체 디스크 액세스]에서 wmimoServiceSE 권한을 활성화하고 다시 연결하십시오.';
	@override String get proxy => '프록시';
	@override String get theme => '테마';
	@override String get tvMode => 'TV 모드';
	@override String get autoUpdate => '자동 업데이트';
	@override String get updateChannel => '자동 업데이트 채널';
	@override String get onlineCustomerService => '온라인 고객센터';
	@override String get subscriptionChannel => '구독 채널';
	@override String hasNewVersion({required Object p}) => '버전 ${p}로 업데이트';
	@override String get autoDownloadPkg => '업데이트 패키지 자동 다운로드';
	@override String get devOptions => '개발자 옵션';
	@override String get joinUs => '커뮤니티 참여';
	@override String get about => '정보';
	@override String get name => '이름';
	@override String get version => '버전';
	@override String get notice => '공지사항';
	@override String get sort => '정렬';
	@override String get recommended => '추천';
	@override String innerError({required Object p}) => '내부 오류: ${p}';
	@override String get share => '공유';
	@override String get importFromClipboard => '클립보드에서 가져오기';
	@override String get exportToClipboard => '클립보드로 내보내기';
	@override String get server => '서버';
	@override String get port => '포트';
	@override String get donate => '후원';
	@override String get setting => '설정';
	@override String get settingCore => '코어 설정';
	@override String get settingApp => '앱 설정';
	@override String get coreOverwrite => '코어 덮어쓰기';
	@override String get iCloud => 'iCloud';
	@override String get webdav => 'Webdav';
	@override String get lanSync => 'LAN 동기화';
	@override String get lanSyncNotQuitTips => '동기화가 완료될 때까지 이 화면을 종료하지 마십시오';
	@override String get deviceNoSpace => '디스크 공간 부족';
	@override String get hideSystemApp => '시스템 앱 숨기기';
	@override String get hideAppIcon => '앱 아이콘 숨기기';
	@override String get openDir => '파일 디렉토리 열기';
	@override String get type => '유형';
	@override String get fileChoose => '파일 선택';
	@override String get filePathCannotEmpty => '파일 경로는 비워둘 수 없습니다';
	@override String fileNotExist({required Object p}) => '파일이 존재하지 않습니다: ${p}';
	@override String fileTypeInvalid({required Object p}) => '유효하지 않은 파일 형식: ${p}';
	@override String get uwpExemption => 'UWP 네트워크 격리 면제';
	@override String get getProfile => '구독 가져오기';
	@override String get buyProfile => '구독 구매';
	@override String get addProfile => '구독 추가';
	@override String get myProfiles => '구독 설정';
	@override String get profileEdit => '구독 설정 편집';
	@override String get profileNeedActive => '먼저 이 프로필을 현재 프로필로 설정한 뒤 연결/재연결하세요';
	@override String get profileDownloadBackupChannel => '백업 다운로드 채널 사용';
	@override String get profileDownloadBackupChannelTips => 'Wmimo에서 제공하는 프록시 다운로드 채널(어떤 정보도 저장하지 않음)';
	@override String get profileEditReloadAfterProfileUpdate => '프로필 업데이트 후 다시 로드';
	@override String get profileRulesAppendApplePush => 'Apple 푸시 알림 규칙 추가';
	@override String get profileRulesAppendProxyTips => '규칙은 원본 설정의 [proxy-groups]에서 [url-test] 또는 [select] 유형의 첫 번째 프록시로 자동 설정됩니다';
	@override String get profileImport => '설정 파일 가져오기';
	@override String get profileAddUrlOrContent => '구독 링크 추가';
	@override String get profileUrlOrContent => '구독 링크 / 노드 내용';
	@override String get profileUrlOrContentHit => '구독 링크 또는 설정 내용 [필수]';
	@override String get profileUrlOrContentCannotEmpty => '구독 링크 또는 내용은 비워 둘 수 없습니다';
	@override String get overview => '개요';
	@override String get trafficStats => '트래픽 통계';
	@override String get realtimeMonitor => '실시간 모니터링';
	@override String get realtimeUpload => '실시간 업로드';
	@override String get realtimeDownload => '실시간 다운로드';
	@override String get sessionUpload => '이번 업로드';
	@override String get sessionDownload => '이번 다운로드';
	@override String get planUsage => '요금제 사용량';
	@override String get memoryUsage => '메모리';
	@override String get remaining => '남음';
	@override String get expireTime => '만료 시간';
	@override String get tunMode => 'TUN 모드';
	@override String daysAgo({required Object p}) => '${p}일 전';
	@override String hoursAgo({required Object p}) => '${p}시간 전';
	@override String get lessThanOneHourAgo => '1시간 이내';
	@override String get inUse => '사용 중';
	@override String get remoteSubscription => '원격 구독';
	@override String get noTrafficData => '사용량 통계 없음';
	@override String get localProfile => '로컬 파일';
	@override String get viewYamlConfig => 'YAML 설정 보기';
	@override String get editYamlConfig => 'YAML 설정 편집';
	@override String get copySubscriptionUrl => '구독 URL 복사';
	@override String get qrCode => 'QR 코드';
	@override String get deleteProfile => '설정 삭제';
	@override String get noProfilesYet => '등록된 구독 설정이 없습니다';
	@override String get addProfilePrompt => '오른쪽 상단 + 를 눌러 링크 추가 또는 파일 가져오기';
	@override String get subscriptionUrlCopied => '구독 URL이 클립보드에 복사되었습니다';
	@override String autoGroupTip({required Object group, required Object type}) => '「${group}」은(는) ${type} 자동 정책 그룹으로 지연 시간/가용성에 따라 노드가 자동 선택됩니다. 수동으로 선택하려면 \'노드 선택\' 그룹에서 전환하세요.';
	@override String switchNodeFailed({required Object p}) => '노드 전환 실패: ${p}';
	@override String nodeSelected({required Object p}) => '선택된 노드: ${p}';
	@override String get startingCoreAndTesting => '코어를 시작하고 지연 속도를 측정하는 중...';
	@override String chartMinutes({required Object p}) => '${p} 분';
	@override String get chartUpload => '업로드';
	@override String get chartDownload => '다운로드';
	@override String get author => '작성자';
	@override String get githubRepo => '오픈 소스 저장소';
	@override String get openSourceLicense => '오픈 소스 라이선스';
	@override String get submitFeedback => '피드백 및 문제 제출';
	@override String get copiedToClipboard => '클립보드에 복사되었습니다';
	@override String get autoScrollEnabled => '자동 스크롤 켜짐';
	@override String get autoScrollDisabled => '자동 스크롤 꺼짐';
	@override String get pauseLogs => '실시간 로그 일시 중지';
	@override String get resumeLogs => '실시간 로그 재개';
	@override String get scrollToLatest => '최신으로 스크롤';
	@override String get scrollToBottom => '맨 아래로 스크롤';
	@override String newLogsCount({required Object p}) => '(${p}개 새 로그)';
	@override String get copiedLogContent => '로그 내용이 복사되었습니다';
	@override String get copyLog => '로그 복사';
	@override String get noLogsPrompt => '아직 로그가 없습니다. 프록시 시작 후 실시간 로그가 표시됩니다.';
	@override String get searchLogsHint => ' (IP, 도메인, 규칙, 오류...)';
	@override String get offlinePreviewPrompt => '오프라인 미리보기 모드. 프록시를 시작하여 라우팅 및 지연 테스트를 사용합니다.';
	@override String get manualSelect => '수동 선택';
	@override String get autoSelect => '자동 선택';
	@override String get speedTestGroup => '그룹 속도 테스트';
	@override String get pause => '일시 중지';
	@override String get resume => '재개';
	@override String get ipInfo => 'IP 정보';
	@override String get ipFetching => 'IP 정보 가져오는 중...';
	@override String get ipCopied => 'IP 주소가 클립보드에 복사되었습니다';
	@override String get ipLocation => '위치';
	@override String get ipIsp => '제공자';
	@override String get ipTapToFetch => '탭하여 IP 정보 가져오기';
	@override String get ipProxy => '프록시 출구';
	@override String get ipDirect => '로컬 직접 연결';
	@override String get ipAsn => 'ASN';
	@override String get ipOrg => '소속 조직';
	@override String get ipTimezone => '시간대';
	@override String get ipCoordinates => '좌표';
	@override String get ipMoreDetails => '자세한 정보';
	@override String get ipLessDetails => '접기';
	@override String get collapseAll => '모든 그룹 접기';
	@override String get expandAll => '모든 그룹 펼치기';
	@override String get donateTitle => '💖 개발자에게 커피 한 잔 후원하기';
	@override String get donateThankYou => 'ฅ^•ﻌ•^ฅ 여러분의 따뜻한 후원은 Wmimo를 발전시키는 가장 큰 원동력입니다 ~ ☕✨';
	@override String get tokenCurrency => '토큰';
	@override String get networkChain => '네트워크';
	@override String get depositAddress => 'APTOS 입금 주소';
	@override String get clickToCopy => '클릭하여 복사';
	@override String get copyAddressBtn => '주소 복사 ✨';
	@override String get donateAddressCopied => '( ੭ ˙ᗜ˙ )੭ 주소가 복사되었습니다! 후원해 주셔서 진심으로 감사드립니다~ 💖';
	@override String get donateTip => '💡 팁: Bybit 또는 모든 Aptos 호환 지갑 스캔 지원';
	@override String get qrcodeParsing => 'QR 코드 분석 중...';
	@override String get qrcodeNotFound => 'QR 코드가 감지되지 않았습니다';
	@override String get qrcodeSupportHint => '각종 구독, 노드 및 설정 QR 코드 이미지 분석 지원';
	@override String get qrcodeCameraHint => '프레임 안에 QR 코드를 맞추면 자동으로 스캔됩니다';
	@override String get flashlight => '손전등';
	@override String get screenshotDesc => '화면 캡처';
	@override String get fromImageDesc => '로컬 이미지';
	@override String get fromClipboardDesc => '클립보드 읽기';
	@override String get errorPrompt => '오류 안내';
	@override String get copied => '복사됨';
	@override String get sortAndFilterNodes => '노드 정렬 및 필터링';
	@override String get sortOptions => '정렬 옵션';
	@override String get sortDefault => '기본 정렬';
	@override String get sortLatency => '지연 시간 정렬';
	@override String get sortName => '이름순 (A-Z)';
	@override String get sortRegion => '지역별 그룹';
	@override String get filterOptions => '필터 옵션';
	@override String portableUpdateTip({required Object version}) => '포터블(무설치) 모드가 감지되었습니다:\n포터블 버전은 앱 내 덮어쓰기 업데이트를 지원하지 않습니다. 공식 저장소에서 최신 포터블 압축 파일을 다운로드하여 덮어쓰기 해주세요.\n\n최신 버전: v${version}';
	@override String get portableModeTipTitle => '포터블 모드 안내';
	@override String get noNodesToSpeedTest => '측정할 수 있는 노드가 없습니다';
	@override String alreadyLatestVersion({required Object version}) => '이미 최신 버전입니다 (v${version})';
	@override String get checkUpdateFailed => '업데이트 확인 실패, 네트워크 연결을 확인하세요';
	@override String get hideTimeoutNodes => '시간 초과 및 오프라인 노드 숨기기';
	@override String get hideTimeoutNodesDesc => '속도 테스트 실패 또는 시간 초과된 노드를 자동으로 숨깁니다';
	@override String get speedtestScenario => '현재 속도 테스트 시나리오';
	@override String get speedtestScenarioSwitch => '속도 테스트 시나리오 전환';
	@override String get speedtestScenarioDesc => '실제 연결 지연 및 가용성을 테스트할 대상을 선택하세요';
	@override String get speedtestAllNodes => '모든 노드 속도 측정';
	@override String get retestTimeoutNodes => '시간 초과 노드만 재테스트';
	@override String switchedTargetScenario({required Object target}) => '속도 테스트 시나리오 변경됨: ${target}';
	@override String get notTested => '미측정';
	@override String get timeoutOrFailed => '시간 초과 / 연결 불가';
	@override String get identifiedRegion => '지역';
	@override String get nodeProtocol => '프로토콜';
	@override String get currentLatency => '지연 시간';
	@override String get testScenario => '테스트 시나리오';
	@override String get belongsToGroup => '그룹';
	@override String get copyNodeName => '이름 복사';
	@override String get nodeNameCopied => '노드 이름이 복사되었습니다';
	@override String get testSingleNode => '단독 테스트';
	@override String get selectThisNode => '이 노드 선택';
	@override String get allNodesNormal => '모든 노드가 정상입니다. 재테스트가 필요하지 않습니다';
	@override String get customUrlPrompt => '사용자 지정 URL (예: http://...)';
	@override String get customTarget => '사용자 지정 대상';
	@override String get downloadFailedTip => '설치 패키지 다운로드 실패, 네트워크를 확인하거나 웹사이트에서 다운로드하세요.';
	@override String discoveredNewVersion({required Object version}) => '새 버전 발견됨: v${version}';
	@override String get preparingUpdate => '업데이트 준비 중...';
	@override String get downloadingPackage => '설치 패키지 다운로드 중, 잠시만 기다려주세요...';
	@override String get downloadUpdateNow => '지금 업데이트 다운로드';
	@override String get downloadFromWeb => '웹사이트에서 다운로드';
	@override String get switchSource => '서버 변경';
	@override String get serverSwitch => '측정 서버 전환';
	@override String get autoDetectBest => '최적 서버 자동 감지';
	@override String get serverSwitchDesc => '연결을 테스트할 CDN 또는 사용자 지정 대상을 선택하세요';
	@override String autoSelectedBest({required Object server, required Object ping}) => '최적 서버 자동 선택됨: ${server} (${ping} ms)';
	@override String get networkGradeTitle => '네트워크 품질 종합 점수';
	@override String get copyReport => '리포트 복사';
	@override String get reportCopied => '리포트가 복사되었습니다. 바로 공유할 수 있습니다';
	@override String get gamingExperience => '게이밍 경험';
	@override String get streamingExperience => '스트리밍';
	@override String get meetingExperience => '화상 회의';
	@override String get customSpeedtestUrl => '사용자 지정 다운로드 URL (https://...)';
	@override String get customSpeedtestSource => '사용자 지정 측정 서버';
	@override String get userSpecifiedUrl => '사용자 지정 URL';
	@override String cannotBeEmpty({required Object item}) => '${item}은(는) 비워둘 수 없습니다';
	@override String alreadyExists({required Object item}) => '${item}이(가) 이미 존재합니다';
	@override String installFailedWithCode({required Object installer, required Object code}) => '${installer} 설치 실패, 코드: ${code}';
	@override String get resetSystemProxy => '네트워크 복구 / 시스템 프록시 초기화';
	@override String get resetSystemProxyDesc => '잔여 시스템 프록시 설정을 제거하고 네트워크를 새로고침하여 비정상 종료 후 인터넷 불가 문제를 해결합니다';
	@override String get resetSystemProxySuccess => '시스템 프록시가 초기화되었으며 네트워크가 정상 복구되었습니다';
	@override String get networkDiagnostics => '네트워크 진단 및 스마트 복구';
	@override String get networkDiagnosticsDesc => 'NIC, DNS, 코어 포트, 프록시 상태를 원클릭으로 종합 진단하고 자동 복구';
	@override String get sortLatencyDesc => '지연 시간 높은 순';
	@override String get sortNameDesc => '이름 Z-A';
	@override String get sortMultiplier => '배율 낮은 순';
	@override String get uwpLoopback => 'UWP 루프백 예외 도구';
	@override String get uwpLoopbackDesc => '마이크로소프트 스토어, Xbox 등 UWP 앱이 로컬 프록시를 사용하도록 예외 처리';
	@override String get uwpExemptAllCommon => '추천 앱 일괄 예외 처리';
	@override String get uwpApplySuccess => 'UWP 루프백 예외 규칙이 적용되었습니다';
	@override String get common => '주요';
	@override String get exempted => '예외 처리됨';
	@override String get notExempted => '미처리';
	@override String get deselectAll => '선택 해제';
	@override String get userApps => '사용자 앱';
	@override String get systemApps => '시스템 앱';
	@override String get selectedOnly => '선택됨';
	@override String get proxySelectedMode => '선택 앱만 프록시 적용';
	@override String get proxySelectedModeDesc => '선택한 앱만 프록시를 거치고 다른 앱은 직접 연결합니다';
	@override String get bypassSelectedMode => '선택 앱 우회';
	@override String get bypassSelectedModeDesc => '선택한 앱은 직접 연결하고 다른 앱은 프록시를 거칩니다';
	@override String get invertSelection => '반전 선택';
	@override String get all => '전체';
	@override String get showAppIcon => '앱 아이콘 표시';
	@override String get proxySelection => '프록시 선택';
	@override String get regionHk => '🇭🇰 홍콩';
	@override String get regionJp => '🇯🇵 일본';
	@override String get regionSg => '🇸🇬 싱가포르';
	@override String get regionTw => '🇹🇼 대만';
	@override String get regionUs => '🇺🇸 미국';
	@override String get regionKr => '🇰🇷 한국';
	@override String get macMoveToApplications => 'Wmimo를 [응용 프로그램] 폴더로 이동한 후 실행해 주세요';
	@override String get notifCurrentNode => '현재 노드';
	@override String get notifMode => '동작 모드';
	@override String get notifPort => '포트';
	@override String get notifProfile => '구독 프로필';
	@override String get notifDisconnect => '연결 끊기';
	@override String get notifSwitchNode => '노드 전환';
	@override String get notifVpnConnected => 'VPN 프록시 연결됨';
	@override String get connectionDetails => '연결 세부정보';
	@override String get sourceAddress => '소스 주소';
	@override String get destinationAddress => '대상 주소';
	@override String get host => '호스트';
	@override String get process => '프로세스';
	@override String get processPath => '프로세스 경로';
	@override String get proxyChain => '프록시 체인';
	@override String get networkProtocol => '프로토콜';
	@override String get trafficUpload => '업로드 트래픽';
	@override String get trafficDownload => '다운로드 트래픽';
	@override String get connectionDuration => '연결 시간';
	@override String get connectionStart => '시작 시간';
	@override String get copyHost => '호스트 복사';
	@override String get copyAllDetails => '모든 세부정보 복사';
	@override String get closeThisConnection => '이 연결 닫기';
	@override String get sortByDownload => '다운로드순';
	@override String get sortByUpload => '업로드순';
	@override String get sortBySpeed => '속도순';
	@override String get sortByDuration => '연결 시간순';
	@override String get sortByHost => '호스트순';
	@override String get realtimeSpeed => '실시간 속도';
	@override String get totalUpload => '총 업로드';
	@override String get totalDownload => '총 다운로드';
	@override String get activeConnections => '활성 연결';
	@override String get openInFolder => '폴더에서 보기';
	@override String get openProfilesDir => '프로필 디렉터리 열기';
	@override String get profilePatches => '프로필 덮어쓰기';
	@override String nodeCount({required Object p}) => '${p}개 노드';
	@override String get copyFilePath => '파일 경로 복사';
	@override String get duplicateProfile => '사본 만들기';
	@override String get useThisProfile => '이 프로필 사용';
	@override String get websiteTest => '웹사이트 테스트';
	@override String get testAll => '모두 테스트';
	@override String get addTestWebsite => '테스트 사이트 추가';
	@override String get websiteName => '웹사이트 이름';
	@override String get websiteUrl => '테스트 URL';
	@override String get websiteNameHint => '웹사이트 이름 (예: Cloudflare)';
	@override String get websiteInputEmpty => '웹사이트 이름과 URL을 입력하세요';
	@override String get autoRefresh => '자동 새로고침';
	@override String get currentProfile => '현재 프로필';
	@override String get quickActions => '빠른 도구';
	@override String get fastest => '가장 빠름';
	@override String get hideTimeout => '시간 초과 숨기기';
	@override String get filteredTimeout => '시간 초과 필터링됨';
	@override String get tunDeviceCreateFailed => 'TUN 가상 네트워크 어댑터 생성 실패';
	@override String get test => '테스트';
	@override String get addWebsite => '웹사이트 추가';
	@override String get maxWebsitesReached => '테스트 웹사이트는 최대 6개까지 추가할 수 있습니다';
	@override String get sideBySideLayout => '병렬 레이아웃';
	@override String get sideBySideLayoutTips => '와이드 화면에서 홈 카드 및 구독 목록을 병렬로 표시합니다';
	@override String get homeCardsManage => '홈 카드 관리';
	@override String get homeCardsManageTips => '홈 화면에 표시할 카드 모듈 및 표시 상태 사용자 정의';
	@override String get cardTrafficChart => '트래픽 통계 차트';
	@override String get cardWebsiteTest => '웹사이트 지연 시간 테스트';
	@override String get cardIpInfo => 'IP 및 출구 정보';
	@override String get cardSubscription => '구독 및 만료 정보';
	@override String get cardQuickActions => '빠른 도구';
	@override String get resetDefaultCards => '기본값 복원';
}

// Path: permission
class _Translations$permission$ko implements Translations$permission$en {
	_Translations$permission$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get camera => '카메라';
	@override String get screen => '화면 녹화';
	@override String get appQuery => '애플리케이션 목록 가져오기';
	@override String request({required Object p}) => '[${p}] 권한 켜기';
	@override String requestNeed({required Object p}) => '[${p}] 권한을 켜주십시오';
}

// Path: tls
class _Translations$tls$ko implements Translations$tls$en {
	_Translations$tls$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get insecure => '인증서 검증 건너뛰기';
	@override String get certificate => '인증서';
	@override String get privateKey => '개인 키';
	@override String get customTrustCert => '사용자 정의 인증서';
}

// Path: tun
class _Translations$tun$ko implements Translations$tun$en {
	_Translations$tun$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get stack => '네트워크 스택';
	@override String get stackGvisor => 'gVisor';
	@override String get stackGvisorDesc => '사용자 공간 네트워크 스택, 뛰어난 안정성과 호환성';
	@override String get stackSystem => 'System';
	@override String get stackSystemDesc => 'OS 기본 네트워크 스택, 고성능이지만 시스템 구현에 의존';
	@override String get stackMixed => 'Mixed';
	@override String get stackMixedDesc => '혼합 네트워크 스택 모드, 성능과 호환성의 균형';
	@override String get stackMips => 'MIPS (Mihomo IP Stack)';
	@override String get stackMipsDesc => 'Mihomo 자체 개발 고성능 IP 스택, 높은 처리량 및 낮은 지연 시간';
	@override String get inet4Address => 'IPv4 주소 범위';
	@override String get inet6Address => 'IPv6 주소 범위';
	@override String get dnsHijack => 'DNS 하이제킹';
	@override String get strictRoute => '엄격한 경로';
	@override String get tunDefaultRoute => '기본 경로';
	@override String get icmpForward => 'ICMP 전달';
	@override String get allowBypass => '앱이 VPN을 우회하도록 허용';
	@override String get appendHttpProxy => 'VPN에 HTTP 프록시 추가';
	@override String get bypassHttpProxyDomain => 'HTTP 프록시를 우회하도록 허용된 도메인';
}

// Path: dns
class _Translations$dns$ko implements Translations$dns$en {
	_Translations$dns$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get listen => '청취 연설';
	@override String get fakeIp => 'fake-ip';
	@override String get fallback => '폴백(Fallback)';
	@override String get preferH3 => 'DoH H3 우선';
	@override String get useHosts => 'Hosts 사용';
	@override String get useSystemHosts => '시스템 Hosts 사용';
	@override String get enhancedMode => '향상된 모드';
	@override String get fakeIPFilterMode => '${_root.dns.fakeIp} 필터 모드';
	@override String get fakeIPFilter => '${_root.dns.fakeIp} 필터';
	@override String get respectRules => '규칙 준수';
	@override String get nameServer => '네임 서버';
	@override String get defaultNameServer => '${_root.meta.byDefault} ${_root.dns.nameServer}';
	@override String get proxyNameServer => '${_root.meta.proxy} ${_root.dns.nameServer}';
	@override String get directNameServer => '${_root.meta.direct} ${_root.dns.nameServer}';
	@override String get fallbackNameServer => '${_root.dns.fallback} ${_root.dns.nameServer}';
	@override String get fallbackGeoIp => '${_root.dns.fallback} GeoIp';
	@override String get fallbackGeoIpCode => '${_root.dns.fallback} GeoIpCode';
	@override String get flushCache => 'DNS 캐시 비우기';
	@override String get flushCacheSuccess => 'DNS 및 Fake-IP 캐시가 성공적으로 지워졌습니다';
	@override String get presets => '빠른 DNS 사전 설정';
	@override String get presetSpeed => '고속 듀얼 스택';
	@override String get presetSpeedDesc => 'AliDNS DoH3 + DNSPod DoH: 국내 즉시 연결 및 스마트 분기';
	@override String get presetSecure => '오염 방지 및 개인정보 보호 모드';
	@override String get presetSecureDesc => 'Cloudflare DoH3 + Google DoH: DNS 하이재킹 및 검열 차단';
	@override String get presetAdGuard => 'AdGuard 광고 차단 및 클린 모드';
	@override String get presetAdGuardDesc => 'AdGuard DoQ + AliDNS DoH: 광고 필터링 및 추적 차단';
	@override String get overwriteDesc => '구독 프로필의 DNS 설정 덮어쓰기';
	@override String get enableDesc => '사용자 지정 DNS 리졸버 활성화';
	@override String get resetFakeIpFilter => '기본값 복원';
	@override String get resetFakeIpFilterConfirm => '권장 Fake-IP 필터 목록을 복원하시겠습니까?';
	@override String get dnsTester => '실시간 DNS 진단';
	@override String get testQuery => '테스트';
	@override String get fakeIpDetected => 'Fake-IP 일치';
	@override String get realIpDetected => '실제 공인 IP';
	@override String get addServer => 'DNS 서버 추가';
	@override String get geoAssetsTitle => 'GEO 오프라인 데이터베이스';
	@override String get geoAssetsDesc => 'GeoSite 도메인 규칙, GeoIP 및 ASN 데이터베이스 관리';
	@override String get cdnSource => '다운로드 CDN 미러';
	@override String get updateAll => '모두 업데이트';
	@override String get updateSuccess => '업데이트 성공';
	@override String get updateFailed => '업데이트 실패';
	@override String get addPresetServer => '프리셋 DNS 추가';
	@override String manageFakeIpFilter({required Object p}) => '필터 목록 관리 (${p})';
	@override String fakeIpFilterDesc({required Object p}) => '${p}개의 도메인 규칙이 네트워크 격리 문제를 방지하기 위해 Fake-IP 확인을 우회합니다.';
}

// Path: sniffer
class _Translations$sniffer$ko implements Translations$sniffer$en {
	_Translations$sniffer$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get overrideDest => '덮어쓰기';
}

// Path: profilePatchMode
class _Translations$profilePatchMode$ko implements Translations$profilePatchMode$en {
	_Translations$profilePatchMode$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get currentSelected => '현재 선택됨';
	@override String get overwrite => '내장 - 덮어쓰기';
	@override String get noOverwrite => '내장 - 덮어쓰지 않음';
}

// Path: main.tray
class _Translations$main$tray$ko implements Translations$main$tray$en {
	_Translations$main$tray$ko._(this._root);

	final TranslationsKo _root; // ignore: unused_field

	// Translations
	@override String get menuOpen => '열기';
	@override String get menuExit => '종료';
	@override String get coreDisconnected => 'Wmimo · 코어 미실행';
	@override String get coreRunning => 'Wmimo · 코어 실행 중';
	@override String get startProxy => '프록시 연결 시작';
	@override String get stopProxy => '프록시 연결 끊기';
	@override String get restartCore => '프록시 코어 재시작';
	@override String get systemProxyItem => '시스템 프록시';
	@override String get tunModeItem => 'TUN 모드';
	@override String get outboundMode => '아웃바운드 모드';
	@override String get modeRule => '규칙 라우팅';
	@override String get modeGlobal => '글로벌 프록시';
	@override String get modeDirect => '직접 연결';
	@override String get profilesMenu => '구독 설정';
	@override String get updateAllProfiles => '모든 구독 설정 업데이트';
	@override String get proxyNodes => '프록시 노드';
	@override String get tools => '도구';
	@override String get copyProxyCmd => '터미널 프록시 명령 복사 (CMD / Bash)';
	@override String get delayTestAll => '모든 노드 지연 속도 측정';
	@override String get openDashboard => '제어판 열기';
	@override String get resetSystemProxy => '네트워크 복구 / 시스템 프록시 초기화';
	@override String get copyCmdPowerShell => 'PowerShell 명령어';
	@override String get copyCmdCmd => 'CMD 명령어';
	@override String get copyCmdBash => 'Bash/Zsh 명령어';
}

/// The flat map containing all translations for locale <ko>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsKo {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'WelcomeLanguageScreen.welcomeTitle' => 'Wmimo에 오신 것을 환영합니다',
			'WelcomeLanguageScreen.selectLanguage' => '언어 선택',
			'WelcomeLanguageScreen.subtitle' => '원하시는 언어를 선택해 주세요. 설정에서 언제든지 변경할 수 있습니다.',
			'WelcomeLanguageScreen.start' => '시작하기',
			'BackupAndSyncWebdavScreen.webdavServerUrl' => '서버 URL',
			'BackupAndSyncWebdavScreen.webdavRequired' => '비워둘 수 없습니다',
			'BackupAndSyncWebdavScreen.webdavLoginFailed' => '로그인 실패:',
			'BackupAndSyncWebdavScreen.webdavListFailed' => '파일 목록을 가져오지 못했습니다:',
			'LaunchFailedScreen.invalidProcess' => '앱 시작 실패 [유효하지 않은 프로세스 이름], 앱을 별도의 디렉토리에 다시 설치하십시오',
			'LaunchFailedScreen.invalidProfile' => '앱 시작 실패 [프로필 액세스 실패], 앱을 다시 설치하십시오',
			'LaunchFailedScreen.invalidVersion' => '앱 시작 실패 [유효하지 않은 버전], 앱을 다시 설치하십시오',
			'LaunchFailedScreen.systemVersionLow' => '앱 시작 실패 [시스템 버전이 너무 낮음]',
			'LaunchFailedScreen.invalidInstallPath' => '설치 경로가 유효하지 않습니다. 유효한 경로에 다시 설치하십시오',
			'PerAppAndroidScreen.title' => '앱별 프록시',
			'PerAppAndroidScreen.whiteListMode' => '화이트리스트 모드',
			'PerAppAndroidScreen.whiteListModeTip' => '활성화 시: 체크된 앱만 프록시됩니다. 비활성화 시: 체크되지 않은 앱만 프록시됩니다',
			'PerAppAndroidScreen.manualAddPackage' => '패키지 이름 직접 추가',
			'PerAppAndroidScreen.manualAddPackageHint' => '프록시할 패키지 이름을 입력하세요 (공백, 쉼표 또는 줄바꿈으로 구분하여 여러 개 지원, 예: org.telegram.messenger, com.google.android.youtube):',
			'PerAppAndroidScreen.quickAddPresets' => '자주 쓰는 프록시 앱 빠른 추가',
			'PerAppAndroidScreen.saveSelected' => '선택 항목 저장',
			'PerAppAndroidScreen.permissionRestrictedTip' => '시스템에서 앱 목록 읽기가 제한되었습니다. 아래 【시스템 권한 설정 열기】를 눌러 앱 목록 접근 권한을 허용하거나 권한이 필요 없는 프리셋을 사용하세요.',
			'PerAppAndroidScreen.openSystemPermission' => '시스템 권한 설정으로 이동',
			'PerAppAndroidScreen.presetApps' => '자주 쓰는 앱 빠른 추가 (권한 불필요 프리셋)',
			'PerAppAndroidScreen.requestPermissionPopup' => '권한 요청 (시스템 팝업)',
			'UserAgreementScreen.privacyFirst' => '개인 정보 보호 우선',
			'UserAgreementScreen.agreeAndContinue' => '동의 및 계속',
			'NetCheckScreen.title' => '네트워크 진단 및 복구',
			'NetCheckScreen.fullDiagnosticsTab' => '파이프라인 진단',
			'NetCheckScreen.advancedCheckTab' => '고급 도메인 쿼리',
			'NetCheckScreen.startDiagnostics' => '진단 시작',
			'NetCheckScreen.reDiagnostics' => '재진단',
			'NetCheckScreen.diagnosing' => '네트워크 경로 진단 중...',
			'NetCheckScreen.healthScore' => '상태 점수',
			'NetCheckScreen.scorePerfect' => '매우 우수',
			'NetCheckScreen.scoreGood' => '양호',
			'NetCheckScreen.scoreWarning' => '경고 발생',
			'NetCheckScreen.scoreCritical' => '연결 차단',
			'NetCheckScreen.oneClickRepair' => '원클릭 스마트 자동 복구',
			'NetCheckScreen.repairSuccess' => '자동 복구가 완료되었으며 네트워크가 정상 복원되었습니다',
			'NetCheckScreen.repairFailed' => '복구가 적용되었습니다. 일부 항목을 수동 확인하세요',
			'NetCheckScreen.repairing' => '자동 복구 실행 중...',
			'NetCheckScreen.issueFound' => ({required Object count}) => '${count} 개 이상 감지',
			'NetCheckScreen.noIssue' => '모든 검사 통과',
			'NetCheckScreen.details' => '상세 로그',
			'NetCheckScreen.copyDetails' => '로그 복사',
			'NetCheckScreen.detailsCopied' => '진단 로그가 클립보드에 복사되었습니다',
			'NetCheckScreen.stepPhysical' => '물리 랜카드 및 게이트웨이',
			'NetCheckScreen.stepDns' => 'DNS 확인 및 Fake-IP',
			'NetCheckScreen.stepCore' => '코어 프로세스 및 포트',
			'NetCheckScreen.stepProxy' => '시스템 프록시 설정',
			'NetCheckScreen.stepHandshake' => '인터넷 엔드투엔드 핸드셰이크',
			'NetCheckScreen.suggestedAction' => '해결 제안',
			'NetCheckScreen.autoRepairAction' => '지금 복구',
			'NetCheckScreen.enterDomain' => '도메인 이름을 입력하세요',
			'NetCheckScreen.checking' => '확인 중...',
			'NetCheckScreen.aQueryFailed' => ({required Object p}) => 'A 레코드 조회 실패: ${p}',
			'NetCheckScreen.aaaaQueryFailed' => ({required Object p}) => 'AAAA 레코드 조회 실패: ${p}',
			'NetCheckScreen.success' => '성공',
			'NetCheckScreen.failed' => '실패',
			'NetCheckScreen.suspectedPollution' => 'DNS 오염 의심',
			'NetCheckScreen.domainLabel' => '도메인',
			'NetCheckScreen.checkButton' => '진단',
			'NetCheckScreen.dnsSection' => '1. DNS 조회',
			'NetCheckScreen.directHttpSection' => '2. HTTP (TUN 경유, 먼저 TUN을 활성화하세요)',
			'NetCheckScreen.proxyHttpSection' => ({required Object p}) => '3. HTTP (프록시 경유, 포트: ${p})',
			'NetCheckScreen.tunNotEnabled' => 'TUN이 활성화되지 않았습니다',
			'NetCheckScreen.routeTableSection' => '4. 라우팅 테이블',
			'NetCheckScreen.stepPhysicalDesc' => '물리적 네트워크 카드, 로컬 IP 및 게이트웨이 연결 상태를 확인합니다',
			'NetCheckScreen.stepDnsDesc' => '로컬 DNS 확인 지연 시간 및 코어 DNS 응답 상태를 확인합니다',
			'NetCheckScreen.stepCoreDesc' => 'Mihomo 프로세스 상태 및 Mixed-Port/API 포트 수신 대기를 확인합니다',
			'NetCheckScreen.stepProxyDesc' => '시스템 프록시 설정 일치 여부 및 잔류 프록시로 인한 네트워크 차단을 점검합니다',
			'NetCheckScreen.stepHandshakeDesc' => '활성 프록시 노드를 통해 글로벌 CDN으로의 종단 간 지연 시간과 연결성을 측정합니다',
			'NetCheckScreen.shortStepPhysical' => '랜카드',
			'NetCheckScreen.shortStepDns' => 'DNS',
			'NetCheckScreen.shortStepCore' => '코어',
			'NetCheckScreen.shortStepProxy' => '프록시',
			'NetCheckScreen.shortStepHandshake' => '공용망',
			'NetCheckScreen.valNicNormal' => ({required Object p}) => '네트워크 연결 정상 (${p})',
			'NetCheckScreen.valNicNone' => '사용 가능한 네트워크 인터페이스를 찾을 수 없습니다',
			'NetCheckScreen.valNicGatewayTimeout' => '로컬 IP는 할당되었으나 외부 게이트웨이 응답 시간이 초과되었습니다',
			'NetCheckScreen.valNicError' => '네트워크 인터페이스 확인 오류',
			'NetCheckScreen.valDnsNormal' => ({required Object p}) => 'DNS 응답 정상 (${p})',
			'NetCheckScreen.valDnsEmpty' => 'DNS 쿼리가 빈 목록을 반환했습니다',
			'NetCheckScreen.valDnsTimeout' => 'DNS 쿼리 시간 초과 또는 실패',
			'NetCheckScreen.valCoreNormal' => ({required Object port, required Object mode}) => '코어 정상 작동 중 (혼합 포트: ${port}, 모드: ${mode})',
			'NetCheckScreen.valCoreNotRunning' => '코어 서비스가 실행 중이지 않습니다',
			'NetCheckScreen.valCorePortConflict' => ({required Object p}) => '포트 ${p}이(가) 다른 프로그램에 의해 사용 중입니다',
			'NetCheckScreen.valCoreApiFailed' => '코어 프로세스 응답 없음 (API 통신 실패)',
			'NetCheckScreen.valCoreError' => '코어 검사 오류',
			'NetCheckScreen.valProxyActive' => ({required Object port}) => '시스템 프록시 적용됨 (127.0.0.1:${port})',
			'NetCheckScreen.valProxyDisabled' => '시스템 프록시 비활성화됨 (직접 연결 / TUN / 수동 모드)',
			'NetCheckScreen.valProxyZombie' => '잔류 시스템 프록시 감지됨 (인터넷 연결 끊김 원인)',
			'NetCheckScreen.valProxyFailed' => '시스템 프록시를 활성화하지 못했습니다',
			'NetCheckScreen.valProxyWarning' => '시스템 프록시 상태 읽기 경고',
			'NetCheckScreen.valHandshakeNormal' => ({required Object node, required Object delay}) => '공용망 핸드셰이크 정상 (${node} • ${delay} ms)',
			'NetCheckScreen.valHandshakeFailed' => ({required Object node, required Object err}) => '현재 노드 [${node}] 핸드셰이크 실패 (${err})',
			'NetCheckScreen.valHandshakeSkipped' => '코어가 실행되지 않아 공용망 테스트를 건너뜁니다',
			'NetCheckScreen.valHandshakeError' => '공용망 핸드셰이크 오류 발생',
			'NetCheckScreen.issueNicDisconnected' => '네트워크 카드가 연결되지 않았습니다 (랜선 분리, Wi-Fi 미연결 또는 비행기 탑승 모드)',
			'NetCheckScreen.suggestNicCheck' => '이더넷 케이블, Wi-Fi 연결 또는 네트워크 어댑터 상태를 확인하세요',
			'NetCheckScreen.suggestNicReset' => '시스템 설정에서 네트워크 어댑터를 사용 안 함으로 설정한 후 다시 사용해 보세요',
			'NetCheckScreen.issueNicGatewayUnreachable' => 'LAN에 연결되었으나 외부 게이트웨이에 접근할 수 없습니다 (인증 필요 또는 공유기 인터넷 끊김)',
			'NetCheckScreen.suggestNicGateway' => '공유기 상태를 확인하거나 브라우저를 열어 웹 로그인 인증이 필요한지 확인하세요',
			'NetCheckScreen.issueDnsPollution' => '로컬 DNS 서비스가 응답하지 않습니다. DNS 오염 또는 하이재킹 가능성이 있습니다',
			'NetCheckScreen.suggestDnsReset' => '시스템 DNS를 재설정하거나 Wmimo에서 스마트 암호화 DNS(DoH/DoT)를 활성화하세요',
			'NetCheckScreen.actionFlushDns' => '시스템 DNS 캐시 새로고침',
			'NetCheckScreen.suggestDnsSlow' => 'DNS 응답 시간이 지연되고 있습니다. 스마트 암호화 DNS를 활성화하는 것을 권장합니다',
			'NetCheckScreen.issueDnsFailed' => '로컬 DNS 확인 실패, 도메인 이름을 IP 주소로 변환할 수 없습니다',
			'NetCheckScreen.suggestDnsFlush' => 'DNS 캐시를 새로고침하거나 Wmimo 설정에서 암호화 DNS를 활성화하세요',
			'NetCheckScreen.issueCorePortConflict' => '포트 충돌 감지됨! 다른 프록시 소프트웨어나 서비스가 해당 포트를 사용 중입니다',
			'NetCheckScreen.suggestCoreChangePort' => '다른 프록시 프로그램을 완전히 종료하거나 Wmimo 설정에서 포트를 변경하세요',
			'NetCheckScreen.actionRestartCore' => '코어 재시작',
			'NetCheckScreen.issueCoreStopped' => 'Wmimo 코어 프로세스가 현재 중지 상태입니다',
			'NetCheckScreen.suggestCoreStart' => '홈 화면의 연결 스위치를 누르거나 아래의 [코어 시작]을 누르세요',
			'NetCheckScreen.actionStartCore' => '코어 프로세스 시작',
			'NetCheckScreen.issueCoreFrozen' => '코어 프로세스가 응답하지 않거나 API 인증 정보가 일치하지 않습니다',
			'NetCheckScreen.suggestCoreRestart' => '[코어 재시작]을 클릭하여 서비스를 복구하세요',
			'NetCheckScreen.suggestCoreReinstall' => '코어를 재시작하거나 서비스 드라이버를 재설치해 보세요',
			'NetCheckScreen.issueProxyZombie' => '잔류 시스템 프록시가 비활성 포트로 트래픽을 전달하여 인터넷이 차단되었습니다',
			'NetCheckScreen.suggestProxyReset' => '아래의 [시스템 프록시 정리 및 재설정]을 클릭하여 즉시 인터넷을 복구하세요',
			'NetCheckScreen.actionResetProxy' => '프록시 정리 및 재설정',
			'NetCheckScreen.issueProxyBlocked' => '시스템 프록시가 적용되지 않았습니다. 백신 프로그램의 차단이나 권한 제한일 수 있습니다',
			'NetCheckScreen.suggestProxyReapply' => '아래 버튼을 눌러 시스템 프록시를 강제로 다시 적용해 보세요',
			'NetCheckScreen.actionReapplyProxy' => '시스템 프록시 다시 적용',
			'NetCheckScreen.issueProxyRead' => '시스템 프록시 설정을 읽는 중 경미한 예외가 발생했습니다',
			'NetCheckScreen.issueHandshakeBlocked' => '선택된 프록시 노드가 인터넷에 연결할 수 없습니다. 연결이 차단되었을 수 있습니다',
			'NetCheckScreen.suggestHandshakeSwitch' => '해당 노드가 점검 중이거나 연결할 수 없습니다. 다른 노드로 전환해 주세요',
			'NetCheckScreen.suggestHandshakeSlow' => ({required Object delay}) => '노드 지연 시간이 다소 높습니다 (${delay} ms). 속도 측정을 통해 더 가까운 노드를 선택하세요',
			'NetCheckScreen.suggestHandshakeCheck' => '노드 설정을 확인하거나 테스트 대상을 변경하세요',
			'NetCheckScreen.conclusionPerfect' => '전체 네트워크 최상! 모든 노드와 프록시 설정이 원활하게 연결되어 있습니다.',
			'NetCheckScreen.conclusionGood' => '네트워크가 대체로 정상입니다. 경미한 지연이나 경고가 감지되었으니 상세 정보를 확인하세요.',
			'NetCheckScreen.conclusionWarning' => '일부 네트워크 또는 프록시에 이상이 감지되었습니다. 아래의 [원클릭 복구]를 이용해 보세요.',
			'NetCheckScreen.conclusionCritical' => '심각한 네트워크 차단! 로컬 네트워크가 끊겼거나 프록시 코어가 차단되었습니다.',
			'SpeedTestScreen.title' => '속도 측정',
			'SpeedTestScreen.startTest' => '측정 시작',
			'SpeedTestScreen.stopTest' => '중지',
			'SpeedTestScreen.reTest' => '다시 측정',
			'SpeedTestScreen.ready' => '준비 완료',
			'SpeedTestScreen.testingPing' => 'Ping & 지터 측정 중...',
			'SpeedTestScreen.testingDownload' => '다운로드 속도 측정 중...',
			'SpeedTestScreen.testingUpload' => '업로드 속도 측정 중...',
			'SpeedTestScreen.completed' => '측정 완료',
			'SpeedTestScreen.stopped' => '중지됨',
			'SpeedTestScreen.ping' => '지연 시간',
			'SpeedTestScreen.jitter' => '지터',
			'SpeedTestScreen.download' => '다운로드',
			'SpeedTestScreen.upload' => '업로드',
			'SpeedTestScreen.currentProxy' => '현재 프록시',
			'SpeedTestScreen.directConnection' => '직접 연결',
			'SpeedTestScreen.server' => '측정 서버',
			'SpeedTestScreen.serverLocation' => '서버 위치',
			'SpeedTestScreen.realtimeSpeed' => '실시간 속도 그래프',
			'SpeedTestScreen.peakSpeed' => '최대 속도',
			'SpeedTestScreen.avgSpeed' => '평균 속도',
			'SpeedTestScreen.testHistory' => '측정 기록',
			'SpeedTestScreen.clearHistory' => '기록 삭제',
			'VersionUpdateScreen.versionReady' => ({required Object p}) => '새 버전 [${p}]이 준비되었습니다',
			'VersionUpdateScreen.update' => '업데이트를 위해 재시작',
			'VersionUpdateScreen.cancel' => '나중에',
			'loginScreen.login' => '로그인',
			'loginScreen.register' => '계정 가입',
			'loginScreen.forgotPassword' => '비밀번호 찾기',
			'loginScreen.provider' => '서비스 제공자',
			'loginScreen.providerName' => '${_root.loginScreen.provider} 코드/별칭/URL',
			'loginScreen.providerNameRequired' => '${_root.loginScreen.provider} 코드/별칭/URL을 입력하세요',
			'loginScreen.account' => '계정',
			'loginScreen.accountRequired' => '계정을 입력하세요',
			'loginScreen.email' => '이메일',
			'loginScreen.emailRequired' => '이메일 주소를 입력하세요',
			'loginScreen.password' => '비밀번호',
			'loginScreen.passwordRequired' => '비밀번호를 입력하세요',
			'loginScreen.validEmailRequired' => '유효한 이메일 주소를 입력하세요',
			'loginScreen.passwordMinLength' => ({required Object minLength}) => '비밀번호 길이는 최소 ${minLength}자 이상이어야 합니다',
			'loginScreen.unsupportedProvider' => '지원되지 않는 ${_root.loginScreen.provider}',
			'loginScreen.unsupportedProviderType' => '지원되지 않는 ${_root.loginScreen.provider} 유형',
			'loginScreen.unActivedProvider' => '로그인 기능이 활성화되어 있지 않습니다',
			'loginScreen.providerLoginSupportRequired' => ({required Object p}) => '공급자 코드/별칭은 ${_root.loginScreen.provider}에 문의해 주세요.\n${_root.loginScreen.provider} 연동은 다음을 참고하세요: ${p}',
			'loginScreen.providerDisclaimer' => '면책 조항: ${_root.loginScreen.provider}는 제3자 서비스이며, 본 앱과는 무관합니다',
			'loginScreen.createSessionFailed' => '세션 생성 실패, 제공업체 또는 계정을 확인하세요',
			'main.tray.menuOpen' => '열기',
			'main.tray.menuExit' => '종료',
			'main.tray.coreDisconnected' => 'Wmimo · 코어 미실행',
			'main.tray.coreRunning' => 'Wmimo · 코어 실행 중',
			'main.tray.startProxy' => '프록시 연결 시작',
			'main.tray.stopProxy' => '프록시 연결 끊기',
			'main.tray.restartCore' => '프록시 코어 재시작',
			'main.tray.systemProxyItem' => '시스템 프록시',
			'main.tray.tunModeItem' => 'TUN 모드',
			'main.tray.outboundMode' => '아웃바운드 모드',
			'main.tray.modeRule' => '규칙 라우팅',
			'main.tray.modeGlobal' => '글로벌 프록시',
			'main.tray.modeDirect' => '직접 연결',
			'main.tray.profilesMenu' => '구독 설정',
			'main.tray.updateAllProfiles' => '모든 구독 설정 업데이트',
			'main.tray.proxyNodes' => '프록시 노드',
			'main.tray.tools' => '도구',
			'main.tray.copyProxyCmd' => '터미널 프록시 명령 복사 (CMD / Bash)',
			'main.tray.delayTestAll' => '모든 노드 지연 속도 측정',
			'main.tray.openDashboard' => '제어판 열기',
			'main.tray.resetSystemProxy' => '네트워크 복구 / 시스템 프록시 초기화',
			'main.tray.copyCmdPowerShell' => 'PowerShell 명령어',
			'main.tray.copyCmdCmd' => 'CMD 명령어',
			'main.tray.copyCmdBash' => 'Bash/Zsh 명령어',
			'meta.enable' => '활성화',
			'meta.disable' => '비활성화',
			'meta.open' => '열기',
			'meta.close' => '닫기',
			'meta.quit' => '종료',
			'meta.add' => '추가',
			'meta.addSuccess' => '성공적으로 추가되었습니다',
			'meta.addFailed' => ({required Object p}) => '추가 실패: ${p}',
			'meta.remove' => '제거',
			'meta.removeConfirm' => '정말로 삭제하시겠습니까?',
			'meta.edit' => '편집',
			'meta.view' => '보기',
			'meta.remark' => '메모',
			'meta.byDefault' => '기본값',
			'meta.editRemark' => '메모 편집',
			'meta.more' => '더 보기',
			'meta.tips' => '정보',
			'meta.selectAll' => '전체 선택',
			'meta.copy' => '복사',
			'meta.paste' => '반죽',
			'meta.cut' => '자르다',
			'meta.save' => '저장',
			'meta.ok' => '확인',
			'meta.cancel' => '취소',
			'meta.faq' => '자주 묻는 질문',
			'meta.doc' => '문서',
			'meta.htmlTools' => 'HTML 툴셋',
			'meta.download' => '다운로드',
			'meta.loading' => '로드 중...',
			'meta.days' => '일',
			'meta.hours' => '시간',
			'meta.minutes' => '분',
			'meta.seconds' => '초',
			'meta.milliseconds' => '밀리초',
			'meta.protocol' => '프로토콜',
			'meta.search' => '검색',
			'meta.custom' => '사용자 정의',
			'meta.connect' => '연결',
			'meta.disconnect' => '연결 해제',
			'meta.connected' => '연결됨',
			'meta.disconnected' => '연결 해제됨',
			'meta.connecting' => '연결 중',
			'meta.connectTimeout' => '연결 시간 초과',
			'meta.timeout' => '시간 초과',
			'meta.timeoutDuration' => '시간 초과 기간',
			'meta.latency' => '지연 시간',
			'meta.latencyTest' => '지연 속도 테스트',
			'meta.networkCheck' => '네트워크 점검',
			'meta.speedTest' => '속도 측정',
			'meta.language' => '언어',
			'meta.next' => '다음',
			'meta.done' => '완료',
			'meta.apply' => '적용',
			'meta.refresh' => '새로고침',
			'meta.retry' => '다시 시도하시겠습니까?',
			'meta.update' => '업데이트',
			'meta.updateInterval' => '업데이트 간격',
			'meta.updateFailed' => ({required Object p}) => '업데이트 실패: ${p}',
			'meta.updateInterval5mTips' => '최소: 5분',
			'meta.updateIntervalPreferByProfile' => '공급자 설정 우선',
			'meta.none' => '없음',
			'meta.reset' => '초기화',
			'meta.resetConfirm' => '모든 앱 설정을 초기화하시겠습니까?',
			'meta.resetSuccess' => '앱 설정이 기본값으로 초기화되었습니다',
			'meta.resetCoreConfirm' => '코어 설정 및 덮어쓰기 구성을 초기화하시겠습니까?',
			'meta.resetCoreSuccess' => '코어 설정이 기본값으로 초기화되었습니다',
			'meta.authentication' => '인증',
			'meta.submit' => '제출',
			'meta.user' => '사용자',
			'meta.account' => '계정',
			'meta.password' => '비밀번호',
			'meta.decryptPassword' => '복호화 비밀번호',
			'meta.required' => '필수',
			'meta.go' => '계속',
			'meta.sudoPassword' => 'sudo 비밀번호 (TUN 모드에 필요)',
			'meta.other' => '기타',
			'meta.dns' => 'DNS',
			'meta.url' => 'URL',
			'meta.urlInvalid' => '유효하지 않은 URL',
			'meta.urlCannotEmpty' => '링크는 비워둘 수 없습니다',
			'meta.urlTooLong' => 'URL이 너무 깁니다 (>8182)',
			'meta.copyUrl' => '링크 복사',
			'meta.openUrl' => '링크 열기',
			'meta.shareUrl' => '링크 공유',
			'meta.coreSettingTips' => '참고: 설정을 수정한 후 적용하려면 다시 연결해야 합니다',
			'meta.overwrite' => '덮어쓰기',
			'meta.overwriteCustom' => '사용자 정의 덮어쓰기',
			'meta.overwriteAppend' => '추가 덮어쓰기',
			'meta.overwriteTips' => '원본 프로필 <- 사용자 정의 덮어쓰기 <- 앱 덮어쓰기',
			'meta.noOverwrite' => '덮어쓰지 않음',
			'meta.overwriteSettings' => '덮어쓰기 설정',
			'meta.diversionTemplates' => '분류 템플릿',
			'meta.ruleProviders' => '규칙 세트 (RuleSet)',
			'meta.ruleTemplates' => '규칙 템플릿',
			'meta.proxyGroupsTemplates' => '그룹 템플릿',
			'meta.proxyGroups' => '프록시 그룹',
			'meta.proxyNodeList' => '프록시 노드 목록',
			'meta.proxyNodeFailure' => ({required Object p}) => '다음 프록시 노드가 만료되어 자동으로 제거되었습니다: ${p}',
			'meta.externalController' => '외부 컨트롤러',
			'meta.secret' => '비밀번호(Secret)',
			'meta.tcpConcurrent' => 'TCP 동시 핸드셰이크',
			'meta.globalClientFingerprint' => 'TLS 글로벌 핑거프린트',
			'meta.allowLanAccess' => 'LAN 장치 액세스',
			'meta.mixedPort' => '혼합 프록시 포트',
			'meta.logLevel' => '로그 레벨',
			'meta.findProcessMode' => '프로세스 매칭 모드',
			'meta.tcpkeepAliveInterval' => 'TCP Keep-alive 간격',
			'meta.delayTestUrl' => '지연 테스트 URL',
			'meta.delayTestTimeout' => '지연 테스트 시간 초과(ms)',
			'meta.tun' => 'TUN',
			'meta.ntp' => 'NTP',
			'meta.tls' => 'TLS',
			'meta.geo' => 'GEO',
			'meta.geoDownloadByProxy' => '프록시를 통해 Geo RuleSet 다운로드',
			'meta.geoRulesetTips' => 'Geosite/Geoip는 해당 RuleSet으로 변환됩니다',
			'meta.asnNotSupportInIosTips' => 'iOS 시스템 메모리 제한으로 인해 IP-ASN 및 SRC-IP-ASN 규칙은 iOS에서 무시됩니다.',
			'meta.sniffer' => '스니퍼',
			'meta.userAgent' => 'UserAgent',
			'meta.launchAtStartup' => '시작 시 실행',
			'meta.launchAtStartupRunAsAdmin' => 'Wmimo를 관리자 권한으로 다시 시작하십시오',
			'meta.tunModeRunAsAdmin' => 'TUN 모드는 시스템 관리자 권한이 필요합니다. 앱을 관리자 권한으로 다시 시작하십시오',
			'meta.tunSwitchToSystemProxy' => '임시로 [시스템 프록시 모드]로 전환하여 계속 연결하시겠습니까?',
			'meta.tunCreateAdapterFailedAdmin' => 'TUN 가상 네트워크 어댑터 생성 실패: Access is denied.\nTUN 모드는 관리자 권한이 필요합니다. 마우스 우클릭 후 【관리자 권한으로 실행】을 선택하거나, 메인 화면/코어 설정에서 TUN 모드를 끄고 시스템 프록시를 사용하여 연결하십시오.',
			'meta.portableMode' => '포터블 모드',
			'meta.portableModeDisableTips' => '포터블 모드를 종료해야 하는 경우 [Wmimo]를 종료하고 [wmimo.exe]와 동일한 디렉토리에 있는 [portable] 폴더를 수동으로 삭제하십시오',
			'meta.systemProxy' => '시스템 프록시',
			'meta.autoConnectAfterLaunch' => '실행 후 자동 연결',
			'meta.autoConnectAtBoot' => '시스템 시작 후 자동 연결',
			'meta.autoConnectAtBootTips' => '시스템 지원이 필요합니다. 일부 시스템에서는 [자동 시작]을 활성화해야 할 수도 있습니다.',
			'meta.hideAfterLaunch' => '실행 후 창 숨기기',
			'meta.autoSetSystemProxy' => '연결 시 시스템 프록시 자동 설정',
			'meta.bypassSystemProxy' => '시스템 프록시를 우회하도록 허용된 도메인 이름',
			'meta.excludeFromRecent' => '[최근 작업]에서 숨기기',
			'meta.wakeLock' => '절전 모드 방지',
			'meta.hideVpn' => 'VPN 아이콘 숨기기',
			'meta.hideVpnTips' => 'IPv6를 활성화하면 이 기능이 작동하지 않습니다',
			'meta.hideDockIcon' => 'Dock 아이콘 숨기기',
			'meta.showTrayTraffic' => '트레이에 트래픽 정보 표시',
			'meta.website' => '웹사이트',
			'meta.homePage' => '홈페이지',
			'meta.rule' => '규칙',
			'meta.global' => '글로벌',
			'meta.direct' => '직접 연결',
			'meta.block' => '차단',
			'meta.qrcode' => 'QR 코드',
			'meta.qrcodeTooLong' => '텍스트가 너무 길어 표시할 수 없습니다',
			'meta.qrcodeShare' => 'QR 코드 공유',
			'meta.textToQrcode' => '텍스트를 QR 코드로 변환',
			'meta.qrcodeScan' => 'QR 코드 스캔',
			'meta.qrcodeScanResult' => '스캔 결과',
			'meta.qrcodeScanFromImage' => '이미지에서 스캔',
			'meta.qrcodeScanFromClipboard' => '클립보드에서 읽기',
			'meta.qrcodeRecognized' => 'QR 코드가 인식되었습니다',
			'meta.qrcodeDropHint' => '위 버튼을 클릭하여 화면 캡처 또는 이미지 선택',
			'meta.confirmImport' => '가져오기 확인',
			'meta.reScan' => '다시 스캔',
			'meta.qrcodeScanResultFailed' => '이미지 분석 실패. 스크린샷이 유효한 QR 코드인지 확인하십시오',
			'meta.qrcodeScanResultEmpty' => '스캔 결과가 비어 있습니다',
			'meta.screenshot' => '스크린샷',
			'meta.backupAndSync' => '백업 및 동기화',
			'meta.importSuccess' => '가져오기 성공',
			'meta.rewriteConfirm' => '이 파일은 기존 로컬 설정을 덮어씁니다. 계속하시겠습니까?',
			'meta.importAndExport' => '가져오기 및 내보내기',
			'meta.import' => '가져오기',
			'meta.importFromUrl' => 'URL에서 가져오기',
			'meta.export' => '내보내기',
			'meta.send' => '보내기',
			'meta.receive' => '받기',
			'meta.sendConfirm' => '보내기를 확인하시겠습니까?',
			'meta.continueConnectConfirm' => '계속 연결하시겠습니까?',
			'meta.termOfUse' => '서비스 약관',
			'meta.privacyPolicy' => '개인정보 보호정책',
			'meta.log' => '로그',
			'meta.coreLog' => '코어 로그',
			'meta.core' => '코어',
			'meta.help' => '도움말',
			'meta.tutorial' => '튜토리얼',
			'meta.board' => '보드',
			'meta.boardOnline' => '온라인 보드 사용',
			'meta.boardOnlineUrl' => '온라인 보드 URL',
			'meta.boardLocalPort' => '로컬 보드 포트',
			'meta.connections' => '연결',
			'meta.closeAllConnections' => '모든 연결 닫기',
			'meta.searchConnections' => '연결 검색 (도메인/IP/규칙/프로세스)',
			'meta.noFilterResults' => '일치하는 연결 없음',
			'meta.searchRules' => '규칙 검색 (유형/페이로드/프록시)',
			'meta.searchProfiles' => '프로필 검색 (이름/URL/비고)',
			'meta.noMatchingProfiles' => '일치하는 프로필을 찾을 수 없습니다',
			'meta.rules' => '분류 규칙',
			'meta.clear' => '지우기',
			'meta.copySuccess' => '복사되었습니다',
			'meta.alwayOnVPN' => '상시 연결',
			'meta.disableFontScaler' => '글꼴 크기 조정 비활성화 (재시작 후 적용)',
			'meta.autoOrientation' => '화면 방향에 따라 회전',
			'meta.restartTakesEffect' => '재시작 후 적용',
			'meta.reconnectTakesEffect' => '다시 연결 후 적용',
			'meta.runtimeProfile' => '런타임 프로필',
			'meta.willCompleteAfterRebootInstall' => '시스템 확장 설치를 완료하려면 장치를 재시작하십시오',
			'meta.willCompleteAfterRebootUninstall' => '시스템 확장 제거를 완료하려면 장치를 재시작하십시오',
			'meta.requestNeedsUserApproval' => '1. [시스템 설정]-[개인정보 보호 및 보안]에서 Wmimo의 시스템 확장 설치를 [허용]하십시오\n2. [시스템 설정]-[일반]-[로그인 항목 및 확장 프로그램]-[네트워크 확장 프로그램]에서 [wmimoServiceSE]를 활성화하십시오\n완료 후 다시 연결하십시오',
			'meta.FullDiskAccessPermissionRequired' => '[시스템 설정]-[개인정보 보호 및 보안]-[전체 디스크 액세스]에서 wmimoServiceSE 권한을 활성화하고 다시 연결하십시오.',
			'meta.proxy' => '프록시',
			'meta.theme' => '테마',
			'meta.tvMode' => 'TV 모드',
			'meta.autoUpdate' => '자동 업데이트',
			'meta.updateChannel' => '자동 업데이트 채널',
			'meta.onlineCustomerService' => '온라인 고객센터',
			'meta.subscriptionChannel' => '구독 채널',
			'meta.hasNewVersion' => ({required Object p}) => '버전 ${p}로 업데이트',
			'meta.autoDownloadPkg' => '업데이트 패키지 자동 다운로드',
			'meta.devOptions' => '개발자 옵션',
			'meta.joinUs' => '커뮤니티 참여',
			'meta.about' => '정보',
			'meta.name' => '이름',
			'meta.version' => '버전',
			'meta.notice' => '공지사항',
			'meta.sort' => '정렬',
			'meta.recommended' => '추천',
			'meta.innerError' => ({required Object p}) => '내부 오류: ${p}',
			'meta.share' => '공유',
			'meta.importFromClipboard' => '클립보드에서 가져오기',
			'meta.exportToClipboard' => '클립보드로 내보내기',
			'meta.server' => '서버',
			'meta.port' => '포트',
			'meta.donate' => '후원',
			'meta.setting' => '설정',
			'meta.settingCore' => '코어 설정',
			'meta.settingApp' => '앱 설정',
			'meta.coreOverwrite' => '코어 덮어쓰기',
			'meta.iCloud' => 'iCloud',
			'meta.webdav' => 'Webdav',
			'meta.lanSync' => 'LAN 동기화',
			'meta.lanSyncNotQuitTips' => '동기화가 완료될 때까지 이 화면을 종료하지 마십시오',
			'meta.deviceNoSpace' => '디스크 공간 부족',
			'meta.hideSystemApp' => '시스템 앱 숨기기',
			'meta.hideAppIcon' => '앱 아이콘 숨기기',
			'meta.openDir' => '파일 디렉토리 열기',
			'meta.type' => '유형',
			'meta.fileChoose' => '파일 선택',
			'meta.filePathCannotEmpty' => '파일 경로는 비워둘 수 없습니다',
			'meta.fileNotExist' => ({required Object p}) => '파일이 존재하지 않습니다: ${p}',
			'meta.fileTypeInvalid' => ({required Object p}) => '유효하지 않은 파일 형식: ${p}',
			'meta.uwpExemption' => 'UWP 네트워크 격리 면제',
			'meta.getProfile' => '구독 가져오기',
			'meta.buyProfile' => '구독 구매',
			'meta.addProfile' => '구독 추가',
			'meta.myProfiles' => '구독 설정',
			'meta.profileEdit' => '구독 설정 편집',
			'meta.profileNeedActive' => '먼저 이 프로필을 현재 프로필로 설정한 뒤 연결/재연결하세요',
			'meta.profileDownloadBackupChannel' => '백업 다운로드 채널 사용',
			'meta.profileDownloadBackupChannelTips' => 'Wmimo에서 제공하는 프록시 다운로드 채널(어떤 정보도 저장하지 않음)',
			'meta.profileEditReloadAfterProfileUpdate' => '프로필 업데이트 후 다시 로드',
			'meta.profileRulesAppendApplePush' => 'Apple 푸시 알림 규칙 추가',
			'meta.profileRulesAppendProxyTips' => '규칙은 원본 설정의 [proxy-groups]에서 [url-test] 또는 [select] 유형의 첫 번째 프록시로 자동 설정됩니다',
			'meta.profileImport' => '설정 파일 가져오기',
			'meta.profileAddUrlOrContent' => '구독 링크 추가',
			'meta.profileUrlOrContent' => '구독 링크 / 노드 내용',
			'meta.profileUrlOrContentHit' => '구독 링크 또는 설정 내용 [필수]',
			'meta.profileUrlOrContentCannotEmpty' => '구독 링크 또는 내용은 비워 둘 수 없습니다',
			'meta.overview' => '개요',
			'meta.trafficStats' => '트래픽 통계',
			'meta.realtimeMonitor' => '실시간 모니터링',
			'meta.realtimeUpload' => '실시간 업로드',
			'meta.realtimeDownload' => '실시간 다운로드',
			'meta.sessionUpload' => '이번 업로드',
			'meta.sessionDownload' => '이번 다운로드',
			'meta.planUsage' => '요금제 사용량',
			'meta.memoryUsage' => '메모리',
			'meta.remaining' => '남음',
			'meta.expireTime' => '만료 시간',
			'meta.tunMode' => 'TUN 모드',
			'meta.daysAgo' => ({required Object p}) => '${p}일 전',
			'meta.hoursAgo' => ({required Object p}) => '${p}시간 전',
			'meta.lessThanOneHourAgo' => '1시간 이내',
			'meta.inUse' => '사용 중',
			'meta.remoteSubscription' => '원격 구독',
			'meta.noTrafficData' => '사용량 통계 없음',
			'meta.localProfile' => '로컬 파일',
			'meta.viewYamlConfig' => 'YAML 설정 보기',
			'meta.editYamlConfig' => 'YAML 설정 편집',
			'meta.copySubscriptionUrl' => '구독 URL 복사',
			'meta.qrCode' => 'QR 코드',
			'meta.deleteProfile' => '설정 삭제',
			'meta.noProfilesYet' => '등록된 구독 설정이 없습니다',
			'meta.addProfilePrompt' => '오른쪽 상단 + 를 눌러 링크 추가 또는 파일 가져오기',
			'meta.subscriptionUrlCopied' => '구독 URL이 클립보드에 복사되었습니다',
			'meta.autoGroupTip' => ({required Object group, required Object type}) => '「${group}」은(는) ${type} 자동 정책 그룹으로 지연 시간/가용성에 따라 노드가 자동 선택됩니다. 수동으로 선택하려면 \'노드 선택\' 그룹에서 전환하세요.',
			'meta.switchNodeFailed' => ({required Object p}) => '노드 전환 실패: ${p}',
			'meta.nodeSelected' => ({required Object p}) => '선택된 노드: ${p}',
			'meta.startingCoreAndTesting' => '코어를 시작하고 지연 속도를 측정하는 중...',
			'meta.chartMinutes' => ({required Object p}) => '${p} 분',
			'meta.chartUpload' => '업로드',
			'meta.chartDownload' => '다운로드',
			'meta.author' => '작성자',
			'meta.githubRepo' => '오픈 소스 저장소',
			'meta.openSourceLicense' => '오픈 소스 라이선스',
			'meta.submitFeedback' => '피드백 및 문제 제출',
			'meta.copiedToClipboard' => '클립보드에 복사되었습니다',
			'meta.autoScrollEnabled' => '자동 스크롤 켜짐',
			'meta.autoScrollDisabled' => '자동 스크롤 꺼짐',
			'meta.pauseLogs' => '실시간 로그 일시 중지',
			'meta.resumeLogs' => '실시간 로그 재개',
			'meta.scrollToLatest' => '최신으로 스크롤',
			'meta.scrollToBottom' => '맨 아래로 스크롤',
			'meta.newLogsCount' => ({required Object p}) => '(${p}개 새 로그)',
			'meta.copiedLogContent' => '로그 내용이 복사되었습니다',
			'meta.copyLog' => '로그 복사',
			'meta.noLogsPrompt' => '아직 로그가 없습니다. 프록시 시작 후 실시간 로그가 표시됩니다.',
			'meta.searchLogsHint' => ' (IP, 도메인, 규칙, 오류...)',
			_ => null,
		} ?? switch (path) {
			'meta.offlinePreviewPrompt' => '오프라인 미리보기 모드. 프록시를 시작하여 라우팅 및 지연 테스트를 사용합니다.',
			'meta.manualSelect' => '수동 선택',
			'meta.autoSelect' => '자동 선택',
			'meta.speedTestGroup' => '그룹 속도 테스트',
			'meta.pause' => '일시 중지',
			'meta.resume' => '재개',
			'meta.ipInfo' => 'IP 정보',
			'meta.ipFetching' => 'IP 정보 가져오는 중...',
			'meta.ipCopied' => 'IP 주소가 클립보드에 복사되었습니다',
			'meta.ipLocation' => '위치',
			'meta.ipIsp' => '제공자',
			'meta.ipTapToFetch' => '탭하여 IP 정보 가져오기',
			'meta.ipProxy' => '프록시 출구',
			'meta.ipDirect' => '로컬 직접 연결',
			'meta.ipAsn' => 'ASN',
			'meta.ipOrg' => '소속 조직',
			'meta.ipTimezone' => '시간대',
			'meta.ipCoordinates' => '좌표',
			'meta.ipMoreDetails' => '자세한 정보',
			'meta.ipLessDetails' => '접기',
			'meta.collapseAll' => '모든 그룹 접기',
			'meta.expandAll' => '모든 그룹 펼치기',
			'meta.donateTitle' => '💖 개발자에게 커피 한 잔 후원하기',
			'meta.donateThankYou' => 'ฅ^•ﻌ•^ฅ 여러분의 따뜻한 후원은 Wmimo를 발전시키는 가장 큰 원동력입니다 ~ ☕✨',
			'meta.tokenCurrency' => '토큰',
			'meta.networkChain' => '네트워크',
			'meta.depositAddress' => 'APTOS 입금 주소',
			'meta.clickToCopy' => '클릭하여 복사',
			'meta.copyAddressBtn' => '주소 복사 ✨',
			'meta.donateAddressCopied' => '( ੭ ˙ᗜ˙ )੭ 주소가 복사되었습니다! 후원해 주셔서 진심으로 감사드립니다~ 💖',
			'meta.donateTip' => '💡 팁: Bybit 또는 모든 Aptos 호환 지갑 스캔 지원',
			'meta.qrcodeParsing' => 'QR 코드 분석 중...',
			'meta.qrcodeNotFound' => 'QR 코드가 감지되지 않았습니다',
			'meta.qrcodeSupportHint' => '각종 구독, 노드 및 설정 QR 코드 이미지 분석 지원',
			'meta.qrcodeCameraHint' => '프레임 안에 QR 코드를 맞추면 자동으로 스캔됩니다',
			'meta.flashlight' => '손전등',
			'meta.screenshotDesc' => '화면 캡처',
			'meta.fromImageDesc' => '로컬 이미지',
			'meta.fromClipboardDesc' => '클립보드 읽기',
			'meta.errorPrompt' => '오류 안내',
			'meta.copied' => '복사됨',
			'meta.sortAndFilterNodes' => '노드 정렬 및 필터링',
			'meta.sortOptions' => '정렬 옵션',
			'meta.sortDefault' => '기본 정렬',
			'meta.sortLatency' => '지연 시간 정렬',
			'meta.sortName' => '이름순 (A-Z)',
			'meta.sortRegion' => '지역별 그룹',
			'meta.filterOptions' => '필터 옵션',
			'meta.portableUpdateTip' => ({required Object version}) => '포터블(무설치) 모드가 감지되었습니다:\n포터블 버전은 앱 내 덮어쓰기 업데이트를 지원하지 않습니다. 공식 저장소에서 최신 포터블 압축 파일을 다운로드하여 덮어쓰기 해주세요.\n\n최신 버전: v${version}',
			'meta.portableModeTipTitle' => '포터블 모드 안내',
			'meta.noNodesToSpeedTest' => '측정할 수 있는 노드가 없습니다',
			'meta.alreadyLatestVersion' => ({required Object version}) => '이미 최신 버전입니다 (v${version})',
			'meta.checkUpdateFailed' => '업데이트 확인 실패, 네트워크 연결을 확인하세요',
			'meta.hideTimeoutNodes' => '시간 초과 및 오프라인 노드 숨기기',
			'meta.hideTimeoutNodesDesc' => '속도 테스트 실패 또는 시간 초과된 노드를 자동으로 숨깁니다',
			'meta.speedtestScenario' => '현재 속도 테스트 시나리오',
			'meta.speedtestScenarioSwitch' => '속도 테스트 시나리오 전환',
			'meta.speedtestScenarioDesc' => '실제 연결 지연 및 가용성을 테스트할 대상을 선택하세요',
			'meta.speedtestAllNodes' => '모든 노드 속도 측정',
			'meta.retestTimeoutNodes' => '시간 초과 노드만 재테스트',
			'meta.switchedTargetScenario' => ({required Object target}) => '속도 테스트 시나리오 변경됨: ${target}',
			'meta.notTested' => '미측정',
			'meta.timeoutOrFailed' => '시간 초과 / 연결 불가',
			'meta.identifiedRegion' => '지역',
			'meta.nodeProtocol' => '프로토콜',
			'meta.currentLatency' => '지연 시간',
			'meta.testScenario' => '테스트 시나리오',
			'meta.belongsToGroup' => '그룹',
			'meta.copyNodeName' => '이름 복사',
			'meta.nodeNameCopied' => '노드 이름이 복사되었습니다',
			'meta.testSingleNode' => '단독 테스트',
			'meta.selectThisNode' => '이 노드 선택',
			'meta.allNodesNormal' => '모든 노드가 정상입니다. 재테스트가 필요하지 않습니다',
			'meta.customUrlPrompt' => '사용자 지정 URL (예: http://...)',
			'meta.customTarget' => '사용자 지정 대상',
			'meta.downloadFailedTip' => '설치 패키지 다운로드 실패, 네트워크를 확인하거나 웹사이트에서 다운로드하세요.',
			'meta.discoveredNewVersion' => ({required Object version}) => '새 버전 발견됨: v${version}',
			'meta.preparingUpdate' => '업데이트 준비 중...',
			'meta.downloadingPackage' => '설치 패키지 다운로드 중, 잠시만 기다려주세요...',
			'meta.downloadUpdateNow' => '지금 업데이트 다운로드',
			'meta.downloadFromWeb' => '웹사이트에서 다운로드',
			'meta.switchSource' => '서버 변경',
			'meta.serverSwitch' => '측정 서버 전환',
			'meta.autoDetectBest' => '최적 서버 자동 감지',
			'meta.serverSwitchDesc' => '연결을 테스트할 CDN 또는 사용자 지정 대상을 선택하세요',
			'meta.autoSelectedBest' => ({required Object server, required Object ping}) => '최적 서버 자동 선택됨: ${server} (${ping} ms)',
			'meta.networkGradeTitle' => '네트워크 품질 종합 점수',
			'meta.copyReport' => '리포트 복사',
			'meta.reportCopied' => '리포트가 복사되었습니다. 바로 공유할 수 있습니다',
			'meta.gamingExperience' => '게이밍 경험',
			'meta.streamingExperience' => '스트리밍',
			'meta.meetingExperience' => '화상 회의',
			'meta.customSpeedtestUrl' => '사용자 지정 다운로드 URL (https://...)',
			'meta.customSpeedtestSource' => '사용자 지정 측정 서버',
			'meta.userSpecifiedUrl' => '사용자 지정 URL',
			'meta.cannotBeEmpty' => ({required Object item}) => '${item}은(는) 비워둘 수 없습니다',
			'meta.alreadyExists' => ({required Object item}) => '${item}이(가) 이미 존재합니다',
			'meta.installFailedWithCode' => ({required Object installer, required Object code}) => '${installer} 설치 실패, 코드: ${code}',
			'meta.resetSystemProxy' => '네트워크 복구 / 시스템 프록시 초기화',
			'meta.resetSystemProxyDesc' => '잔여 시스템 프록시 설정을 제거하고 네트워크를 새로고침하여 비정상 종료 후 인터넷 불가 문제를 해결합니다',
			'meta.resetSystemProxySuccess' => '시스템 프록시가 초기화되었으며 네트워크가 정상 복구되었습니다',
			'meta.networkDiagnostics' => '네트워크 진단 및 스마트 복구',
			'meta.networkDiagnosticsDesc' => 'NIC, DNS, 코어 포트, 프록시 상태를 원클릭으로 종합 진단하고 자동 복구',
			'meta.sortLatencyDesc' => '지연 시간 높은 순',
			'meta.sortNameDesc' => '이름 Z-A',
			'meta.sortMultiplier' => '배율 낮은 순',
			'meta.uwpLoopback' => 'UWP 루프백 예외 도구',
			'meta.uwpLoopbackDesc' => '마이크로소프트 스토어, Xbox 등 UWP 앱이 로컬 프록시를 사용하도록 예외 처리',
			'meta.uwpExemptAllCommon' => '추천 앱 일괄 예외 처리',
			'meta.uwpApplySuccess' => 'UWP 루프백 예외 규칙이 적용되었습니다',
			'meta.common' => '주요',
			'meta.exempted' => '예외 처리됨',
			'meta.notExempted' => '미처리',
			'meta.deselectAll' => '선택 해제',
			'meta.userApps' => '사용자 앱',
			'meta.systemApps' => '시스템 앱',
			'meta.selectedOnly' => '선택됨',
			'meta.proxySelectedMode' => '선택 앱만 프록시 적용',
			'meta.proxySelectedModeDesc' => '선택한 앱만 프록시를 거치고 다른 앱은 직접 연결합니다',
			'meta.bypassSelectedMode' => '선택 앱 우회',
			'meta.bypassSelectedModeDesc' => '선택한 앱은 직접 연결하고 다른 앱은 프록시를 거칩니다',
			'meta.invertSelection' => '반전 선택',
			'meta.all' => '전체',
			'meta.showAppIcon' => '앱 아이콘 표시',
			'meta.proxySelection' => '프록시 선택',
			'meta.regionHk' => '🇭🇰 홍콩',
			'meta.regionJp' => '🇯🇵 일본',
			'meta.regionSg' => '🇸🇬 싱가포르',
			'meta.regionTw' => '🇹🇼 대만',
			'meta.regionUs' => '🇺🇸 미국',
			'meta.regionKr' => '🇰🇷 한국',
			'meta.macMoveToApplications' => 'Wmimo를 [응용 프로그램] 폴더로 이동한 후 실행해 주세요',
			'meta.notifCurrentNode' => '현재 노드',
			'meta.notifMode' => '동작 모드',
			'meta.notifPort' => '포트',
			'meta.notifProfile' => '구독 프로필',
			'meta.notifDisconnect' => '연결 끊기',
			'meta.notifSwitchNode' => '노드 전환',
			'meta.notifVpnConnected' => 'VPN 프록시 연결됨',
			'meta.connectionDetails' => '연결 세부정보',
			'meta.sourceAddress' => '소스 주소',
			'meta.destinationAddress' => '대상 주소',
			'meta.host' => '호스트',
			'meta.process' => '프로세스',
			'meta.processPath' => '프로세스 경로',
			'meta.proxyChain' => '프록시 체인',
			'meta.networkProtocol' => '프로토콜',
			'meta.trafficUpload' => '업로드 트래픽',
			'meta.trafficDownload' => '다운로드 트래픽',
			'meta.connectionDuration' => '연결 시간',
			'meta.connectionStart' => '시작 시간',
			'meta.copyHost' => '호스트 복사',
			'meta.copyAllDetails' => '모든 세부정보 복사',
			'meta.closeThisConnection' => '이 연결 닫기',
			'meta.sortByDownload' => '다운로드순',
			'meta.sortByUpload' => '업로드순',
			'meta.sortBySpeed' => '속도순',
			'meta.sortByDuration' => '연결 시간순',
			'meta.sortByHost' => '호스트순',
			'meta.realtimeSpeed' => '실시간 속도',
			'meta.totalUpload' => '총 업로드',
			'meta.totalDownload' => '총 다운로드',
			'meta.activeConnections' => '활성 연결',
			'meta.openInFolder' => '폴더에서 보기',
			'meta.openProfilesDir' => '프로필 디렉터리 열기',
			'meta.profilePatches' => '프로필 덮어쓰기',
			'meta.nodeCount' => ({required Object p}) => '${p}개 노드',
			'meta.copyFilePath' => '파일 경로 복사',
			'meta.duplicateProfile' => '사본 만들기',
			'meta.useThisProfile' => '이 프로필 사용',
			'meta.websiteTest' => '웹사이트 테스트',
			'meta.testAll' => '모두 테스트',
			'meta.addTestWebsite' => '테스트 사이트 추가',
			'meta.websiteName' => '웹사이트 이름',
			'meta.websiteUrl' => '테스트 URL',
			'meta.websiteNameHint' => '웹사이트 이름 (예: Cloudflare)',
			'meta.websiteInputEmpty' => '웹사이트 이름과 URL을 입력하세요',
			'meta.autoRefresh' => '자동 새로고침',
			'meta.currentProfile' => '현재 프로필',
			'meta.quickActions' => '빠른 도구',
			'meta.fastest' => '가장 빠름',
			'meta.hideTimeout' => '시간 초과 숨기기',
			'meta.filteredTimeout' => '시간 초과 필터링됨',
			'meta.tunDeviceCreateFailed' => 'TUN 가상 네트워크 어댑터 생성 실패',
			'meta.test' => '테스트',
			'meta.addWebsite' => '웹사이트 추가',
			'meta.maxWebsitesReached' => '테스트 웹사이트는 최대 6개까지 추가할 수 있습니다',
			'meta.sideBySideLayout' => '병렬 레이아웃',
			'meta.sideBySideLayoutTips' => '와이드 화면에서 홈 카드 및 구독 목록을 병렬로 표시합니다',
			'meta.homeCardsManage' => '홈 카드 관리',
			'meta.homeCardsManageTips' => '홈 화면에 표시할 카드 모듈 및 표시 상태 사용자 정의',
			'meta.cardTrafficChart' => '트래픽 통계 차트',
			'meta.cardWebsiteTest' => '웹사이트 지연 시간 테스트',
			'meta.cardIpInfo' => 'IP 및 출구 정보',
			'meta.cardSubscription' => '구독 및 만료 정보',
			'meta.cardQuickActions' => '빠른 도구',
			'meta.resetDefaultCards' => '기본값 복원',
			'permission.camera' => '카메라',
			'permission.screen' => '화면 녹화',
			'permission.appQuery' => '애플리케이션 목록 가져오기',
			'permission.request' => ({required Object p}) => '[${p}] 권한 켜기',
			'permission.requestNeed' => ({required Object p}) => '[${p}] 권한을 켜주십시오',
			'tls.insecure' => '인증서 검증 건너뛰기',
			'tls.certificate' => '인증서',
			'tls.privateKey' => '개인 키',
			'tls.customTrustCert' => '사용자 정의 인증서',
			'tun.stack' => '네트워크 스택',
			'tun.stackGvisor' => 'gVisor',
			'tun.stackGvisorDesc' => '사용자 공간 네트워크 스택, 뛰어난 안정성과 호환성',
			'tun.stackSystem' => 'System',
			'tun.stackSystemDesc' => 'OS 기본 네트워크 스택, 고성능이지만 시스템 구현에 의존',
			'tun.stackMixed' => 'Mixed',
			'tun.stackMixedDesc' => '혼합 네트워크 스택 모드, 성능과 호환성의 균형',
			'tun.stackMips' => 'MIPS (Mihomo IP Stack)',
			'tun.stackMipsDesc' => 'Mihomo 자체 개발 고성능 IP 스택, 높은 처리량 및 낮은 지연 시간',
			'tun.inet4Address' => 'IPv4 주소 범위',
			'tun.inet6Address' => 'IPv6 주소 범위',
			'tun.dnsHijack' => 'DNS 하이제킹',
			'tun.strictRoute' => '엄격한 경로',
			'tun.tunDefaultRoute' => '기본 경로',
			'tun.icmpForward' => 'ICMP 전달',
			'tun.allowBypass' => '앱이 VPN을 우회하도록 허용',
			'tun.appendHttpProxy' => 'VPN에 HTTP 프록시 추가',
			'tun.bypassHttpProxyDomain' => 'HTTP 프록시를 우회하도록 허용된 도메인',
			'dns.listen' => '청취 연설',
			'dns.fakeIp' => 'fake-ip',
			'dns.fallback' => '폴백(Fallback)',
			'dns.preferH3' => 'DoH H3 우선',
			'dns.useHosts' => 'Hosts 사용',
			'dns.useSystemHosts' => '시스템 Hosts 사용',
			'dns.enhancedMode' => '향상된 모드',
			'dns.fakeIPFilterMode' => '${_root.dns.fakeIp} 필터 모드',
			'dns.fakeIPFilter' => '${_root.dns.fakeIp} 필터',
			'dns.respectRules' => '규칙 준수',
			'dns.nameServer' => '네임 서버',
			'dns.defaultNameServer' => '${_root.meta.byDefault} ${_root.dns.nameServer}',
			'dns.proxyNameServer' => '${_root.meta.proxy} ${_root.dns.nameServer}',
			'dns.directNameServer' => '${_root.meta.direct} ${_root.dns.nameServer}',
			'dns.fallbackNameServer' => '${_root.dns.fallback} ${_root.dns.nameServer}',
			'dns.fallbackGeoIp' => '${_root.dns.fallback} GeoIp',
			'dns.fallbackGeoIpCode' => '${_root.dns.fallback} GeoIpCode',
			'dns.flushCache' => 'DNS 캐시 비우기',
			'dns.flushCacheSuccess' => 'DNS 및 Fake-IP 캐시가 성공적으로 지워졌습니다',
			'dns.presets' => '빠른 DNS 사전 설정',
			'dns.presetSpeed' => '고속 듀얼 스택',
			'dns.presetSpeedDesc' => 'AliDNS DoH3 + DNSPod DoH: 국내 즉시 연결 및 스마트 분기',
			'dns.presetSecure' => '오염 방지 및 개인정보 보호 모드',
			'dns.presetSecureDesc' => 'Cloudflare DoH3 + Google DoH: DNS 하이재킹 및 검열 차단',
			'dns.presetAdGuard' => 'AdGuard 광고 차단 및 클린 모드',
			'dns.presetAdGuardDesc' => 'AdGuard DoQ + AliDNS DoH: 광고 필터링 및 추적 차단',
			'dns.overwriteDesc' => '구독 프로필의 DNS 설정 덮어쓰기',
			'dns.enableDesc' => '사용자 지정 DNS 리졸버 활성화',
			'dns.resetFakeIpFilter' => '기본값 복원',
			'dns.resetFakeIpFilterConfirm' => '권장 Fake-IP 필터 목록을 복원하시겠습니까?',
			'dns.dnsTester' => '실시간 DNS 진단',
			'dns.testQuery' => '테스트',
			'dns.fakeIpDetected' => 'Fake-IP 일치',
			'dns.realIpDetected' => '실제 공인 IP',
			'dns.addServer' => 'DNS 서버 추가',
			'dns.geoAssetsTitle' => 'GEO 오프라인 데이터베이스',
			'dns.geoAssetsDesc' => 'GeoSite 도메인 규칙, GeoIP 및 ASN 데이터베이스 관리',
			'dns.cdnSource' => '다운로드 CDN 미러',
			'dns.updateAll' => '모두 업데이트',
			'dns.updateSuccess' => '업데이트 성공',
			'dns.updateFailed' => '업데이트 실패',
			'dns.addPresetServer' => '프리셋 DNS 추가',
			'dns.manageFakeIpFilter' => ({required Object p}) => '필터 목록 관리 (${p})',
			'dns.fakeIpFilterDesc' => ({required Object p}) => '${p}개의 도메인 규칙이 네트워크 격리 문제를 방지하기 위해 Fake-IP 확인을 우회합니다.',
			'sniffer.overrideDest' => '덮어쓰기',
			'profilePatchMode.currentSelected' => '현재 선택됨',
			'profilePatchMode.overwrite' => '내장 - 덮어쓰기',
			'profilePatchMode.noOverwrite' => '내장 - 덮어쓰지 않음',
			'protocolSniff' => '프로토콜 스니핑',
			'protocolSniffOverrideDestination' => '스니핑된 도메인 이름으로 연결 대상 주소 덮어쓰기',
			'edgeRuntimeNotInstalled' => '현재 장치에 Edge WebView2 런타임이 설치되어 있지 않아 페이지를 표시할 수 없습니다. Edge WebView2 런타임(x64)을 다운로드하여 설치하고 앱을 다시 시작한 후 다시 시도하십시오。',
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
