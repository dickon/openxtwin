param 
(
  [string]$workdir = $env:temp,
  [string]$package
)

function Handle($p) {
  if (&('Test-'+$p)) {
    Write-Host "$p no action needed"
  } else {
    Write-Host "$p missing"
    &('Install-'+$p)
  }
}

$ErrorActionPreference = "Stop"

if ($workdir -ne $env:temp) {
  if (-Not (Test-Path $workdir)) {
     mkdir $workdir
  }
  $env:temp = $workdir
}

Start-Transcript -Append -Path ($env:temp+'\mkbuildmachine.log')

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\PackageLibrary.psm1

if ($package) {
  Handle($package)
  Write-Host "SUCCESS: This machine is now configured for $package"
} else {
  foreach ($p in (Get-Packages)) {
    Handle($p)
  }
  Write-Host "SUCCESS: This machine is now fully configured for building XT"
}

