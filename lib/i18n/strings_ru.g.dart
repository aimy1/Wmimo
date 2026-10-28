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
class TranslationsRu with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$WelcomeLanguageScreen$ru WelcomeLanguageScreen = _Translations$WelcomeLanguageScreen$ru._(_root);
	@override late final _Translations$BackupAndSyncWebdavScreen$ru BackupAndSyncWebdavScreen = _Translations$BackupAndSyncWebdavScreen$ru._(_root);
	@override late final _Translations$LaunchFailedScreen$ru LaunchFailedScreen = _Translations$LaunchFailedScreen$ru._(_root);
	@override late final _Translations$PerAppAndroidScreen$ru PerAppAndroidScreen = _Translations$PerAppAndroidScreen$ru._(_root);
	@override late final _Translations$UserAgreementScreen$ru UserAgreementScreen = _Translations$UserAgreementScreen$ru._(_root);
	@override late final _Translations$NetCheckScreen$ru NetCheckScreen = _Translations$NetCheckScreen$ru._(_root);
	@override late final _Translations$SpeedTestScreen$ru SpeedTestScreen = _Translations$SpeedTestScreen$ru._(_root);
	@override late final _Translations$VersionUpdateScreen$ru VersionUpdateScreen = _Translations$VersionUpdateScreen$ru._(_root);
	@override late final _Translations$loginScreen$ru loginScreen = _Translations$loginScreen$ru._(_root);
	@override late final _Translations$main$ru main = _Translations$main$ru._(_root);
	@override late final _Translations$meta$ru meta = _Translations$meta$ru._(_root);
	@override late final _Translations$permission$ru permission = _Translations$permission$ru._(_root);
	@override late final _Translations$tls$ru tls = _Translations$tls$ru._(_root);
	@override late final _Translations$tun$ru tun = _Translations$tun$ru._(_root);
	@override late final _Translations$dns$ru dns = _Translations$dns$ru._(_root);
	@override late final _Translations$sniffer$ru sniffer = _Translations$sniffer$ru._(_root);
	@override late final _Translations$profilePatchMode$ru profilePatchMode = _Translations$profilePatchMode$ru._(_root);
	@override String get protocolSniff => 'Определение протокола';
	@override String get protocolSniffOverrideDestination => 'Обнаруженное имя домена перезаписывает целевой адрес подключения.';
	@override String get edgeRuntimeNotInstalled => 'Среда выполнения Edge WebView2 не установлена ​​на текущем устройстве, и страница не может быть отображена. Загрузите и установите среду выполнения Edge WebView2 (x64), перезапустите приложение и повторите попытку.';
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
class _Translations$WelcomeLanguageScreen$ru implements Translations$WelcomeLanguageScreen$en {
	_Translations$WelcomeLanguageScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get welcomeTitle => 'Добро пожаловать в Wmimo';
	@override String get selectLanguage => 'Выберите язык';
	@override String get subtitle => 'Пожалуйста, выберите предпочитаемый язык. Вы можете изменить его в настройках в любое время.';
	@override String get start => 'Начать';
}

// Path: BackupAndSyncWebdavScreen
class _Translations$BackupAndSyncWebdavScreen$ru implements Translations$BackupAndSyncWebdavScreen$en {
	_Translations$BackupAndSyncWebdavScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get webdavServerUrl => 'Адрес сервера';
	@override String get webdavRequired => 'Не может быть пустым';
	@override String get webdavLoginFailed => 'Ошибка входа:';
	@override String get webdavListFailed => 'Не удалось получить список файлов:';
}

// Path: LaunchFailedScreen
class _Translations$LaunchFailedScreen$ru implements Translations$LaunchFailedScreen$en {
	_Translations$LaunchFailedScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get invalidProcess => 'Не удалось запустить приложение [Неверное имя процесса], переустановите приложение в отдельную папку';
	@override String get invalidProfile => 'Не удалось запустить приложение [Не удалось получить доступ к профилю], переустановите приложение';
	@override String get invalidVersion => 'Не удалось запустить приложение [Неверная версия], переустановите приложение';
	@override String get systemVersionLow => 'Не удалось запустить приложение [Слишком низкая версия системы]';
	@override String get invalidInstallPath => 'Путь установки недействителен, переустановите его по допустимому пути';
}

// Path: PerAppAndroidScreen
class _Translations$PerAppAndroidScreen$ru implements Translations$PerAppAndroidScreen$en {
	_Translations$PerAppAndroidScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Проксируемые приложения';
	@override String get whiteListMode => 'Режим белого списка';
	@override String get whiteListModeTip => 'Если включено: перенаправляются через прокси-сервер только те приложения, которые были отмечены. Если выключено: перенаправляются через прокси-сервер только те приложения, которые не были отмечены.';
	@override String get manualAddPackage => 'Добавить имя пакета вручную';
	@override String get manualAddPackageHint => 'Введите имена пакетов для проксирования (разделяйте пробелами, запятыми или переносом строк, напр.: org.telegram.messenger, com.google.android.youtube):';
	@override String get quickAddPresets => 'Быстрое добавление популярных приложений';
	@override String get saveSelected => 'Сохранить выбранное';
	@override String get permissionRestrictedTip => 'Система ограничила чтение списка приложений. Нажмите 【Открыть настройки разрешений】 ниже, чтобы включить доступ к списку приложений, или используйте пресеты без разрешений.';
	@override String get openSystemPermission => 'Открыть настройки разрешений';
	@override String get presetApps => 'Быстрое добавление (пресет без разрешений)';
	@override String get requestPermissionPopup => 'Запросить разрешение (системный диалог)';
}

// Path: UserAgreementScreen
class _Translations$UserAgreementScreen$ru implements Translations$UserAgreementScreen$en {
	_Translations$UserAgreementScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get privacyFirst => 'Ваша конфиденциальность превыше всего';
	@override String get agreeAndContinue => 'Принять и продолжить';
}

// Path: NetCheckScreen
class _Translations$NetCheckScreen$ru implements Translations$NetCheckScreen$en {
	_Translations$NetCheckScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Диагностика сети';
	@override String get fullDiagnosticsTab => 'Полная диагностика';
	@override String get advancedCheckTab => 'Расширенная проверка домена';
	@override String get startDiagnostics => 'Начать диагностику';
	@override String get reDiagnostics => 'Повторить';
	@override String get diagnosing => 'Диагностика сетевого контура...';
	@override String get healthScore => 'Оценка состояния';
	@override String get scorePerfect => 'Отлично';
	@override String get scoreGood => 'Хорошо';
	@override String get scoreWarning => 'Предупреждение';
	@override String get scoreCritical => 'Заблокировано';
	@override String get oneClickRepair => 'Умное автовосстановление';
	@override String get repairSuccess => 'Восстановление успешно завершено, сеть работает нормально';
	@override String get repairFailed => 'Применено, может потребоваться ручная проверка';
	@override String get repairing => 'Выполняется автовосстановление...';
	@override String issueFound({required Object count}) => 'Обнаружено проблем: ${count}';
	@override String get noIssue => 'Все проверки пройдены';
	@override String get details => 'Технические детали';
	@override String get copyDetails => 'Копировать журнал';
	@override String get detailsCopied => 'Журнал диагностики скопирован в буфер обмена';
	@override String get stepPhysical => 'Сетевой адаптер и шлюз';
	@override String get stepDns => 'DNS и механизм Fake-IP';
	@override String get stepCore => 'Процесс ядра и порты';
	@override String get stepProxy => 'Конфигурация системного прокси';
	@override String get stepHandshake => 'Сквозное рукопожатие с Интернетом';
	@override String get suggestedAction => 'Рекомендация';
	@override String get autoRepairAction => 'Исправить';
	@override String get enterDomain => 'Введите доменное имя';
	@override String get checking => 'Проверка...';
	@override String aQueryFailed({required Object p}) => 'Ошибка запроса A-записи: ${p}';
	@override String aaaaQueryFailed({required Object p}) => 'Ошибка запроса AAAA-записи: ${p}';
	@override String get success => 'Успешно';
	@override String get failed => 'Не удалось';
	@override String get suspectedPollution => 'Подозрение на DNS-спуфинг';
	@override String get domainLabel => 'Домен';
	@override String get checkButton => 'Проверить';
	@override String get dnsSection => '1. DNS-запрос';
	@override String get directHttpSection => '2. HTTP (через TUN, сначала включите TUN)';
	@override String proxyHttpSection({required Object p}) => '3. HTTP (через прокси, порт: ${p})';
	@override String get tunNotEnabled => 'TUN не включен';
	@override String get routeTableSection => '4. Таблица маршрутизации';
	@override String get stepPhysicalDesc => 'Проверка физического сетевого адаптера, локального IP и шлюза';
	@override String get stepDnsDesc => 'Проверка задержки разрешения DNS и состояния ядра DNS';
	@override String get stepCoreDesc => 'Проверка процесса Mihomo и прослушивания портов Mixed-Port/API';
	@override String get stepProxyDesc => 'Проверка настроек системного прокси и устранение остаточных сбоев';
	@override String get stepHandshakeDesc => 'Тестирование сквозной задержки и доступности глобального CDN через узел';
	@override String get shortStepPhysical => 'Адаптер';
	@override String get shortStepDns => 'DNS';
	@override String get shortStepCore => 'Ядро';
	@override String get shortStepProxy => 'Прокси';
	@override String get shortStepHandshake => 'WAN';
	@override String valNicNormal({required Object p}) => 'Сетевой адаптер подключен (${p})';
	@override String get valNicNone => 'Сетевые интерфейсы не найдены';
	@override String get valNicGatewayTimeout => 'Локальный IP получен, но шлюз не отвечает';
	@override String get valNicError => 'Ошибка проверки сетевого интерфейса';
	@override String valDnsNormal({required Object p}) => 'Ответ DNS в норме (${p})';
	@override String get valDnsEmpty => 'DNS-запрос вернул пустой список';
	@override String get valDnsTimeout => 'DNS-запрос превысил время ожидания или завершился ошибкой';
	@override String valCoreNormal({required Object port, required Object mode}) => 'Ядро работает нормально (Смешанный порт: ${port}, Режим: ${mode})';
	@override String get valCoreNotRunning => 'Служба ядра не запущена';
	@override String valCorePortConflict({required Object p}) => 'Порт ${p} занят другой программой';
	@override String get valCoreApiFailed => 'Ядро не отвечает (Сбой связи с API)';
	@override String get valCoreError => 'Ошибка проверки ядра';
	@override String valProxyActive({required Object port}) => 'Системный прокси активен (127.0.0.1:${port})';
	@override String get valProxyDisabled => 'Системный прокси отключен (Прямой/TUN/Ручной режим)';
	@override String get valProxyZombie => 'Обнаружен остаточный системный прокси (блокирует интернет)';
	@override String get valProxyFailed => 'Не удалось включить системный прокси';
	@override String get valProxyWarning => 'Предупреждение о состоянии системного прокси';
	@override String valHandshakeNormal({required Object node, required Object delay}) => 'Связь с интернетом в норме (${node} • ${delay} мс)';
	@override String valHandshakeFailed({required Object node, required Object err}) => 'Сбой связи через узел [${node}] (${err})';
	@override String get valHandshakeSkipped => 'Ядро не запущено, тест связи пропущен';
	@override String get valHandshakeError => 'Ошибка при подключении к интернету';
	@override String get issueNicDisconnected => 'Сетевой адаптер не подключен (кабель отключен, Wi-Fi выключен или режим полета)';
	@override String get suggestNicCheck => 'Проверьте кабель Ethernet, подключение к Wi-Fi или состояние сетевого адаптера';
	@override String get suggestNicReset => 'Попробуйте отключить и снова включить сетевой адаптер в настройках системы';
	@override String get issueNicGatewayUnreachable => 'Подключено к локальной сети, но внешний шлюз недоступен (портал авторизации или роутер отключен)';
	@override String get suggestNicGateway => 'Проверьте индикаторы роутера или откройте браузер для прохождения веб-авторизации';
	@override String get issueDnsPollution => 'Локальная служба DNS не отвечает; возможно загрязнение DNS или перехват шлюза';
	@override String get suggestDnsReset => 'Сбросьте системный DNS или включите умный зашифрованный DNS (DoH/DoT) в Wmimo';
	@override String get actionFlushDns => 'Сбросить кэш DNS';
	@override String get suggestDnsSlow => 'Высокая задержка DNS; рекомендуется включить зашифрованный DNS';
	@override String get issueDnsFailed => 'Сбой локального DNS; невозможно преобразовать имя домена в IP-адрес';
	@override String get suggestDnsFlush => 'Нажмите для сброса кэша DNS или включите шифрование DNS в настройках Wmimo';
	@override String get issueCorePortConflict => 'Обнаружен конфликт портов! Другая программа или служба занимает порт';
	@override String get suggestCoreChangePort => 'Полностью закройте другие прокси-клиенты или измените порт в настройках Wmimo';
	@override String get actionRestartCore => 'Перезапустить ядро';
	@override String get issueCoreStopped => 'Процесс ядра Wmimo в настоящее время остановлен';
	@override String get suggestCoreStart => 'Включите подключение на главном экране или нажмите «Запустить ядро» ниже';
	@override String get actionStartCore => 'Запустить процесс ядра';
	@override String get issueCoreFrozen => 'Процесс ядра завис или не совпадает секретный ключ API';
	@override String get suggestCoreRestart => 'Рекомендуется перезапустить ядро для восстановления службы';
	@override String get suggestCoreReinstall => 'Попробуйте перезапустить ядро или переустановить драйвер службы';
	@override String get issueProxyZombie => 'Остаточный прокси перенаправляет трафик на неактивный порт, блокируя сеть';
	@override String get suggestProxyReset => 'Нажмите «Очистить и сбросить системный прокси» ниже для восстановления доступа';
	@override String get actionResetProxy => 'Очистить и сбросить прокси';
	@override String get issueProxyBlocked => 'Системный прокси не применился, возможно заблокирован антивирусом или правами';
	@override String get suggestProxyReapply => 'Нажмите кнопку ниже, чтобы принудительно применить системный прокси';
	@override String get actionReapplyProxy => 'Повторно применить прокси';
	@override String get issueProxyRead => 'Некритическая ошибка при чтении настроек системного прокси';
	@override String get issueHandshakeBlocked => 'Текущий прокси-узел не может подключиться к интернету; связь заблокирована';
	@override String get suggestHandshakeSwitch => 'Узел недоступен или на обслуживании; переключитесь на другой узел';
	@override String suggestHandshakeSlow({required Object delay}) => 'Высокая задержка узла (${delay} мс); выберите более близкий узел';
	@override String get suggestHandshakeCheck => 'Проверьте конфигурацию узла или смените цель проверки';
	@override String get conclusionPerfect => 'Сеть в отличном состоянии! Все узлы и настройки прокси работают исправно.';
	@override String get conclusionGood => 'Сеть в норме, обнаружены незначительные задержки или предупреждения.';
	@override String get conclusionWarning => 'Обнаружены проблемы в сети или прокси; используйте «Быстрое исправление» ниже.';
	@override String get conclusionCritical => 'Серьезный сбой сети! Локальная сеть отключена или ядро заблокировано.';
}

