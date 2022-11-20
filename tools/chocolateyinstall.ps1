$ErrorActionPreference = 'Stop';

$packageName= 'colemak'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://skozl.com/s/colemak-caps.zip'

$locale = 'EN'
$arch = 'i386'
if (Get-ProcessorBits 64) {
    $arch = 'amd64'
}
$fileLocation = Join-Path $toolsDir "colemak ($locale)/Colemak_$arch.msi"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url
  file          = $fileLocation
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`" ALLUSERS=1"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'colemak*'
  checksum      = 'babdb6461663932a11480da384e5ef41024470d1dc0cc8792c0b2955398d29ac'
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

Get-ChildItem -recurse $toolsDir -filter setup.exe | foreach {
    $ignoreFile = $_.FullName + '.ignore'
    Set-Content -Path $ignoreFile -Value ($null)
}

Install-ChocolateyInstallPackage @packageArgs
