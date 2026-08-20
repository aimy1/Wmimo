; Script generated for Wmimo Windows Installer
; Supports x64 and arm64 architectures

#ifndef MyAppName
  #define MyAppName "Wmimo"
#endif

#ifndef MyAppVersion
  #define MyAppVersion "1.0.30"
#endif

#ifndef MyAppPublisher
  #define MyAppPublisher "aimy1"
#endif

#ifndef MyAppURL
  #define MyAppURL "https://github.com/aimy1/Wmimo"
#endif

#ifndef MyAppExeName
  #define MyAppExeName "wmimo.exe"
#endif

#ifndef MyAppArch
  #define MyAppArch "x64"
#endif

#ifndef SourceDir
  #define SourceDir "..\..\build\windows\x64\runner\Release"
#endif

#ifndef OutputDir
  #define OutputDir "..\..\dist"
#endif

#ifndef AppId
  #define AppId "{{5B63E2DF-84D0-4E87-93C9-9A0B83E15781}"
#endif

[Setup]
AppId={#AppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} v{#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir={#OutputDir}
OutputBaseFilename=Wmimo-Windows-{#MyAppArch}-Setup-{#MyAppVersion}
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
DisableWelcomePage=no
DisableDirPage=no
ShowLanguageDialog=yes
UsePreviousLanguage=no

#if MyAppArch == "x64"
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
#elif MyAppArch == "arm64"
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
#endif

[Languages]
Name: "chinesesimplified"; MessagesFile: "ChineseSimplified.isl"
Name: "chinesetraditional"; MessagesFile: "ChineseTraditional.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "arabic"; MessagesFile: "compiler:Languages\Arabic.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"

[CustomMessages]
chinesesimplified.AdditionalIcons=附加图标:
chinesesimplified.CreateDesktopIcon=创建桌面快捷方式(&D)
chinesesimplified.LaunchProgram=启动 %1
chinesesimplified.UninstallProgram=卸载 %1

chinesetraditional.AdditionalIcons=附加圖示:
chinesetraditional.CreateDesktopIcon=建立桌面捷徑(&D)
chinesetraditional.LaunchProgram=啟動 %1
chinesetraditional.UninstallProgram=解除安裝 %1

english.AdditionalIcons=Additional shortcuts:
english.CreateDesktopIcon=Create a &desktop shortcut
english.LaunchProgram=Launch %1
english.UninstallProgram=Uninstall %1

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "*.pdb,portable\*,*.log"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "Software\{#MyAppName}"; ValueType: string; ValueName: "LanguageTag"; ValueData: "{code:GetLanguageTag}"; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
function GetLanguageTag(Param: String): String;
begin
  case ExpandConstant('{language}') of
    'chinesesimplified': Result := 'zh-CN';
    'chinesetraditional': Result := 'zh-TW';
    'english': Result := 'en';
    'japanese': Result := 'ja';
    'korean': Result := 'ko';
    'russian': Result := 'ru';
    'spanish': Result := 'es';
    'arabic': Result := 'ar';
    'french': Result := 'fr';
    'german': Result := 'de';
    'italian': Result := 'it';
    'portuguese': Result := 'pt';
    'turkish': Result := 'tr';
    'dutch': Result := 'nl';
    'polish': Result := 'pl';
  else
    Result := 'en';
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  LangFile: String;
  LangTag: String;
begin
  if CurStep = ssPostInstall then
  begin
    LangTag := GetLanguageTag('');
    LangFile := ExpandConstant('{app}\installer_language.txt');
    SaveStringToFile(LangFile, LangTag, False);
  end;
end;

// Helper function to kill running processes before install or uninstall
procedure StopWmimoProcesses();
var
  ResultCode: Integer;
begin
  Exec('taskkill.exe', '/F /IM wmimo.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('taskkill.exe', '/F /IM wmimoService.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

function InitializeSetup(): Boolean;
begin
  StopWmimoProcesses();
  Result := True;
end;

function InitializeUninstall(): Boolean;
begin
  StopWmimoProcesses();
  Result := True;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    StopWmimoProcesses();
  end;
end;