// Path: SpeedTestScreen
class _Translations$SpeedTestScreen$ru implements Translations$SpeedTestScreen$en {
	_Translations$SpeedTestScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Тест скорости';
	@override String get startTest => 'Начать тест';
	@override String get stopTest => 'Остановить';
	@override String get reTest => 'Повторить';
	@override String get ready => 'Готово';
	@override String get testingPing => 'Проверка задержки и джиттера...';
	@override String get testingDownload => 'Тестирование загрузки...';
	@override String get testingUpload => 'Тестирование отдачи...';
	@override String get completed => 'Тест завершен';
	@override String get stopped => 'Остановлено';
	@override String get ping => 'Пинг';
	@override String get jitter => 'Джиттер';
	@override String get download => 'Скачивание';
	@override String get upload => 'Загрузка';
	@override String get currentProxy => 'Текущий прокси';
	@override String get directConnection => 'Прямое соединение';
	@override String get server => 'Сервер тестирования';
	@override String get serverLocation => 'Расположение';
	@override String get realtimeSpeed => 'График скорости';
	@override String get peakSpeed => 'Пиковая скорость';
	@override String get avgSpeed => 'Средняя скорость';
	@override String get testHistory => 'История тестов';
	@override String get clearHistory => 'Очистить историю';
}

// Path: VersionUpdateScreen
class _Translations$VersionUpdateScreen$ru implements Translations$VersionUpdateScreen$en {
	_Translations$VersionUpdateScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String versionReady({required Object p}) => 'Новая версия [${p}] доступна';
	@override String get update => 'Перезапустить';
	@override String get cancel => 'Не сейчас';
}

// Path: loginScreen
class _Translations$loginScreen$ru implements Translations$loginScreen$en {
	_Translations$loginScreen$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get login => 'Вход';
	@override String get register => 'Зарегистрировать аккаунт';
	@override String get forgotPassword => 'Забыли пароль';
	@override String get provider => 'Провайдер';
	@override String get providerName => 'Код/алиас/URL ${_root.loginScreen.provider}';
	@override String get providerNameRequired => 'Пожалуйста, введите код/алиас/URL ${_root.loginScreen.provider}';
	@override String get account => 'Аккаунт';
	@override String get accountRequired => 'Пожалуйста, введите аккаунт';
	@override String get email => 'Электронная почта';
	@override String get emailRequired => 'Пожалуйста, введите адрес электронной почты';
	@override String get password => 'Пароль';
	@override String get passwordRequired => 'Пожалуйста, введите пароль';
	@override String get validEmailRequired => 'Пожалуйста, введите действительный адрес электронной почты';
	@override String passwordMinLength({required Object minLength}) => 'Длина пароля должна быть не менее ${minLength} символов';
	@override String get unsupportedProvider => 'Неподдерживаемый ${_root.loginScreen.provider}';
	@override String get unsupportedProviderType => 'Неподдерживаемый тип ${_root.loginScreen.provider}';
	@override String get unActivedProvider => 'Функция входа не активирована';
	@override String providerLoginSupportRequired({required Object p}) => 'Запросите код/алиас провайдера у вашего ${_root.loginScreen.provider}.\nИнструкцию по интеграции с ${_root.loginScreen.provider} смотрите: ${p}';
	@override String get providerDisclaimer => 'Отказ от ответственности: ${_root.loginScreen.provider} — это сторонний сервис и не связан с этим приложением';
	@override String get createSessionFailed => 'Не удалось создать сессию, проверьте провайдера или аккаунт';
}

// Path: main
class _Translations$main$ru implements Translations$main$en {
	_Translations$main$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _Translations$main$tray$ru tray = _Translations$main$tray$ru._(_root);
}

