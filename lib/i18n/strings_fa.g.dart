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
class TranslationsFa with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fa,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fa>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsFa _root = this; // ignore: unused_field

	@override 
	TranslationsFa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFa(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$WelcomeLanguageScreen$fa WelcomeLanguageScreen = _Translations$WelcomeLanguageScreen$fa._(_root);
	@override late final _Translations$BackupAndSyncWebdavScreen$fa BackupAndSyncWebdavScreen = _Translations$BackupAndSyncWebdavScreen$fa._(_root);
	@override late final _Translations$LaunchFailedScreen$fa LaunchFailedScreen = _Translations$LaunchFailedScreen$fa._(_root);
	@override late final _Translations$PerAppAndroidScreen$fa PerAppAndroidScreen = _Translations$PerAppAndroidScreen$fa._(_root);
	@override late final _Translations$UserAgreementScreen$fa UserAgreementScreen = _Translations$UserAgreementScreen$fa._(_root);
	@override late final _Translations$NetCheckScreen$fa NetCheckScreen = _Translations$NetCheckScreen$fa._(_root);
	@override late final _Translations$SpeedTestScreen$fa SpeedTestScreen = _Translations$SpeedTestScreen$fa._(_root);
	@override late final _Translations$VersionUpdateScreen$fa VersionUpdateScreen = _Translations$VersionUpdateScreen$fa._(_root);
	@override late final _Translations$loginScreen$fa loginScreen = _Translations$loginScreen$fa._(_root);
	@override late final _Translations$main$fa main = _Translations$main$fa._(_root);
	@override late final _Translations$meta$fa meta = _Translations$meta$fa._(_root);
	@override late final _Translations$permission$fa permission = _Translations$permission$fa._(_root);
	@override late final _Translations$tls$fa tls = _Translations$tls$fa._(_root);
	@override late final _Translations$tun$fa tun = _Translations$tun$fa._(_root);
	@override late final _Translations$dns$fa dns = _Translations$dns$fa._(_root);
	@override late final _Translations$sniffer$fa sniffer = _Translations$sniffer$fa._(_root);
	@override late final _Translations$profilePatchMode$fa profilePatchMode = _Translations$profilePatchMode$fa._(_root);
	@override String get protocolSniff => 'تشخیص پروتکل';
	@override String get protocolSniffOverrideDestination => 'نام دامنه شناسایی شده آدرس هدف اتصال را پوشش می دهد';
	@override String get edgeRuntimeNotInstalled => 'زمان اجرا Edge WebView2 روی دستگاه فعلی نصب نشده است و صفحه قابل نمایش نیست لطفاً زمان اجرا Edge WebView2 (x64) را بارگیری و نصب کنید، برنامه را مجدداً راه اندازی کنید و دوباره امتحان کنید.';
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
class _Translations$WelcomeLanguageScreen$fa implements Translations$WelcomeLanguageScreen$en {
	_Translations$WelcomeLanguageScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => 'به Wmimo خوش آمدید';
	@override String get selectLanguage => 'انتخاب زبان';
	@override String get subtitle => 'لطفاً زبان مورد نظر خود را انتخاب کنید. می‌توانید در هر زمان در تنظیمات آن را تغییر دهید.';
	@override String get start => 'شروع کنید';
}

// Path: BackupAndSyncWebdavScreen
class _Translations$BackupAndSyncWebdavScreen$fa implements Translations$BackupAndSyncWebdavScreen$en {
	_Translations$BackupAndSyncWebdavScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get webdavServerUrl => 'آدرس URL سرور';
	@override String get webdavRequired => 'نمی‌تواند خالی باشد';
	@override String get webdavLoginFailed => 'ورود ناموفق بود:';
	@override String get webdavListFailed => 'دریافت لیست فایل ناموفق بود:';
}

// Path: LaunchFailedScreen
class _Translations$LaunchFailedScreen$fa implements Translations$LaunchFailedScreen$en {
	_Translations$LaunchFailedScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get invalidProcess => 'اجرای نرم‌افزار ناموفق بود [نام‌ اجرایی پروسه نامعتبر]، لطفا مجدد نرم‌افزار را در دایرکتوری دیگری نصب کنید';
	@override String get invalidProfile => 'اجرای نرم‌افزار ناموفق بود [دسترسی به پروفایل ناموفق بود]، لطفا مجدد نرم افزار را نصب کنید';
	@override String get invalidVersion => 'اجرای نرم‌افزار ناموفق بود [ورژن نامعتبر]، لطفا مجدد نرم‌افزار را نصب کنید';
	@override String get systemVersionLow => 'راه اندازی برنامه ناموفق بود [نسخه سیستم خیلی کم است]';
	@override String get invalidInstallPath => 'مسیر نصب نامعتبر است، لطفا مجدد در مسیر معتبر نصب کنید';
}

// Path: PerAppAndroidScreen
class _Translations$PerAppAndroidScreen$fa implements Translations$PerAppAndroidScreen$en {
	_Translations$PerAppAndroidScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'پروکسی به‌تفکیک برنامه';
	@override String get whiteListMode => 'حالت لیست سفید';
	@override String get whiteListModeTip => 'وقتی فعال باشد: فقط برنامه‌هایی که انتخاب شده‌اند پروکسی می‌شوند؛ وقتی فعال نباشد: فقط برنامه‌هایی که انتخاب نشده‌اند پروکسی می‌شوند';
}

// Path: UserAgreementScreen
class _Translations$UserAgreementScreen$fa implements Translations$UserAgreementScreen$en {
	_Translations$UserAgreementScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get privacyFirst => 'حریم‌خصوصی شما اولویت دارد';
	@override String get agreeAndContinue => 'پذیرفتن و ادامه';
}

// Path: NetCheckScreen
class _Translations$NetCheckScreen$fa implements Translations$NetCheckScreen$en {
	_Translations$NetCheckScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'عیب‌یابی و تشخیص شبکه';
	@override String get fullDiagnosticsTab => 'عیب‌یابی کامل لینک';
	@override String get advancedCheckTab => 'بررسی پیشرفته دامنه';
	@override String get startDiagnostics => 'شروع عیب‌یابی کامل';
	@override String get reDiagnostics => 'تست مجدد';
	@override String get diagnosing => 'در حال بررسی و عیب‌یابی شبکه...';
	@override String get healthScore => 'امتیاز سلامت';
	@override String get scorePerfect => 'عالی';
	@override String get scoreGood => 'خوب';
	@override String get scoreWarning => 'هشدار';
	@override String get scoreCritical => 'مسدود شده';
	@override String get oneClickRepair => 'خودترمیم هوشمند';
	@override String get repairSuccess => 'ترمیم خودکار موفقیت‌آمیز بود، اتصال بازیابی شد';
	@override String get repairFailed => 'ترمیم انجام شد، ممکن است نیاز به بررسی دستی باشد';
	@override String get repairing => 'در حال اجرای خودترمیم...';
	@override String issueFound({required Object count}) => '${count} مشکل پیدا شد';
	@override String get noIssue => 'تمام بررسی‌ها با موفقیت انجام شد';
	@override String get details => 'جزئیات فنی';
	@override String get copyDetails => 'کپی لاگ';
	@override String get detailsCopied => 'گزارش عیب‌یابی در کلیپ‌بورد کپی شد';
	@override String get stepPhysical => 'کارت شبکه و درگاه ارتباطی';
	@override String get stepDns => 'DNS و موتور Fake-IP';
	@override String get stepCore => 'فرایند هسته و پورت‌ها';
	@override String get stepProxy => 'پیکربندی پروکسی سیستم';
	@override String get stepHandshake => 'دست‌تکانی سرتاسری اینترنت';
	@override String get suggestedAction => 'پیشنهاد رفع مشکل';
	@override String get autoRepairAction => 'ترمیم فوری';
	@override String get enterDomain => 'لطفا یک دامنه وارد کنید';
	@override String get checking => 'در حال بررسی...';
	@override String aQueryFailed({required Object p}) => 'خطای استعلام رکورد A: ${p}';
	@override String aaaaQueryFailed({required Object p}) => 'خطای استعلام رکورد AAAA: ${p}';
	@override String get success => 'موفقیت‌آمیز';
	@override String get failed => 'ناموفق';
	@override String get suspectedPollution => 'مشکوک به مسمومیت DNS';
	@override String get domainLabel => 'دامنه';
	@override String get checkButton => 'بررسی';
	@override String get dnsSection => '۱. استعلام DNS';
	@override String get directHttpSection => '۲. HTTP (از طریق TUN، ابتدا TUN را فعال کنید)';
	@override String proxyHttpSection({required Object p}) => '۳. HTTP (از طریق پروکسی، پورت: ${p})';
	@override String get tunNotEnabled => 'TUN فعال نیست';
	@override String get routeTableSection => '۴. جدول مسیریابی';
	@override String get stepPhysicalDesc => 'بررسی وضعیت آداپتور شبکه فیزیکی، IP محلی و اتصال گیت‌وی';
	@override String get stepDnsDesc => 'بررسی تأخیر وضوح DNS محلی و وضعیت پاسخ DNS هسته';
	@override String get stepCoreDesc => 'بررسی وضعیت فرآیند Mihomo و پورت‌های شنود Mixed-Port/API';
	@override String get stepProxyDesc => 'بررسی تنظیمات پروکسی سیستم و عیب‌یابی پروکسی‌های باقیمانده قطعی شبکه';
	@override String get stepHandshakeDesc => 'سنجش تأخیر سرتاسری و دردسترس‌بودن CDN جهانی از طریق نود فعال';
	@override String get shortStepPhysical => 'کارت شبکه';
	@override String get shortStepDns => 'DNS';
	@override String get shortStepCore => 'هسته';
	@override String get shortStepProxy => 'پروکسی';
	@override String get shortStepHandshake => 'اینترنت';
	@override String valNicNormal({required Object p}) => 'شبکه متصل است (${p})';
	@override String get valNicNone => 'هیچ رابط شبکه فعالی یافت نشد';
	@override String get valNicGatewayTimeout => 'IP محلی دریافت شد اما اتصال به گیت‌وی خارجی منقضی شد';
	@override String get valNicError => 'خطا در بررسی رابط شبکه';
	@override String valDnsNormal({required Object p}) => 'پاسخ DNS نرمال (${p})';
	@override String get valDnsEmpty => 'درخواست DNS لیست خالی برگرداند';
	@override String get valDnsTimeout => 'درخواست DNS منقضی شد یا با خطا مواجه شد';
	@override String valCoreNormal({required Object port, required Object mode}) => 'هسته سالم است (پورت ترکیبی: ${port}، حالت: ${mode})';
	@override String get valCoreNotRunning => 'سرویس هسته در حال اجرا نیست';
	@override String valCorePortConflict({required Object p}) => 'پورت ${p} توسط برنامه دیگری اشغال شده است';
	@override String get valCoreApiFailed => 'هسته پاسخگو نیست (خطای ارتباط با API)';
	@override String get valCoreError => 'خطا در بررسی هسته';
	@override String valProxyActive({required Object port}) => 'پروکسی سیستم فعال است (127.0.0.1:${port})';
	@override String get valProxyDisabled => 'پروکسی سیستم غیرفعال است (حالت مستقیم / TUN / دستی)';
	@override String get valProxyZombie => 'پروکسی باقیمانده سیستم شناسایی شد (باعث قطعی اینترنت)';
	@override String get valProxyFailed => 'فعال‌سازی پروکسی سیستم ناموفق بود';
	@override String get valProxyWarning => 'هشدار وضعیت پروکسی سیستم';
	@override String valHandshakeNormal({required Object node, required Object delay}) => 'اتصال به اینترنت نرمال (${node} • ${delay} ms)';
	@override String valHandshakeFailed({required Object node, required Object err}) => 'خطای اتصال نود فعلی [${node}] (${err})';
	@override String get valHandshakeSkipped => 'هسته شروع نشده، تست اتصال انجام نشد';
	@override String get valHandshakeError => 'خطا در اتصال به اینترنت';
	@override String get issueNicDisconnected => 'کارت شبکه به هیچ شبکه‌ای متصل نیست (کابل جدا شده، وای‌فای خاموش یا حالت هواپیما)';
	@override String get suggestNicCheck => 'لطفاً کابل شبکه، اتصال وای‌فای یا وضعیت آداپتور شبکه را بررسی کنید';
	@override String get suggestNicReset => 'غیرفعال کردن و فعال‌سازی مجدد آداپتور شبکه را در تنظیمات سیستم امتحان کنید';
	@override String get issueNicGatewayUnreachable => 'به شبکه محلی متصل است، اما گیت‌وی خارجی دردسترس نیست (پرتال ورود یا قطعی روتر)';
	@override String get suggestNicGateway => 'چراغ‌های روتر را بررسی کنید یا مرورگر را برای ورود به سیستم باز کنید';
	@override String get issueDnsPollution => 'سرویس DNS محلی پاسخ نمی‌دهد؛ احتمال آلودگی DNS یا ربایش گیت‌وی وجود دارد';
	@override String get suggestDnsReset => 'DNS سیستم را بازنشانی کنید یا DNS رمزگذاری‌شده هوشمند (DoH/DoT) را در Wmimo فعال نمایید';
	@override String get actionFlushDns => 'پاکسازی کش DNS سیستم';
	@override String get suggestDnsSlow => 'تأخیر DNS طولانی است، پیشنهاد می‌شود DNS رمزگذاری‌شده فعال گردد';
	@override String get issueDnsFailed => 'تجزیه DNS محلی با شکست مواجه شد؛ تبدیل دامنه به IP امکان‌پذیر نیست';
	@override String get suggestDnsFlush => 'برای پاکسازی کش DNS کلیک کنید یا در تنظیمات Wmimo دی‌ان‌اس رمزگذاری‌شده را فعال کنید';
	@override String get issueCorePortConflict => 'تداخل پورت شناسایی شد! نرم‌افزار پروکسی یا سرویس دیگری پورت را اشغال کرده است';
	@override String get suggestCoreChangePort => 'سایر برنامه‌های پروکسی را ببندید یا در تنظیمات Wmimo شماره پورت را تغییر دهید';
	@override String get actionRestartCore => 'راه‌اندازی مجدد هسته';
	@override String get issueCoreStopped => 'فرآیند هسته Wmimo در حال حاضر متوقف است';
	@override String get suggestCoreStart => 'کلید اتصال در صفحه اصلی یا دکمه [شروع هسته] در زیر را بزنید';
	@override String get actionStartCore => 'شروع فرآیند هسته';
	@override String get issueCoreFrozen => 'فرآیند هسته متوقف شده یا رمز عبور API همخوانی ندارد';
	@override String get suggestCoreRestart => 'پیشنهاد می‌شود دکمه [راه‌اندازی مجدد هسته] را برای بازیابی سرویس بزنید';
	@override String get suggestCoreReinstall => 'راه‌اندازی مجدد هسته یا نصب مجدد درایور را امتحان کنید';
	@override String get issueProxyZombie => 'پروکسی باقیمانده ترافیک را به پورت غیرفعال هدایت می‌کند و باعث قطعی شبکه می‌شود';
	@override String get suggestProxyReset => 'روی [پاکسازی و بازنشانی پروکسی سیستم] در زیر کلیک کنید تا اینترنت فوراً وصل شود';
	@override String get actionResetProxy => 'پاکسازی و بازنشانی پروکسی';
	@override String get issueProxyBlocked => 'پروکسی سیستم اعمال نشد؛ ممکن است توسط آنتی‌ویروس مسدود شده باشد';
	@override String get suggestProxyReapply => 'برای ثبت مجدد و اعمال اجباری پروکسی روی دکمه زیر کلیک کنید';
	@override String get actionReapplyProxy => 'اعمال مجدد پروکسی سیستم';
	@override String get issueProxyRead => 'خطای غیربحرانی در خواندن تنظیمات پروکسی سیستم رخ داد';
	@override String get issueHandshakeBlocked => 'نود پروکسی انتخابی نمی‌تواند به اینترنت متصل شود؛ ارتباط مسدود شده است';
	@override String get suggestHandshakeSwitch => 'نود ممکن است در دست تعمیر یا غیرقابل دسترس باشد؛ لطفاً نود دیگری را انتخاب کنید';
	@override String suggestHandshakeSlow({required Object delay}) => 'تأخیر نود بالاست (${delay} ms)، پیشنهاد می‌شود نود نزدیک‌تری را انتخاب نمایید';
	@override String get suggestHandshakeCheck => 'تنظیمات نود را بررسی کرده یا هدف تست را تغییر دهید';
	@override String get conclusionPerfect => 'مسیر شبکه عالی است! تمامی نودها و تنظیمات پروکسی کاملاً فعال و روان هستند.';
	@override String get conclusionGood => 'مسیر نسبتاً طبیعی است، تأخیرهای جزئی یا هشدارهایی شناسایی شده است.';
	@override String get conclusionWarning => 'اشکالاتی در مسیر شبکه یا پروکسی شناسایی شد؛ لطفاً از دکمه [تعمیر هوشمند] زیر استفاده کنید.';
	@override String get conclusionCritical => 'انسداد شدید شبکه! شبکه محلی متصل نیست یا هسته پروکسی مسدود شده است.';
}

// Path: SpeedTestScreen
class _Translations$SpeedTestScreen$fa implements Translations$SpeedTestScreen$en {
	_Translations$SpeedTestScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get title => 'تست سرعت';
	@override String get startTest => 'شروع تست';
	@override String get stopTest => 'توقف';
	@override String get reTest => 'تست مجدد';
	@override String get ready => 'آماده';
	@override String get testingPing => 'در حال تست پینگ و نوسان...';
	@override String get testingDownload => 'در حال تست سرعت دانلود...';
	@override String get testingUpload => 'در حال تست سرعت آپلود...';
	@override String get completed => 'تست تکمیل شد';
	@override String get stopped => 'متوقف شد';
	@override String get ping => 'پینگ';
	@override String get jitter => 'نوسان (Jitter)';
	@override String get download => 'دانلود';
	@override String get upload => 'آپلود';
	@override String get currentProxy => 'پروکسی فعلی';
	@override String get directConnection => 'اتصال مستقیم';
	@override String get server => 'سرور تست';
	@override String get serverLocation => 'موقعیت سرور';
	@override String get realtimeSpeed => 'نمودار لحظه‌ای سرعت';
	@override String get peakSpeed => 'اوج سرعت';
	@override String get avgSpeed => 'میانگین سرعت';
	@override String get testHistory => 'تاریخچه تست';
	@override String get clearHistory => 'پاک کردن تاریخچه';
}

// Path: VersionUpdateScreen
class _Translations$VersionUpdateScreen$fa implements Translations$VersionUpdateScreen$en {
	_Translations$VersionUpdateScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String versionReady({required Object p}) => 'نسخه جدید [${p}] آماده است';
	@override String get update => 'راه‌اندازی مجدد برای به‌روزرسانی';
	@override String get cancel => 'الان‌ نه';
}

// Path: loginScreen
class _Translations$loginScreen$fa implements Translations$loginScreen$en {
	_Translations$loginScreen$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get login => 'ورود';
	@override String get register => 'ایجاد حساب';
	@override String get forgotPassword => 'فراموشی رمز عبور';
	@override String get provider => 'ارائه دهنده خدمات';
	@override String get providerName => 'کد/نام مستعار/URL ${_root.loginScreen.provider}';
	@override String get providerNameRequired => 'لطفا کد/نام مستعار/URL ${_root.loginScreen.provider} را وارد کنید';
	@override String get account => 'حساب';
	@override String get accountRequired => 'لطفا حساب را وارد کنید';
	@override String get email => 'ایمیل';
	@override String get emailRequired => 'لطفا آدرس ایمیل را وارد کنید';
	@override String get password => 'رمز عبور';
	@override String get passwordRequired => 'لطفا رمز عبور را وارد کنید';
	@override String get validEmailRequired => 'لطفا یک آدرس ایمیل معتبر وارد کنید';
	@override String passwordMinLength({required Object minLength}) => 'طول رمز عبور باید حداقل ${minLength} کاراکتر باشد';
	@override String get unsupportedProvider => '${_root.loginScreen.provider} پشتیبانی نمی شود';
	@override String get unsupportedProviderType => 'نوع ${_root.loginScreen.provider} پشتیبانی نمی شود';
	@override String get unActivedProvider => 'قابلیت ورود فعال نشده است';
	@override String providerLoginSupportRequired({required Object p}) => 'لطفاً کد/نام مستعار ارائه‌دهنده را از ${_root.loginScreen.provider} دریافت کنید.\nبرای راهنمای اتصال ${_root.loginScreen.provider} به این لینک مراجعه کنید: ${p}';
	@override String get providerDisclaimer => 'سلب مسئولیت: ${_root.loginScreen.provider} یک سرویس شخص ثالث است و ارتباطی با این برنامه ندارد';
	@override String get createSessionFailed => 'ایجاد نشست با خطا مواجه شد، ارائه‌دهنده یا حساب را بررسی کنید';
}

// Path: main
class _Translations$main$fa implements Translations$main$en {
	_Translations$main$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$main$tray$fa tray = _Translations$main$tray$fa._(_root);
}

// Path: meta
class _Translations$meta$fa implements Translations$meta$en {
	_Translations$meta$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get enable => 'فعال‌سازی';
	@override String get disable => 'غیرفعال';
	@override String get open => 'باز کن';
	@override String get close => 'بسته';
	@override String get quit => 'خروج';
	@override String get add => 'افزودن';
	@override String get addSuccess => 'با‌موفقیت اضافه شد';
	@override String addFailed({required Object p}) => 'افزودن ناموفق بود:${p}';
	@override String get remove => 'حذف';
	@override String get removeConfirm => 'آیا از حذف اطمینان دارین؟';
	@override String get edit => 'ویرایش کنید';
	@override String get view => 'بررسی';
	@override String get remark => 'ملاحضات';
	@override String get byDefault => 'پیش‌فرض';
	@override String get editRemark => 'یادداشت های اصلاحی';
	@override String get more => 'بیشتر';
	@override String get tips => 'اطلاعات';
	@override String get selectAll => 'انتخاب همه';
	@override String get copy => 'کپی';
	@override String get paste => 'چسباندن';
	@override String get cut => 'برش';
	@override String get save => 'ذخیره کنید';
	@override String get ok => 'خُب';
	@override String get cancel => 'لغو';
	@override String get faq => 'سوالات متداول';
	@override String get doc => 'سند';
	@override String get htmlTools => 'مجموعه ابزارهای HTML';
	@override String get download => 'دانلود';
	@override String get loading => 'درحال بارگذاری…';
	@override String get days => 'روز';
	@override String get hours => 'ساعت';
	@override String get minutes => 'دقیقه';
	@override String get seconds => 'دومین';
	@override String get milliseconds => 'میلی‌ثانیه';
	@override String get protocol => 'پروتکل';
	@override String get search => 'جستجو';
	@override String get custom => 'سفارشی';
	@override String get connect => 'اتصال';
	@override String get disconnect => 'قطع‌ اتصال';
	@override String get connected => 'وصل شد';
	@override String get disconnected => 'قطع شد';
	@override String get connecting => 'درحال اتصال';
	@override String get connectTimeout => 'اتمام مهلت اتصال';
	@override String get timeout => 'تایم اوت';
	@override String get timeoutDuration => 'مدت زمان وقفه';
	@override String get latency => 'پینگ';
	@override String get latencyTest => 'تست پینگ';
	@override String get networkCheck => 'بررسی شبکه';
	@override String get speedTest => 'تست سرعت';
	@override String get language => 'زبان';
	@override String get next => 'بعدی';
	@override String get done => 'انجام‌شد';
	@override String get apply => 'درخواست دادن';
	@override String get refresh => 'بارگذاری مجدد';
	@override String get retry => 'دوباره امتحان کنید؟';
	@override String get update => 'تجدید';
	@override String get updateInterval => 'فاصله‌ی به‌روزرسانی';
	@override String get updateInterval5mTips => 'حداقل: 5 متر';
	@override String get updateIntervalPreferByProfile => 'اولویت با تنظیمات ارائه‌دهنده';
	@override String updateFailed({required Object p}) => 'به‌روزرسانی ناموفق بود:${p}';
	@override String get none => 'هیچ‌کدام';
	@override String get reset => 'بازنشانی';
	@override String get resetConfirm => 'آیا مطمئن هستید که می‌خواهید تمام تنظیمات برنامه را بازنشانی کنید؟';
	@override String get resetSuccess => 'تنظیمات برنامه به مقادیر پیش‌فرض بازنشانی شد';
	@override String get resetCoreConfirm => 'آیا مطمئن هستید که می‌خواهید تنظیمات هسته و بازنویسی‌ها را بازنشانی کنید؟';
	@override String get resetCoreSuccess => 'تنظیمات هسته به مقادیر پیش‌فرض بازنشانی شد';
	@override String get authentication => 'مجوز';
	@override String get submit => 'ارسال';
	@override String get user => 'کاربر';
	@override String get account => 'نام‌کاربری';
	@override String get password => 'رمز‌عبور';
	@override String get decryptPassword => 'دکريپت رمز‌عبور';
	@override String get required => 'الزامی';
	@override String get go => 'ادامه';
	@override String get sudoPassword => 'رمز عبور sudo (برای حالت TUN لازم است)';
	@override String get other => 'دیگر';
	@override String get dns => 'DNS';
	@override String get url => 'URL';
	@override String get urlInvalid => 'URL نامعتبر';
	@override String get urlCannotEmpty => 'لینک نمی‌تواند خالی باشد';
	@override String get urlTooLong => 'URL خیلی طولانی است (>8182)';
	@override String get copyUrl => 'کپی‌کردن لینک';
	@override String get openUrl => 'بازکردن لینک';
	@override String get shareUrl => 'اشتراک لینک';
	@override String get coreSettingTips => 'توجه: پس از تغییر پیکربندی، باید دوباره وصل شوید تا اعمال شود';
	@override String get overwrite => 'لغو';
	@override String get overwriteCustom => 'لغوهای سفارشی';
	@override String get overwriteAppend => 'لغو الحاقی';
	@override String get overwriteTips => 'پیکربندی اصلی <- لغو سفارشی <- لغو برنامه';
	@override String get noOverwrite => 'رونویسی نکنید';
	@override String get overwriteSettings => 'لغو تنظیمات';
	@override String get diversionTemplates => 'الگوهای مسیریابی';
	@override String get ruleProviders => 'مجموعه قوانین (RuleSet)';
	@override String get ruleTemplates => 'الگوی قانون';
	@override String get proxyGroupsTemplates => 'الگوهای گروه‌ها';
	@override String get proxyGroups => 'گروه‌های پروکسی';
	@override String get proxyNodeList => 'فهرست گره‌های پروکسی';
	@override String proxyNodeFailure({required Object p}) => 'گره‌های پروکسی زیر منقضی شده و به طور خودکار حذف شده‌اند: ${p}';
	@override String get externalController => 'کنترل خارجی';
	@override String get secret => 'Secret';
	@override String get tcpConcurrent => 'دست دادن همزمان TCP';
	@override String get globalClientFingerprint => 'اثر انگشت جهانی TLS';
	@override String get allowLanAccess => 'دسترسی به دستگاه LAN';
	@override String get mixedPort => 'پورت پروکسی هیبریدی';
	@override String get logLevel => 'سطح ورود به سیستم';
	@override String get findProcessMode => 'حالت تطابق فرآیند';
	@override String get tcpkeepAliveInterval => 'فاصله حفظ زنده TCP';
	@override String get delayTestUrl => 'URL تست تأخیر';
	@override String get delayTestTimeout => 'مهلت زمانی تست تاخیری (میلی‌ثانیه)';
	@override String get tun => 'TUN';
	@override String get ntp => 'NTP';
	@override String get tls => 'TLS';
	@override String get geo => 'GEO';
	@override String get geoDownloadByProxy => 'دانلود Geo RuleSet با استفاده از یک پروکسی';
	@override String get geoRulesetTips => 'Geosite/Geoip به RuleSet مربوطه تبدیل می شود';
	@override String get asnNotSupportInIosTips => 'با توجه به محدودیت‌های حافظه سیستم iOS، قوانین IP-ASN و SRC-IP-ASN در iOS نادیده گرفته می‌شوند.';
	@override String get sniffer => 'بو کشیدن';
	@override String get userAgent => 'UserAgent';
	@override String get launchAtStartup => 'اجرا در راه‌اندازی';
	@override String get launchAtStartupRunAsAdmin => 'لطفاً Wmimo را به عنوان مدیر راه اندازی مجدد کنید';
	@override String get tunModeRunAsAdmin => 'حالت TUN نیازمند مجوز مدیر سیستم می‌باشد لطفا نرم‌افزار را مجدد با حالت مدیر (administrator) راه‌اندازی کنید';
	@override String get tunSwitchToSystemProxy => 'آیا مایلید برای ادامه اتصال، موقتاً به [حالت پروکسی سیستم] تغییر وضعیت دهید؟';
	@override String get tunCreateAdapterFailedAdmin => 'ایجاد آداپتور شبکه مجازی TUN ناموفق بود: Access is denied.\nحالت TUN نیازمند دسترسی سرپرست (Administrator) است. لطفاً کلیک راست کرده و 【اجرا به عنوان مدیر (Run as administrator)】 را انتخاب کنید، یا در صفحه اصلی/تنظیمات هسته، حالت TUN را غیرفعال کرده و با پروکسی سیستم متصل شوید.';
	@override String get portableMode => 'حالت قابل‌حمل';
	@override String get portableModeDisableTips => 'اگر نیاز دارین از حالت قابل‌حمل خارج شوید لطفا از [Wmimo] خارج شده و به‌صورت دستی پوشه [portable] هم مسیر با فایل [wmimo.exe] را حذف کنید';
	@override String get systemProxy => 'پروکسی سیستم';
	@override String get autoConnectAfterLaunch => 'اتصال خودکار پس‌از راه‌اندازی';
	@override String get autoConnectAtBoot => 'اتصال خودکار پس از روشن شدن سیستم';
	@override String get autoConnectAtBootTips => 'پشتیبانی سیستم مورد نیاز است؛ برخی سیستم‌ها ممکن است نیاز به فعال بودن [شروع خودکار] نیز داشته باشند.';
	@override String get hideAfterLaunch => 'پنهان کردن پنجره پس از راه اندازی';
	@override String get autoSetSystemProxy => 'تنظیم خودکار حالت پروکسی سیستم پس‌از اتصال';
	@override String get bypassSystemProxy => 'نام های دامنه ای که مجاز به دور زدن پراکسی سیستم هستند';
	@override String get excludeFromRecent => 'پنهان شدن از وظایف اخیر';
	@override String get hideDockIcon => 'پنهان کردن آیکون داک';
	@override String get showTrayTraffic => 'نمایش اطلاعات ترافیک در سینی سیستم';
	@override String get wakeLock => 'قفل بیدارباش';
	@override String get hideVpn => 'مخفی کردن آیکون VPN';
	@override String get hideVpnTips => 'فعال کردن IPv6 باعث از کار افتادن این عملکرد خواهد شد.';
	@override String get website => 'وبسایت';
	@override String get homePage => 'صفحه اصلی';
	@override String get rule => 'قانون';
	@override String get global => 'عمومی';
	@override String get direct => 'مستقیم';
	@override String get block => 'مسدود';
	@override String get qrcode => 'کد QR';
	@override String get qrcodeTooLong => 'متن برای نمایش خیلی طولانی است';
	@override String get qrcodeShare => 'اشتراک کدQR';
	@override String get textToQrcode => 'متن به کد QR';
	@override String get qrcodeScan => 'اسکن QRکد';
	@override String get qrcodeScanResult => 'نتایج اسکن';
	@override String get qrcodeScanFromImage => 'اسکن از عکس';
	@override String get qrcodeScanFromClipboard => 'از کلیپ‌بورد';
	@override String get qrcodeRecognized => 'کد QR با موفقیت شناسایی شد';
	@override String get qrcodeDropHint => 'برای عکس‌برداری یا انتخاب تصویر، دکمه‌های بالا را کلیک کنید';
	@override String get confirmImport => 'تأیید واردسازی';
	@override String get reScan => 'اسکن مجدد';
	@override String get qrcodeScanResultFailed => 'تجزیه عکس ناموفق بود، لطفا مطمعن شوید اسکرین‌شات یک کدQR معتبر است';
	@override String get qrcodeScanResultEmpty => 'نتیجه اسکن خالی است';
	@override String get screenshot => 'اسکرین‌شات';
	@override String get backupAndSync => 'پشتیبان‌گیری و همگام‌سازی';
	@override String get importSuccess => 'افزودن موفق بود';
	@override String get rewriteConfirm => 'این فایل کانفیگ‌های محلی موجود را بازنویسی می‌کند. آیا می‌خواهید ادامه بدین؟';
	@override String get importAndExport => 'وارد‌کردن و خروجی‌گرفتن';
	@override String get import => 'وارد‌کردن';
	@override String get importFromUrl => 'وارد کردن از URL';
	@override String get export => 'خروجی‌گرفتن';
	@override String get send => 'ارسال کنید';
	@override String get receive => 'تصاحب';
	@override String get sendConfirm => 'ارسال را تایید کرد؟';
	@override String get continueConnectConfirm => 'آیا اتصال ادامه یابد؟';
	@override String get termOfUse => 'شرایط استفاده';
	@override String get privacyPolicy => 'سیاست حریم خصوصی';
	@override String get log => 'ورود به سیستم';
	@override String get coreLog => 'لاگ‌های هسته';
	@override String get core => 'هسته';
	@override String get help => 'کمک کند';
	@override String get tutorial => 'آموزش';
	@override String get board => 'پانل';
	@override String get boardOnline => 'استفاده از پانل آنلاین';
	@override String get boardOnlineUrl => 'URL پانل آنلاین';
	@override String get boardLocalPort => 'پورت پانل محلی';
	@override String get connections => 'اتصال‌های فعال';
	@override String get closeAllConnections => 'بستن همه اتصال‌ها';
	@override String get searchConnections => 'جستجوی اتصال‌ها (دامنه/IP/قاعده/پردازش)';
	@override String get noFilterResults => 'اتصالی یافت نشد';
	@override String get searchRules => 'جستجوی قوانین (نوع/محتوا/پروکسی)';
	@override String get searchProfiles => 'جستجوی پروفایل‌ها (نام/لینک/یادداشت)';
	@override String get noMatchingProfiles => 'هیچ پروفایل متطابقی یافت نشد';
	@override String get rules => 'قوانین مسیریابی';
	@override String get clear => 'پاک کردن';
	@override String get copySuccess => 'کپی شد';
	@override String get alwayOnVPN => 'اتصال همیشه باز';
	@override String get disableFontScaler => 'غیرفعال‌سازی مقیاس‌بندی فونت(با راه‌اندازی مجدد اعمال می‌شود)';
	@override String get autoOrientation => 'چرخش صفحه را دنبال کنید';
	@override String get restartTakesEffect => 'با راه‌اندازی مجدد اعمال می‌شود';
	@override String get reconnectTakesEffect => 'پس از اتصال مجدد، اعمال خواهد شد.';
	@override String get runtimeProfile => 'پیکربندی زمان اجرا';
	@override String get willCompleteAfterRebootInstall => 'لطفاً دستگاه خود را مجدداً راه اندازی کنید تا نصب افزونه سیستم تکمیل شود.';
	@override String get willCompleteAfterRebootUninstall => 'لطفاً دستگاه خود را مجدداً راه‌اندازی کنید تا حذف نصب افزونه سیستم تکمیل شود';
	@override String get requestNeedsUserApproval => '۱. لطفاً به Wmimo اجازه دهید افزونه‌های سیستمی را در [تنظیمات سیستم] - [حریم خصوصی و امنیت] نصب کند. ۲. : [تنظیمات سیستم] - [عمومی] - [موارد ورود و افزونه‌ها - افزونه‌های شبکه] [wmimoServiceSE] را فعال کنید. پس از اتمام، دوباره متصل شوید.';
	@override String get FullDiskAccessPermissionRequired => 'لطفاً مجوز wmimoServiceSE را در [تنظیمات سیستم]-[حریم خصوصی و امنیت]-[دسترسی کامل به دیسک] فعال کنید و دوباره متصل شوید.';
	@override String get proxy => 'بازیگری';
	@override String get theme => 'موضوع';
	@override String get tvMode => 'حالت تلویزیون';
	@override String get autoUpdate => 'به روز رسانی خودکار';
	@override String get updateChannel => 'کانال به‌روزرسانی خودکار';
	@override String get onlineCustomerService => 'پشتیبانی آنلاین';
	@override String get subscriptionChannel => 'کانال اشتراک';
	@override String hasNewVersion({required Object p}) => 'به‌روزرسانی نسخه ${p} ';
	@override String get autoDownloadPkg => 'دانلود خودکار بسته‌های به‌روزرسانی';
	@override String get devOptions => 'تنظیمات توسعه‌دهندگان';
	@override String get joinUs => 'به ما بپیوندید';
	@override String get about => 'درباره';
	@override String get name => 'نام';
	@override String get version => 'نسخه';
	@override String get notice => 'اطلاعیه';
	@override String get sort => 'مرتب‌سازی';
	@override String get recommended => 'پیشنهادی';
	@override String innerError({required Object p}) => 'خطای داخلی: ${p}';
	@override String get share => 'اشتراک گذاری';
	@override String get importFromClipboard => 'افزودن از کلیپ‌برد';
	@override String get exportToClipboard => 'صادرات به کلیپ بورد';
	@override String get server => 'سرور';
	@override String get port => 'بندر';
	@override String get donate => 'اهدا کنید';
	@override String get setting => 'تنظیمات';
	@override String get settingCore => 'تنظیمات هسته';
	@override String get settingApp => 'تنظیمات برنامه';
	@override String get coreOverwrite => 'بازنویسی هسته';
	@override String get iCloud => 'iCloud';
	@override String get webdav => 'Webdav';
	@override String get lanSync => 'LAN Sync';
	@override String get lanSyncNotQuitTips => 'قبل از تکمیل همگام‌سازی از این قسمت خارج نشوید';
	@override String get deviceNoSpace => 'فضای خالی کافی ندارید';
	@override String get hideSystemApp => 'برنامه های سیستم را مخفی کنید';
	@override String get hideAppIcon => 'پنهان کردن نماد برنامه';
	@override String get openDir => 'بازکردن دایرکتوری فایل';
	@override String get type => 'نوع';
	@override String get fileChoose => 'انتخاب فایل';
	@override String get filePathCannotEmpty => 'مسیر فایل نمی‌تواند خالی باشد';
	@override String fileNotExist({required Object p}) => 'فایل وجود ندارد:${p}';
	@override String fileTypeInvalid({required Object p}) => 'نوع فایل نامعتبر:${p}';
	@override String get uwpExemption => 'معافیت جداسازی شبکه UWP';
	@override String get getProfile => 'دریافت اشتراک';
	@override String get buyProfile => 'خرید اشتراک';
	@override String get addProfile => 'افزودن اشتراک';
	@override String get myProfiles => 'اشتراک‌ها';
	@override String get profileEdit => 'ویرایش اشتراک';
	@override String get profileNeedActive => 'ابتدا این پروفایل را به‌عنوان پروفایل فعلی تنظیم کنید، سپس اتصال را فعال/دوباره متصل کنید';
	@override String get profileDownloadBackupChannel => 'فعال‌سازی کانال دانلود پشتیبان';
	@override String get profileDownloadBackupChannelTips => 'کانال دانلود پراکسی ارائه‌شده توسط Wmimo (هیچ اطلاعاتی ذخیره نمی‌شود)';
	@override String get profileEditReloadAfterProfileUpdate => 'بارگذاری مجدد پس‌از به‌روزرسانی پروفایل';
	@override String get profileRulesAppendApplePush => 'افزودن قوانین اعلان‌های Push اپل';
	@override String get profileRulesAppendProxyTips => 'قوانین به‌صورت خودکار روی نخستین پراکسی با نوع [url-test] یا [select] در [proxy-groups] پیکربندی اصلی تنظیم می‌شوند';
	@override String get profileImport => 'وارد کردن فایل پیکربندی';
	@override String get profileAddUrlOrContent => 'افزودن لینک اشتراک';
	@override String get profileUrlOrContent => 'لینک اشتراک / محتوا';
	@override String get profileUrlOrContentHit => 'لینک اشتراک یا محتوا [الزامی]';
	@override String get profileUrlOrContentCannotEmpty => 'لینک اشتراک نمی‌تواند خالی باشد';
	@override String get overview => 'نمای کلی';
	@override String get trafficStats => 'آمار ترافیک';
	@override String get realtimeMonitor => 'نظارت زنده';
	@override String get realtimeUpload => 'آپلود لحظه‌ای';
	@override String get realtimeDownload => 'دانلود لحظه‌ای';
	@override String get sessionUpload => 'آپلود نشست';
	@override String get sessionDownload => 'دانلود نشست';
	@override String get planUsage => 'مصرف بسته';
	@override String get memoryUsage => 'حافظه';
	@override String get remaining => 'باقیمانده';
	@override String get expireTime => 'زمان انقضا';
	@override String get tunMode => 'حالت TUN';
	@override String daysAgo({required Object p}) => '${p} روز پیش';
	@override String hoursAgo({required Object p}) => '${p} ساعت پیش';
	@override String get lessThanOneHourAgo => 'کمتر از ۱ ساعت پیش';
	@override String get inUse => 'در حال استفاده';
	@override String get remoteSubscription => 'اشتراک از راه دور';
	@override String get localProfile => 'فایل محلی';
	@override String get viewYamlConfig => 'مشاهده پیکربندی YAML';
	@override String get editYamlConfig => 'ویرایش پیکربندی YAML';
	@override String get copySubscriptionUrl => 'کپی پیوند اشتراک';
	@override String get qrCode => 'کد QR';
	@override String get deleteProfile => 'حذف پیکربندی';
	@override String get noProfilesYet => 'هنوز اشتراکی وجود ندارد';
	@override String get addProfilePrompt => 'برای افزودن لینک یا وارد کردن فایل، روی + در بالا ضربه بزنید';
	@override String get subscriptionUrlCopied => 'پیوند اشتراک در کلیپ‌بورد کپی شد';
	@override String autoGroupTip({required Object group, required Object type}) => '«${group}» یک گروه سیاست خودکار (${type}) است. برای انتخاب دستی گره، لطفاً در گروه‌های دستی جابه‌جا شوید.';
	@override String switchNodeFailed({required Object p}) => 'تغییر گره ناموفق بود: ${p}';
	@override String nodeSelected({required Object p}) => 'گره انتخاب شده: ${p}';
	@override String get startingCoreAndTesting => 'در حال شروع هسته و تست سرعت...';
	@override String chartMinutes({required Object p}) => '${p} دقیقه';
	@override String get chartUpload => 'آپلود';
	@override String get chartDownload => 'دانلود';
	@override String get author => 'سازنده';
	@override String get githubRepo => 'مخزن متن باز';
	@override String get openSourceLicense => 'مجوز متن باز';
	@override String get submitFeedback => 'ارسال بازخورد و پیشنهادات';
	@override String get copiedToClipboard => 'در کلیپ‌بورد کپی شد';
	@override String get autoScrollEnabled => 'پیمایش خودکار فعال است';
	@override String get autoScrollDisabled => 'پیمایش خودکار غیرفعال است';
	@override String get pauseLogs => 'توقف موقت لاگ‌های زنده';
	@override String get resumeLogs => 'ادامه لاگ‌های زنده';
	@override String get scrollToLatest => 'پیمایش به جدیدترین';
	@override String get scrollToBottom => 'پیمایش به پایین';
	@override String newLogsCount({required Object p}) => '(${p} لاگ جدید)';
	@override String get copiedLogContent => 'محتوای لاگ کپی شد';
	@override String get copyLog => 'کپی لاگ';
	@override String get noLogsPrompt => 'هنوز لاگی وجود ندارد. پس از شروع پروکسی نمایش داده می‌شود.';
	@override String get searchLogsHint => ' (IP, دامنه, قانون, خطا...)';
	@override String get offlinePreviewPrompt => 'حالت پیش‌نمایش آفلاین. برای مسیریابی و تست تأخیر پروکسی را فعال کنید.';
	@override String get manualSelect => 'انتخاب دستی';
	@override String get autoSelect => 'انتخاب خودکار';
	@override String get speedTestGroup => 'تست سرعت گروه';
	@override String get pause => 'توقف موقت';
	@override String get resume => 'ادامه';
	@override String get ipInfo => 'اطلاعات IP';
	@override String get ipFetching => 'در حال دریافت اطلاعات IP...';
	@override String get ipCopied => 'آدرس IP در کلیپ‌بورد کپی شد';
	@override String get ipLocation => 'مکان';
	@override String get ipIsp => 'ارائه‌دهنده';
	@override String get ipTapToFetch => 'برای دریافت اطلاعات IP ضربه بزنید';
	@override String get ipProxy => 'خروجی پروکسی';
	@override String get ipDirect => 'اتصال مستقیم محلی';
	@override String get ipAsn => 'ASN';
	@override String get ipOrg => 'سازمان';
	@override String get ipTimezone => 'منطقه زمانی';
	@override String get ipCoordinates => 'مختصات';
	@override String get ipMoreDetails => 'جزئیات بیشتر';
	@override String get ipLessDetails => 'بستن جزئیات';
	@override String get collapseAll => 'بستن همه گروه‌ها';
	@override String get expandAll => 'باز کردن همه گروه‌ها';
	@override String get donateTitle => '💖 خرید یک قهوه برای نویسنده';
	@override String get donateThankYou => 'ฅ^•ﻌ•^ฅ حمایت شما بزرگترین انگیزه برای بهبود مداوم Wmimo است ~ ☕✨';
	@override String get tokenCurrency => 'ارز';
	@override String get networkChain => 'شبکه';
	@override String get depositAddress => 'آدرس واریز APTOS';
	@override String get clickToCopy => 'کلیک برای کپی';
	@override String get copyAddressBtn => 'کپی آدرس ✨';
	@override String get donateAddressCopied => '( ੭ ˙ᗜ˙ )੭ آدرس کپی شد! از حمایت گرم شما بسیار سپاسگزاریم~ 💖';
	@override String get donateTip => '💡 نکته: پشتیبانی از اسکن از طریق Bybit یا هر کیف پول سازگار با Aptos';
	@override String get qrcodeParsing => 'در حال پردازش کد QR...';
	@override String get qrcodeNotFound => 'هیچ کد QR شناسایی نشد';
	@override String get qrcodeSupportHint => 'پشتیبانی از کدهای QR اشتراک، نود و پیکربندی';
	@override String get qrcodeCameraHint => 'کد QR را درون کادر قرار دهید تا به طور خودکار اسکن شود';
	@override String get flashlight => 'چراغ قوه';
	@override String get screenshotDesc => 'تصویربرداری صفحه';
	@override String get fromImageDesc => 'تصویر محلی';
	@override String get fromClipboardDesc => 'خواندن از کلیپ‌بورد';
	@override String get errorPrompt => 'خطا';
	@override String get copied => 'کپی شد';
	@override String get sortAndFilterNodes => 'مرتب‌سازی و فیلتر نودها';
	@override String get sortOptions => 'گزینه‌های مرتب‌سازی';
	@override String get sortDefault => 'پیش‌فرض';
	@override String get sortLatency => 'کمترین تاخیر';
	@override String get sortName => 'بر اساس نام (A-Z)';
	@override String get sortRegion => 'بر اساس منطقه';
	@override String get filterOptions => 'گزینه‌های فیلتر';
	@override String portableUpdateTip({required Object version}) => 'حالت پرتابل شناسایی شد:\nبه‌روزرسانی درون‌برنامه‌ای در حالت پرتابل پشتیبانی نمی‌شود. لطفاً آخرین نسخه فشرده پرتابل را دانلود و جایگزین کنید.\n\nآخرین نسخه: v${version}';
	@override String get portableModeTipTitle => 'اعلان حالت پرتابل';
	@override String get noNodesToSpeedTest => 'هیچ نودی برای آزمایش در دسترس نیست';
	@override String alreadyLatestVersion({required Object version}) => 'در حال حاضر آخرین نسخه است (v${version})';
	@override String get checkUpdateFailed => 'بررسی به‌روزرسانی با خطا مواجه شد، لطفاً اتصال شبکه را بررسی کنید';
	@override String get hideTimeoutNodes => 'پنهان کردن گره‌های ناموفق و آفلاین';
	@override String get hideTimeoutNodesDesc => 'فیلتر خودکار گره‌های غیرقابل دسترس';
	@override String get speedtestScenario => 'سناریوی تست سرعت فعلی';
	@override String get speedtestScenarioSwitch => 'تغییر سناریوی تست سرعت';
	@override String get speedtestScenarioDesc => 'انتخاب اهداف برای تست تأخیر و در دسترس بودن واقعی';
	@override String get speedtestAllNodes => 'تست همه گره‌ها';
	@override String get retestTimeoutNodes => 'تست مجدد گره‌های تایم‌اوت شده';
	@override String switchedTargetScenario({required Object target}) => 'تغییر سناریوی تست به: ${target}';
	@override String get notTested => 'تست نشده';
	@override String get timeoutOrFailed => 'تایم‌اوت / غیرقابل دسترس';
	@override String get identifiedRegion => 'منطقه';
	@override String get nodeProtocol => 'پروتکل';
	@override String get currentLatency => 'تأخیر';
	@override String get testScenario => 'سناریوی تست';
	@override String get belongsToGroup => 'گروه';
	@override String get copyNodeName => 'کپی نام';
	@override String get nodeNameCopied => 'نام گره کپی شد';
	@override String get testSingleNode => 'تست این گره';
	@override String get selectThisNode => 'انتخاب این گره';
	@override String get allNodesNormal => 'همه گره‌ها در دسترس هستند و نیازی به تست مجدد نیست';
	@override String get customUrlPrompt => 'آدرس سفارشی (مانند http://...)';
	@override String get customTarget => 'هدف سفارشی';
	@override String get downloadFailedTip => 'دانلود بسته به‌روزرسانی ناموفق بود، لطفاً شبکه را بررسی کنید یا از وب‌سایت دانلود کنید.';
	@override String discoveredNewVersion({required Object version}) => 'نسخه جدید یافت شد: v${version}';
	@override String get preparingUpdate => 'در حال آماده‌سازی برای به‌روزرسانی...';
	@override String get downloadingPackage => 'در حال دانلود بسته به‌روزرسانی، لطفاً صبر کنید...';
	@override String get downloadUpdateNow => 'اکنون به‌روزرسانی را دانلود کنید';
	@override String get downloadFromWeb => 'دانلود از وب‌سایت';
	@override String get switchSource => 'تغییر';
	@override String get serverSwitch => 'سرور تست سرعت';
	@override String get autoDetectBest => 'شناسایی خودکار بهترین سرور';
	@override String get serverSwitchDesc => 'انتخاب CDN یا هدف سفارشی برای تست اتصال';
	@override String autoSelectedBest({required Object server, required Object ping}) => 'بهترین سرور به طور خودکار انتخاب شد: ${server} (${ping} ms)';
	@override String get networkGradeTitle => 'امتیاز کیفیت شبکه';
	@override String get copyReport => 'کپی گزارش';
	@override String get reportCopied => 'گزارش در کلیپ‌بورد کپی شد، آماده برای اشتراک‌گذاری';
	@override String get gamingExperience => 'بازی آنلاین';
	@override String get streamingExperience => 'استریم ویدیو';
	@override String get meetingExperience => 'ویدیو کنفرانس';
	@override String get customSpeedtestUrl => 'آدرس سفارشی دانلود (https://...)';
	@override String get customSpeedtestSource => 'منبع تست سفارشی';
	@override String get userSpecifiedUrl => 'آدرس مشخص‌شده توسط کاربر';
	@override String cannotBeEmpty({required Object item}) => '${item} نمی‌تواند خالی باشد';
	@override String alreadyExists({required Object item}) => '${item} از قبل وجود دارد';
	@override String installFailedWithCode({required Object installer, required Object code}) => 'نصب ${installer} با خطا مواجه شد، کد: ${code}';
	@override String get resetSystemProxy => 'تعمیر شبکه / بازنشانی پروکسی سیستم';
	@override String get resetSystemProxyDesc => 'پاکسازی تنظیمات باقیمانده پروکسی سیستم و تازه‌سازی شبکه برای رفع مشکلات قطعی اینترنت';
	@override String get resetSystemProxySuccess => 'پروکسی سیستم پاکسازی شد و شبکه به حالت عادی بازگشت';
	@override String get networkDiagnostics => 'عیب‌یابی شبکه و خودترمیم هوشمند';
	@override String get networkDiagnosticsDesc => 'عیب‌یابی کارت شبکه، DNS، پورت‌های هسته و وضعیت پروکسی با ترمیم با یک کلیک';
	@override String get sortLatencyDesc => 'بیشترین تأخیر';
	@override String get sortNameDesc => 'نام Z-A';
	@override String get sortMultiplier => 'کمترین ضریب';
	@override String get uwpLoopback => 'ابزار معافیت لوپ‌بک UWP';
	@override String get uwpLoopbackDesc => 'اجازه به برنامه‌های UWP برای استفاده از پروکسی محلی';
	@override String get uwpExemptAllCommon => 'معافیت برنامه‌های پیشنهادی';
	@override String get uwpApplySuccess => 'قوانین معافیت لوپ‌بک UWP با موفقیت اعمال شد';
	@override String get common => 'رایج';
	@override String get exempted => 'معاف شده';
	@override String get notExempted => 'معاف نشده';
	@override String get deselectAll => 'لغو انتخاب همه';
	@override String get userApps => 'برنامه‌های کاربر';
	@override String get systemApps => 'برنامه‌های سیستم';
	@override String get selectedOnly => 'انتخاب شده';
	@override String get proxySelectedMode => 'فقط پروکسی برنامه‌های انتخاب شده';
	@override String get proxySelectedModeDesc => 'برنامه‌های انتخاب شده از پروکسی عبور می‌کنند و بقیه مستقیم متصل می‌شوند';
	@override String get bypassSelectedMode => 'دور زدن برنامه‌های انتخاب شده';
	@override String get bypassSelectedModeDesc => 'برنامه‌های انتخاب شده مستقیم متصل می‌شوند و بقیه از پروکسی عبور می‌کنند';
	@override String get invertSelection => 'معکوس کردن انتخاب';
	@override String get all => 'همه';
	@override String get showAppIcon => 'نمایش آیکون برنامه';
	@override String get proxySelection => 'انتخاب پروکسی';
	@override String get regionHk => '🇭🇰 هنگ کنگ';
	@override String get regionJp => '🇯🇵 ژاپن';
	@override String get regionSg => '🇸🇬 سنگاپور';
	@override String get regionTw => '🇹🇼 تایوان';
	@override String get regionUs => '🇺🇸 ایالات متحده';
	@override String get regionKr => '🇰🇷 کره جنوبی';
	@override String get macMoveToApplications => 'لطفاً قبل از اجرا، Wmimo را به پوشه Applications منتقل کنید';
	@override String get notifCurrentNode => 'سرور فعلی';
	@override String get notifMode => 'حالت';
	@override String get notifPort => 'پورت';
	@override String get notifProfile => 'اشتراک';
	@override String get notifDisconnect => 'قطع اتصال';
	@override String get notifSwitchNode => 'تغییر سرور';
	@override String get notifVpnConnected => 'پروکسی VPN متصل است';
	@override String get connectionDetails => 'جزئیات اتصال';
	@override String get sourceAddress => 'آدرس مبدا';
	@override String get destinationAddress => 'آدرس مقصد';
	@override String get host => 'هاست';
	@override String get process => 'فرآیند';
	@override String get processPath => 'مسیر فرآیند';
	@override String get proxyChain => 'زنجیره پروکسی';
	@override String get networkProtocol => 'پروتکل';
	@override String get trafficUpload => 'ترافیک آپلود';
	@override String get trafficDownload => 'دانلود ترافیک';
	@override String get connectionDuration => 'مدت زمان';
	@override String get connectionStart => 'زمان شروع';
	@override String get copyHost => 'کپی هاست';
	@override String get copyAllDetails => 'کپی همه جزئیات';
	@override String get closeThisConnection => 'بستن این اتصال';
	@override String get sortByDownload => 'بر اساس دانلود';
	@override String get sortByUpload => 'بر اساس آپلود';
	@override String get sortBySpeed => 'بر اساس سرعت';
	@override String get sortByDuration => 'بر اساس مدت';
	@override String get sortByHost => 'بر اساس هاست';
	@override String get realtimeSpeed => 'سرعت لحظه‌ای';
	@override String get totalUpload => 'کل آپلود';
	@override String get totalDownload => 'کل دانلود';
	@override String get activeConnections => 'اتصال‌های فعال';
	@override String get openInFolder => 'نمایش در پوشه';
	@override String get openProfilesDir => 'باز کردن پوشه پروفایل‌ها';
	@override String get profilePatches => 'بازنویسی پروفایل';
	@override String nodeCount({required Object p}) => '${p} گره';
	@override String get copyFilePath => 'کپی مسیر فایل';
	@override String get duplicateProfile => 'ایجاد رونوشت';
	@override String get useThisProfile => 'استفاده از این پروفایل';
}

// Path: permission
class _Translations$permission$fa implements Translations$permission$en {
	_Translations$permission$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get camera => 'دوربین';
	@override String get screen => 'ضبط صفحه';
	@override String get appQuery => 'Get Application List';
	@override String request({required Object p}) => 'مجوزهای [${p}] را فعال کنید';
	@override String requestNeed({required Object p}) => 'لطفاً مجوز [${p}] را فعال کنید';
}

// Path: tls
class _Translations$tls$fa implements Translations$tls$en {
	_Translations$tls$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get insecure => 'رد شدن از تأیید گواهی';
	@override String get certificate => 'گواهی';
	@override String get privateKey => 'کلید خصوصی';
	@override String get customTrustCert => 'گواهی های سفارشی';
}

// Path: tun
class _Translations$tun$fa implements Translations$tun$en {
	_Translations$tun$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get stack => 'پشته شبکه';
	@override String get stackGvisor => 'gVisor';
	@override String get stackGvisorDesc => 'پشته شبکه فضای کاربر، پایداری و سازگاری بالا';
	@override String get stackSystem => 'System';
	@override String get stackSystemDesc => 'پشته شبکه بومی سیستم‌عامل، عملکرد بالا وابسته به سیستم';
	@override String get stackMixed => 'Mixed';
	@override String get stackMixedDesc => 'حالت پشته شبکه ترکیبی، تعادل میان عملکرد و سازگاری';
	@override String get stackMips => 'MIPS (Mihomo IP Stack)';
	@override String get stackMipsDesc => 'پشته IP با عملکرد بالا ساخته Mihomo با توان بالا و تاخیر کم';
	@override String get inet4Address => 'محدوده آدرس IPv4';
	@override String get inet6Address => 'محدوده آدرس IPv6';
	@override String get dnsHijack => 'ربودن DNS';
	@override String get strictRoute => 'مسیریابی دقیق';
	@override String get tunDefaultRoute => 'مسیر پیش‌فرض';
	@override String get icmpForward => 'ارسال ICMP';
	@override String get allowBypass => 'به برنامه‌ها اجازه دهید VPN را دور بزنند';
	@override String get appendHttpProxy => 'پیوست دادن پروکسی HTTP به وی‌پی‌ان';
	@override String get bypassHttpProxyDomain => 'دامنه ها مجاز به دور زدن پروکسی HTTP هستند';
}

// Path: dns
class _Translations$dns$fa implements Translations$dns$en {
	_Translations$dns$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get listen => 'آدرس گوش دادن';
	@override String get fakeIp => 'fake-ip';
	@override String get fallback => 'Fallback';
	@override String get preferH3 => 'اولویت DoH H3';
	@override String get useHosts => 'استفاده از هاست ها';
	@override String get useSystemHosts => 'استفاده از هاست های سیستم';
	@override String get enhancedMode => 'حالت پیشرفته';
	@override String get fakeIPFilterMode => 'حالت فیلتر ${_root.dns.fakeIp}';
	@override String get fakeIPFilter => 'فیلتر ${_root.dns.fakeIp}';
	@override String get respectRules => 'رعایت قوانین';
	@override String get nameServer => 'سرور DNS';
	@override String get defaultNameServer => '${_root.meta.byDefault} ${_root.dns.nameServer}';
	@override String get proxyNameServer => '${_root.meta.proxy} ${_root.dns.nameServer}';
	@override String get directNameServer => '${_root.meta.direct} ${_root.dns.nameServer}';
	@override String get fallbackNameServer => '${_root.dns.fallback} ${_root.dns.nameServer}';
	@override String get fallbackGeoIp => '${_root.dns.fallback} GeoIp';
	@override String get fallbackGeoIpCode => '${_root.dns.fallback} GeoIpCode';
	@override String get flushCache => 'پاک کردن حافظه پنهان DNS';
	@override String get flushCacheSuccess => 'حافظه پنهان DNS و Fake-IP با موفقیت پاک شد';
	@override String get presets => 'پیش‌تنظیم‌های سریع DNS';
	@override String get presetSpeed => 'دو پشته پرسرعت';
	@override String get presetSpeedDesc => 'AliDNS DoH3 + DNSPod DoH: اتصال داخلی فوری و مسیریابی هوشمند';
	@override String get presetSecure => 'ضد آلودگی و حفظ حریم خصوصی';
	@override String get presetSecureDesc => 'Cloudflare DoH3 + Google DoH: جلوگیری از سرقت و سانسور';
	@override String get presetAdGuard => 'مسدودسازی تبلیغات با AdGuard';
	@override String get presetAdGuardDesc => 'AdGuard DoQ + AliDNS DoH: فیلتر درخواست‌ها و حفاظت از حریم خصوصی';
	@override String get overwriteDesc => 'بازنویسی تنظیمات DNS از پروفایل‌های اشتراک';
	@override String get enableDesc => 'فعال‌سازی تحلیل‌کننده DNS سفارشی';
	@override String get resetFakeIpFilter => 'بازیابی پیش‌فرض‌ها';
	@override String get resetFakeIpFilterConfirm => 'آیا مطمئن هستید که می‌خواهید لیست فیلتر Fake-IP پیشنهادی را بازیابی کنید؟';
	@override String get dnsTester => 'تشخیص زنده DNS';
	@override String get testQuery => 'آزمایش';
	@override String get fakeIpDetected => 'Fake-IP منطبق شد';
	@override String get realIpDetected => 'IP عمومی واقعی';
	@override String get addServer => 'افزودن سرور DNS';
	@override String get geoAssetsTitle => 'پایگاه‌های داده آفلاین GEO';
	@override String get geoAssetsDesc => 'مدیریت قوانین دامنه GeoSite، پایگاه‌های داده GeoIP و ASN';
	@override String get cdnSource => 'آینه CDN دانلود';
	@override String get updateAll => 'به‌روزرسانی همه';
	@override String get updateSuccess => 'به‌روزرسانی با موفقیت انجام شد';
	@override String get updateFailed => 'به‌روزرسانی ناموفق بود';
	@override String get addPresetServer => 'افزودن DNS پیش‌فرض';
	@override String manageFakeIpFilter({required Object p}) => 'مدیریت فهرست فیلترها (${p})';
	@override String fakeIpFilterDesc({required Object p}) => '${p} قانون دامنه برای جلوگیری از مشکلات انزوای شبکه، تفکیک Fake-IP را دور می‌زنند.';
}

// Path: sniffer
class _Translations$sniffer$fa implements Translations$sniffer$en {
	_Translations$sniffer$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get overrideDest => 'پوشش';
}

// Path: profilePatchMode
class _Translations$profilePatchMode$fa implements Translations$profilePatchMode$en {
	_Translations$profilePatchMode$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get currentSelected => 'فعلی انتخاب شده';
	@override String get overwrite => 'Overwrite داخلی';
	@override String get noOverwrite => 'داخلی - رونویسی نشده است';
}

// Path: main.tray
class _Translations$main$tray$fa implements Translations$main$tray$en {
	_Translations$main$tray$fa._(this._root);

	final TranslationsFa _root; // ignore: unused_field

	// Translations
	@override String get menuOpen => 'باز کردن';
	@override String get menuExit => 'خروج';
	@override String get coreDisconnected => 'Wmimo · هسته متصل نیست';
	@override String get coreRunning => 'Wmimo · هسته در حال اجرا است';
	@override String get startProxy => 'شروع اتصال پروکسی';
	@override String get stopProxy => 'قطع اتصال پروکسی';
	@override String get restartCore => 'راه‌اندازی مجدد هسته پروکسی';
	@override String get systemProxyItem => 'پروکسی سیستم';
	@override String get tunModeItem => 'حالت TUN';
	@override String get outboundMode => 'حالت خروجی';
	@override String get modeRule => 'مسیریابی بر اساس قانون';
	@override String get modeGlobal => 'پروکسی سرتاسری';
	@override String get modeDirect => 'اتصال مستقیم';
	@override String get profilesMenu => 'اشتراک‌ها';
	@override String get updateAllProfiles => 'به‌روزرسانی همه اشتراک‌ها';
	@override String get proxyNodes => 'گره‌های پروکسی';
	@override String get tools => 'ابزارها';
	@override String get copyProxyCmd => 'کپی دستور پروکسی ترمینال (CMD / Bash)';
	@override String get delayTestAll => 'تست سرعت همه سرورها';
	@override String get openDashboard => 'باز کردن کنترل پنل';
	@override String get resetSystemProxy => 'تعمیر شبکه / بازنشانی پروکسی سیستم';
	@override String get copyCmdPowerShell => 'دستور PowerShell';
	@override String get copyCmdCmd => 'دستور CMD';
	@override String get copyCmdBash => 'دستور Bash/Zsh';
}

/// The flat map containing all translations for locale <fa>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'WelcomeLanguageScreen.welcomeTitle' => 'به Wmimo خوش آمدید',
			'WelcomeLanguageScreen.selectLanguage' => 'انتخاب زبان',
			'WelcomeLanguageScreen.subtitle' => 'لطفاً زبان مورد نظر خود را انتخاب کنید. می‌توانید در هر زمان در تنظیمات آن را تغییر دهید.',
			'WelcomeLanguageScreen.start' => 'شروع کنید',
			'BackupAndSyncWebdavScreen.webdavServerUrl' => 'آدرس URL سرور',
			'BackupAndSyncWebdavScreen.webdavRequired' => 'نمی‌تواند خالی باشد',
			'BackupAndSyncWebdavScreen.webdavLoginFailed' => 'ورود ناموفق بود:',
			'BackupAndSyncWebdavScreen.webdavListFailed' => 'دریافت لیست فایل ناموفق بود:',
			'LaunchFailedScreen.invalidProcess' => 'اجرای نرم‌افزار ناموفق بود [نام‌ اجرایی پروسه نامعتبر]، لطفا مجدد نرم‌افزار را در دایرکتوری دیگری نصب کنید',
			'LaunchFailedScreen.invalidProfile' => 'اجرای نرم‌افزار ناموفق بود [دسترسی به پروفایل ناموفق بود]، لطفا مجدد نرم افزار را نصب کنید',
			'LaunchFailedScreen.invalidVersion' => 'اجرای نرم‌افزار ناموفق بود [ورژن نامعتبر]، لطفا مجدد نرم‌افزار را نصب کنید',
			'LaunchFailedScreen.systemVersionLow' => 'راه اندازی برنامه ناموفق بود [نسخه سیستم خیلی کم است]',
			'LaunchFailedScreen.invalidInstallPath' => 'مسیر نصب نامعتبر است، لطفا مجدد در مسیر معتبر نصب کنید',
			'PerAppAndroidScreen.title' => 'پروکسی به‌تفکیک برنامه',
			'PerAppAndroidScreen.whiteListMode' => 'حالت لیست سفید',
			'PerAppAndroidScreen.whiteListModeTip' => 'وقتی فعال باشد: فقط برنامه‌هایی که انتخاب شده‌اند پروکسی می‌شوند؛ وقتی فعال نباشد: فقط برنامه‌هایی که انتخاب نشده‌اند پروکسی می‌شوند',
			'UserAgreementScreen.privacyFirst' => 'حریم‌خصوصی شما اولویت دارد',
			'UserAgreementScreen.agreeAndContinue' => 'پذیرفتن و ادامه',
			'NetCheckScreen.title' => 'عیب‌یابی و تشخیص شبکه',
			'NetCheckScreen.fullDiagnosticsTab' => 'عیب‌یابی کامل لینک',
			'NetCheckScreen.advancedCheckTab' => 'بررسی پیشرفته دامنه',
			'NetCheckScreen.startDiagnostics' => 'شروع عیب‌یابی کامل',
			'NetCheckScreen.reDiagnostics' => 'تست مجدد',
			'NetCheckScreen.diagnosing' => 'در حال بررسی و عیب‌یابی شبکه...',
			'NetCheckScreen.healthScore' => 'امتیاز سلامت',
			'NetCheckScreen.scorePerfect' => 'عالی',
			'NetCheckScreen.scoreGood' => 'خوب',
			'NetCheckScreen.scoreWarning' => 'هشدار',
			'NetCheckScreen.scoreCritical' => 'مسدود شده',
			'NetCheckScreen.oneClickRepair' => 'خودترمیم هوشمند',
			'NetCheckScreen.repairSuccess' => 'ترمیم خودکار موفقیت‌آمیز بود، اتصال بازیابی شد',
			'NetCheckScreen.repairFailed' => 'ترمیم انجام شد، ممکن است نیاز به بررسی دستی باشد',
			'NetCheckScreen.repairing' => 'در حال اجرای خودترمیم...',
			'NetCheckScreen.issueFound' => ({required Object count}) => '${count} مشکل پیدا شد',
			'NetCheckScreen.noIssue' => 'تمام بررسی‌ها با موفقیت انجام شد',
			'NetCheckScreen.details' => 'جزئیات فنی',
			'NetCheckScreen.copyDetails' => 'کپی لاگ',
			'NetCheckScreen.detailsCopied' => 'گزارش عیب‌یابی در کلیپ‌بورد کپی شد',
			'NetCheckScreen.stepPhysical' => 'کارت شبکه و درگاه ارتباطی',
			'NetCheckScreen.stepDns' => 'DNS و موتور Fake-IP',
			'NetCheckScreen.stepCore' => 'فرایند هسته و پورت‌ها',
			'NetCheckScreen.stepProxy' => 'پیکربندی پروکسی سیستم',
			'NetCheckScreen.stepHandshake' => 'دست‌تکانی سرتاسری اینترنت',
			'NetCheckScreen.suggestedAction' => 'پیشنهاد رفع مشکل',
			'NetCheckScreen.autoRepairAction' => 'ترمیم فوری',
			'NetCheckScreen.enterDomain' => 'لطفا یک دامنه وارد کنید',
			'NetCheckScreen.checking' => 'در حال بررسی...',
			'NetCheckScreen.aQueryFailed' => ({required Object p}) => 'خطای استعلام رکورد A: ${p}',
			'NetCheckScreen.aaaaQueryFailed' => ({required Object p}) => 'خطای استعلام رکورد AAAA: ${p}',
			'NetCheckScreen.success' => 'موفقیت‌آمیز',
			'NetCheckScreen.failed' => 'ناموفق',
			'NetCheckScreen.suspectedPollution' => 'مشکوک به مسمومیت DNS',
			'NetCheckScreen.domainLabel' => 'دامنه',
			'NetCheckScreen.checkButton' => 'بررسی',
			'NetCheckScreen.dnsSection' => '۱. استعلام DNS',
			'NetCheckScreen.directHttpSection' => '۲. HTTP (از طریق TUN، ابتدا TUN را فعال کنید)',
			'NetCheckScreen.proxyHttpSection' => ({required Object p}) => '۳. HTTP (از طریق پروکسی، پورت: ${p})',
			'NetCheckScreen.tunNotEnabled' => 'TUN فعال نیست',
			'NetCheckScreen.routeTableSection' => '۴. جدول مسیریابی',
			'NetCheckScreen.stepPhysicalDesc' => 'بررسی وضعیت آداپتور شبکه فیزیکی، IP محلی و اتصال گیت‌وی',
			'NetCheckScreen.stepDnsDesc' => 'بررسی تأخیر وضوح DNS محلی و وضعیت پاسخ DNS هسته',
			'NetCheckScreen.stepCoreDesc' => 'بررسی وضعیت فرآیند Mihomo و پورت‌های شنود Mixed-Port/API',
			'NetCheckScreen.stepProxyDesc' => 'بررسی تنظیمات پروکسی سیستم و عیب‌یابی پروکسی‌های باقیمانده قطعی شبکه',
			'NetCheckScreen.stepHandshakeDesc' => 'سنجش تأخیر سرتاسری و دردسترس‌بودن CDN جهانی از طریق نود فعال',
			'NetCheckScreen.shortStepPhysical' => 'کارت شبکه',
			'NetCheckScreen.shortStepDns' => 'DNS',
			'NetCheckScreen.shortStepCore' => 'هسته',
			'NetCheckScreen.shortStepProxy' => 'پروکسی',
			'NetCheckScreen.shortStepHandshake' => 'اینترنت',
			'NetCheckScreen.valNicNormal' => ({required Object p}) => 'شبکه متصل است (${p})',
			'NetCheckScreen.valNicNone' => 'هیچ رابط شبکه فعالی یافت نشد',
			'NetCheckScreen.valNicGatewayTimeout' => 'IP محلی دریافت شد اما اتصال به گیت‌وی خارجی منقضی شد',
			'NetCheckScreen.valNicError' => 'خطا در بررسی رابط شبکه',
			'NetCheckScreen.valDnsNormal' => ({required Object p}) => 'پاسخ DNS نرمال (${p})',
			'NetCheckScreen.valDnsEmpty' => 'درخواست DNS لیست خالی برگرداند',
			'NetCheckScreen.valDnsTimeout' => 'درخواست DNS منقضی شد یا با خطا مواجه شد',
			'NetCheckScreen.valCoreNormal' => ({required Object port, required Object mode}) => 'هسته سالم است (پورت ترکیبی: ${port}، حالت: ${mode})',
			'NetCheckScreen.valCoreNotRunning' => 'سرویس هسته در حال اجرا نیست',
			'NetCheckScreen.valCorePortConflict' => ({required Object p}) => 'پورت ${p} توسط برنامه دیگری اشغال شده است',
			'NetCheckScreen.valCoreApiFailed' => 'هسته پاسخگو نیست (خطای ارتباط با API)',
			'NetCheckScreen.valCoreError' => 'خطا در بررسی هسته',
			'NetCheckScreen.valProxyActive' => ({required Object port}) => 'پروکسی سیستم فعال است (127.0.0.1:${port})',
			'NetCheckScreen.valProxyDisabled' => 'پروکسی سیستم غیرفعال است (حالت مستقیم / TUN / دستی)',
			'NetCheckScreen.valProxyZombie' => 'پروکسی باقیمانده سیستم شناسایی شد (باعث قطعی اینترنت)',
			'NetCheckScreen.valProxyFailed' => 'فعال‌سازی پروکسی سیستم ناموفق بود',
			'NetCheckScreen.valProxyWarning' => 'هشدار وضعیت پروکسی سیستم',
			'NetCheckScreen.valHandshakeNormal' => ({required Object node, required Object delay}) => 'اتصال به اینترنت نرمال (${node} • ${delay} ms)',
			'NetCheckScreen.valHandshakeFailed' => ({required Object node, required Object err}) => 'خطای اتصال نود فعلی [${node}] (${err})',
			'NetCheckScreen.valHandshakeSkipped' => 'هسته شروع نشده، تست اتصال انجام نشد',
			'NetCheckScreen.valHandshakeError' => 'خطا در اتصال به اینترنت',
			'NetCheckScreen.issueNicDisconnected' => 'کارت شبکه به هیچ شبکه‌ای متصل نیست (کابل جدا شده، وای‌فای خاموش یا حالت هواپیما)',
			'NetCheckScreen.suggestNicCheck' => 'لطفاً کابل شبکه، اتصال وای‌فای یا وضعیت آداپتور شبکه را بررسی کنید',
			'NetCheckScreen.suggestNicReset' => 'غیرفعال کردن و فعال‌سازی مجدد آداپتور شبکه را در تنظیمات سیستم امتحان کنید',
			'NetCheckScreen.issueNicGatewayUnreachable' => 'به شبکه محلی متصل است، اما گیت‌وی خارجی دردسترس نیست (پرتال ورود یا قطعی روتر)',
			'NetCheckScreen.suggestNicGateway' => 'چراغ‌های روتر را بررسی کنید یا مرورگر را برای ورود به سیستم باز کنید',
			'NetCheckScreen.issueDnsPollution' => 'سرویس DNS محلی پاسخ نمی‌دهد؛ احتمال آلودگی DNS یا ربایش گیت‌وی وجود دارد',
			'NetCheckScreen.suggestDnsReset' => 'DNS سیستم را بازنشانی کنید یا DNS رمزگذاری‌شده هوشمند (DoH/DoT) را در Wmimo فعال نمایید',
			'NetCheckScreen.actionFlushDns' => 'پاکسازی کش DNS سیستم',
			'NetCheckScreen.suggestDnsSlow' => 'تأخیر DNS طولانی است، پیشنهاد می‌شود DNS رمزگذاری‌شده فعال گردد',
			'NetCheckScreen.issueDnsFailed' => 'تجزیه DNS محلی با شکست مواجه شد؛ تبدیل دامنه به IP امکان‌پذیر نیست',
			'NetCheckScreen.suggestDnsFlush' => 'برای پاکسازی کش DNS کلیک کنید یا در تنظیمات Wmimo دی‌ان‌اس رمزگذاری‌شده را فعال کنید',
			'NetCheckScreen.issueCorePortConflict' => 'تداخل پورت شناسایی شد! نرم‌افزار پروکسی یا سرویس دیگری پورت را اشغال کرده است',
			'NetCheckScreen.suggestCoreChangePort' => 'سایر برنامه‌های پروکسی را ببندید یا در تنظیمات Wmimo شماره پورت را تغییر دهید',
			'NetCheckScreen.actionRestartCore' => 'راه‌اندازی مجدد هسته',
			'NetCheckScreen.issueCoreStopped' => 'فرآیند هسته Wmimo در حال حاضر متوقف است',
			'NetCheckScreen.suggestCoreStart' => 'کلید اتصال در صفحه اصلی یا دکمه [شروع هسته] در زیر را بزنید',
			'NetCheckScreen.actionStartCore' => 'شروع فرآیند هسته',
			'NetCheckScreen.issueCoreFrozen' => 'فرآیند هسته متوقف شده یا رمز عبور API همخوانی ندارد',
			'NetCheckScreen.suggestCoreRestart' => 'پیشنهاد می‌شود دکمه [راه‌اندازی مجدد هسته] را برای بازیابی سرویس بزنید',
			'NetCheckScreen.suggestCoreReinstall' => 'راه‌اندازی مجدد هسته یا نصب مجدد درایور را امتحان کنید',
			'NetCheckScreen.issueProxyZombie' => 'پروکسی باقیمانده ترافیک را به پورت غیرفعال هدایت می‌کند و باعث قطعی شبکه می‌شود',
			'NetCheckScreen.suggestProxyReset' => 'روی [پاکسازی و بازنشانی پروکسی سیستم] در زیر کلیک کنید تا اینترنت فوراً وصل شود',
			'NetCheckScreen.actionResetProxy' => 'پاکسازی و بازنشانی پروکسی',
			'NetCheckScreen.issueProxyBlocked' => 'پروکسی سیستم اعمال نشد؛ ممکن است توسط آنتی‌ویروس مسدود شده باشد',
			'NetCheckScreen.suggestProxyReapply' => 'برای ثبت مجدد و اعمال اجباری پروکسی روی دکمه زیر کلیک کنید',
			'NetCheckScreen.actionReapplyProxy' => 'اعمال مجدد پروکسی سیستم',
			'NetCheckScreen.issueProxyRead' => 'خطای غیربحرانی در خواندن تنظیمات پروکسی سیستم رخ داد',
			'NetCheckScreen.issueHandshakeBlocked' => 'نود پروکسی انتخابی نمی‌تواند به اینترنت متصل شود؛ ارتباط مسدود شده است',
			'NetCheckScreen.suggestHandshakeSwitch' => 'نود ممکن است در دست تعمیر یا غیرقابل دسترس باشد؛ لطفاً نود دیگری را انتخاب کنید',
			'NetCheckScreen.suggestHandshakeSlow' => ({required Object delay}) => 'تأخیر نود بالاست (${delay} ms)، پیشنهاد می‌شود نود نزدیک‌تری را انتخاب نمایید',
			'NetCheckScreen.suggestHandshakeCheck' => 'تنظیمات نود را بررسی کرده یا هدف تست را تغییر دهید',
			'NetCheckScreen.conclusionPerfect' => 'مسیر شبکه عالی است! تمامی نودها و تنظیمات پروکسی کاملاً فعال و روان هستند.',
			'NetCheckScreen.conclusionGood' => 'مسیر نسبتاً طبیعی است، تأخیرهای جزئی یا هشدارهایی شناسایی شده است.',
			'NetCheckScreen.conclusionWarning' => 'اشکالاتی در مسیر شبکه یا پروکسی شناسایی شد؛ لطفاً از دکمه [تعمیر هوشمند] زیر استفاده کنید.',
			'NetCheckScreen.conclusionCritical' => 'انسداد شدید شبکه! شبکه محلی متصل نیست یا هسته پروکسی مسدود شده است.',
			'SpeedTestScreen.title' => 'تست سرعت',
			'SpeedTestScreen.startTest' => 'شروع تست',
			'SpeedTestScreen.stopTest' => 'توقف',
			'SpeedTestScreen.reTest' => 'تست مجدد',
			'SpeedTestScreen.ready' => 'آماده',
			'SpeedTestScreen.testingPing' => 'در حال تست پینگ و نوسان...',
			'SpeedTestScreen.testingDownload' => 'در حال تست سرعت دانلود...',
			'SpeedTestScreen.testingUpload' => 'در حال تست سرعت آپلود...',
			'SpeedTestScreen.completed' => 'تست تکمیل شد',
			'SpeedTestScreen.stopped' => 'متوقف شد',
			'SpeedTestScreen.ping' => 'پینگ',
			'SpeedTestScreen.jitter' => 'نوسان (Jitter)',
			'SpeedTestScreen.download' => 'دانلود',
			'SpeedTestScreen.upload' => 'آپلود',
			'SpeedTestScreen.currentProxy' => 'پروکسی فعلی',
			'SpeedTestScreen.directConnection' => 'اتصال مستقیم',
			'SpeedTestScreen.server' => 'سرور تست',
			'SpeedTestScreen.serverLocation' => 'موقعیت سرور',
			'SpeedTestScreen.realtimeSpeed' => 'نمودار لحظه‌ای سرعت',
			'SpeedTestScreen.peakSpeed' => 'اوج سرعت',
			'SpeedTestScreen.avgSpeed' => 'میانگین سرعت',
			'SpeedTestScreen.testHistory' => 'تاریخچه تست',
			'SpeedTestScreen.clearHistory' => 'پاک کردن تاریخچه',
			'VersionUpdateScreen.versionReady' => ({required Object p}) => 'نسخه جدید [${p}] آماده است',
			'VersionUpdateScreen.update' => 'راه‌اندازی مجدد برای به‌روزرسانی',
			'VersionUpdateScreen.cancel' => 'الان‌ نه',
			'loginScreen.login' => 'ورود',
			'loginScreen.register' => 'ایجاد حساب',
			'loginScreen.forgotPassword' => 'فراموشی رمز عبور',
			'loginScreen.provider' => 'ارائه دهنده خدمات',
			'loginScreen.providerName' => 'کد/نام مستعار/URL ${_root.loginScreen.provider}',
			'loginScreen.providerNameRequired' => 'لطفا کد/نام مستعار/URL ${_root.loginScreen.provider} را وارد کنید',
			'loginScreen.account' => 'حساب',
			'loginScreen.accountRequired' => 'لطفا حساب را وارد کنید',
			'loginScreen.email' => 'ایمیل',
			'loginScreen.emailRequired' => 'لطفا آدرس ایمیل را وارد کنید',
			'loginScreen.password' => 'رمز عبور',
			'loginScreen.passwordRequired' => 'لطفا رمز عبور را وارد کنید',
			'loginScreen.validEmailRequired' => 'لطفا یک آدرس ایمیل معتبر وارد کنید',
			'loginScreen.passwordMinLength' => ({required Object minLength}) => 'طول رمز عبور باید حداقل ${minLength} کاراکتر باشد',
			'loginScreen.unsupportedProvider' => '${_root.loginScreen.provider} پشتیبانی نمی شود',
			'loginScreen.unsupportedProviderType' => 'نوع ${_root.loginScreen.provider} پشتیبانی نمی شود',
			'loginScreen.unActivedProvider' => 'قابلیت ورود فعال نشده است',
			'loginScreen.providerLoginSupportRequired' => ({required Object p}) => 'لطفاً کد/نام مستعار ارائه‌دهنده را از ${_root.loginScreen.provider} دریافت کنید.\nبرای راهنمای اتصال ${_root.loginScreen.provider} به این لینک مراجعه کنید: ${p}',
			'loginScreen.providerDisclaimer' => 'سلب مسئولیت: ${_root.loginScreen.provider} یک سرویس شخص ثالث است و ارتباطی با این برنامه ندارد',
			'loginScreen.createSessionFailed' => 'ایجاد نشست با خطا مواجه شد، ارائه‌دهنده یا حساب را بررسی کنید',
			'main.tray.menuOpen' => 'باز کردن',
			'main.tray.menuExit' => 'خروج',
			'main.tray.coreDisconnected' => 'Wmimo · هسته متصل نیست',
			'main.tray.coreRunning' => 'Wmimo · هسته در حال اجرا است',
			'main.tray.startProxy' => 'شروع اتصال پروکسی',
			'main.tray.stopProxy' => 'قطع اتصال پروکسی',
			'main.tray.restartCore' => 'راه‌اندازی مجدد هسته پروکسی',
			'main.tray.systemProxyItem' => 'پروکسی سیستم',
			'main.tray.tunModeItem' => 'حالت TUN',
			'main.tray.outboundMode' => 'حالت خروجی',
			'main.tray.modeRule' => 'مسیریابی بر اساس قانون',
			'main.tray.modeGlobal' => 'پروکسی سرتاسری',
			'main.tray.modeDirect' => 'اتصال مستقیم',
			'main.tray.profilesMenu' => 'اشتراک‌ها',
			'main.tray.updateAllProfiles' => 'به‌روزرسانی همه اشتراک‌ها',
			'main.tray.proxyNodes' => 'گره‌های پروکسی',
			'main.tray.tools' => 'ابزارها',
			'main.tray.copyProxyCmd' => 'کپی دستور پروکسی ترمینال (CMD / Bash)',
			'main.tray.delayTestAll' => 'تست سرعت همه سرورها',
			'main.tray.openDashboard' => 'باز کردن کنترل پنل',
			'main.tray.resetSystemProxy' => 'تعمیر شبکه / بازنشانی پروکسی سیستم',
			'main.tray.copyCmdPowerShell' => 'دستور PowerShell',
			'main.tray.copyCmdCmd' => 'دستور CMD',
			'main.tray.copyCmdBash' => 'دستور Bash/Zsh',
			'meta.enable' => 'فعال‌سازی',
			'meta.disable' => 'غیرفعال',
			'meta.open' => 'باز کن',
			'meta.close' => 'بسته',
			'meta.quit' => 'خروج',
			'meta.add' => 'افزودن',
			'meta.addSuccess' => 'با‌موفقیت اضافه شد',
			'meta.addFailed' => ({required Object p}) => 'افزودن ناموفق بود:${p}',
			'meta.remove' => 'حذف',
			'meta.removeConfirm' => 'آیا از حذف اطمینان دارین؟',
			'meta.edit' => 'ویرایش کنید',
			'meta.view' => 'بررسی',
			'meta.remark' => 'ملاحضات',
			'meta.byDefault' => 'پیش‌فرض',
			'meta.editRemark' => 'یادداشت های اصلاحی',
			'meta.more' => 'بیشتر',
			'meta.tips' => 'اطلاعات',
			'meta.selectAll' => 'انتخاب همه',
			'meta.copy' => 'کپی',
			'meta.paste' => 'چسباندن',
			'meta.cut' => 'برش',
			'meta.save' => 'ذخیره کنید',
			'meta.ok' => 'خُب',
			'meta.cancel' => 'لغو',
			'meta.faq' => 'سوالات متداول',
			'meta.doc' => 'سند',
			'meta.htmlTools' => 'مجموعه ابزارهای HTML',
			'meta.download' => 'دانلود',
			'meta.loading' => 'درحال بارگذاری…',
			'meta.days' => 'روز',
			'meta.hours' => 'ساعت',
			'meta.minutes' => 'دقیقه',
			'meta.seconds' => 'دومین',
			'meta.milliseconds' => 'میلی‌ثانیه',
			'meta.protocol' => 'پروتکل',
			'meta.search' => 'جستجو',
			'meta.custom' => 'سفارشی',
			'meta.connect' => 'اتصال',
			'meta.disconnect' => 'قطع‌ اتصال',
			'meta.connected' => 'وصل شد',
			'meta.disconnected' => 'قطع شد',
			'meta.connecting' => 'درحال اتصال',
			'meta.connectTimeout' => 'اتمام مهلت اتصال',
			'meta.timeout' => 'تایم اوت',
			'meta.timeoutDuration' => 'مدت زمان وقفه',
			'meta.latency' => 'پینگ',
			'meta.latencyTest' => 'تست پینگ',
			'meta.networkCheck' => 'بررسی شبکه',
			'meta.speedTest' => 'تست سرعت',
			'meta.language' => 'زبان',
			'meta.next' => 'بعدی',
			'meta.done' => 'انجام‌شد',
			'meta.apply' => 'درخواست دادن',
			'meta.refresh' => 'بارگذاری مجدد',
			'meta.retry' => 'دوباره امتحان کنید؟',
			'meta.update' => 'تجدید',
			'meta.updateInterval' => 'فاصله‌ی به‌روزرسانی',
			'meta.updateInterval5mTips' => 'حداقل: 5 متر',
			'meta.updateIntervalPreferByProfile' => 'اولویت با تنظیمات ارائه‌دهنده',
			'meta.updateFailed' => ({required Object p}) => 'به‌روزرسانی ناموفق بود:${p}',
			'meta.none' => 'هیچ‌کدام',
			'meta.reset' => 'بازنشانی',
			'meta.resetConfirm' => 'آیا مطمئن هستید که می‌خواهید تمام تنظیمات برنامه را بازنشانی کنید؟',
			'meta.resetSuccess' => 'تنظیمات برنامه به مقادیر پیش‌فرض بازنشانی شد',
			'meta.resetCoreConfirm' => 'آیا مطمئن هستید که می‌خواهید تنظیمات هسته و بازنویسی‌ها را بازنشانی کنید؟',
			'meta.resetCoreSuccess' => 'تنظیمات هسته به مقادیر پیش‌فرض بازنشانی شد',
			'meta.authentication' => 'مجوز',
			'meta.submit' => 'ارسال',
			'meta.user' => 'کاربر',
			'meta.account' => 'نام‌کاربری',
			'meta.password' => 'رمز‌عبور',
			'meta.decryptPassword' => 'دکريپت رمز‌عبور',
			'meta.required' => 'الزامی',
			'meta.go' => 'ادامه',
			'meta.sudoPassword' => 'رمز عبور sudo (برای حالت TUN لازم است)',
			'meta.other' => 'دیگر',
			'meta.dns' => 'DNS',
			'meta.url' => 'URL',
			'meta.urlInvalid' => 'URL نامعتبر',
			'meta.urlCannotEmpty' => 'لینک نمی‌تواند خالی باشد',
			'meta.urlTooLong' => 'URL خیلی طولانی است (>8182)',
			'meta.copyUrl' => 'کپی‌کردن لینک',
			'meta.openUrl' => 'بازکردن لینک',
			'meta.shareUrl' => 'اشتراک لینک',
			'meta.coreSettingTips' => 'توجه: پس از تغییر پیکربندی، باید دوباره وصل شوید تا اعمال شود',
			'meta.overwrite' => 'لغو',
			'meta.overwriteCustom' => 'لغوهای سفارشی',
			'meta.overwriteAppend' => 'لغو الحاقی',
			'meta.overwriteTips' => 'پیکربندی اصلی <- لغو سفارشی <- لغو برنامه',
			'meta.noOverwrite' => 'رونویسی نکنید',
			'meta.overwriteSettings' => 'لغو تنظیمات',
			'meta.diversionTemplates' => 'الگوهای مسیریابی',
			'meta.ruleProviders' => 'مجموعه قوانین (RuleSet)',
			'meta.ruleTemplates' => 'الگوی قانون',
			'meta.proxyGroupsTemplates' => 'الگوهای گروه‌ها',
			'meta.proxyGroups' => 'گروه‌های پروکسی',
			'meta.proxyNodeList' => 'فهرست گره‌های پروکسی',
			'meta.proxyNodeFailure' => ({required Object p}) => 'گره‌های پروکسی زیر منقضی شده و به طور خودکار حذف شده‌اند: ${p}',
			'meta.externalController' => 'کنترل خارجی',
			'meta.secret' => 'Secret',
			'meta.tcpConcurrent' => 'دست دادن همزمان TCP',
			'meta.globalClientFingerprint' => 'اثر انگشت جهانی TLS',
			'meta.allowLanAccess' => 'دسترسی به دستگاه LAN',
			'meta.mixedPort' => 'پورت پروکسی هیبریدی',
			'meta.logLevel' => 'سطح ورود به سیستم',
			'meta.findProcessMode' => 'حالت تطابق فرآیند',
			'meta.tcpkeepAliveInterval' => 'فاصله حفظ زنده TCP',
			'meta.delayTestUrl' => 'URL تست تأخیر',
			'meta.delayTestTimeout' => 'مهلت زمانی تست تاخیری (میلی‌ثانیه)',
			'meta.tun' => 'TUN',
			'meta.ntp' => 'NTP',
			'meta.tls' => 'TLS',
			'meta.geo' => 'GEO',
			'meta.geoDownloadByProxy' => 'دانلود Geo RuleSet با استفاده از یک پروکسی',
			'meta.geoRulesetTips' => 'Geosite/Geoip به RuleSet مربوطه تبدیل می شود',
			'meta.asnNotSupportInIosTips' => 'با توجه به محدودیت‌های حافظه سیستم iOS، قوانین IP-ASN و SRC-IP-ASN در iOS نادیده گرفته می‌شوند.',
			'meta.sniffer' => 'بو کشیدن',
			'meta.userAgent' => 'UserAgent',
			'meta.launchAtStartup' => 'اجرا در راه‌اندازی',
			'meta.launchAtStartupRunAsAdmin' => 'لطفاً Wmimo را به عنوان مدیر راه اندازی مجدد کنید',
			'meta.tunModeRunAsAdmin' => 'حالت TUN نیازمند مجوز مدیر سیستم می‌باشد لطفا نرم‌افزار را مجدد با حالت مدیر (administrator) راه‌اندازی کنید',
			'meta.tunSwitchToSystemProxy' => 'آیا مایلید برای ادامه اتصال، موقتاً به [حالت پروکسی سیستم] تغییر وضعیت دهید؟',
			'meta.tunCreateAdapterFailedAdmin' => 'ایجاد آداپتور شبکه مجازی TUN ناموفق بود: Access is denied.\nحالت TUN نیازمند دسترسی سرپرست (Administrator) است. لطفاً کلیک راست کرده و 【اجرا به عنوان مدیر (Run as administrator)】 را انتخاب کنید، یا در صفحه اصلی/تنظیمات هسته، حالت TUN را غیرفعال کرده و با پروکسی سیستم متصل شوید.',
			'meta.portableMode' => 'حالت قابل‌حمل',
			'meta.portableModeDisableTips' => 'اگر نیاز دارین از حالت قابل‌حمل خارج شوید لطفا از [Wmimo] خارج شده و به‌صورت دستی پوشه [portable] هم مسیر با فایل [wmimo.exe] را حذف کنید',
			'meta.systemProxy' => 'پروکسی سیستم',
			'meta.autoConnectAfterLaunch' => 'اتصال خودکار پس‌از راه‌اندازی',
			'meta.autoConnectAtBoot' => 'اتصال خودکار پس از روشن شدن سیستم',
			'meta.autoConnectAtBootTips' => 'پشتیبانی سیستم مورد نیاز است؛ برخی سیستم‌ها ممکن است نیاز به فعال بودن [شروع خودکار] نیز داشته باشند.',
			'meta.hideAfterLaunch' => 'پنهان کردن پنجره پس از راه اندازی',
			'meta.autoSetSystemProxy' => 'تنظیم خودکار حالت پروکسی سیستم پس‌از اتصال',
			'meta.bypassSystemProxy' => 'نام های دامنه ای که مجاز به دور زدن پراکسی سیستم هستند',
			'meta.excludeFromRecent' => 'پنهان شدن از وظایف اخیر',
			'meta.hideDockIcon' => 'پنهان کردن آیکون داک',
			'meta.showTrayTraffic' => 'نمایش اطلاعات ترافیک در سینی سیستم',
			'meta.wakeLock' => 'قفل بیدارباش',
			'meta.hideVpn' => 'مخفی کردن آیکون VPN',
			'meta.hideVpnTips' => 'فعال کردن IPv6 باعث از کار افتادن این عملکرد خواهد شد.',
			'meta.website' => 'وبسایت',
			'meta.homePage' => 'صفحه اصلی',
			'meta.rule' => 'قانون',
			'meta.global' => 'عمومی',
			'meta.direct' => 'مستقیم',
			'meta.block' => 'مسدود',
			'meta.qrcode' => 'کد QR',
			'meta.qrcodeTooLong' => 'متن برای نمایش خیلی طولانی است',
			'meta.qrcodeShare' => 'اشتراک کدQR',
			'meta.textToQrcode' => 'متن به کد QR',
			'meta.qrcodeScan' => 'اسکن QRکد',
			'meta.qrcodeScanResult' => 'نتایج اسکن',
			'meta.qrcodeScanFromImage' => 'اسکن از عکس',
			'meta.qrcodeScanFromClipboard' => 'از کلیپ‌بورد',
			'meta.qrcodeRecognized' => 'کد QR با موفقیت شناسایی شد',
			'meta.qrcodeDropHint' => 'برای عکس‌برداری یا انتخاب تصویر، دکمه‌های بالا را کلیک کنید',
			'meta.confirmImport' => 'تأیید واردسازی',
			'meta.reScan' => 'اسکن مجدد',
			'meta.qrcodeScanResultFailed' => 'تجزیه عکس ناموفق بود، لطفا مطمعن شوید اسکرین‌شات یک کدQR معتبر است',
			'meta.qrcodeScanResultEmpty' => 'نتیجه اسکن خالی است',
			'meta.screenshot' => 'اسکرین‌شات',
			'meta.backupAndSync' => 'پشتیبان‌گیری و همگام‌سازی',
			'meta.importSuccess' => 'افزودن موفق بود',
			'meta.rewriteConfirm' => 'این فایل کانفیگ‌های محلی موجود را بازنویسی می‌کند. آیا می‌خواهید ادامه بدین؟',
			'meta.importAndExport' => 'وارد‌کردن و خروجی‌گرفتن',
			'meta.import' => 'وارد‌کردن',
			'meta.importFromUrl' => 'وارد کردن از URL',
			'meta.export' => 'خروجی‌گرفتن',
			'meta.send' => 'ارسال کنید',
			'meta.receive' => 'تصاحب',
			'meta.sendConfirm' => 'ارسال را تایید کرد؟',
			'meta.continueConnectConfirm' => 'آیا اتصال ادامه یابد؟',
			'meta.termOfUse' => 'شرایط استفاده',
			'meta.privacyPolicy' => 'سیاست حریم خصوصی',
			'meta.log' => 'ورود به سیستم',
			'meta.coreLog' => 'لاگ‌های هسته',
			'meta.core' => 'هسته',
			'meta.help' => 'کمک کند',
			'meta.tutorial' => 'آموزش',
			'meta.board' => 'پانل',
			'meta.boardOnline' => 'استفاده از پانل آنلاین',
			'meta.boardOnlineUrl' => 'URL پانل آنلاین',
			'meta.boardLocalPort' => 'پورت پانل محلی',
			'meta.connections' => 'اتصال‌های فعال',
			'meta.closeAllConnections' => 'بستن همه اتصال‌ها',
			'meta.searchConnections' => 'جستجوی اتصال‌ها (دامنه/IP/قاعده/پردازش)',
			'meta.noFilterResults' => 'اتصالی یافت نشد',
			'meta.searchRules' => 'جستجوی قوانین (نوع/محتوا/پروکسی)',
			'meta.searchProfiles' => 'جستجوی پروفایل‌ها (نام/لینک/یادداشت)',
			'meta.noMatchingProfiles' => 'هیچ پروفایل متطابقی یافت نشد',
			'meta.rules' => 'قوانین مسیریابی',
			'meta.clear' => 'پاک کردن',
			'meta.copySuccess' => 'کپی شد',
			'meta.alwayOnVPN' => 'اتصال همیشه باز',
			'meta.disableFontScaler' => 'غیرفعال‌سازی مقیاس‌بندی فونت(با راه‌اندازی مجدد اعمال می‌شود)',
			'meta.autoOrientation' => 'چرخش صفحه را دنبال کنید',
			'meta.restartTakesEffect' => 'با راه‌اندازی مجدد اعمال می‌شود',
			'meta.reconnectTakesEffect' => 'پس از اتصال مجدد، اعمال خواهد شد.',
			'meta.runtimeProfile' => 'پیکربندی زمان اجرا',
			'meta.willCompleteAfterRebootInstall' => 'لطفاً دستگاه خود را مجدداً راه اندازی کنید تا نصب افزونه سیستم تکمیل شود.',
			'meta.willCompleteAfterRebootUninstall' => 'لطفاً دستگاه خود را مجدداً راه‌اندازی کنید تا حذف نصب افزونه سیستم تکمیل شود',
			'meta.requestNeedsUserApproval' => '۱. لطفاً به Wmimo اجازه دهید افزونه‌های سیستمی را در [تنظیمات سیستم] - [حریم خصوصی و امنیت] نصب کند. ۲. : [تنظیمات سیستم] - [عمومی] - [موارد ورود و افزونه‌ها - افزونه‌های شبکه] [wmimoServiceSE] را فعال کنید. پس از اتمام، دوباره متصل شوید.',
			'meta.FullDiskAccessPermissionRequired' => 'لطفاً مجوز wmimoServiceSE را در [تنظیمات سیستم]-[حریم خصوصی و امنیت]-[دسترسی کامل به دیسک] فعال کنید و دوباره متصل شوید.',
			'meta.proxy' => 'بازیگری',
			'meta.theme' => 'موضوع',
			'meta.tvMode' => 'حالت تلویزیون',
			'meta.autoUpdate' => 'به روز رسانی خودکار',
			'meta.updateChannel' => 'کانال به‌روزرسانی خودکار',
			'meta.onlineCustomerService' => 'پشتیبانی آنلاین',
			'meta.subscriptionChannel' => 'کانال اشتراک',
			'meta.hasNewVersion' => ({required Object p}) => 'به‌روزرسانی نسخه ${p} ',
			'meta.autoDownloadPkg' => 'دانلود خودکار بسته‌های به‌روزرسانی',
			'meta.devOptions' => 'تنظیمات توسعه‌دهندگان',
			'meta.joinUs' => 'به ما بپیوندید',
			'meta.about' => 'درباره',
			'meta.name' => 'نام',
			'meta.version' => 'نسخه',
			'meta.notice' => 'اطلاعیه',
			'meta.sort' => 'مرتب‌سازی',
			'meta.recommended' => 'پیشنهادی',
			'meta.innerError' => ({required Object p}) => 'خطای داخلی: ${p}',
			'meta.share' => 'اشتراک گذاری',
			'meta.importFromClipboard' => 'افزودن از کلیپ‌برد',
			'meta.exportToClipboard' => 'صادرات به کلیپ بورد',
			'meta.server' => 'سرور',
			'meta.port' => 'بندر',
			'meta.donate' => 'اهدا کنید',
			'meta.setting' => 'تنظیمات',
			'meta.settingCore' => 'تنظیمات هسته',
			'meta.settingApp' => 'تنظیمات برنامه',
			'meta.coreOverwrite' => 'بازنویسی هسته',
			'meta.iCloud' => 'iCloud',
			'meta.webdav' => 'Webdav',
			'meta.lanSync' => 'LAN Sync',
			'meta.lanSyncNotQuitTips' => 'قبل از تکمیل همگام‌سازی از این قسمت خارج نشوید',
			'meta.deviceNoSpace' => 'فضای خالی کافی ندارید',
			'meta.hideSystemApp' => 'برنامه های سیستم را مخفی کنید',
			'meta.hideAppIcon' => 'پنهان کردن نماد برنامه',
			'meta.openDir' => 'بازکردن دایرکتوری فایل',
			'meta.type' => 'نوع',
			'meta.fileChoose' => 'انتخاب فایل',
			'meta.filePathCannotEmpty' => 'مسیر فایل نمی‌تواند خالی باشد',
			'meta.fileNotExist' => ({required Object p}) => 'فایل وجود ندارد:${p}',
			'meta.fileTypeInvalid' => ({required Object p}) => 'نوع فایل نامعتبر:${p}',
			'meta.uwpExemption' => 'معافیت جداسازی شبکه UWP',
			'meta.getProfile' => 'دریافت اشتراک',
			'meta.buyProfile' => 'خرید اشتراک',
			'meta.addProfile' => 'افزودن اشتراک',
			'meta.myProfiles' => 'اشتراک‌ها',
			'meta.profileEdit' => 'ویرایش اشتراک',
			'meta.profileNeedActive' => 'ابتدا این پروفایل را به‌عنوان پروفایل فعلی تنظیم کنید، سپس اتصال را فعال/دوباره متصل کنید',
			'meta.profileDownloadBackupChannel' => 'فعال‌سازی کانال دانلود پشتیبان',
			'meta.profileDownloadBackupChannelTips' => 'کانال دانلود پراکسی ارائه‌شده توسط Wmimo (هیچ اطلاعاتی ذخیره نمی‌شود)',
			'meta.profileEditReloadAfterProfileUpdate' => 'بارگذاری مجدد پس‌از به‌روزرسانی پروفایل',
			'meta.profileRulesAppendApplePush' => 'افزودن قوانین اعلان‌های Push اپل',
			'meta.profileRulesAppendProxyTips' => 'قوانین به‌صورت خودکار روی نخستین پراکسی با نوع [url-test] یا [select] در [proxy-groups] پیکربندی اصلی تنظیم می‌شوند',
			'meta.profileImport' => 'وارد کردن فایل پیکربندی',
			'meta.profileAddUrlOrContent' => 'افزودن لینک اشتراک',
			'meta.profileUrlOrContent' => 'لینک اشتراک / محتوا',
			'meta.profileUrlOrContentHit' => 'لینک اشتراک یا محتوا [الزامی]',
			'meta.profileUrlOrContentCannotEmpty' => 'لینک اشتراک نمی‌تواند خالی باشد',
			'meta.overview' => 'نمای کلی',
			'meta.trafficStats' => 'آمار ترافیک',
			'meta.realtimeMonitor' => 'نظارت زنده',
			'meta.realtimeUpload' => 'آپلود لحظه‌ای',
			'meta.realtimeDownload' => 'دانلود لحظه‌ای',
			'meta.sessionUpload' => 'آپلود نشست',
			'meta.sessionDownload' => 'دانلود نشست',
			'meta.planUsage' => 'مصرف بسته',
			'meta.memoryUsage' => 'حافظه',
			'meta.remaining' => 'باقیمانده',
			'meta.expireTime' => 'زمان انقضا',
			'meta.tunMode' => 'حالت TUN',
			'meta.daysAgo' => ({required Object p}) => '${p} روز پیش',
			'meta.hoursAgo' => ({required Object p}) => '${p} ساعت پیش',
			'meta.lessThanOneHourAgo' => 'کمتر از ۱ ساعت پیش',
			'meta.inUse' => 'در حال استفاده',
			'meta.remoteSubscription' => 'اشتراک از راه دور',
			'meta.localProfile' => 'فایل محلی',
			'meta.viewYamlConfig' => 'مشاهده پیکربندی YAML',
			'meta.editYamlConfig' => 'ویرایش پیکربندی YAML',
			'meta.copySubscriptionUrl' => 'کپی پیوند اشتراک',
			'meta.qrCode' => 'کد QR',
			'meta.deleteProfile' => 'حذف پیکربندی',
			'meta.noProfilesYet' => 'هنوز اشتراکی وجود ندارد',
			'meta.addProfilePrompt' => 'برای افزودن لینک یا وارد کردن فایل، روی + در بالا ضربه بزنید',
			'meta.subscriptionUrlCopied' => 'پیوند اشتراک در کلیپ‌بورد کپی شد',
			'meta.autoGroupTip' => ({required Object group, required Object type}) => '«${group}» یک گروه سیاست خودکار (${type}) است. برای انتخاب دستی گره، لطفاً در گروه‌های دستی جابه‌جا شوید.',
			'meta.switchNodeFailed' => ({required Object p}) => 'تغییر گره ناموفق بود: ${p}',
			'meta.nodeSelected' => ({required Object p}) => 'گره انتخاب شده: ${p}',
			'meta.startingCoreAndTesting' => 'در حال شروع هسته و تست سرعت...',
			'meta.chartMinutes' => ({required Object p}) => '${p} دقیقه',
			'meta.chartUpload' => 'آپلود',
			'meta.chartDownload' => 'دانلود',
			'meta.author' => 'سازنده',
			'meta.githubRepo' => 'مخزن متن باز',
			'meta.openSourceLicense' => 'مجوز متن باز',
			'meta.submitFeedback' => 'ارسال بازخورد و پیشنهادات',
			'meta.copiedToClipboard' => 'در کلیپ‌بورد کپی شد',
			'meta.autoScrollEnabled' => 'پیمایش خودکار فعال است',
			'meta.autoScrollDisabled' => 'پیمایش خودکار غیرفعال است',
			'meta.pauseLogs' => 'توقف موقت لاگ‌های زنده',
			'meta.resumeLogs' => 'ادامه لاگ‌های زنده',
			'meta.scrollToLatest' => 'پیمایش به جدیدترین',
			'meta.scrollToBottom' => 'پیمایش به پایین',
			'meta.newLogsCount' => ({required Object p}) => '(${p} لاگ جدید)',
			'meta.copiedLogContent' => 'محتوای لاگ کپی شد',
			'meta.copyLog' => 'کپی لاگ',
			'meta.noLogsPrompt' => 'هنوز لاگی وجود ندارد. پس از شروع پروکسی نمایش داده می‌شود.',
			'meta.searchLogsHint' => ' (IP, دامنه, قانون, خطا...)',
			'meta.offlinePreviewPrompt' => 'حالت پیش‌نمایش آفلاین. برای مسیریابی و تست تأخیر پروکسی را فعال کنید.',
			'meta.manualSelect' => 'انتخاب دستی',
			'meta.autoSelect' => 'انتخاب خودکار',
			'meta.speedTestGroup' => 'تست سرعت گروه',
			'meta.pause' => 'توقف موقت',
			'meta.resume' => 'ادامه',
			'meta.ipInfo' => 'اطلاعات IP',
			'meta.ipFetching' => 'در حال دریافت اطلاعات IP...',
			'meta.ipCopied' => 'آدرس IP در کلیپ‌بورد کپی شد',
			_ => null,
		} ?? switch (path) {
			'meta.ipLocation' => 'مکان',
			'meta.ipIsp' => 'ارائه‌دهنده',
			'meta.ipTapToFetch' => 'برای دریافت اطلاعات IP ضربه بزنید',
			'meta.ipProxy' => 'خروجی پروکسی',
			'meta.ipDirect' => 'اتصال مستقیم محلی',
			'meta.ipAsn' => 'ASN',
			'meta.ipOrg' => 'سازمان',
			'meta.ipTimezone' => 'منطقه زمانی',
			'meta.ipCoordinates' => 'مختصات',
			'meta.ipMoreDetails' => 'جزئیات بیشتر',
			'meta.ipLessDetails' => 'بستن جزئیات',
			'meta.collapseAll' => 'بستن همه گروه‌ها',
			'meta.expandAll' => 'باز کردن همه گروه‌ها',
			'meta.donateTitle' => '💖 خرید یک قهوه برای نویسنده',
			'meta.donateThankYou' => 'ฅ^•ﻌ•^ฅ حمایت شما بزرگترین انگیزه برای بهبود مداوم Wmimo است ~ ☕✨',
			'meta.tokenCurrency' => 'ارز',
			'meta.networkChain' => 'شبکه',
			'meta.depositAddress' => 'آدرس واریز APTOS',
			'meta.clickToCopy' => 'کلیک برای کپی',
			'meta.copyAddressBtn' => 'کپی آدرس ✨',
			'meta.donateAddressCopied' => '( ੭ ˙ᗜ˙ )੭ آدرس کپی شد! از حمایت گرم شما بسیار سپاسگزاریم~ 💖',
			'meta.donateTip' => '💡 نکته: پشتیبانی از اسکن از طریق Bybit یا هر کیف پول سازگار با Aptos',
			'meta.qrcodeParsing' => 'در حال پردازش کد QR...',
			'meta.qrcodeNotFound' => 'هیچ کد QR شناسایی نشد',
			'meta.qrcodeSupportHint' => 'پشتیبانی از کدهای QR اشتراک، نود و پیکربندی',
			'meta.qrcodeCameraHint' => 'کد QR را درون کادر قرار دهید تا به طور خودکار اسکن شود',
			'meta.flashlight' => 'چراغ قوه',
			'meta.screenshotDesc' => 'تصویربرداری صفحه',
			'meta.fromImageDesc' => 'تصویر محلی',
			'meta.fromClipboardDesc' => 'خواندن از کلیپ‌بورد',
			'meta.errorPrompt' => 'خطا',
			'meta.copied' => 'کپی شد',
			'meta.sortAndFilterNodes' => 'مرتب‌سازی و فیلتر نودها',
			'meta.sortOptions' => 'گزینه‌های مرتب‌سازی',
			'meta.sortDefault' => 'پیش‌فرض',
			'meta.sortLatency' => 'کمترین تاخیر',
			'meta.sortName' => 'بر اساس نام (A-Z)',
			'meta.sortRegion' => 'بر اساس منطقه',
			'meta.filterOptions' => 'گزینه‌های فیلتر',
			'meta.portableUpdateTip' => ({required Object version}) => 'حالت پرتابل شناسایی شد:\nبه‌روزرسانی درون‌برنامه‌ای در حالت پرتابل پشتیبانی نمی‌شود. لطفاً آخرین نسخه فشرده پرتابل را دانلود و جایگزین کنید.\n\nآخرین نسخه: v${version}',
			'meta.portableModeTipTitle' => 'اعلان حالت پرتابل',
			'meta.noNodesToSpeedTest' => 'هیچ نودی برای آزمایش در دسترس نیست',
			'meta.alreadyLatestVersion' => ({required Object version}) => 'در حال حاضر آخرین نسخه است (v${version})',
			'meta.checkUpdateFailed' => 'بررسی به‌روزرسانی با خطا مواجه شد، لطفاً اتصال شبکه را بررسی کنید',
			'meta.hideTimeoutNodes' => 'پنهان کردن گره‌های ناموفق و آفلاین',
			'meta.hideTimeoutNodesDesc' => 'فیلتر خودکار گره‌های غیرقابل دسترس',
			'meta.speedtestScenario' => 'سناریوی تست سرعت فعلی',
			'meta.speedtestScenarioSwitch' => 'تغییر سناریوی تست سرعت',
			'meta.speedtestScenarioDesc' => 'انتخاب اهداف برای تست تأخیر و در دسترس بودن واقعی',
			'meta.speedtestAllNodes' => 'تست همه گره‌ها',
			'meta.retestTimeoutNodes' => 'تست مجدد گره‌های تایم‌اوت شده',
			'meta.switchedTargetScenario' => ({required Object target}) => 'تغییر سناریوی تست به: ${target}',
			'meta.notTested' => 'تست نشده',
			'meta.timeoutOrFailed' => 'تایم‌اوت / غیرقابل دسترس',
			'meta.identifiedRegion' => 'منطقه',
			'meta.nodeProtocol' => 'پروتکل',
			'meta.currentLatency' => 'تأخیر',
			'meta.testScenario' => 'سناریوی تست',
			'meta.belongsToGroup' => 'گروه',
			'meta.copyNodeName' => 'کپی نام',
			'meta.nodeNameCopied' => 'نام گره کپی شد',
			'meta.testSingleNode' => 'تست این گره',
			'meta.selectThisNode' => 'انتخاب این گره',
			'meta.allNodesNormal' => 'همه گره‌ها در دسترس هستند و نیازی به تست مجدد نیست',
			'meta.customUrlPrompt' => 'آدرس سفارشی (مانند http://...)',
			'meta.customTarget' => 'هدف سفارشی',
			'meta.downloadFailedTip' => 'دانلود بسته به‌روزرسانی ناموفق بود، لطفاً شبکه را بررسی کنید یا از وب‌سایت دانلود کنید.',
			'meta.discoveredNewVersion' => ({required Object version}) => 'نسخه جدید یافت شد: v${version}',
			'meta.preparingUpdate' => 'در حال آماده‌سازی برای به‌روزرسانی...',
			'meta.downloadingPackage' => 'در حال دانلود بسته به‌روزرسانی، لطفاً صبر کنید...',
			'meta.downloadUpdateNow' => 'اکنون به‌روزرسانی را دانلود کنید',
			'meta.downloadFromWeb' => 'دانلود از وب‌سایت',
			'meta.switchSource' => 'تغییر',
			'meta.serverSwitch' => 'سرور تست سرعت',
			'meta.autoDetectBest' => 'شناسایی خودکار بهترین سرور',
			'meta.serverSwitchDesc' => 'انتخاب CDN یا هدف سفارشی برای تست اتصال',
			'meta.autoSelectedBest' => ({required Object server, required Object ping}) => 'بهترین سرور به طور خودکار انتخاب شد: ${server} (${ping} ms)',
			'meta.networkGradeTitle' => 'امتیاز کیفیت شبکه',
			'meta.copyReport' => 'کپی گزارش',
			'meta.reportCopied' => 'گزارش در کلیپ‌بورد کپی شد، آماده برای اشتراک‌گذاری',
			'meta.gamingExperience' => 'بازی آنلاین',
			'meta.streamingExperience' => 'استریم ویدیو',
			'meta.meetingExperience' => 'ویدیو کنفرانس',
			'meta.customSpeedtestUrl' => 'آدرس سفارشی دانلود (https://...)',
			'meta.customSpeedtestSource' => 'منبع تست سفارشی',
			'meta.userSpecifiedUrl' => 'آدرس مشخص‌شده توسط کاربر',
			'meta.cannotBeEmpty' => ({required Object item}) => '${item} نمی‌تواند خالی باشد',
			'meta.alreadyExists' => ({required Object item}) => '${item} از قبل وجود دارد',
			'meta.installFailedWithCode' => ({required Object installer, required Object code}) => 'نصب ${installer} با خطا مواجه شد، کد: ${code}',
			'meta.resetSystemProxy' => 'تعمیر شبکه / بازنشانی پروکسی سیستم',
			'meta.resetSystemProxyDesc' => 'پاکسازی تنظیمات باقیمانده پروکسی سیستم و تازه‌سازی شبکه برای رفع مشکلات قطعی اینترنت',
			'meta.resetSystemProxySuccess' => 'پروکسی سیستم پاکسازی شد و شبکه به حالت عادی بازگشت',
			'meta.networkDiagnostics' => 'عیب‌یابی شبکه و خودترمیم هوشمند',
			'meta.networkDiagnosticsDesc' => 'عیب‌یابی کارت شبکه، DNS، پورت‌های هسته و وضعیت پروکسی با ترمیم با یک کلیک',
			'meta.sortLatencyDesc' => 'بیشترین تأخیر',
			'meta.sortNameDesc' => 'نام Z-A',
			'meta.sortMultiplier' => 'کمترین ضریب',
			'meta.uwpLoopback' => 'ابزار معافیت لوپ‌بک UWP',
			'meta.uwpLoopbackDesc' => 'اجازه به برنامه‌های UWP برای استفاده از پروکسی محلی',
			'meta.uwpExemptAllCommon' => 'معافیت برنامه‌های پیشنهادی',
			'meta.uwpApplySuccess' => 'قوانین معافیت لوپ‌بک UWP با موفقیت اعمال شد',
			'meta.common' => 'رایج',
			'meta.exempted' => 'معاف شده',
			'meta.notExempted' => 'معاف نشده',
			'meta.deselectAll' => 'لغو انتخاب همه',
			'meta.userApps' => 'برنامه‌های کاربر',
			'meta.systemApps' => 'برنامه‌های سیستم',
			'meta.selectedOnly' => 'انتخاب شده',
			'meta.proxySelectedMode' => 'فقط پروکسی برنامه‌های انتخاب شده',
			'meta.proxySelectedModeDesc' => 'برنامه‌های انتخاب شده از پروکسی عبور می‌کنند و بقیه مستقیم متصل می‌شوند',
			'meta.bypassSelectedMode' => 'دور زدن برنامه‌های انتخاب شده',
			'meta.bypassSelectedModeDesc' => 'برنامه‌های انتخاب شده مستقیم متصل می‌شوند و بقیه از پروکسی عبور می‌کنند',
			'meta.invertSelection' => 'معکوس کردن انتخاب',
			'meta.all' => 'همه',
			'meta.showAppIcon' => 'نمایش آیکون برنامه',
			'meta.proxySelection' => 'انتخاب پروکسی',
			'meta.regionHk' => '🇭🇰 هنگ کنگ',
			'meta.regionJp' => '🇯🇵 ژاپن',
			'meta.regionSg' => '🇸🇬 سنگاپور',
			'meta.regionTw' => '🇹🇼 تایوان',
			'meta.regionUs' => '🇺🇸 ایالات متحده',
			'meta.regionKr' => '🇰🇷 کره جنوبی',
			'meta.macMoveToApplications' => 'لطفاً قبل از اجرا، Wmimo را به پوشه Applications منتقل کنید',
			'meta.notifCurrentNode' => 'سرور فعلی',
			'meta.notifMode' => 'حالت',
			'meta.notifPort' => 'پورت',
			'meta.notifProfile' => 'اشتراک',
			'meta.notifDisconnect' => 'قطع اتصال',
			'meta.notifSwitchNode' => 'تغییر سرور',
			'meta.notifVpnConnected' => 'پروکسی VPN متصل است',
			'meta.connectionDetails' => 'جزئیات اتصال',
			'meta.sourceAddress' => 'آدرس مبدا',
			'meta.destinationAddress' => 'آدرس مقصد',
			'meta.host' => 'هاست',
			'meta.process' => 'فرآیند',
			'meta.processPath' => 'مسیر فرآیند',
			'meta.proxyChain' => 'زنجیره پروکسی',
			'meta.networkProtocol' => 'پروتکل',
			'meta.trafficUpload' => 'ترافیک آپلود',
			'meta.trafficDownload' => 'دانلود ترافیک',
			'meta.connectionDuration' => 'مدت زمان',
			'meta.connectionStart' => 'زمان شروع',
			'meta.copyHost' => 'کپی هاست',
			'meta.copyAllDetails' => 'کپی همه جزئیات',
			'meta.closeThisConnection' => 'بستن این اتصال',
			'meta.sortByDownload' => 'بر اساس دانلود',
			'meta.sortByUpload' => 'بر اساس آپلود',
			'meta.sortBySpeed' => 'بر اساس سرعت',
			'meta.sortByDuration' => 'بر اساس مدت',
			'meta.sortByHost' => 'بر اساس هاست',
			'meta.realtimeSpeed' => 'سرعت لحظه‌ای',
			'meta.totalUpload' => 'کل آپلود',
			'meta.totalDownload' => 'کل دانلود',
			'meta.activeConnections' => 'اتصال‌های فعال',
			'meta.openInFolder' => 'نمایش در پوشه',
			'meta.openProfilesDir' => 'باز کردن پوشه پروفایل‌ها',
			'meta.profilePatches' => 'بازنویسی پروفایل',
			'meta.nodeCount' => ({required Object p}) => '${p} گره',
			'meta.copyFilePath' => 'کپی مسیر فایل',
			'meta.duplicateProfile' => 'ایجاد رونوشت',
			'meta.useThisProfile' => 'استفاده از این پروفایل',
			'permission.camera' => 'دوربین',
			'permission.screen' => 'ضبط صفحه',
			'permission.appQuery' => 'Get Application List',
			'permission.request' => ({required Object p}) => 'مجوزهای [${p}] را فعال کنید',
			'permission.requestNeed' => ({required Object p}) => 'لطفاً مجوز [${p}] را فعال کنید',
			'tls.insecure' => 'رد شدن از تأیید گواهی',
			'tls.certificate' => 'گواهی',
			'tls.privateKey' => 'کلید خصوصی',
			'tls.customTrustCert' => 'گواهی های سفارشی',
			'tun.stack' => 'پشته شبکه',
			'tun.stackGvisor' => 'gVisor',
			'tun.stackGvisorDesc' => 'پشته شبکه فضای کاربر، پایداری و سازگاری بالا',
			'tun.stackSystem' => 'System',
			'tun.stackSystemDesc' => 'پشته شبکه بومی سیستم‌عامل، عملکرد بالا وابسته به سیستم',
			'tun.stackMixed' => 'Mixed',
			'tun.stackMixedDesc' => 'حالت پشته شبکه ترکیبی، تعادل میان عملکرد و سازگاری',
			'tun.stackMips' => 'MIPS (Mihomo IP Stack)',
			'tun.stackMipsDesc' => 'پشته IP با عملکرد بالا ساخته Mihomo با توان بالا و تاخیر کم',
			'tun.inet4Address' => 'محدوده آدرس IPv4',
			'tun.inet6Address' => 'محدوده آدرس IPv6',
			'tun.dnsHijack' => 'ربودن DNS',
			'tun.strictRoute' => 'مسیریابی دقیق',
			'tun.tunDefaultRoute' => 'مسیر پیش‌فرض',
			'tun.icmpForward' => 'ارسال ICMP',
			'tun.allowBypass' => 'به برنامه‌ها اجازه دهید VPN را دور بزنند',
			'tun.appendHttpProxy' => 'پیوست دادن پروکسی HTTP به وی‌پی‌ان',
			'tun.bypassHttpProxyDomain' => 'دامنه ها مجاز به دور زدن پروکسی HTTP هستند',
			'dns.listen' => 'آدرس گوش دادن',
			'dns.fakeIp' => 'fake-ip',
			'dns.fallback' => 'Fallback',
			'dns.preferH3' => 'اولویت DoH H3',
			'dns.useHosts' => 'استفاده از هاست ها',
			'dns.useSystemHosts' => 'استفاده از هاست های سیستم',
			'dns.enhancedMode' => 'حالت پیشرفته',
			'dns.fakeIPFilterMode' => 'حالت فیلتر ${_root.dns.fakeIp}',
			'dns.fakeIPFilter' => 'فیلتر ${_root.dns.fakeIp}',
			'dns.respectRules' => 'رعایت قوانین',
			'dns.nameServer' => 'سرور DNS',
			'dns.defaultNameServer' => '${_root.meta.byDefault} ${_root.dns.nameServer}',
			'dns.proxyNameServer' => '${_root.meta.proxy} ${_root.dns.nameServer}',
			'dns.directNameServer' => '${_root.meta.direct} ${_root.dns.nameServer}',
			'dns.fallbackNameServer' => '${_root.dns.fallback} ${_root.dns.nameServer}',
			'dns.fallbackGeoIp' => '${_root.dns.fallback} GeoIp',
			'dns.fallbackGeoIpCode' => '${_root.dns.fallback} GeoIpCode',
			'dns.flushCache' => 'پاک کردن حافظه پنهان DNS',
			'dns.flushCacheSuccess' => 'حافظه پنهان DNS و Fake-IP با موفقیت پاک شد',
			'dns.presets' => 'پیش‌تنظیم‌های سریع DNS',
			'dns.presetSpeed' => 'دو پشته پرسرعت',
			'dns.presetSpeedDesc' => 'AliDNS DoH3 + DNSPod DoH: اتصال داخلی فوری و مسیریابی هوشمند',
			'dns.presetSecure' => 'ضد آلودگی و حفظ حریم خصوصی',
			'dns.presetSecureDesc' => 'Cloudflare DoH3 + Google DoH: جلوگیری از سرقت و سانسور',
			'dns.presetAdGuard' => 'مسدودسازی تبلیغات با AdGuard',
			'dns.presetAdGuardDesc' => 'AdGuard DoQ + AliDNS DoH: فیلتر درخواست‌ها و حفاظت از حریم خصوصی',
			'dns.overwriteDesc' => 'بازنویسی تنظیمات DNS از پروفایل‌های اشتراک',
			'dns.enableDesc' => 'فعال‌سازی تحلیل‌کننده DNS سفارشی',
			'dns.resetFakeIpFilter' => 'بازیابی پیش‌فرض‌ها',
			'dns.resetFakeIpFilterConfirm' => 'آیا مطمئن هستید که می‌خواهید لیست فیلتر Fake-IP پیشنهادی را بازیابی کنید؟',
			'dns.dnsTester' => 'تشخیص زنده DNS',
			'dns.testQuery' => 'آزمایش',
			'dns.fakeIpDetected' => 'Fake-IP منطبق شد',
			'dns.realIpDetected' => 'IP عمومی واقعی',
			'dns.addServer' => 'افزودن سرور DNS',
			'dns.geoAssetsTitle' => 'پایگاه‌های داده آفلاین GEO',
			'dns.geoAssetsDesc' => 'مدیریت قوانین دامنه GeoSite، پایگاه‌های داده GeoIP و ASN',
			'dns.cdnSource' => 'آینه CDN دانلود',
			'dns.updateAll' => 'به‌روزرسانی همه',
			'dns.updateSuccess' => 'به‌روزرسانی با موفقیت انجام شد',
			'dns.updateFailed' => 'به‌روزرسانی ناموفق بود',
			'dns.addPresetServer' => 'افزودن DNS پیش‌فرض',
			'dns.manageFakeIpFilter' => ({required Object p}) => 'مدیریت فهرست فیلترها (${p})',
			'dns.fakeIpFilterDesc' => ({required Object p}) => '${p} قانون دامنه برای جلوگیری از مشکلات انزوای شبکه، تفکیک Fake-IP را دور می‌زنند.',
			'sniffer.overrideDest' => 'پوشش',
			'profilePatchMode.currentSelected' => 'فعلی انتخاب شده',
			'profilePatchMode.overwrite' => 'Overwrite داخلی',
			'profilePatchMode.noOverwrite' => 'داخلی - رونویسی نشده است',
			'protocolSniff' => 'تشخیص پروتکل',
			'protocolSniffOverrideDestination' => 'نام دامنه شناسایی شده آدرس هدف اتصال را پوشش می دهد',
			'edgeRuntimeNotInstalled' => 'زمان اجرا Edge WebView2 روی دستگاه فعلی نصب نشده است و صفحه قابل نمایش نیست لطفاً زمان اجرا Edge WebView2 (x64) را بارگیری و نصب کنید، برنامه را مجدداً راه اندازی کنید و دوباره امتحان کنید.',
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
