Param(
    [parameter(mandatory=$true)]
    [switch]$ApplyDefault
)

function ReadPassword (
    [string]$message,
    [string]$default
) {
    if (![string]::IsNullOrEmpty($default)) {
        $message += " (default: $default)"
    }
    $input = (Read-Host $message -AsSecureString)
    $input = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
       [Runtime.InteropServices.Marshal]::SecureStringToBSTR(
           $input
       )
    )
    $input = $input.Trim()
    if ([string]::IsNullOrEmpty($input) -And ![string]::IsNullOrEmpty($default)) {
        return $default
    } else {
        return $input
    }
}

function IsDirectory (
    [string]$path
) {
    return ![string]::IsNullOrEmpty($path) -And (Test-Path $path) -And ((Get-Item $path) -is [IO.DirectoryInfo])
}

function DownloadFile (
    [string]$url,
    [string]$save_as
) {
    $cli = New-Object Net.WebClient
    $cli.Headers.Add("Cache-Control", "no-cache, no-store")

    if ([string]::IsNullOrEmpty($save_as) -Or (IsDirectory $save_as)) {
        $uri = New-Object System.Uri($url)
        if (!$uri.AbsolutePath.EndsWith("/")) {
            $filename = Split-Path $uri.AbsolutePath -Leaf
        } else {
            $filename = "temp.dat"
        }
        if ((IsDirectory $save_as)) {
            $save_as = [IO.Path]::GetFullPath((Join-Path $save_as $filename))
        } else {
            $save_as = $filename
        }
    }
    $cli.DownloadFile($url, $save_as)
    return (Get-Item $save_as).FullName
}

$local_user_id = "lab-user"
$local_password = "Paloalto1!"
if ($ApplyDefault -ne $true) {
    $local_password = ReadPassword "Enter the password for ${local_user_id}" $local_password
}

$domain_name = "corp.cortex.lan"
$domain_password = "Paloalto1!"
if ($ApplyDefault -ne $true) {
    $domain_password = ReadPassword "Enter the password to be used for all users in the ${domain_name} domain." $domain_password
}
$script_name = "byos-setup-slp-ad.ps1"
$script_path = DownloadFile "https://github.com/spearmin10/xsiam-instant-poc-pack/blob/main/slp-endpoints/byos/scripts/${script_name}?raw=true" $script_name

& $script_path `
  -ComputerIP 172.16.77.240 `
  -ComputerName SLP-AD `
  -ComputerDnsServers "1.1.1.1,8.8.8.8" `
  -LocalUserID $local_user_id `
  -LocalPassword $local_password `
  -DomainDnsName $domain_name `
  -DomainOU CORTEX `
  -DomainPassword $domain_password