// Path: meta
class _Translations$meta$ru implements Translations$meta$en {
	_Translations$meta$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get enable => 'Включить';
	@override String get disable => 'Запретить';
	@override String get open => 'Открыть';
	@override String get close => 'Закрыть';
	@override String get quit => 'Выйти';
	@override String get add => 'Добавить';
	@override String get addSuccess => 'Добавлено успешно';
	@override String addFailed({required Object p}) => 'Ошибка при добавлении:${p}';
	@override String get remove => 'Удалить';
	@override String get removeConfirm => 'Подтверждаете удаление?';
	@override String get edit => 'Редактировать';
	@override String get view => 'Просмотр';
	@override String get remark => 'Примечание';
	@override String get byDefault => 'по умолчанию';
	@override String get editRemark => 'Заметки об изменениях';
	@override String get more => 'Больше';
	@override String get tips => 'Инфо';
	@override String get selectAll => 'Выбрать все';
	@override String get copy => 'Скопировать';
	@override String get paste => 'Вставить';
	@override String get cut => 'Вырезать';
	@override String get save => 'Сохранить';
	@override String get ok => 'Ок';
	@override String get cancel => 'Закрыть';
	@override String get faq => 'Часто задаваемые вопросы (FAQ)';
	@override String get doc => 'документ';
	@override String get htmlTools => 'HTML Toolset';
	@override String get download => 'Скачать';
	@override String get loading => 'Загрузка...';
	@override String get days => 'дни';
	@override String get hours => 'часы';
	@override String get minutes => 'минуты';
	@override String get seconds => 'секунды';
	@override String get milliseconds => 'миллисекунды';
	@override String get protocol => 'Протокол';
	@override String get search => 'Поиск';
	@override String get custom => 'Настроить самостоятельно';
	@override String get connect => 'Соединить';
	@override String get disconnect => 'Отключить';
	@override String get connected => 'Подключено';
	@override String get disconnected => 'Отключено';
	@override String get connecting => 'Подключение';
	@override String get connectTimeout => 'Таймаут при соединении';
	@override String get timeout => 'Тайм-аут';
	@override String get timeoutDuration => 'Длительность тайм-аута';
	@override String get latency => 'Задержка';
	@override String get latencyTest => 'Тест задержки';
	@override String get networkCheck => 'Проверка сети';
	@override String get speedTest => 'Тест скорости';
	@override String get language => 'Язык';
	@override String get next => 'Дальше';
	@override String get done => 'Готово';
	@override String get apply => 'Применить';
	@override String get refresh => 'Обновить';
	@override String get retry => 'Хотите попробовать еще раз?';
	@override String get update => 'Обновить';
	@override String get updateInterval => 'Интервал обновления';
	@override String get updateInterval5mTips => 'Минимум: 5 м';
	@override String get updateIntervalPreferByProfile => 'Приоритет настроек провайдера';
	@override String updateFailed({required Object p}) => 'Не удалось обновить:${p}';
	@override String get none => 'Ничего не делать';
	@override String get reset => 'Сбросить';
	@override String get resetConfirm => 'Вы уверены, что хотите сбросить все настройки приложения?';
	@override String get resetSuccess => 'Настройки приложения сброшены по умолчанию';
	@override String get resetCoreConfirm => 'Вы уверены, что хотите сбросить настройки ядра и переопределения?';
	@override String get resetCoreSuccess => 'Настройки ядра сброшены по умолчанию';
	@override String get authentication => 'Авторизация';
	@override String get submit => 'Отправить';
	@override String get user => 'Пользователь';
	@override String get account => 'Аккаунт';
	@override String get password => 'Пароль';
	@override String get decryptPassword => 'Пароль расшифровки';
	@override String get required => 'Необходимо';
	@override String get go => 'Продолжить';
	@override String get sudoPassword => 'Пароль sudo (требуется для режима TUN)';
	@override String get other => 'Другой';
	@override String get dns => 'DNS';
	@override String get url => 'URL';
	@override String get urlInvalid => 'Неверный URL';
	@override String get urlCannotEmpty => 'Ссылка не может быть пустой';
	@override String get urlTooLong => 'URL слишком длинный (>8182)';
	@override String get copyUrl => 'Скопировать ссылку';
	@override String get openUrl => 'Открыть ссылку';
	@override String get shareUrl => 'Поделиться ссылкой';
	@override String get coreSettingTips => 'Примечание: После изменения конфигурации необходимо повторно подключиться, чтобы изменения вступили в силу.';
	@override String get overwrite => 'Переопределить';
	@override String get overwriteCustom => 'Пользовательские переопределения';
	@override String get overwriteAppend => 'Дополнительное переопределение';
	@override String get overwriteTips => 'Исходная конфигурация <- Пользовательское переопределение <- Переопределение приложения';
	@override String get noOverwrite => 'Не перезаписывать';
	@override String get overwriteSettings => 'Переопределить настройки';
	@override String get diversionTemplates => 'Шаблоны маршрутизации';
	@override String get ruleProviders => 'Наборы правил (RuleSet)';
	@override String get ruleTemplates => 'Шаблон правила';
	@override String get proxyGroupsTemplates => 'Шаблоны групп';
	@override String get proxyGroups => 'Группы прокси';
	@override String get proxyNodeList => 'Список прокси-узлов';
	@override String proxyNodeFailure({required Object p}) => 'Срок действия следующих прокси-узлов истек, и они были автоматически удалены: ${p}';
	@override String get externalController => 'Внешнее управление';
	@override String get secret => 'Пароль';
	@override String get tcpConcurrent => 'Параллельное TCP-подтверждение';
	@override String get globalClientFingerprint => 'Глобальный отпечаток пальца TLS';
	@override String get allowLanAccess => 'Доступ к локальной сети устройства';
	@override String get mixedPort => 'Порт mixed-прокси';
	@override String get logLevel => 'Уровень журнала';
	@override String get findProcessMode => 'Режим поиска процесса';
	@override String get tcpkeepAliveInterval => 'Интервал проверки активности TCP';
	@override String get delayTestUrl => 'URL-адрес теста задержки';
	@override String get delayTestTimeout => 'Время ожидания теста задержки (мс)';
	@override String get tun => 'TUN';
	@override String get ntp => 'NTP';
	@override String get tls => 'TLS';
	@override String get geo => 'GEO';
	@override String get geoDownloadByProxy => 'Загрузка гео-правил через прокси';
	@override String get geoRulesetTips => 'Geosite/Geoip будет преобразован в соответствующий RuleSet';
	@override String get asnNotSupportInIosTips => 'Из-за ограничений памяти системы iOS правила IP-ASN и SRC-IP-ASN будут игнорироваться в iOS.';
	@override String get sniffer => 'Обнаружение доменов';
	@override String get userAgent => 'UserAgent';
	@override String get launchAtStartup => 'Запуск при включении';
	@override String get launchAtStartupRunAsAdmin => 'Пожалуйста, перезапустите Wmimo от имени администратора.';
	@override String get tunModeRunAsAdmin => 'Для режима TUN требуются права администратора. Перезапустите приложение от имени администратора';
	@override String get tunSwitchToSystemProxy => 'Временно переключиться в [Режим системного прокси] для продолжения подключения?';
	@override String get tunCreateAdapterFailedAdmin => 'Не удалось создать виртуальный сетевой адаптер TUN: Access is denied.\nДля режима TUN требуются права администратора. Нажмите правой кнопкой мыши и выберите 【Запуск от имени администратора】 или отключите режим TUN на главном экране/в настройках ядра и используйте системный прокси.';
	@override String get portableMode => 'Портативный режим';
	@override String get portableModeDisableTips => 'Если вам нужно выйти из портативного режима, выйдите из [Wmimo] и вручную удалите папку [portable] в том же каталоге, что и [wmimo.exe]';
	@override String get systemProxy => 'Системный прокси';
	@override String get autoConnectAfterLaunch => 'Автоматическое подключение после запуска';
	@override String get autoConnectAtBoot => 'Автоматическое подключение после запуска системы';
	@override String get autoConnectAtBootTips => 'Требуется поддержка системы; некоторые системы также могут потребовать включения [автозапуска].';
	@override String get hideAfterLaunch => 'Скрыть окно после запуска';
	@override String get autoSetSystemProxy => 'Установить системный прокси после подключения';
	@override String get bypassSystemProxy => 'Доменные имена, которым разрешено обходить системный прокси-сервер';
	@override String get excludeFromRecent => 'Скрыть из недавних задач';
	@override String get wakeLock => 'Блокировка пробуждения';
	@override String get hideVpn => 'Скрыть значок VPN';
	@override String get hideVpnTips => 'Включение IPv6 приведет к сбою этой функции.';
	@override String get hideDockIcon => 'Скрыть значок дока';
	@override String get showTrayTraffic => 'Показывать трафик в трее';
	@override String get website => 'Веб-сайт';
	@override String get homePage => 'Главная';
	@override String get rule => 'Правила';
	@override String get global => 'Глобально';
	@override String get direct => 'Напрямую';
	@override String get block => 'Блокировать';
	@override String get qrcode => 'QR-код';
	@override String get qrcodeTooLong => 'Слишком большой текст для отображения';
	@override String get qrcodeShare => 'Поделиться QR-кодом';
	@override String get textToQrcode => 'Преобразование текста в QR-код';
	@override String get qrcodeScan => 'Сканировать QR-код';
	@override String get qrcodeScanResult => 'Результат сканирования';
	@override String get qrcodeScanFromImage => 'Открыть';
	@override String get qrcodeScanFromClipboard => 'Из буфера обмена';
	@override String get qrcodeRecognized => 'QR-код успешно распознан';
	@override String get qrcodeDropHint => 'Нажмите кнопки выше, чтобы сделать снимок экрана или выбрать изображение';
	@override String get confirmImport => 'Подтвердить импорт';
	@override String get reScan => 'Сканировать снова';
	@override String get qrcodeScanResultFailed => 'Не удалось проанализировать изображение. Убедитесь, что снимок экрана представляет собой действительный QR-код.';
	@override String get qrcodeScanResultEmpty => 'Пустой результат сканирования.';
	@override String get screenshot => 'Скриншот';
	@override String get backupAndSync => 'Резервное копирование и синхронизация';
	@override String get importSuccess => 'Импорт выполнен успешно';
	@override String get rewriteConfirm => 'Этот файл перезапишет существующую локальную профиль. Продолжить?';
	@override String get importAndExport => 'Импорт и экспорт';
	@override String get import => 'Импорт';
	@override String get importFromUrl => 'Импорт из URL';
	@override String get export => 'Экспорт';
	@override String get send => 'Передать';
	@override String get receive => 'Принять';
	@override String get sendConfirm => 'Подтверждаете передачу?';
	@override String get continueConnectConfirm => 'Продолжить подключение?';
	@override String get termOfUse => 'Условия использования';
	@override String get privacyPolicy => 'Политика конфиденциальности';
	@override String get log => 'Журнал';
	@override String get coreLog => 'Логи ядра';
	@override String get core => 'Ядро';
	@override String get help => 'Помощь';
	@override String get tutorial => 'Руководство';
	@override String get board => 'Панель';
	@override String get boardOnline => 'Использовать онлайн-панель';
	@override String get boardOnlineUrl => 'URL онлайн-панели';
	@override String get boardLocalPort => 'Порт локальной панели';
	@override String get connections => 'Соединения';
	@override String get closeAllConnections => 'Закрыть все соединения';
	@override String get searchConnections => 'Поиск соединений (Домен/IP/Правило/Процесс)';
	@override String get noFilterResults => 'Нет подходящих соединений';
	@override String get searchRules => 'Поиск правил (Тип/Пейлоад/Прокси)';
	@override String get searchProfiles => 'Поиск профилей (Имя/URL/Примечание)';
	@override String get noMatchingProfiles => 'Подходящие профили не найдены';
	@override String get rules => 'Правила маршрутизации';
	@override String get clear => 'Очистить';
	@override String get copySuccess => 'Скопировано';
	@override String get alwayOnVPN => 'VPN всегда включен';
	@override String get disableFontScaler => 'Отключить масштабирование шрифта';
	@override String get autoOrientation => 'Следовать за поворотом экрана';
	@override String get restartTakesEffect => 'Требуется перезапуск';
	@override String get reconnectTakesEffect => 'Изменения вступят в силу после повторного подключения.';
	@override String get runtimeProfile => 'Конфигурация времени выполнения';
	@override String get willCompleteAfterRebootInstall => 'Пожалуйста, перезагрузите устройство, чтобы завершить установку расширения системы.';
	@override String get willCompleteAfterRebootUninstall => 'Пожалуйста, перезагрузите устройство, чтобы завершить удаление системного расширения.';
	@override String get requestNeedsUserApproval => '1. Пожалуйста, [разрешите] Wmimo устанавливать системные расширения в [Системные настройки] - [Конфиденциальность и безопасность]. 2. : [Системные настройки] - [Основные] - [Элементы входа и расширения - Сетевые расширения] Включите [wmimoServiceSE]. После завершения подключитесь снова.';
	@override String get FullDiskAccessPermissionRequired => 'Включите разрешение wmimoServiceSE в [Системные настройки]-[Конфиденциальность и безопасность]-[Полный доступ к диску] и переподключитесь.';
	@override String get proxy => 'Прокси';
	@override String get theme => 'Тема';
	@override String get tvMode => 'Режим ТВ';
	@override String get autoUpdate => 'Автоматические обновления';
	@override String get updateChannel => 'Канал автоматического обновления';
	@override String get onlineCustomerService => 'Онлайн-служба поддержки';
	@override String get subscriptionChannel => 'Канал подписки';
	@override String hasNewVersion({required Object p}) => 'Обновить версию ${p}';
	@override String get autoDownloadPkg => 'Автоматически загружать пакеты обновлений';
	@override String get devOptions => 'Параметры разработчика';
	@override String get joinUs => 'Присоединиться к нам';
	@override String get about => 'О приложении';
	@override String get name => 'Название';
	@override String get version => 'Версия';
	@override String get notice => 'Уведомления';
	@override String get sort => 'Отсортировать';
	@override String get recommended => 'Рекомендуемые';
	@override String innerError({required Object p}) => 'Внутренняя ошибка:${p}';
	@override String get share => 'Поделиться';
	@override String get importFromClipboard => 'Импорт из буфера обмена';
	@override String get exportToClipboard => 'Экспорт в буфер обмена';
	@override String get server => 'Сервер';
	@override String get port => 'Порт';
	@override String get donate => 'Пожертвовать';
	@override String get setting => 'Настройки';
	@override String get settingCore => 'Настройки ядра';
	@override String get settingApp => 'Настройки приложения';
	@override String get coreOverwrite => 'Переопределения ядра';
	@override String get iCloud => 'iCloud';
	@override String get webdav => 'Webdav';
	@override String get lanSync => 'Синхронизация по локальной сети';
	@override String get lanSyncNotQuitTips => 'Не выходите из этого окна до завершения синхронизации.';
	@override String get deviceNoSpace => 'Недостаточно места на диске';
	@override String get hideSystemApp => 'Скрыть системные приложения';
	@override String get hideAppIcon => 'Скрыть значок приложения';
	@override String get openDir => 'Открыть каталог файлов';
	@override String get type => 'Тип';
	@override String get fileChoose => 'Выбрать файл';
	@override String get filePathCannotEmpty => 'Путь к файлу не может быть пустым';
	@override String fileNotExist({required Object p}) => 'Файла не существует:${p}';
	@override String fileTypeInvalid({required Object p}) => 'Неверный тип файла:${p}';
	@override String get uwpExemption => 'Исключение из изоляции сети UWP';
	@override String get getProfile => 'Получить подписку';
	@override String get buyProfile => 'Купить подписку';
	@override String get addProfile => 'Добавить подписку';
	@override String get myProfiles => 'Подписки';
	@override String get profileEdit => 'Редактировать подписку';
	@override String get profileNeedActive => 'Сначала сделайте этот профиль текущим, затем включите подключение/переподключитесь';
	@override String get profileDownloadBackupChannel => 'Включить резервный канал загрузки';
	@override String get profileDownloadBackupChannelTips => 'Прокси-канал загрузки, предоставляемый Wmimo (никакая информация не сохраняется)';
	@override String get profileEditReloadAfterProfileUpdate => 'Перезагрузить после обновления профиля';
	@override String get profileRulesAppendApplePush => 'Добавить правила Push-уведомлений Apple';
	@override String get profileRulesAppendProxyTips => 'Правила будут автоматически установлены на первый прокси в [proxy-groups] исходной конфигурации с типом [url-test] или [select]';
	@override String get profileImport => 'Импорт файла профиля';
	@override String get profileAddUrlOrContent => 'Добавить ссылку на подписку';
	@override String get profileUrlOrContent => 'Ссылка на подписку / Содержимое';
	@override String get profileUrlOrContentHit => 'Ссылка на подписку или конфиг [Обязательно]';
	@override String get profileUrlOrContentCannotEmpty => 'Ссылка или содержимое не могут быть пустыми';
	@override String get overview => 'Обзор';
	@override String get trafficStats => 'Статистика трафика';
	@override String get realtimeMonitor => 'Мониторинг';
	@override String get realtimeUpload => 'Текущая отдача';
	@override String get realtimeDownload => 'Текущая загрузка';
	@override String get sessionUpload => 'За сессию отдано';
	@override String get sessionDownload => 'За сессию принято';
	@override String get planUsage => 'Использование тарифа';
	@override String get memoryUsage => 'Память';
	@override String get remaining => 'Осталось';
	@override String get expireTime => 'Срок действия';
	@override String get tunMode => 'Режим TUN';
	@override String daysAgo({required Object p}) => '${p} дн. назад';
	@override String hoursAgo({required Object p}) => '${p} ч. назад';
	@override String get lessThanOneHourAgo => '< 1 часа назад';
	@override String get inUse => 'Используется';
	@override String get remoteSubscription => 'Удаленная подписка';
	@override String get noTrafficData => 'Статистика использования отсутствует';
	@override String get localProfile => 'Локальный файл';
	@override String get viewYamlConfig => 'Просмотреть YAML-конфиг';
	@override String get editYamlConfig => 'Редактировать YAML-конфиг';
	@override String get copySubscriptionUrl => 'Скопировать URL подписки';
	@override String get qrCode => 'QR-код';
	@override String get deleteProfile => 'Удалить профиль';
	@override String get noProfilesYet => 'Нет сохраненных подписок';
	@override String get addProfilePrompt => 'Нажмите + в правом верхнем углу, чтобы добавить URL или файл';
	@override String get subscriptionUrlCopied => 'URL подписки скопирован в буфер обмена';
	@override String autoGroupTip({required Object group, required Object type}) => '«${group}» — автоматическая группа (${type}), которая выбирает узлы по задержке/доступности. Для ручного выбора переключитесь в ручной группе, например «Выбор узла».';
	@override String switchNodeFailed({required Object p}) => 'Не удалось переключить узел: ${p}';
	@override String nodeSelected({required Object p}) => 'Выбран узел: ${p}';
	@override String get startingCoreAndTesting => 'Запуск ядра и проверка задержки...';
	@override String chartMinutes({required Object p}) => '${p} мин';
	@override String get chartUpload => 'Отдача';
	@override String get chartDownload => 'Загрузка';
	@override String get author => 'Автор';
	@override String get githubRepo => 'Репозиторий с открытым исходным кодом';
	@override String get openSourceLicense => 'Лицензия';
	@override String get submitFeedback => 'Обратная связь и предложения';
	@override String get copiedToClipboard => 'Скопировано в буфер обмена';
	@override String get autoScrollEnabled => 'Автопрокрутка включена';
	@override String get autoScrollDisabled => 'Автопрокрутка отключена';
	@override String get pauseLogs => 'Приостановить логи';
	@override String get resumeLogs => 'Возобновить логи';
	@override String get scrollToLatest => 'К последним логам';
	@override String get scrollToBottom => 'Прокрутить вниз';
	@override String newLogsCount({required Object p}) => '(${p} новых логов)';
	@override String get copiedLogContent => 'Содержимое лога скопировано';
	@override String get copyLog => 'Копировать лог';
	@override String get noLogsPrompt => 'Логов пока нет. Логи ядра появятся после запуска прокси.';
	@override String get searchLogsHint => ' (IP, Домен, Правило, Ошибка...)';
	@override String get offlinePreviewPrompt => 'Режим предпросмотра. Запустите прокси для маршрутизации и проверки задержки.';
	@override String get manualSelect => 'Ручной выбор';
	@override String get autoSelect => 'Автовыбор';
	@override String get speedTestGroup => 'Тест скорости группы';
	@override String get pause => 'Пауза';
	@override String get resume => 'Возобновить';
	@override String get ipInfo => 'Информация об IP';
	@override String get ipFetching => 'Получение данных IP...';
	@override String get ipCopied => 'IP-адрес скопирован в буфер обмена';
	@override String get ipLocation => 'Местоположение';
	@override String get ipIsp => 'Провайдер';
	@override String get ipTapToFetch => 'Нажмите для получения IP';
	@override String get ipProxy => 'Прокси выход';
	@override String get ipDirect => 'Прямое подключение';
	@override String get ipAsn => 'ASN';
	@override String get ipOrg => 'Организация';
	@override String get ipTimezone => 'Часовой пояс';
	@override String get ipCoordinates => 'Координаты';
	@override String get ipMoreDetails => 'Подробнее';
	@override String get ipLessDetails => 'Свернуть';
	@override String get collapseAll => 'Свернуть все группы';
	@override String get expandAll => 'Развернуть все группы';
	@override String get donateTitle => '💖 Угостить автора кофе';
	@override String get donateThankYou => 'ฅ^•ﻌ•^ฅ Ваша поддержка — главная мотивация делать Wmimo ещё лучше ~ ☕✨';
	@override String get tokenCurrency => 'Токен';
	@override String get networkChain => 'Сеть';
	@override String get depositAddress => 'Адрес для пополнения APTOS';
	@override String get clickToCopy => 'Нажмите для копирования';
	@override String get copyAddressBtn => 'Скопировать адрес ✨';
	@override String get donateAddressCopied => '( ੭ ˙ᗜ˙ )੭ Адрес скопирован! Большое спасибо за вашу поддержку~ 💖';
	@override String get donateTip => '💡 Совет: Поддерживается сканирование через Bybit или любой кошелек Aptos';
	@override String get qrcodeParsing => 'Распознавание QR-кода...';
	@override String get qrcodeNotFound => 'QR-код не обнаружен';
	@override String get qrcodeSupportHint => 'Поддерживаются QR-коды подписок, узлов и конфигураций';
	@override String get qrcodeCameraHint => 'Поместите QR-код в рамку для автоматического сканирования';
	@override String get flashlight => 'Фонарик';
	@override String get screenshotDesc => 'Снимок экрана';
	@override String get fromImageDesc => 'Файл изображения';
	@override String get fromClipboardDesc => 'Из буфера';
	@override String get errorPrompt => 'Ошибка';
	@override String get copied => 'Скопировано';
	@override String get sortAndFilterNodes => 'Сортировка и фильтрация узлов';
	@override String get sortOptions => 'Параметры сортировки';
	@override String get sortDefault => 'По умолчанию';
	@override String get sortLatency => 'По задержке';
	@override String get sortName => 'По имени (A-Z)';
	@override String get sortRegion => 'По регионам';
	@override String get filterOptions => 'Параметры фильтра';
	@override String portableUpdateTip({required Object version}) => 'Обнаружен портативный режим:\nАвтообновление внутри приложения не поддерживается в портативном режиме. Пожалуйста, скачайте свежий портативный ZIP и распакуйте с заменой.\n\nПоследняя версия: v${version}';
	@override String get portableModeTipTitle => 'Уведомление о портативном режиме';
	@override String get noNodesToSpeedTest => 'Нет доступных узлов для проверки скорости';
	@override String alreadyLatestVersion({required Object version}) => 'Уже установлена последняя версия (v${version})';
	@override String get checkUpdateFailed => 'Не удалось проверить наличие обновлений, проверьте подключение к сети';
	@override String get hideTimeoutNodes => 'Скрыть недоступные узлы';
	@override String get hideTimeoutNodesDesc => 'Автоматически скрывать недоступные узлы';
	@override String get speedtestScenario => 'Сценарий проверки скорости';
	@override String get speedtestScenarioSwitch => 'Выбор цели проверки скорости';
	@override String get speedtestScenarioDesc => 'Выберите цель для проверки реальной задержки и доступности';
	@override String get speedtestAllNodes => 'Проверить все узлы';
	@override String get retestTimeoutNodes => 'Перепроверить только недоступные';
	@override String switchedTargetScenario({required Object target}) => 'Переключено на сценарий: ${target}';
	@override String get notTested => 'Не проверялось';
	@override String get timeoutOrFailed => 'Тайм-аут / Недоступно';
	@override String get identifiedRegion => 'Регион';
	@override String get nodeProtocol => 'Протокол';
	@override String get currentLatency => 'Задержка';
	@override String get testScenario => 'Сценарий проверки';
	@override String get belongsToGroup => 'Группа';
	@override String get copyNodeName => 'Скопировать имя';
	@override String get nodeNameCopied => 'Имя узла скопировано';
	@override String get testSingleNode => 'Проверить узел';
	@override String get selectThisNode => 'Выбрать этот узел';
	@override String get allNodesNormal => 'Все узлы доступны, повторная проверка не требуется';
	@override String get customUrlPrompt => 'Пользовательский URL (напр. http://...)';
	@override String get customTarget => 'Пользовательская цель';
	@override String get downloadFailedTip => 'Не удалось загрузить пакет обновления. Проверьте сеть или скачайте с сайта.';
	@override String discoveredNewVersion({required Object version}) => 'Найдена новая версия: v${version}';
	@override String get preparingUpdate => 'Подготовка к обновлению...';
	@override String get downloadingPackage => 'Загрузка пакета обновления, пожалуйста, подождите...';
	@override String get downloadUpdateNow => 'Загрузить обновление сейчас';
	@override String get downloadFromWeb => 'Скачать с веб-сайта';
	@override String get switchSource => 'Сменить';
	@override String get serverSwitch => 'Выбор сервера скорости';
	@override String get autoDetectBest => 'Автовыбор лучшего';
	@override String get serverSwitchDesc => 'Выберите CDN или свой сервер для проверки подключения';
	@override String autoSelectedBest({required Object server, required Object ping}) => 'Автоматически выбран лучший сервер: ${server} (${ping} ms)';
	@override String get networkGradeTitle => 'Общая оценка качества сети';
	@override String get copyReport => 'Скопировать отчёт';
	@override String get reportCopied => 'Отчёт скопирован в буфер обмена';
	@override String get gamingExperience => 'Онлайн-игры';
	@override String get streamingExperience => 'Стриминг';
	@override String get meetingExperience => 'Видеоконференции';
	@override String get customSpeedtestUrl => 'Пользовательский URL загрузки (https://...)';
	@override String get customSpeedtestSource => 'Пользовательский сервер';
	@override String get userSpecifiedUrl => 'URL, указанный пользователем';
	@override String cannotBeEmpty({required Object item}) => 'Поле ${item} не может быть пустым';
	@override String alreadyExists({required Object item}) => '${item} уже существует';
	@override String installFailedWithCode({required Object installer, required Object code}) => 'Не удалось установить ${installer}, код: ${code}';
	@override String get resetSystemProxy => 'Восстановление сети / Сброс системного прокси';
	@override String get resetSystemProxyDesc => 'Очистить остаточные настройки системного прокси и восстановить сеть';
	@override String get resetSystemProxySuccess => 'Системный прокси сброшен, сеть восстановлена';
	@override String get networkDiagnostics => 'Диагностика сети и автовосстановление';
	@override String get networkDiagnosticsDesc => 'Диагностика сетевых адаптеров, DNS, портов ядра и прокси с восстановлением в один клик';
	@override String get sortLatencyDesc => 'По убыванию задержки';
	@override String get sortNameDesc => 'По имени (Z-A)';
	@override String get sortMultiplier => 'По возрастанию множителя';
	@override String get uwpLoopback => 'Утилита исключений UWP Loopback';
	@override String get uwpLoopbackDesc => 'Разрешить приложениям UWP (Microsoft Store, Xbox) использовать локальный прокси';
	@override String get uwpExemptAllCommon => 'Исключить рекомендуемые';
	@override String get uwpApplySuccess => 'Правила исключений UWP Loopback успешно применены';
	@override String get common => 'Частые';
	@override String get exempted => 'Исключено';
	@override String get notExempted => 'Не исключено';
	@override String get deselectAll => 'Снять выбор';
	@override String get userApps => 'Пользовательские';
	@override String get systemApps => 'Системные';
	@override String get selectedOnly => 'Выбрано';
	@override String get proxySelectedMode => 'Проксировать только выбранные';
	@override String get proxySelectedModeDesc => 'Выбранные приложения идут через прокси, остальные напрямую';
	@override String get bypassSelectedMode => 'Обходить выбранные приложения';
	@override String get bypassSelectedModeDesc => 'Выбранные приложения подключаются напрямую, остальные через прокси';
	@override String get invertSelection => 'Инвертировать';
	@override String get all => 'Все';
	@override String get showAppIcon => 'Показывать значки приложений';
	@override String get proxySelection => 'Выбор узла';
	@override String get regionHk => '🇭🇰 Гонконг';
	@override String get regionJp => '🇯🇵 Япония';
	@override String get regionSg => '🇸🇬 Сингапур';
	@override String get regionTw => '🇹🇼 Тайвань';
	@override String get regionUs => '🇺🇸 США';
	@override String get regionKr => '🇰🇷 Южная Корея';
	@override String get macMoveToApplications => 'Пожалуйста, переместите Wmimo в папку Программы перед запуском';
	@override String get notifCurrentNode => 'Текущий узел';
	@override String get notifMode => 'Режим';
	@override String get notifPort => 'Порт';
	@override String get notifProfile => 'Профиль';
	@override String get notifDisconnect => 'Отключить';
	@override String get notifSwitchNode => 'Сменить узел';
	@override String get notifVpnConnected => 'VPN-прокси подключен';
	@override String get connectionDetails => 'Детали соединения';
	@override String get sourceAddress => 'Исходный адрес';
	@override String get destinationAddress => 'Адрес назначения';
	@override String get host => 'Хост';
	@override String get process => 'Процесс';
	@override String get processPath => 'Путь процесса';
	@override String get proxyChain => 'Цепочка прокси';
	@override String get networkProtocol => 'Протокол';
	@override String get trafficUpload => 'Отправлено';
	@override String get trafficDownload => 'Загружено';
	@override String get connectionDuration => 'Длительность';
	@override String get connectionStart => 'Время начала';
	@override String get copyHost => 'Копировать хост';
	@override String get copyAllDetails => 'Копировать все детали';
	@override String get closeThisConnection => 'Закрыть соединение';
	@override String get sortByDownload => 'По загрузке';
	@override String get sortByUpload => 'По отдаче';
	@override String get sortBySpeed => 'По скорости';
	@override String get sortByDuration => 'По времени';
	@override String get sortByHost => 'По хосту';
	@override String get realtimeSpeed => 'Скорость';
	@override String get totalUpload => 'Всего отдача';
	@override String get totalDownload => 'Всего загрузка';
	@override String get activeConnections => 'Активные';
	@override String get openInFolder => 'Показать в папке';
	@override String get openProfilesDir => 'Открыть папку профилей';
	@override String get profilePatches => 'Переопределения профиля';
	@override String nodeCount({required Object p}) => '${p} узлов';
	@override String get copyFilePath => 'Копировать путь к файлу';
	@override String get duplicateProfile => 'Создать копию';
	@override String get useThisProfile => 'Использовать этот профиль';
	@override String get websiteTest => 'Тест сайтов';
	@override String get testAll => 'Тест всех';
	@override String get addTestWebsite => 'Добавить сайт для теста';
	@override String get websiteName => 'Название сайта';
	@override String get websiteUrl => 'URL для теста';
	@override String get websiteNameHint => 'Название сайта (напр. Cloudflare)';
	@override String get websiteInputEmpty => 'Пожалуйста, введите название сайта и URL';
	@override String get autoRefresh => 'Автообновление';
	@override String get currentProfile => 'Текущий профиль';
	@override String get quickActions => 'Быстрые инструменты';
	@override String get fastest => 'Самый быстрый';
	@override String get hideTimeout => 'Скрыть тайм-ауты';
	@override String get filteredTimeout => 'Тайм-ауты скрыты';
	@override String get tunDeviceCreateFailed => 'Не удалось создать виртуальный сетевой адаптер TUN';
	@override String get test => 'Тест';
	@override String get addWebsite => 'Добавить сайт';
	@override String get maxWebsitesReached => 'Можно добавить не более 6 тестовых сайтов';
}

