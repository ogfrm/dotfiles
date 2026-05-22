function Manage_NerdFont {
    param(
        [ValidateSet("Install","Uninstall")]
        [string]$Action = "Install",
        [Parameter(Mandatory)][string]$FontName,
        [string]$FontVersion,           # Optional. If not provided, latest will be downloaded
        [switch]$CurrentUser
    )

    $Folder = if ($CurrentUser) { "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" } else { "$env:WINDIR\Fonts" }
    $Reg = if ($CurrentUser) { "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" } else { "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" }
    switch ($Action) {
        "Install" {
            $Temp = "$env:TEMP\NerdFonts"; if (-not (Test-Path $Temp)) { New-Item $Temp -ItemType Dir | Out-Null }
            $Zip = "$Temp\$FontName.zip"
            if ($FontVersion) {
                $Url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v$FontVersion/$FontName.zip"
            } else {
                $Url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FontName.zip"
            }
            Invoke-WebRequest $Url -OutFile $Zip -UseBasicParsing
            Expand-Archive $Zip -DestinationPath $Temp -Force
            if (-not (Test-Path $Folder)) { New-Item $Folder -ItemType Dir | Out-Null }
            Get-ChildItem $Temp -Filter "*.ttf" -Recurse | ForEach-Object {
                $dest = Join-Path $Folder $_.Name
                if (-not (Test-Path $dest)) {
                    Copy-Item $_.FullName $Folder -Force
                    New-ItemProperty -Path $Reg -Name $_.BaseName -Value $_.Name -PropertyType String -Force | Out-Null
                } else {
                    Write-Host "Skipping $($_.Name) – file in use."
                }
            }
            Remove-Item $Zip -Force; Remove-Item $Temp -Recurse -Force
        }
        "Uninstall" {
            $Fonts = Get-ChildItem $Folder -Filter "*.ttf" | Where-Object { $_.BaseName -like "*$FontName*" }
            if ($Fonts.Count -eq 0) { Write-Host "No fonts matching $FontName"; return }

            foreach ($f in $Fonts) {
                Remove-Item $f.FullName -Force
                Get-ItemProperty $Reg | ForEach-Object {
                    $_.PSObject.Properties | Where-Object { $_.Name -like "*$($f.BaseName)*" } |
                    ForEach-Object { Remove-ItemProperty -Path $Reg -Name $_.Name }
                }
            }

        }
    }
    Write-Host "$FontName $($Action)ed"
}

# Manage-NerdFont -FontName "CaskaydiaCove" -FontVersion "2.3.3" -CurrentUser
# Manage-NerdFont -Action Uninstall -FontName "CaskaydiaCove" -CurrentUser
Manage_NerdFont -FontName "FiraCode" -CurrentUser
Manage_NerdFont -FontName "JetBrainsMono"
Manage_NerdFont -FontName "CascadiaCode"

# VS Code settings
$vscodeSettings = "$env:APPDATA\Code\User\settings.json"

# if (!(Test-Path $vscode)) { "{}" | Set-Content $vscode }
if (!(Test-Path $vscodeSettings)) {
    New-Item -ItemType File -Path $vscodeSettings -Force
    Set-Content $vscodeSettings "{}"
}

$settings = Get-Content $vscodeSettings -Raw | ConvertFrom-Json

# $json."editor.fontFamily" = "JetBrainsMono Nerd Font"
$settings | Add-Member -NotePropertyName "editor.fontFamily" `
    -NotePropertyValue "'JetBrainsMono Nerd Font', 'CascadiaCode Nerd Font', 'FiraCode Nerd Font'" -Force

# $json."terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font"
$settings | Add-Member -NotePropertyName "terminal.integrated.fontFamily" `
    -NotePropertyValue "'JetBrainsMono Nerd Font'" -Force

$settings | ConvertTo-Json -Depth 10 | Set-Content $vscodeSettings


# Windows Terminal settings
$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (Test-Path $wtSettings) {
    $wt = Get-Content $wtSettings -Raw | ConvertFrom-Json

    if (-not $wt.profiles.defaults) {
        $wt.profiles | Add-Member -Name defaults -MemberType NoteProperty -Value @{}
    }

    # $wtJson.profiles.defaults.font = @{ face = "JetBrainsMono Nerd Font" }
    $wt.profiles.defaults | Add-Member `
        -NotePropertyName "font" `
        -NotePropertyValue @{ face = "JetBrainsMono Nerd Font" } -Force

    $wt | ConvertTo-Json -Depth 20 | Set-Content $wtSettings

    Write-Host "Windows Terminal font updated."
}

Write-Host "`nDone. Restart VS Code and Windows Terminal."

# BeyondCompare Options/Apperance/File View/Editor Font -> Nerd font