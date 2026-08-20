; Inno Setup Script for Wmimo
; Supports multi-architecture builds (x64 and arm64) with modern UI and multi-language support

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
#ifndef MySourceDir
  #define MySourceDir "..\..\..\build\windows\x64\runner\Release"
#endif
#ifndef MyOutputDir
  #define MyOutputDir "..\..\..\dist"
#endif
#ifndef MyOutputBaseFilename
  #define MyOutputBaseFilename "Wmimo-Windows-" + MyAppArch + "-Setup-v" + MyAppVersion
#endif
#ifndef MySetupIcon
  #define MySetupIcon "..\..\runner\resources\app_icon.ico"
#endif

[Setup]
AppId={{C67D3AE2-3BE9-4A93-8E56-2CEB8A4D62DF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
ChangesAssociations=yes
DisableProgramGroupPage=yes
OutputDir={#MyOutputDir}
OutputBaseFilename={#MyOutputBaseFilename}
SetupIconFile={#MySetupIcon}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes
CloseApplicationsFilter=wmimo.exe,wmimoService.exe
RestartApplications=no
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

#if MyAppArch == "arm64"
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
#elif MyAppArch == "x64"
ArchitecturesAllowed=x64compatible x64
ArchitecturesInstallIn64BitMode=x64compatible x64
#else
ArchitecturesInstallIn64BitMode=x64compatible x64 arm64
#endif

[Languages]
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesetraditional"; MessagesFile: "compiler:Languages\ChineseTraditional.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"

[CustomMessages]
english.CreateDesktopIcon=Create a &desktop shortcut
english.AdditionalIcons=Additional shortcuts:
english.AdditionalOptions=Additional options:
english.AutoStartProgram=Start Wmimo automatically when Windows starts
english.PreserveUserData=Do you want to preserve your user configuration and profile data?
english.UninstallTitle=Uninstall

chinesesimplified.CreateDesktopIcon=创建桌面快捷方式(&D)
chinesesimplified.AdditionalIcons=附加快捷方式:
chinesesimplified.AdditionalOptions=附加选项:
chinesesimplified.AutoStartProgram=开机自动启动 Wmimo
chinesesimplified.PreserveUserData=是否保留您的配置与用户数据？
chinesesimplified.UninstallTitle=卸载

chinesetraditional.CreateDesktopIcon=建立桌面捷徑(&D)
chinesetraditional.AdditionalIcons=附加捷徑:
chinesetraditional.AdditionalOptions=附加選項:
chinesetraditional.AutoStartProgram=開機自動啟動 Wmimo
chinesetraditional.PreserveUserData=是否保留您的設定與使用者資料？
chinesetraditional.UninstallTitle=解除安裝

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkablealone
Name: "autostart"; Description: "{cm:AutoStartProgram}"; GroupDescription: "{cm:AdditionalOptions}"; Flags: unchecked

[Files]
Source: "{#MySourceDir}\*"; DestDir: "{app}"; Excludes: "*.pdb,*.lib,*.exp,*.log"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userstartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: autostart

[UninstallDelete]
Type: filesandordirs; Name: "{app}\data"
Type: filesandordirs; Name: "{app}\portable"

[InstallDelete]
Type: filesandordirs; Name: "{app}\unins000.dat"
Type: filesandordirs; Name: "{app}\unins000.exe"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill"; Parameters: "/F /IM wmimo.exe /IM wmimoService.exe"; Flags: runhidden; RunOnceId: "KillWmimoProcesses"

[Code]
var
  PreserveUserData: Boolean;

function GetLocalAppDataPath(): string;
begin
  Result := ExpandConstant('{userappdata}\com.wmimo.app');
  if not DirExists(Result) then
    Result := ExpandConstant('{userappdata}\Wmimo');
end;

function InitializeUninstall(): Boolean;
var
  DataDir: string;
  MsgText: string;
  MsgTitle: string;
begin
  Result := True;
  DataDir := GetLocalAppDataPath();

  if DirExists(DataDir) then
  begin
    MsgTitle := '{#MyAppName} - ' + CustomMessage('UninstallTitle');
    MsgText := CustomMessage('PreserveUserData') + #13#10#13#10 + DataDir;
    
    // Default is YES (preserve data)
    PreserveUserData := MsgBox(MsgText, mbConfirmation, MB_YESNO or MB_DEFBUTTON1) = IDYES;
  end else
  begin
    PreserveUserData := True;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  DataDir: string;
  ResultCode: Integer;
begin
  if CurUninstallStep = usUninstall then
  begin
    // Terminate any running instances
    Exec('taskkill', '/F /IM wmimo.exe /IM wmimoService.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

    // Delete user appdata if requested
    if not PreserveUserData then
    begin
      DataDir := GetLocalAppDataPath();
      if DirExists(DataDir) then
      begin
        DelTree(DataDir, True, True, True);
      end;
    end;
  end;
end;