// Path: permission
class _Translations$permission$ru implements Translations$permission$en {
	_Translations$permission$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get camera => 'Камера';
	@override String get screen => 'Запись экрана';
	@override String get appQuery => 'Получить список приложений';
	@override String request({required Object p}) => 'Включить разрешения [${p}]';
	@override String requestNeed({required Object p}) => 'Пожалуйста, включите разрешение [${p}]';
}

// Path: tls
class _Translations$tls$ru implements Translations$tls$en {
	_Translations$tls$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get insecure => 'Пропустить проверку сертификата';
	@override String get certificate => 'Сертификат';
	@override String get privateKey => 'Закрытый ключ';
	@override String get customTrustCert => 'Индивидуальные сертификаты';
}

// Path: tun
class _Translations$tun$ru implements Translations$tun$en {
	_Translations$tun$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get stack => 'Сетевой стек';
	@override String get stackGvisor => 'gVisor';
	@override String get stackGvisorDesc => 'Сетевой стек пользовательского пространства, отличная стабильность';
	@override String get stackSystem => 'System';
	@override String get stackSystemDesc => 'Системный сетевой стек, высокая производительность';
	@override String get stackMixed => 'Mixed';
	@override String get stackMixedDesc => 'Смешанный сетевой стек, баланс производительности и совместимости';
	@override String get stackMips => 'MIPS (Mihomo IP Stack)';
	@override String get stackMipsDesc => 'Высокопроизводительный IP-стек Mihomo, высокая пропускная способность и низкая задержка';
	@override String get inet4Address => 'Диапазон IPv4-адресов';
	@override String get inet6Address => 'Диапазон IPv6-адресов';
	@override String get dnsHijack => 'Перехват DNS';
	@override String get strictRoute => 'Строгая маршрутизация';
	@override String get tunDefaultRoute => 'Маршрут по умолчанию';
	@override String get icmpForward => 'Пересылка ICMP';
	@override String get allowBypass => 'Разрешить приложениям обходить VPN';
	@override String get appendHttpProxy => 'Подключите HTTP-прокси к VPN';
	@override String get bypassHttpProxyDomain => 'Домены, которым разрешено обходить HTTP-прокси';
}

// Path: dns
class _Translations$dns$ru implements Translations$dns$en {
	_Translations$dns$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get listen => 'Аудиторское обращение';
	@override String get fakeIp => 'fake-ip';
	@override String get fallback => 'Fallback';
	@override String get preferH3 => 'Приоритет DoH H3';
	@override String get useHosts => 'Использование хостов';
	@override String get useSystemHosts => 'Использование системных хостов';
	@override String get enhancedMode => 'Расширенный режим';
	@override String get fakeIPFilterMode => '${_root.dns.fakeIp} режим фильтра';
	@override String get fakeIPFilter => '${_root.dns.fakeIp} фильтрация';
	@override String get respectRules => 'Соблюдайте правила.';
	@override String get nameServer => 'DNS-сервер';
	@override String get defaultNameServer => '${_root.meta.byDefault} ${_root.dns.nameServer}';
	@override String get proxyNameServer => '${_root.meta.proxy} ${_root.dns.nameServer}';
	@override String get directNameServer => '${_root.meta.direct} ${_root.dns.nameServer}';
	@override String get fallbackNameServer => '${_root.dns.fallback} ${_root.dns.nameServer}';
	@override String get fallbackGeoIp => '${_root.dns.fallback} GeoIp';
	@override String get fallbackGeoIpCode => '${_root.dns.fallback} GeoIpCode';
	@override String get flushCache => 'Очистить кэш DNS';
	@override String get flushCacheSuccess => 'Кэш DNS и Fake-IP успешно очищен';
	@override String get presets => 'Быстрые пресеты DNS';
	@override String get presetSpeed => 'Высокоскоростной двухстековый';
	@override String get presetSpeedDesc => 'AliDNS DoH3 + DNSPod DoH: мгновенный внутренний доступ и умная маршрутизация';
	@override String get presetSecure => 'Защита от подмены и приватность';
	@override String get presetSecureDesc => 'Cloudflare DoH3 + Google DoH: защита от перехвата и цензуры';
	@override String get presetAdGuard => 'AdGuard Блокировка рекламы';
	@override String get presetAdGuardDesc => 'AdGuard DoQ + AliDNS DoH: глубокая фильтрация рекламы и трекеров';
	@override String get overwriteDesc => 'Переопределить настройки DNS из профиля подписки';
	@override String get enableDesc => 'Включить пользовательский DNS-резолвер';
	@override String get resetFakeIpFilter => 'Сбросить по умолчанию';
	@override String get resetFakeIpFilterConfirm => 'Восстановить рекомендуемый список фильтрации Fake-IP?';
	@override String get dnsTester => 'Диагностика запросов DNS';
	@override String get testQuery => 'Тест';
	@override String get fakeIpDetected => 'Совпадение Fake-IP';
	@override String get realIpDetected => 'Реальный публичный IP';
	@override String get addServer => 'Добавить DNS-сервер';
	@override String get geoAssetsTitle => 'Базы данных GEO';
	@override String get geoAssetsDesc => 'Управление правилами GeoSite, базами данных GeoIP и ASN';
	@override String get cdnSource => 'Зеркало CDN для загрузки';
	@override String get updateAll => 'Обновить все';
	@override String get updateSuccess => 'Обновление выполнено';
	@override String get updateFailed => 'Ошибка обновления';
	@override String get addPresetServer => 'Добавить предустановленный DNS';
	@override String manageFakeIpFilter({required Object p}) => 'Управление списком фильтров (${p})';
	@override String fakeIpFilterDesc({required Object p}) => '${p} правил доменов обходят разрешение Fake-IP во избежание проблем изоляции сети.';
}

// Path: sniffer
class _Translations$sniffer$ru implements Translations$sniffer$en {
	_Translations$sniffer$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get overrideDest => 'Переназначить';
}

// Path: profilePatchMode
class _Translations$profilePatchMode$ru implements Translations$profilePatchMode$en {
	_Translations$profilePatchMode$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get currentSelected => 'Текущий сервер';
	@override String get overwrite => 'Встроенная функция переопределения';
	@override String get noOverwrite => 'Встроенный - не перезаписывается';
}

