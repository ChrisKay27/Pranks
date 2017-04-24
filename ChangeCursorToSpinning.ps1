# Change the registry to use the busy cursor

$RegConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser","$env:COMPUTERNAME")
$RegCursors = $RegConnect.OpenSubKey("Control Panel\Cursors",$true)
$RegCursors.SetValue("Arrow","C:\Windows\cursors\aero_busy.ani")
$RegCursors.Close()
$RegConnect.Close()


# Now refresh the cursor using some windows API call

$CSharpSig = @'

[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]

public static extern bool SystemParametersInfo(

                 uint uiAction,

                 uint uiParam,

                 uint pvParam,

                 uint fWinIni);

'@

$CursorRefresh = Add-Type -MemberDefinition $CSharpSig -Name WinAPICall -Namespace SystemParamInfo -PassThru

$CursorRefresh::SystemParametersInfo(0x0057,0,$null,0)
