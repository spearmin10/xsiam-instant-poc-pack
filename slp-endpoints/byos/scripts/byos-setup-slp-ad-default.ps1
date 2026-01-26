
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

$user_id = "lab-user"
$password = ReadPassword "Input password for ${user_id}" "Paloalto1!"

$script = ([ScriptBlock]::Create((New-Object Net.WebClient).DownloadString(
  "https://github.com/spearmin10/xsiam-instant-poc-pack/blob/main/slp-endpoints/byos/scripts/byos-setup-slp-ad.ps1?raw=true"
)))
$script.Invoke(
  "-ComputerIP", "172.16.77.240",
  "-ComputerName", "SLP-AD",
  "-ComputerDnsServers", "1.1.1.1,8.8.8.8",
  "-LocalUserID", $user_id,
  "-LocalPassword", $password,
  "-DomainDnsName", "corp.cortex.lan",
  "-DomainOU", "CORTEX"
)