// Path: main.tray
class _Translations$main$tray$ru implements Translations$main$tray$en {
	_Translations$main$tray$ru._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get menuOpen => 'Открыть';
	@override String get menuExit => 'Выход';
	@override String get coreDisconnected => 'Wmimo · Ядро не запущено';
	@override String get coreRunning => 'Wmimo · Ядро работает';
	@override String get startProxy => 'Запустить прокси-соединение';
	@override String get stopProxy => 'Отключить прокси';
	@override String get restartCore => 'Перезапустить ядро прокси';
	@override String get systemProxyItem => 'Системный прокси';
	@override String get tunModeItem => 'Режим TUN';
	@override String get outboundMode => 'Режим маршрутизации';
	@override String get modeRule => 'По правилам';
	@override String get modeGlobal => 'Глобальный прокси';
	@override String get modeDirect => 'Прямое подключение';
	@override String get profilesMenu => 'Подписки';
	@override String get updateAllProfiles => 'Обновить все подписки';
	@override String get proxyNodes => 'Прокси-узлы';
	@override String get tools => 'Инструменты';
	@override String get copyProxyCmd => 'Копировать команду терминала (CMD / Bash)';
	@override String get delayTestAll => 'Проверить скорость всех узлов';
	@override String get openDashboard => 'Панель управления';
	@override String get resetSystemProxy => 'Восстановление сети / Сброс системного прокси';
	@override String get copyCmdPowerShell => 'Команда PowerShell';
	@override String get copyCmdCmd => 'Команда CMD';
	@override String get copyCmdBash => 'Команда Bash/Zsh';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'WelcomeLanguageScreen.welcomeTitle' => 'Добро пожаловать в Wmimo',
			'WelcomeLanguageScreen.selectLanguage' => 'Выберите язык',
			'WelcomeLanguageScreen.subtitle' => 'Пожалуйста, выберите предпочитаемый язык. Вы можете изменить его в настройках в любое время.',
			'WelcomeLanguageScreen.start' => 'Начать',
			'BackupAndSyncWebdavScreen.webdavServerUrl' => 'Адрес сервера',
			'BackupAndSyncWebdavScreen.webdavRequired' => 'Не может быть пустым',
			'BackupAndSyncWebdavScreen.webdavLoginFailed' => 'Ошибка входа:',
			'BackupAndSyncWebdavScreen.webdavListFailed' => 'Не удалось получить список файлов:',
			'LaunchFailedScreen.invalidProcess' => 'Не удалось запустить приложение [Неверное имя процесса], переустановите приложение в отдельную папку',
			'LaunchFailedScreen.invalidProfile' => 'Не удалось запустить приложение [Не удалось получить доступ к профилю], переустановите приложение',
			'LaunchFailedScreen.invalidVersion' => 'Не удалось запустить приложение [Неверная версия], переустановите приложение',
			'LaunchFailedScreen.systemVersionLow' => 'Не удалось запустить приложение [Слишком низкая версия системы]',
			'LaunchFailedScreen.invalidInstallPath' => 'Путь установки недействителен, переустановите его по допустимому пути',
			'PerAppAndroidScreen.title' => 'Проксируемые приложения',
			'PerAppAndroidScreen.whiteListMode' => 'Режим белого списка',
			'PerAppAndroidScreen.whiteListModeTip' => 'Если включено: перенаправляются через прокси-сервер только те приложения, которые были отмечены. Если выключено: перенаправляются через прокси-сервер только те приложения, которые не были отмечены.',
			'PerAppAndroidScreen.manualAddPackage' => 'Добавить имя пакета вручную',
			'PerAppAndroidScreen.manualAddPackageHint' => 'Введите имена пакетов для проксирования (разделяйте пробелами, запятыми или переносом строк, напр.: org.telegram.messenger, com.google.android.youtube):',
			'PerAppAndroidScreen.quickAddPresets' => 'Быстрое добавление популярных приложений',
			'PerAppAndroidScreen.saveSelected' => 'Сохранить выбранное',
			'PerAppAndroidScreen.permissionRestrictedTip' => 'Система ограничила чтение списка приложений. Нажмите 【Открыть настройки разрешений】 ниже, чтобы включить доступ к списку приложений, или используйте пресеты без разрешений.',
			'PerAppAndroidScreen.openSystemPermission' => 'Открыть настройки разрешений',
			'PerAppAndroidScreen.presetApps' => 'Быстрое добавление (пресет без разрешений)',
			'PerAppAndroidScreen.requestPermissionPopup' => 'Запросить разрешение (системный диалог)',
			'UserAgreementScreen.privacyFirst' => 'Ваша конфиденциальность превыше всего',
			'UserAgreementScreen.agreeAndContinue' => 'Принять и продолжить',
			'NetCheckScreen.title' => 'Диагностика сети',
			'NetCheckScreen.fullDiagnosticsTab' => 'Полная диагностика',
			'NetCheckScreen.advancedCheckTab' => 'Расширенная проверка домена',
			'NetCheckScreen.startDiagnostics' => 'Начать диагностику',
			'NetCheckScreen.reDiagnostics' => 'Повторить',
			'NetCheckScreen.diagnosing' => 'Диагностика сетевого контура...',
			'NetCheckScreen.healthScore' => 'Оценка состояния',
			'NetCheckScreen.scorePerfect' => 'Отлично',
			'NetCheckScreen.scoreGood' => 'Хорошо',
			'NetCheckScreen.scoreWarning' => 'Предупреждение',
			'NetCheckScreen.scoreCritical' => 'Заблокировано',
			'NetCheckScreen.oneClickRepair' => 'Умное автовосстановление',
			'NetCheckScreen.repairSuccess' => 'Восстановление успешно завершено, сеть работает нормально',
			'NetCheckScreen.repairFailed' => 'Применено, может потребоваться ручная проверка',
			'NetCheckScreen.repairing' => 'Выполняется автовосстановление...',
			'NetCheckScreen.issueFound' => ({required Object count}) => 'Обнаружено проблем: ${count}',
			'NetCheckScreen.noIssue' => 'Все проверки пройдены',
			'NetCheckScreen.details' => 'Технические детали',
			'NetCheckScreen.copyDetails' => 'Копировать журнал',
			'NetCheckScreen.detailsCopied' => 'Журнал диагностики скопирован в буфер обмена',
			'NetCheckScreen.stepPhysical' => 'Сетевой адаптер и шлюз',
			'NetCheckScreen.stepDns' => 'DNS и механизм Fake-IP',
			'NetCheckScreen.stepCore' => 'Процесс ядра и порты',
			'NetCheckScreen.stepProxy' => 'Конфигурация системного прокси',
			'NetCheckScreen.stepHandshake' => 'Сквозное рукопожатие с Интернетом',
			'NetCheckScreen.suggestedAction' => 'Рекомендация',
			'NetCheckScreen.autoRepairAction' => 'Исправить',
			'NetCheckScreen.enterDomain' => 'Введите доменное имя',
			'NetCheckScreen.checking' => 'Проверка...',
			'NetCheckScreen.aQueryFailed' => ({required Object p}) => 'Ошибка запроса A-записи: ${p}',
			'NetCheckScreen.aaaaQueryFailed' => ({required Object p}) => 'Ошибка запроса AAAA-записи: ${p}',
			'NetCheckScreen.success' => 'Успешно',
			'NetCheckScreen.failed' => 'Не удалось',
			'NetCheckScreen.suspectedPollution' => 'Подозрение на DNS-спуфинг',
			'NetCheckScreen.domainLabel' => 'Домен',
			'NetCheckScreen.checkButton' => 'Проверить',
			'NetCheckScreen.dnsSection' => '1. DNS-запрос',
			'NetCheckScreen.directHttpSection' => '2. HTTP (через TUN, сначала включите TUN)',
			'NetCheckScreen.proxyHttpSection' => ({required Object p}) => '3. HTTP (через прокси, порт: ${p})',
			'NetCheckScreen.tunNotEnabled' => 'TUN не включен',
			'NetCheckScreen.routeTableSection' => '4. Таблица маршрутизации',
			'NetCheckScreen.stepPhysicalDesc' => 'Проверка физического сетевого адаптера, локального IP и шлюза',
			'NetCheckScreen.stepDnsDesc' => 'Проверка задержки разрешения DNS и состояния ядра DNS',
			'NetCheckScreen.stepCoreDesc' => 'Проверка процесса Mihomo и прослушивания портов Mixed-Port/API',
			'NetCheckScreen.stepProxyDesc' => 'Проверка настроек системного прокси и устранение остаточных сбоев',
			'NetCheckScreen.stepHandshakeDesc' => 'Тестирование сквозной задержки и доступности глобального CDN через узел',
			'NetCheckScreen.shortStepPhysical' => 'Адаптер',
			'NetCheckScreen.shortStepDns' => 'DNS',
			'NetCheckScreen.shortStepCore' => 'Ядро',
			'NetCheckScreen.shortStepProxy' => 'Прокси',
			'NetCheckScreen.shortStepHandshake' => 'WAN',
			'NetCheckScreen.valNicNormal' => ({required Object p}) => 'Сетевой адаптер подключен (${p})',
			'NetCheckScreen.valNicNone' => 'Сетевые интерфейсы не найдены',
			'NetCheckScreen.valNicGatewayTimeout' => 'Локальный IP получен, но шлюз не отвечает',
			'NetCheckScreen.valNicError' => 'Ошибка проверки сетевого интерфейса',
			'NetCheckScreen.valDnsNormal' => ({required Object p}) => 'Ответ DNS в норме (${p})',
			'NetCheckScreen.valDnsEmpty' => 'DNS-запрос вернул пустой список',
			'NetCheckScreen.valDnsTimeout' => 'DNS-запрос превысил время ожидания или завершился ошибкой',
			'NetCheckScreen.valCoreNormal' => ({required Object port, required Object mode}) => 'Ядро работает нормально (Смешанный порт: ${port}, Режим: ${mode})',
			'NetCheckScreen.valCoreNotRunning' => 'Служба ядра не запущена',
			'NetCheckScreen.valCorePortConflict' => ({required Object p}) => 'Порт ${p} занят другой программой',
			'NetCheckScreen.valCoreApiFailed' => 'Ядро не отвечает (Сбой связи с API)',
			'NetCheckScreen.valCoreError' => 'Ошибка проверки ядра',
			'NetCheckScreen.valProxyActive' => ({required Object port}) => 'Системный прокси активен (127.0.0.1:${port})',
			'NetCheckScreen.valProxyDisabled' => 'Системный прокси отключен (Прямой/TUN/Ручной режим)',
			'NetCheckScreen.valProxyZombie' => 'Обнаружен остаточный системный прокси (блокирует интернет)',
			'NetCheckScreen.valProxyFailed' => 'Не удалось включить системный прокси',
			'NetCheckScreen.valProxyWarning' => 'Предупреждение о состоянии системного прокси',
			'NetCheckScreen.valHandshakeNormal' => ({required Object node, required Object delay}) => 'Связь с интернетом в норме (${node} • ${delay} мс)',
			'NetCheckScreen.valHandshakeFailed' => ({required Object node, required Object err}) => 'Сбой связи через узел [${node}] (${err})',
			'NetCheckScreen.valHandshakeSkipped' => 'Ядро не запущено, тест связи пропущен',
			'NetCheckScreen.valHandshakeError' => 'Ошибка при подключении к интернету',
			'NetCheckScreen.issueNicDisconnected' => 'Сетевой адаптер не подключен (кабель отключен, Wi-Fi выключен или режим полета)',
			'NetCheckScreen.suggestNicCheck' => 'Проверьте кабель Ethernet, подключение к Wi-Fi или состояние сетевого адаптера',
			'NetCheckScreen.suggestNicReset' => 'Попробуйте отключить и снова включить сетевой адаптер в настройках системы',
			'NetCheckScreen.issueNicGatewayUnreachable' => 'Подключено к локальной сети, но внешний шлюз недоступен (портал авторизации или роутер отключен)',
			'NetCheckScreen.suggestNicGateway' => 'Проверьте индикаторы роутера или откройте браузер для прохождения веб-авторизации',
			'NetCheckScreen.issueDnsPollution' => 'Локальная служба DNS не отвечает; возможно загрязнение DNS или перехват шлюза',
			'NetCheckScreen.suggestDnsReset' => 'Сбросьте системный DNS или включите умный зашифрованный DNS (DoH/DoT) в Wmimo',
			'NetCheckScreen.actionFlushDns' => 'Сбросить кэш DNS',
			'NetCheckScreen.suggestDnsSlow' => 'Высокая задержка DNS; рекомендуется включить зашифрованный DNS',
			'NetCheckScreen.issueDnsFailed' => 'Сбой локального DNS; невозможно преобразовать имя домена в IP-адрес',
			'NetCheckScreen.suggestDnsFlush' => 'Нажмите для сброса кэша DNS или включите шифрование DNS в настройках Wmimo',
			'NetCheckScreen.issueCorePortConflict' => 'Обнаружен конфликт портов! Другая программа или служба занимает порт',
			'NetCheckScreen.suggestCoreChangePort' => 'Полностью закройте другие прокси-клиенты или измените порт в настройках Wmimo',
			'NetCheckScreen.actionRestartCore' => 'Перезапустить ядро',
			'NetCheckScreen.issueCoreStopped' => 'Процесс ядра Wmimo в настоящее время остановлен',
			'NetCheckScreen.suggestCoreStart' => 'Включите подключение на главном экране или нажмите «Запустить ядро» ниже',
			'NetCheckScreen.actionStartCore' => 'Запустить процесс ядра',
			'NetCheckScreen.issueCoreFrozen' => 'Процесс ядра завис или не совпадает секретный ключ API',
			'NetCheckScreen.suggestCoreRestart' => 'Рекомендуется перезапустить ядро для восстановления службы',
			'NetCheckScreen.suggestCoreReinstall' => 'Попробуйте перезапустить ядро или переустановить драйвер службы',
			'NetCheckScreen.issueProxyZombie' => 'Остаточный прокси перенаправляет трафик на неактивный порт, блокируя сеть',
			'NetCheckScreen.suggestProxyReset' => 'Нажмите «Очистить и сбросить системный прокси» ниже для восстановления доступа',
			'NetCheckScreen.actionResetProxy' => 'Очистить и сбросить прокси',
			'NetCheckScreen.issueProxyBlocked' => 'Системный прокси не применился, возможно заблокирован антивирусом или правами',
			'NetCheckScreen.suggestProxyReapply' => 'Нажмите кнопку ниже, чтобы принудительно применить системный прокси',
			'NetCheckScreen.actionReapplyProxy' => 'Повторно применить прокси',
			'NetCheckScreen.issueProxyRead' => 'Некритическая ошибка при чтении настроек системного прокси',
			'NetCheckScreen.issueHandshakeBlocked' => 'Текущий прокси-узел не может подключиться к интернету; связь заблокирована',
			'NetCheckScreen.suggestHandshakeSwitch' => 'Узел недоступен или на обслуживании; переключитесь на другой узел',
			'NetCheckScreen.suggestHandshakeSlow' => ({required Object delay}) => 'Высокая задержка узла (${delay} мс); выберите более близкий узел',
			'NetCheckScreen.suggestHandshakeCheck' => 'Проверьте конфигурацию узла или смените цель проверки',
			'NetCheckScreen.conclusionPerfect' => 'Сеть в отличном состоянии! Все узлы и настройки прокси работают исправно.',
			'NetCheckScreen.conclusionGood' => 'Сеть в норме, обнаружены незначительные задержки или предупреждения.',
			'NetCheckScreen.conclusionWarning' => 'Обнаружены проблемы в сети или прокси; используйте «Быстрое исправление» ниже.',
			'NetCheckScreen.conclusionCritical' => 'Серьезный сбой сети! Локальная сеть отключена или ядро заблокировано.',
			'SpeedTestScreen.title' => 'Тест скорости',
			'SpeedTestScreen.startTest' => 'Начать тест',
			'SpeedTestScreen.stopTest' => 'Остановить',
			'SpeedTestScreen.reTest' => 'Повторить',
			'SpeedTestScreen.ready' => 'Готово',
			'SpeedTestScreen.testingPing' => 'Проверка задержки и джиттера...',
			'SpeedTestScreen.testingDownload' => 'Тестирование загрузки...',
			'SpeedTestScreen.testingUpload' => 'Тестирование отдачи...',
			'SpeedTestScreen.completed' => 'Тест завершен',
			'SpeedTestScreen.stopped' => 'Остановлено',
			'SpeedTestScreen.ping' => 'Пинг',
			'SpeedTestScreen.jitter' => 'Джиттер',
			'SpeedTestScreen.download' => 'Скачивание',
			'SpeedTestScreen.upload' => 'Загрузка',
			'SpeedTestScreen.currentProxy' => 'Текущий прокси',
			'SpeedTestScreen.directConnection' => 'Прямое соединение',
			'SpeedTestScreen.server' => 'Сервер тестирования',
			'SpeedTestScreen.serverLocation' => 'Расположение',
			'SpeedTestScreen.realtimeSpeed' => 'График скорости',
			'SpeedTestScreen.peakSpeed' => 'Пиковая скорость',
			'SpeedTestScreen.avgSpeed' => 'Средняя скорость',
			'SpeedTestScreen.testHistory' => 'История тестов',
			'SpeedTestScreen.clearHistory' => 'Очистить историю',
			'VersionUpdateScreen.versionReady' => ({required Object p}) => 'Новая версия [${p}] доступна',
			'VersionUpdateScreen.update' => 'Перезапустить',
			'VersionUpdateScreen.cancel' => 'Не сейчас',
			'loginScreen.login' => 'Вход',
			'loginScreen.register' => 'Зарегистрировать аккаунт',
			'loginScreen.forgotPassword' => 'Забыли пароль',
			'loginScreen.provider' => 'Провайдер',
			'loginScreen.providerName' => 'Код/алиас/URL ${_root.loginScreen.provider}',
			'loginScreen.providerNameRequired' => 'Пожалуйста, введите код/алиас/URL ${_root.loginScreen.provider}',
			'loginScreen.account' => 'Аккаунт',
			'loginScreen.accountRequired' => 'Пожалуйста, введите аккаунт',
			'loginScreen.email' => 'Электронная почта',
			'loginScreen.emailRequired' => 'Пожалуйста, введите адрес электронной почты',
			'loginScreen.password' => 'Пароль',
			'loginScreen.passwordRequired' => 'Пожалуйста, введите пароль',
			'loginScreen.validEmailRequired' => 'Пожалуйста, введите действительный адрес электронной почты',
			'loginScreen.passwordMinLength' => ({required Object minLength}) => 'Длина пароля должна быть не менее ${minLength} символов',
			'loginScreen.unsupportedProvider' => 'Неподдерживаемый ${_root.loginScreen.provider}',
			'loginScreen.unsupportedProviderType' => 'Неподдерживаемый тип ${_root.loginScreen.provider}',
			'loginScreen.unActivedProvider' => 'Функция входа не активирована',
			'loginScreen.providerLoginSupportRequired' => ({required Object p}) => 'Запросите код/алиас провайдера у вашего ${_root.loginScreen.provider}.\nИнструкцию по интеграции с ${_root.loginScreen.provider} смотрите: ${p}',
			'loginScreen.providerDisclaimer' => 'Отказ от ответственности: ${_root.loginScreen.provider} — это сторонний сервис и не связан с этим приложением',
			'loginScreen.createSessionFailed' => 'Не удалось создать сессию, проверьте провайдера или аккаунт',
			'main.tray.menuOpen' => 'Открыть',
			'main.tray.menuExit' => 'Выход',
			'main.tray.coreDisconnected' => 'Wmimo · Ядро не запущено',
			'main.tray.coreRunning' => 'Wmimo · Ядро работает',
			'main.tray.startProxy' => 'Запустить прокси-соединение',
			'main.tray.stopProxy' => 'Отключить прокси',
			'main.tray.restartCore' => 'Перезапустить ядро прокси',
			'main.tray.systemProxyItem' => 'Системный прокси',
			'main.tray.tunModeItem' => 'Режим TUN',
			'main.tray.outboundMode' => 'Режим маршрутизации',
			'main.tray.modeRule' => 'По правилам',
			'main.tray.modeGlobal' => 'Глобальный прокси',
			'main.tray.modeDirect' => 'Прямое подключение',
			'main.tray.profilesMenu' => 'Подписки',
			'main.tray.updateAllProfiles' => 'Обновить все подписки',
			'main.tray.proxyNodes' => 'Прокси-узлы',
			'main.tray.tools' => 'Инструменты',
			'main.tray.copyProxyCmd' => 'Копировать команду терминала (CMD / Bash)',
			'main.tray.delayTestAll' => 'Проверить скорость всех узлов',
			'main.tray.openDashboard' => 'Панель управления',
			'main.tray.resetSystemProxy' => 'Восстановление сети / Сброс системного прокси',
			'main.tray.copyCmdPowerShell' => 'Команда PowerShell',
			'main.tray.copyCmdCmd' => 'Команда CMD',
			'main.tray.copyCmdBash' => 'Команда Bash/Zsh',
			'meta.enable' => 'Включить',
			'meta.disable' => 'Запретить',
			'meta.open' => 'Открыть',
			'meta.close' => 'Закрыть',
			'meta.quit' => 'Выйти',
			'meta.add' => 'Добавить',
			'meta.addSuccess' => 'Добавлено успешно',
			'meta.addFailed' => ({required Object p}) => 'Ошибка при добавлении:${p}',
			'meta.remove' => 'Удалить',
			'meta.removeConfirm' => 'Подтверждаете удаление?',
			'meta.edit' => 'Редактировать',
			'meta.view' => 'Просмотр',
			'meta.remark' => 'Примечание',
			'meta.byDefault' => 'по умолчанию',
			'meta.editRemark' => 'Заметки об изменениях',
			'meta.more' => 'Больше',
			'meta.tips' => 'Инфо',
			'meta.selectAll' => 'Выбрать все',
			'meta.copy' => 'Скопировать',
			'meta.paste' => 'Вставить',
			'meta.cut' => 'Вырезать',
			'meta.save' => 'Сохранить',
			'meta.ok' => 'Ок',
			'meta.cancel' => 'Закрыть',
			'meta.faq' => 'Часто задаваемые вопросы (FAQ)',
			'meta.doc' => 'документ',
			'meta.htmlTools' => 'HTML Toolset',
			'meta.download' => 'Скачать',
			'meta.loading' => 'Загрузка...',
			'meta.days' => 'дни',
			'meta.hours' => 'часы',
			'meta.minutes' => 'минуты',
			'meta.seconds' => 'секунды',
			'meta.milliseconds' => 'миллисекунды',
			'meta.protocol' => 'Протокол',
			'meta.search' => 'Поиск',
			'meta.custom' => 'Настроить самостоятельно',
			'meta.connect' => 'Соединить',
			'meta.disconnect' => 'Отключить',
			'meta.connected' => 'Подключено',
			'meta.disconnected' => 'Отключено',
			'meta.connecting' => 'Подключение',
			'meta.connectTimeout' => 'Таймаут при соединении',
			'meta.timeout' => 'Тайм-аут',
			'meta.timeoutDuration' => 'Длительность тайм-аута',
			'meta.latency' => 'Задержка',
			'meta.latencyTest' => 'Тест задержки',
			'meta.networkCheck' => 'Проверка сети',
			'meta.speedTest' => 'Тест скорости',
			'meta.language' => 'Язык',
			'meta.next' => 'Дальше',
			'meta.done' => 'Готово',
			'meta.apply' => 'Применить',
			'meta.refresh' => 'Обновить',
			'meta.retry' => 'Хотите попробовать еще раз?',
			'meta.update' => 'Обновить',
			'meta.updateInterval' => 'Интервал обновления',
			'meta.updateInterval5mTips' => 'Минимум: 5 м',
			'meta.updateIntervalPreferByProfile' => 'Приоритет настроек провайдера',
			'meta.updateFailed' => ({required Object p}) => 'Не удалось обновить:${p}',
			'meta.none' => 'Ничего не делать',
			'meta.reset' => 'Сбросить',
			'meta.resetConfirm' => 'Вы уверены, что хотите сбросить все настройки приложения?',
			'meta.resetSuccess' => 'Настройки приложения сброшены по умолчанию',
			'meta.resetCoreConfirm' => 'Вы уверены, что хотите сбросить настройки ядра и переопределения?',
			'meta.resetCoreSuccess' => 'Настройки ядра сброшены по умолчанию',
			'meta.authentication' => 'Авторизация',
			'meta.submit' => 'Отправить',
			'meta.user' => 'Пользователь',
			'meta.account' => 'Аккаунт',
			'meta.password' => 'Пароль',
			'meta.decryptPassword' => 'Пароль расшифровки',
			'meta.required' => 'Необходимо',
			'meta.go' => 'Продолжить',
			'meta.sudoPassword' => 'Пароль sudo (требуется для режима TUN)',
			'meta.other' => 'Другой',
			'meta.dns' => 'DNS',
			'meta.url' => 'URL',
			'meta.urlInvalid' => 'Неверный URL',
			'meta.urlCannotEmpty' => 'Ссылка не может быть пустой',
			'meta.urlTooLong' => 'URL слишком длинный (>8182)',
			'meta.copyUrl' => 'Скопировать ссылку',
			'meta.openUrl' => 'Открыть ссылку',
			'meta.shareUrl' => 'Поделиться ссылкой',
			'meta.coreSettingTips' => 'Примечание: После изменения конфигурации необходимо повторно подключиться, чтобы изменения вступили в силу.',
			'meta.overwrite' => 'Переопределить',
			'meta.overwriteCustom' => 'Пользовательские переопределения',
			'meta.overwriteAppend' => 'Дополнительное переопределение',
			'meta.overwriteTips' => 'Исходная конфигурация <- Пользовательское переопределение <- Переопределение приложения',
			'meta.noOverwrite' => 'Не перезаписывать',
			'meta.overwriteSettings' => 'Переопределить настройки',
			'meta.diversionTemplates' => 'Шаблоны маршрутизации',
			'meta.ruleProviders' => 'Наборы правил (RuleSet)',
			'meta.ruleTemplates' => 'Шаблон правила',
			'meta.proxyGroupsTemplates' => 'Шаблоны групп',
			'meta.proxyGroups' => 'Группы прокси',
			'meta.proxyNodeList' => 'Список прокси-узлов',
			'meta.proxyNodeFailure' => ({required Object p}) => 'Срок действия следующих прокси-узлов истек, и они были автоматически удалены: ${p}',
			'meta.externalController' => 'Внешнее управление',
			'meta.secret' => 'Пароль',
			'meta.tcpConcurrent' => 'Параллельное TCP-подтверждение',
			'meta.globalClientFingerprint' => 'Глобальный отпечаток пальца TLS',
			'meta.allowLanAccess' => 'Доступ к локальной сети устройства',
			'meta.mixedPort' => 'Порт mixed-прокси',
			'meta.logLevel' => 'Уровень журнала',
			'meta.findProcessMode' => 'Режим поиска процесса',
			'meta.tcpkeepAliveInterval' => 'Интервал проверки активности TCP',
			'meta.delayTestUrl' => 'URL-адрес теста задержки',
			'meta.delayTestTimeout' => 'Время ожидания теста задержки (мс)',
			'meta.tun' => 'TUN',
			'meta.ntp' => 'NTP',
			'meta.tls' => 'TLS',
			'meta.geo' => 'GEO',
			'meta.geoDownloadByProxy' => 'Загрузка гео-правил через прокси',
			'meta.geoRulesetTips' => 'Geosite/Geoip будет преобразован в соответствующий RuleSet',
			'meta.asnNotSupportInIosTips' => 'Из-за ограничений памяти системы iOS правила IP-ASN и SRC-IP-ASN будут игнорироваться в iOS.',
			'meta.sniffer' => 'Обнаружение доменов',
			'meta.userAgent' => 'UserAgent',
			'meta.launchAtStartup' => 'Запуск при включении',
			'meta.launchAtStartupRunAsAdmin' => 'Пожалуйста, перезапустите Wmimo от имени администратора.',
			'meta.tunModeRunAsAdmin' => 'Для режима TUN требуются права администратора. Перезапустите приложение от имени администратора',
			'meta.tunSwitchToSystemProxy' => 'Временно переключиться в [Режим системного прокси] для продолжения подключения?',
			'meta.tunCreateAdapterFailedAdmin' => 'Не удалось создать виртуальный сетевой адаптер TUN: Access is denied.\nДля режима TUN требуются права администратора. Нажмите правой кнопкой мыши и выберите 【Запуск от имени администратора】 или отключите режим TUN на главном экране/в настройках ядра и используйте системный прокси.',
			'meta.portableMode' => 'Портативный режим',
			'meta.portableModeDisableTips' => 'Если вам нужно выйти из портативного режима, выйдите из [Wmimo] и вручную удалите папку [portable] в том же каталоге, что и [wmimo.exe]',
			'meta.systemProxy' => 'Системный прокси',
			'meta.autoConnectAfterLaunch' => 'Автоматическое подключение после запуска',
			'meta.autoConnectAtBoot' => 'Автоматическое подключение после запуска системы',
			'meta.autoConnectAtBootTips' => 'Требуется поддержка системы; некоторые системы также могут потребовать включения [автозапуска].',
			'meta.hideAfterLaunch' => 'Скрыть окно после запуска',
			'meta.autoSetSystemProxy' => 'Установить системный прокси после подключения',
			'meta.bypassSystemProxy' => 'Доменные имена, которым разрешено обходить системный прокси-сервер',
			'meta.excludeFromRecent' => 'Скрыть из недавних задач',
			'meta.wakeLock' => 'Блокировка пробуждения',
			'meta.hideVpn' => 'Скрыть значок VPN',
			'meta.hideVpnTips' => 'Включение IPv6 приведет к сбою этой функции.',
			'meta.hideDockIcon' => 'Скрыть значок дока',
			'meta.showTrayTraffic' => 'Показывать трафик в трее',
			'meta.website' => 'Веб-сайт',
			'meta.homePage' => 'Главная',
			'meta.rule' => 'Правила',
			'meta.global' => 'Глобально',
			'meta.direct' => 'Напрямую',
			'meta.block' => 'Блокировать',
			'meta.qrcode' => 'QR-код',
			'meta.qrcodeTooLong' => 'Слишком большой текст для отображения',
			'meta.qrcodeShare' => 'Поделиться QR-кодом',
			'meta.textToQrcode' => 'Преобразование текста в QR-код',
			'meta.qrcodeScan' => 'Сканировать QR-код',
			'meta.qrcodeScanResult' => 'Результат сканирования',
			'meta.qrcodeScanFromImage' => 'Открыть',
			'meta.qrcodeScanFromClipboard' => 'Из буфера обмена',
			'meta.qrcodeRecognized' => 'QR-код успешно распознан',
			'meta.qrcodeDropHint' => 'Нажмите кнопки выше, чтобы сделать снимок экрана или выбрать изображение',
			'meta.confirmImport' => 'Подтвердить импорт',
			'meta.reScan' => 'Сканировать снова',
			'meta.qrcodeScanResultFailed' => 'Не удалось проанализировать изображение. Убедитесь, что снимок экрана представляет собой действительный QR-код.',
			'meta.qrcodeScanResultEmpty' => 'Пустой результат сканирования.',
			'meta.screenshot' => 'Скриншот',
			'meta.backupAndSync' => 'Резервное копирование и синхронизация',
			'meta.importSuccess' => 'Импорт выполнен успешно',
			'meta.rewriteConfirm' => 'Этот файл перезапишет существующую локальную профиль. Продолжить?',
			'meta.importAndExport' => 'Импорт и экспорт',
			'meta.import' => 'Импорт',
			'meta.importFromUrl' => 'Импорт из URL',
			'meta.export' => 'Экспорт',
			'meta.send' => 'Передать',
			'meta.receive' => 'Принять',
			'meta.sendConfirm' => 'Подтверждаете передачу?',
			'meta.continueConnectConfirm' => 'Продолжить подключение?',
			'meta.termOfUse' => 'Условия использования',
			'meta.privacyPolicy' => 'Политика конфиденциальности',
			'meta.log' => 'Журнал',
			'meta.coreLog' => 'Логи ядра',
			'meta.core' => 'Ядро',
			'meta.help' => 'Помощь',
			'meta.tutorial' => 'Руководство',
			'meta.board' => 'Панель',
			'meta.boardOnline' => 'Использовать онлайн-панель',
			'meta.boardOnlineUrl' => 'URL онлайн-панели',
			'meta.boardLocalPort' => 'Порт локальной панели',
			'meta.connections' => 'Соединения',
			'meta.closeAllConnections' => 'Закрыть все соединения',
			'meta.searchConnections' => 'Поиск соединений (Домен/IP/Правило/Процесс)',
			'meta.noFilterResults' => 'Нет подходящих соединений',
			'meta.searchRules' => 'Поиск правил (Тип/Пейлоад/Прокси)',
			'meta.searchProfiles' => 'Поиск профилей (Имя/URL/Примечание)',
			'meta.noMatchingProfiles' => 'Подходящие профили не найдены',
			'meta.rules' => 'Правила маршрутизации',
			'meta.clear' => 'Очистить',
			'meta.copySuccess' => 'Скопировано',
			'meta.alwayOnVPN' => 'VPN всегда включен',
			'meta.disableFontScaler' => 'Отключить масштабирование шрифта',
			'meta.autoOrientation' => 'Следовать за поворотом экрана',
			'meta.restartTakesEffect' => 'Требуется перезапуск',
			'meta.reconnectTakesEffect' => 'Изменения вступят в силу после повторного подключения.',
			'meta.runtimeProfile' => 'Конфигурация времени выполнения',
			'meta.willCompleteAfterRebootInstall' => 'Пожалуйста, перезагрузите устройство, чтобы завершить установку расширения системы.',
			'meta.willCompleteAfterRebootUninstall' => 'Пожалуйста, перезагрузите устройство, чтобы завершить удаление системного расширения.',
			'meta.requestNeedsUserApproval' => '1. Пожалуйста, [разрешите] Wmimo устанавливать системные расширения в [Системные настройки] - [Конфиденциальность и безопасность]. 2. : [Системные настройки] - [Основные] - [Элементы входа и расширения - Сетевые расширения] Включите [wmimoServiceSE]. После завершения подключитесь снова.',
			'meta.FullDiskAccessPermissionRequired' => 'Включите разрешение wmimoServiceSE в [Системные настройки]-[Конфиденциальность и безопасность]-[Полный доступ к диску] и переподключитесь.',
			'meta.proxy' => 'Прокси',
			'meta.theme' => 'Тема',
			'meta.tvMode' => 'Режим ТВ',
			'meta.autoUpdate' => 'Автоматические обновления',
			'meta.updateChannel' => 'Канал автоматического обновления',
			'meta.onlineCustomerService' => 'Онлайн-служба поддержки',
			'meta.subscriptionChannel' => 'Канал подписки',
			'meta.hasNewVersion' => ({required Object p}) => 'Обновить версию ${p}',
			'meta.autoDownloadPkg' => 'Автоматически загружать пакеты обновлений',
			'meta.devOptions' => 'Параметры разработчика',
			'meta.joinUs' => 'Присоединиться к нам',
			'meta.about' => 'О приложении',
			'meta.name' => 'Название',
			'meta.version' => 'Версия',
			'meta.notice' => 'Уведомления',
			'meta.sort' => 'Отсортировать',
			'meta.recommended' => 'Рекомендуемые',
			'meta.innerError' => ({required Object p}) => 'Внутренняя ошибка:${p}',
			'meta.share' => 'Поделиться',
			'meta.importFromClipboard' => 'Импорт из буфера обмена',
			'meta.exportToClipboard' => 'Экспорт в буфер обмена',
			'meta.server' => 'Сервер',
			'meta.port' => 'Порт',
			'meta.donate' => 'Пожертвовать',
			'meta.setting' => 'Настройки',
			'meta.settingCore' => 'Настройки ядра',
			'meta.settingApp' => 'Настройки приложения',
			'meta.coreOverwrite' => 'Переопределения ядра',
			'meta.iCloud' => 'iCloud',
			'meta.webdav' => 'Webdav',
			'meta.lanSync' => 'Синхронизация по локальной сети',
			'meta.lanSyncNotQuitTips' => 'Не выходите из этого окна до завершения синхронизации.',
			'meta.deviceNoSpace' => 'Недостаточно места на диске',
			'meta.hideSystemApp' => 'Скрыть системные приложения',
			'meta.hideAppIcon' => 'Скрыть значок приложения',
			'meta.openDir' => 'Открыть каталог файлов',
			'meta.type' => 'Тип',
			'meta.fileChoose' => 'Выбрать файл',
			'meta.filePathCannotEmpty' => 'Путь к файлу не может быть пустым',
			'meta.fileNotExist' => ({required Object p}) => 'Файла не существует:${p}',
			'meta.fileTypeInvalid' => ({required Object p}) => 'Неверный тип файла:${p}',
			'meta.uwpExemption' => 'Исключение из изоляции сети UWP',
			'meta.getProfile' => 'Получить подписку',
			'meta.buyProfile' => 'Купить подписку',
			'meta.addProfile' => 'Добавить подписку',
			'meta.myProfiles' => 'Подписки',
			'meta.profileEdit' => 'Редактировать подписку',
			'meta.profileNeedActive' => 'Сначала сделайте этот профиль текущим, затем включите подключение/переподключитесь',
			'meta.profileDownloadBackupChannel' => 'Включить резервный канал загрузки',
			'meta.profileDownloadBackupChannelTips' => 'Прокси-канал загрузки, предоставляемый Wmimo (никакая информация не сохраняется)',
			'meta.profileEditReloadAfterProfileUpdate' => 'Перезагрузить после обновления профиля',
			'meta.profileRulesAppendApplePush' => 'Добавить правила Push-уведомлений Apple',
			'meta.profileRulesAppendProxyTips' => 'Правила будут автоматически установлены на первый прокси в [proxy-groups] исходной конфигурации с типом [url-test] или [select]',
			'meta.profileImport' => 'Импорт файла профиля',
			'meta.profileAddUrlOrContent' => 'Добавить ссылку на подписку',
			'meta.profileUrlOrContent' => 'Ссылка на подписку / Содержимое',
			'meta.profileUrlOrContentHit' => 'Ссылка на подписку или конфиг [Обязательно]',
			'meta.profileUrlOrContentCannotEmpty' => 'Ссылка или содержимое не могут быть пустыми',
			'meta.overview' => 'Обзор',
			'meta.trafficStats' => 'Статистика трафика',
			'meta.realtimeMonitor' => 'Мониторинг',
			'meta.realtimeUpload' => 'Текущая отдача',
			'meta.realtimeDownload' => 'Текущая загрузка',
			'meta.sessionUpload' => 'За сессию отдано',
			'meta.sessionDownload' => 'За сессию принято',
			'meta.planUsage' => 'Использование тарифа',
			'meta.memoryUsage' => 'Память',
			'meta.remaining' => 'Осталось',
			'meta.expireTime' => 'Срок действия',
			'meta.tunMode' => 'Режим TUN',
			'meta.daysAgo' => ({required Object p}) => '${p} дн. назад',
			'meta.hoursAgo' => ({required Object p}) => '${p} ч. назад',
			'meta.lessThanOneHourAgo' => '< 1 часа назад',
			'meta.inUse' => 'Используется',
			'meta.remoteSubscription' => 'Удаленная подписка',
			'meta.noTrafficData' => 'Статистика использования отсутствует',
			'meta.localProfile' => 'Локальный файл',
			'meta.viewYamlConfig' => 'Просмотреть YAML-конфиг',
			'meta.editYamlConfig' => 'Редактировать YAML-конфиг',
			'meta.copySubscriptionUrl' => 'Скопировать URL подписки',
			'meta.qrCode' => 'QR-код',
			'meta.deleteProfile' => 'Удалить профиль',
			'meta.noProfilesYet' => 'Нет сохраненных подписок',
			'meta.addProfilePrompt' => 'Нажмите + в правом верхнем углу, чтобы добавить URL или файл',
			'meta.subscriptionUrlCopied' => 'URL подписки скопирован в буфер обмена',
			'meta.autoGroupTip' => ({required Object group, required Object type}) => '«${group}» — автоматическая группа (${type}), которая выбирает узлы по задержке/доступности. Для ручного выбора переключитесь в ручной группе, например «Выбор узла».',
			'meta.switchNodeFailed' => ({required Object p}) => 'Не удалось переключить узел: ${p}',
			'meta.nodeSelected' => ({required Object p}) => 'Выбран узел: ${p}',
			'meta.startingCoreAndTesting' => 'Запуск ядра и проверка задержки...',
			'meta.chartMinutes' => ({required Object p}) => '${p} мин',
			'meta.chartUpload' => 'Отдача',
			'meta.chartDownload' => 'Загрузка',
			'meta.author' => 'Автор',
			'meta.githubRepo' => 'Репозиторий с открытым исходным кодом',
			'meta.openSourceLicense' => 'Лицензия',
			'meta.submitFeedback' => 'Обратная связь и предложения',
			'meta.copiedToClipboard' => 'Скопировано в буфер обмена',
			'meta.autoScrollEnabled' => 'Автопрокрутка включена',
			'meta.autoScrollDisabled' => 'Автопрокрутка отключена',
			'meta.pauseLogs' => 'Приостановить логи',
			'meta.resumeLogs' => 'Возобновить логи',
			'meta.scrollToLatest' => 'К последним логам',
			'meta.scrollToBottom' => 'Прокрутить вниз',
			'meta.newLogsCount' => ({required Object p}) => '(${p} новых логов)',
			'meta.copiedLogContent' => 'Содержимое лога скопировано',
			'meta.copyLog' => 'Копировать лог',
			'meta.noLogsPrompt' => 'Логов пока нет. Логи ядра появятся после запуска прокси.',
			'meta.searchLogsHint' => ' (IP, Домен, Правило, Ошибка...)',
			_ => null,
		} ?? switch (path) {
			'meta.offlinePreviewPrompt' => 'Режим предпросмотра. Запустите прокси для маршрутизации и проверки задержки.',
			'meta.manualSelect' => 'Ручной выбор',
			'meta.autoSelect' => 'Автовыбор',
			'meta.speedTestGroup' => 'Тест скорости группы',
			'meta.pause' => 'Пауза',
			'meta.resume' => 'Возобновить',
			'meta.ipInfo' => 'Информация об IP',
			'meta.ipFetching' => 'Получение данных IP...',
			'meta.ipCopied' => 'IP-адрес скопирован в буфер обмена',
			'meta.ipLocation' => 'Местоположение',
			'meta.ipIsp' => 'Провайдер',
			'meta.ipTapToFetch' => 'Нажмите для получения IP',
			'meta.ipProxy' => 'Прокси выход',
			'meta.ipDirect' => 'Прямое подключение',
			'meta.ipAsn' => 'ASN',
			'meta.ipOrg' => 'Организация',
			'meta.ipTimezone' => 'Часовой пояс',
			'meta.ipCoordinates' => 'Координаты',
			'meta.ipMoreDetails' => 'Подробнее',
			'meta.ipLessDetails' => 'Свернуть',
			'meta.collapseAll' => 'Свернуть все группы',
			'meta.expandAll' => 'Развернуть все группы',
			'meta.donateTitle' => '💖 Угостить автора кофе',
			'meta.donateThankYou' => 'ฅ^•ﻌ•^ฅ Ваша поддержка — главная мотивация делать Wmimo ещё лучше ~ ☕✨',
			'meta.tokenCurrency' => 'Токен',
			'meta.networkChain' => 'Сеть',
			'meta.depositAddress' => 'Адрес для пополнения APTOS',
			'meta.clickToCopy' => 'Нажмите для копирования',
			'meta.copyAddressBtn' => 'Скопировать адрес ✨',
			'meta.donateAddressCopied' => '( ੭ ˙ᗜ˙ )੭ Адрес скопирован! Большое спасибо за вашу поддержку~ 💖',
			'meta.donateTip' => '💡 Совет: Поддерживается сканирование через Bybit или любой кошелек Aptos',
			'meta.qrcodeParsing' => 'Распознавание QR-кода...',
			'meta.qrcodeNotFound' => 'QR-код не обнаружен',
			'meta.qrcodeSupportHint' => 'Поддерживаются QR-коды подписок, узлов и конфигураций',
			'meta.qrcodeCameraHint' => 'Поместите QR-код в рамку для автоматического сканирования',
			'meta.flashlight' => 'Фонарик',
			'meta.screenshotDesc' => 'Снимок экрана',
			'meta.fromImageDesc' => 'Файл изображения',
			'meta.fromClipboardDesc' => 'Из буфера',
			'meta.errorPrompt' => 'Ошибка',
			'meta.copied' => 'Скопировано',
			'meta.sortAndFilterNodes' => 'Сортировка и фильтрация узлов',
			'meta.sortOptions' => 'Параметры сортировки',
			'meta.sortDefault' => 'По умолчанию',
			'meta.sortLatency' => 'По задержке',
			'meta.sortName' => 'По имени (A-Z)',
			'meta.sortRegion' => 'По регионам',
			'meta.filterOptions' => 'Параметры фильтра',
			'meta.portableUpdateTip' => ({required Object version}) => 'Обнаружен портативный режим:\nАвтообновление внутри приложения не поддерживается в портативном режиме. Пожалуйста, скачайте свежий портативный ZIP и распакуйте с заменой.\n\nПоследняя версия: v${version}',
			'meta.portableModeTipTitle' => 'Уведомление о портативном режиме',
			'meta.noNodesToSpeedTest' => 'Нет доступных узлов для проверки скорости',
			'meta.alreadyLatestVersion' => ({required Object version}) => 'Уже установлена последняя версия (v${version})',
			'meta.checkUpdateFailed' => 'Не удалось проверить наличие обновлений, проверьте подключение к сети',
			'meta.hideTimeoutNodes' => 'Скрыть недоступные узлы',
			'meta.hideTimeoutNodesDesc' => 'Автоматически скрывать недоступные узлы',
			'meta.speedtestScenario' => 'Сценарий проверки скорости',
			'meta.speedtestScenarioSwitch' => 'Выбор цели проверки скорости',
			'meta.speedtestScenarioDesc' => 'Выберите цель для проверки реальной задержки и доступности',
			'meta.speedtestAllNodes' => 'Проверить все узлы',
			'meta.retestTimeoutNodes' => 'Перепроверить только недоступные',
			'meta.switchedTargetScenario' => ({required Object target}) => 'Переключено на сценарий: ${target}',
			'meta.notTested' => 'Не проверялось',
			'meta.timeoutOrFailed' => 'Тайм-аут / Недоступно',
			'meta.identifiedRegion' => 'Регион',
			'meta.nodeProtocol' => 'Протокол',
			'meta.currentLatency' => 'Задержка',
			'meta.testScenario' => 'Сценарий проверки',
			'meta.belongsToGroup' => 'Группа',
			'meta.copyNodeName' => 'Скопировать имя',
			'meta.nodeNameCopied' => 'Имя узла скопировано',
			'meta.testSingleNode' => 'Проверить узел',
			'meta.selectThisNode' => 'Выбрать этот узел',
			'meta.allNodesNormal' => 'Все узлы доступны, повторная проверка не требуется',
			'meta.customUrlPrompt' => 'Пользовательский URL (напр. http://...)',
			'meta.customTarget' => 'Пользовательская цель',
			'meta.downloadFailedTip' => 'Не удалось загрузить пакет обновления. Проверьте сеть или скачайте с сайта.',
			'meta.discoveredNewVersion' => ({required Object version}) => 'Найдена новая версия: v${version}',
			'meta.preparingUpdate' => 'Подготовка к обновлению...',
			'meta.downloadingPackage' => 'Загрузка пакета обновления, пожалуйста, подождите...',
			'meta.downloadUpdateNow' => 'Загрузить обновление сейчас',
			'meta.downloadFromWeb' => 'Скачать с веб-сайта',
			'meta.switchSource' => 'Сменить',
			'meta.serverSwitch' => 'Выбор сервера скорости',
			'meta.autoDetectBest' => 'Автовыбор лучшего',
			'meta.serverSwitchDesc' => 'Выберите CDN или свой сервер для проверки подключения',
			'meta.autoSelectedBest' => ({required Object server, required Object ping}) => 'Автоматически выбран лучший сервер: ${server} (${ping} ms)',
			'meta.networkGradeTitle' => 'Общая оценка качества сети',
			'meta.copyReport' => 'Скопировать отчёт',
			'meta.reportCopied' => 'Отчёт скопирован в буфер обмена',
			'meta.gamingExperience' => 'Онлайн-игры',
			'meta.streamingExperience' => 'Стриминг',
			'meta.meetingExperience' => 'Видеоконференции',
			'meta.customSpeedtestUrl' => 'Пользовательский URL загрузки (https://...)',
			'meta.customSpeedtestSource' => 'Пользовательский сервер',
			'meta.userSpecifiedUrl' => 'URL, указанный пользователем',
			'meta.cannotBeEmpty' => ({required Object item}) => 'Поле ${item} не может быть пустым',
			'meta.alreadyExists' => ({required Object item}) => '${item} уже существует',
			'meta.installFailedWithCode' => ({required Object installer, required Object code}) => 'Не удалось установить ${installer}, код: ${code}',
			'meta.resetSystemProxy' => 'Восстановление сети / Сброс системного прокси',
			'meta.resetSystemProxyDesc' => 'Очистить остаточные настройки системного прокси и восстановить сеть',
			'meta.resetSystemProxySuccess' => 'Системный прокси сброшен, сеть восстановлена',
			'meta.networkDiagnostics' => 'Диагностика сети и автовосстановление',
			'meta.networkDiagnosticsDesc' => 'Диагностика сетевых адаптеров, DNS, портов ядра и прокси с восстановлением в один клик',
			'meta.sortLatencyDesc' => 'По убыванию задержки',
			'meta.sortNameDesc' => 'По имени (Z-A)',
			'meta.sortMultiplier' => 'По возрастанию множителя',
			'meta.uwpLoopback' => 'Утилита исключений UWP Loopback',
			'meta.uwpLoopbackDesc' => 'Разрешить приложениям UWP (Microsoft Store, Xbox) использовать локальный прокси',
			'meta.uwpExemptAllCommon' => 'Исключить рекомендуемые',
			'meta.uwpApplySuccess' => 'Правила исключений UWP Loopback успешно применены',
			'meta.common' => 'Частые',
			'meta.exempted' => 'Исключено',
			'meta.notExempted' => 'Не исключено',
			'meta.deselectAll' => 'Снять выбор',
			'meta.userApps' => 'Пользовательские',
			'meta.systemApps' => 'Системные',
			'meta.selectedOnly' => 'Выбрано',
			'meta.proxySelectedMode' => 'Проксировать только выбранные',
			'meta.proxySelectedModeDesc' => 'Выбранные приложения идут через прокси, остальные напрямую',
			'meta.bypassSelectedMode' => 'Обходить выбранные приложения',
			'meta.bypassSelectedModeDesc' => 'Выбранные приложения подключаются напрямую, остальные через прокси',
			'meta.invertSelection' => 'Инвертировать',
			'meta.all' => 'Все',
			'meta.showAppIcon' => 'Показывать значки приложений',
			'meta.proxySelection' => 'Выбор узла',
			'meta.regionHk' => '🇭🇰 Гонконг',
			'meta.regionJp' => '🇯🇵 Япония',
			'meta.regionSg' => '🇸🇬 Сингапур',
			'meta.regionTw' => '🇹🇼 Тайвань',
			'meta.regionUs' => '🇺🇸 США',
			'meta.regionKr' => '🇰🇷 Южная Корея',
			'meta.macMoveToApplications' => 'Пожалуйста, переместите Wmimo в папку Программы перед запуском',
			'meta.notifCurrentNode' => 'Текущий узел',
			'meta.notifMode' => 'Режим',
			'meta.notifPort' => 'Порт',
			'meta.notifProfile' => 'Профиль',
			'meta.notifDisconnect' => 'Отключить',
			'meta.notifSwitchNode' => 'Сменить узел',
			'meta.notifVpnConnected' => 'VPN-прокси подключен',
			'meta.connectionDetails' => 'Детали соединения',
			'meta.sourceAddress' => 'Исходный адрес',
			'meta.destinationAddress' => 'Адрес назначения',
			'meta.host' => 'Хост',
			'meta.process' => 'Процесс',
			'meta.processPath' => 'Путь процесса',
			'meta.proxyChain' => 'Цепочка прокси',
			'meta.networkProtocol' => 'Протокол',
			'meta.trafficUpload' => 'Отправлено',
			'meta.trafficDownload' => 'Загружено',
			'meta.connectionDuration' => 'Длительность',
			'meta.connectionStart' => 'Время начала',
			'meta.copyHost' => 'Копировать хост',
			'meta.copyAllDetails' => 'Копировать все детали',
			'meta.closeThisConnection' => 'Закрыть соединение',
			'meta.sortByDownload' => 'По загрузке',
			'meta.sortByUpload' => 'По отдаче',
			'meta.sortBySpeed' => 'По скорости',
			'meta.sortByDuration' => 'По времени',
			'meta.sortByHost' => 'По хосту',
			'meta.realtimeSpeed' => 'Скорость',
			'meta.totalUpload' => 'Всего отдача',
			'meta.totalDownload' => 'Всего загрузка',
			'meta.activeConnections' => 'Активные',
			'meta.openInFolder' => 'Показать в папке',
			'meta.openProfilesDir' => 'Открыть папку профилей',
			'meta.profilePatches' => 'Переопределения профиля',
			'meta.nodeCount' => ({required Object p}) => '${p} узлов',
			'meta.copyFilePath' => 'Копировать путь к файлу',
			'meta.duplicateProfile' => 'Создать копию',
			'meta.useThisProfile' => 'Использовать этот профиль',
			'meta.websiteTest' => 'Тест сайтов',
			'meta.testAll' => 'Тест всех',
			'meta.addTestWebsite' => 'Добавить сайт для теста',
			'meta.websiteName' => 'Название сайта',
			'meta.websiteUrl' => 'URL для теста',
			'meta.websiteNameHint' => 'Название сайта (напр. Cloudflare)',
			'meta.websiteInputEmpty' => 'Пожалуйста, введите название сайта и URL',
			'meta.autoRefresh' => 'Автообновление',
			'meta.currentProfile' => 'Текущий профиль',
			'meta.quickActions' => 'Быстрые инструменты',
			'meta.fastest' => 'Самый быстрый',
			'meta.hideTimeout' => 'Скрыть тайм-ауты',
			'meta.filteredTimeout' => 'Тайм-ауты скрыты',
			'meta.tunDeviceCreateFailed' => 'Не удалось создать виртуальный сетевой адаптер TUN',
			'meta.test' => 'Тест',
			'meta.addWebsite' => 'Добавить сайт',
			'meta.maxWebsitesReached' => 'Можно добавить не более 6 тестовых сайтов',
			'permission.camera' => 'Камера',
			'permission.screen' => 'Запись экрана',
			'permission.appQuery' => 'Получить список приложений',
			'permission.request' => ({required Object p}) => 'Включить разрешения [${p}]',
			'permission.requestNeed' => ({required Object p}) => 'Пожалуйста, включите разрешение [${p}]',
			'tls.insecure' => 'Пропустить проверку сертификата',
			'tls.certificate' => 'Сертификат',
			'tls.privateKey' => 'Закрытый ключ',
			'tls.customTrustCert' => 'Индивидуальные сертификаты',
			'tun.stack' => 'Сетевой стек',
			'tun.stackGvisor' => 'gVisor',
			'tun.stackGvisorDesc' => 'Сетевой стек пользовательского пространства, отличная стабильность',
			'tun.stackSystem' => 'System',
			'tun.stackSystemDesc' => 'Системный сетевой стек, высокая производительность',
			'tun.stackMixed' => 'Mixed',
			'tun.stackMixedDesc' => 'Смешанный сетевой стек, баланс производительности и совместимости',
			'tun.stackMips' => 'MIPS (Mihomo IP Stack)',
			'tun.stackMipsDesc' => 'Высокопроизводительный IP-стек Mihomo, высокая пропускная способность и низкая задержка',
			'tun.inet4Address' => 'Диапазон IPv4-адресов',
			'tun.inet6Address' => 'Диапазон IPv6-адресов',
			'tun.dnsHijack' => 'Перехват DNS',
			'tun.strictRoute' => 'Строгая маршрутизация',
			'tun.tunDefaultRoute' => 'Маршрут по умолчанию',
			'tun.icmpForward' => 'Пересылка ICMP',
			'tun.allowBypass' => 'Разрешить приложениям обходить VPN',
			'tun.appendHttpProxy' => 'Подключите HTTP-прокси к VPN',
			'tun.bypassHttpProxyDomain' => 'Домены, которым разрешено обходить HTTP-прокси',
			'dns.listen' => 'Аудиторское обращение',
			'dns.fakeIp' => 'fake-ip',
			'dns.fallback' => 'Fallback',
			'dns.preferH3' => 'Приоритет DoH H3',
			'dns.useHosts' => 'Использование хостов',
			'dns.useSystemHosts' => 'Использование системных хостов',
			'dns.enhancedMode' => 'Расширенный режим',
			'dns.fakeIPFilterMode' => '${_root.dns.fakeIp} режим фильтра',
			'dns.fakeIPFilter' => '${_root.dns.fakeIp} фильтрация',
			'dns.respectRules' => 'Соблюдайте правила.',
			'dns.nameServer' => 'DNS-сервер',
			'dns.defaultNameServer' => '${_root.meta.byDefault} ${_root.dns.nameServer}',
			'dns.proxyNameServer' => '${_root.meta.proxy} ${_root.dns.nameServer}',
			'dns.directNameServer' => '${_root.meta.direct} ${_root.dns.nameServer}',
			'dns.fallbackNameServer' => '${_root.dns.fallback} ${_root.dns.nameServer}',
			'dns.fallbackGeoIp' => '${_root.dns.fallback} GeoIp',
			'dns.fallbackGeoIpCode' => '${_root.dns.fallback} GeoIpCode',
			'dns.flushCache' => 'Очистить кэш DNS',
			'dns.flushCacheSuccess' => 'Кэш DNS и Fake-IP успешно очищен',
			'dns.presets' => 'Быстрые пресеты DNS',
			'dns.presetSpeed' => 'Высокоскоростной двухстековый',
			'dns.presetSpeedDesc' => 'AliDNS DoH3 + DNSPod DoH: мгновенный внутренний доступ и умная маршрутизация',
			'dns.presetSecure' => 'Защита от подмены и приватность',
			'dns.presetSecureDesc' => 'Cloudflare DoH3 + Google DoH: защита от перехвата и цензуры',
			'dns.presetAdGuard' => 'AdGuard Блокировка рекламы',
			'dns.presetAdGuardDesc' => 'AdGuard DoQ + AliDNS DoH: глубокая фильтрация рекламы и трекеров',
			'dns.overwriteDesc' => 'Переопределить настройки DNS из профиля подписки',
			'dns.enableDesc' => 'Включить пользовательский DNS-резолвер',
			'dns.resetFakeIpFilter' => 'Сбросить по умолчанию',
			'dns.resetFakeIpFilterConfirm' => 'Восстановить рекомендуемый список фильтрации Fake-IP?',
			'dns.dnsTester' => 'Диагностика запросов DNS',
			'dns.testQuery' => 'Тест',
			'dns.fakeIpDetected' => 'Совпадение Fake-IP',
			'dns.realIpDetected' => 'Реальный публичный IP',
			'dns.addServer' => 'Добавить DNS-сервер',
			'dns.geoAssetsTitle' => 'Базы данных GEO',
			'dns.geoAssetsDesc' => 'Управление правилами GeoSite, базами данных GeoIP и ASN',
			'dns.cdnSource' => 'Зеркало CDN для загрузки',
			'dns.updateAll' => 'Обновить все',
			'dns.updateSuccess' => 'Обновление выполнено',
			'dns.updateFailed' => 'Ошибка обновления',
			'dns.addPresetServer' => 'Добавить предустановленный DNS',
			'dns.manageFakeIpFilter' => ({required Object p}) => 'Управление списком фильтров (${p})',
			'dns.fakeIpFilterDesc' => ({required Object p}) => '${p} правил доменов обходят разрешение Fake-IP во избежание проблем изоляции сети.',
			'sniffer.overrideDest' => 'Переназначить',
			'profilePatchMode.currentSelected' => 'Текущий сервер',
			'profilePatchMode.overwrite' => 'Встроенная функция переопределения',
			'profilePatchMode.noOverwrite' => 'Встроенный - не перезаписывается',
			'protocolSniff' => 'Определение протокола',
			'protocolSniffOverrideDestination' => 'Обнаруженное имя домена перезаписывает целевой адрес подключения.',
			'edgeRuntimeNotInstalled' => 'Среда выполнения Edge WebView2 не установлена ​​на текущем устройстве, и страница не может быть отображена. Загрузите и установите среду выполнения Edge WebView2 (x64), перезапустите приложение и повторите попытку.',
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
