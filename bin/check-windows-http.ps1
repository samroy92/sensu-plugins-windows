#
#   check-windows-http.ps1
#
# DESCRIPTION:
#   This plugin checks availability of link provided as param
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Windows
#
# DEPENDENCIES:
#   Powershell 3.0 or above
#
# USAGE:
#   Powershell.exe -NonInteractive -NoProfile -ExecutionPolicy Bypass -NoLogo -File C:\\etc\\sensu\\plugins\\check-windows-http.ps1 https://google.com
#   Powershell.exe -ExecutionPolicy Bypass check-windows-http.ps1 https://google.com -BasicParsing
#
# NOTES:
#    Use switch '-BasicParsing' to ignore IE rendering of response - invalid or blocked rendering may cause false Critical for check.
#
# LICENSE:
#   Copyright 2016 sensu-plugins
#   Released under the same terms as Sensu (the MIT license); see LICENSE for details.
#
#Requires -Version 3.0
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$CheckAddress,
  [Parameter(Mandatory=$False,Position=2)]
   [switch]$BasicParsing
)

$ThisProcess = Get-Process -Id $pid
$ThisProcess.PriorityClass = "BelowNormal"

try {
  $Available = Invoke-WebRequest $CheckAddress -ErrorAction SilentlyContinue -UseBasicParsing:$BasicParsing
}

catch {
  $errorhandler = $_.Exception.request
}

if (!$Available) {
  Write-Host CRITICAL: Could not connect  $CheckAddress!
  Exit 2 
}

if ($Available) {
   if ($Available.statuscode -eq 200) {
      Write-Host OK: $CheckAddress is available!
      Exit 0
   } else {
      Write-Host CRITICAL: URL $CheckAddress is not accessible!
      Exit 2
   }
}
