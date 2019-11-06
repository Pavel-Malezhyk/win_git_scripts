function GetAndInstall([System.String] $ParseUrl,
                        [System.String] $LinkStringRegExp,
                        [System.String] $LinkRegExp,
                        [System.String] $OutFileName, 
                        [System.String] $FirstDownloadLinkPart,
                        [System.String] $InstallParameters) {
    if ([System.String]::IsNullOrEmpty($FirstDownloadLinkPart) )
    {
        $FirstDownloadLinkPart = ""
    }
    if ([System.String]::IsNullOrEmpty($InstallParameters) )
    {
        $InstallParameters = ""
    }

    Write-Host "Getting last version link, invoking ... "$ParseUrl
    $GitLinks = $(Invoke-WebRequest -Uri ([System.UriBuilder]($ParseUrl)).Uri ).Content -split "`n"
    $HtmlGitLink = ($GitLinks| Select-String -Pattern $LinkStringRegExp | Select-Object -first 1)
    Write-Host "Html linklink is ... "$HtmlGitLink
    $LastVersionUrl = [regex]::match($HtmlGitLink,$LinkRegExp).Groups[2].Value
    Write-Host "Last version link is ... "$FirstDownloadLinkPart$LastVersionUrl
    Write-Host "Downloading ... "
    Invoke-WebRequest $FirstDownloadLinkPart$LastVersionUrl -outFile $OutFileName
    Write-Host "Installing ... "
    Invoke-Expression ".\$OutFileName $InstallParameters"
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

# Installing silently git
GetAndInstall "https://git-scm.com/download/win" "https:\/\/github\.com\/git-for-windows\/git\/releases\/download\/.*64-bit.*" '<a\s+(?:[^>]*?\s+)?href=([\"''])(.*?)\1' "gitInstall.exe" "" "/SILENT"

Read-Host -Prompt "Press enter after git instalation complete ..."

# Installing git Extensions
GetAndInstall "https://github.com/gitextensions/gitextensions/releases" "\/gitextensions\/gitextensions\/releases\/download\/.*.msi.*" '<a\s+(?:[^>]*?\s+)?href=([\"''])(.*?)\1' "gitExtInstall.msi" "https://GitHub.com/" ""

# Installing silently kdiff3
try
{
	Invoke-Expression "$(Get-Command curl.exe) -L -o `"kdiff3install.exe`" https://sourceforge.net/projects/kdiff3/files/latest/download"
}
catch
{
	Invoke-Expression '&"C:\Program Files\Git\mingw64\bin\curl.exe" -L -o "kdiff3install.exe" https://sourceforge.net/projects/kdiff3/files/latest/download'	
}
Invoke-Expression ".\kdiff3install.exe /S"

Read-Host -Prompt "Press Enter to exit"


