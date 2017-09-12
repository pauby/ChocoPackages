$packageName = 'adblockplusopera'
$url = 'https://addons.opera.com/en-gb/extensions/details/opera-adblock/?display=en-US'

if(Test-Path "${Env:ProgramFiles(x86)}\Opera\launcher.exe"){
	start "${Env:ProgramFiles(x86)}\Opera\launcher.exe" "$url"
}
if(Test-Path "${Env:ProgramFiles}\Opera\launcher.exe"){
	start "${Env:ProgramFiles}\Opera\launcher.exe" "$url"
}
if(Test-Path "${Env:ProgramFiles}\Opera\opera.exe"){
	start "${Env:ProgramFiles}\Opera\opera.exe" "$url"
}
if(Test-Path "${Env:ProgramFiles(x86)}\Opera\opera.exe"){
	start "${Env:ProgramFiles(x86)}\Opera\opera.exe" "$url"
}