Param(
    [parameter(mandatory=$true)][string]$ComputerIP
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

function FindDomainUserByIndex (
    [string]$index
) {
    $users = @(
        @{ given_name = "leroy"; family_name = "sears" },
        @{ given_name = "francisco"; family_name = "mayo" },
        @{ given_name = "marcus"; family_name = "dunlap" },
        @{ given_name = "micheal"; family_name = "hayden" },
        @{ given_name = "theodore"; family_name = "wilder" },
        @{ given_name = "clifford"; family_name = "mckay" },
        @{ given_name = "miguel"; family_name = "coffey" },
        @{ given_name = "oscar"; family_name = "mccarty" },
        @{ given_name = "jay"; family_name = "ewing" },
        @{ given_name = "jim"; family_name = "cooley" },
        @{ given_name = "tom"; family_name = "vaughan" },
        @{ given_name = "calvin"; family_name = "bonner" },
        @{ given_name = "alex"; family_name = "cotton" },
        @{ given_name = "jon"; family_name = "holder" },
        @{ given_name = "ronnie"; family_name = "stark" },
        @{ given_name = "bill"; family_name = "ferrell" },
        @{ given_name = "lloyd"; family_name = "cantrell" },
        @{ given_name = "tommy"; family_name = "fulton" },
        @{ given_name = "leon"; family_name = "lynn" },
        @{ given_name = "derek"; family_name = "lott" },
        @{ given_name = "warren"; family_name = "calderon" },
        @{ given_name = "darrell"; family_name = "rosa" },
        @{ given_name = "jerome"; family_name = "pollard" },
        @{ given_name = "floyd"; family_name = "hooper" },
        @{ given_name = "leo"; family_name = "burch" },
        @{ given_name = "alvin"; family_name = "mullen" },
        @{ given_name = "tim"; family_name = "fry" },
        @{ given_name = "wesley"; family_name = "riddle" },
        @{ given_name = "gordon"; family_name = "levy" },
        @{ given_name = "dean"; family_name = "david" },
        @{ given_name = "greg"; family_name = "duke" },
        @{ given_name = "jorge"; family_name = "odonnell" },
        @{ given_name = "dustin"; family_name = "guy" },
        @{ given_name = "pedro"; family_name = "michael" },
        @{ given_name = "derrick"; family_name = "britt" },
        @{ given_name = "dan"; family_name = "frederick" },
        @{ given_name = "lewis"; family_name = "daugherty" },
        @{ given_name = "zachary"; family_name = "berger" },
        @{ given_name = "corey"; family_name = "dillard" },
        @{ given_name = "herman"; family_name = "alston" },
        @{ given_name = "maurice"; family_name = "jarvis" },
        @{ given_name = "vernon"; family_name = "frye" },
        @{ given_name = "roberto"; family_name = "riggs" },
        @{ given_name = "clyde"; family_name = "chaney" },
        @{ given_name = "glen"; family_name = "odom" },
        @{ given_name = "hector"; family_name = "duffy" },
        @{ given_name = "shane"; family_name = "fitzpatrick" },
        @{ given_name = "ricardo"; family_name = "valenzuela" },
        @{ given_name = "sam"; family_name = "merrill" },
        @{ given_name = "rick"; family_name = "mayer" },
        @{ given_name = "lester"; family_name = "alford" },
        @{ given_name = "brent"; family_name = "mcpherson" },
        @{ given_name = "ramon"; family_name = "acevedo" },
        @{ given_name = "charlie"; family_name = "donovan" },
        @{ given_name = "tyler"; family_name = "barrera" },
        @{ given_name = "gilbert"; family_name = "albert" },
        @{ given_name = "gene"; family_name = "cote" },
        @{ given_name = "marc"; family_name = "reilly" },
        @{ given_name = "reginald"; family_name = "compton" },
        @{ given_name = "ruben"; family_name = "raymond" },
        @{ given_name = "brett"; family_name = "mooney" },
        @{ given_name = "angel"; family_name = "mcgowan" },
        @{ given_name = "nathaniel"; family_name = "craft" },
        @{ given_name = "rafael"; family_name = "cleveland" },
        @{ given_name = "leslie"; family_name = "clemons" },
        @{ given_name = "edgar"; family_name = "wynn" },
        @{ given_name = "milton"; family_name = "nielsen" },
        @{ given_name = "raul"; family_name = "baird" },
        @{ given_name = "ben"; family_name = "stanton" },
        @{ given_name = "chester"; family_name = "snider" },
        @{ given_name = "cecil"; family_name = "rosales" },
        @{ given_name = "duane"; family_name = "bright" },
        @{ given_name = "franklin"; family_name = "witt" },
        @{ given_name = "andre"; family_name = "stuart" },
        @{ given_name = "elmer"; family_name = "hays" },
        @{ given_name = "brad"; family_name = "holden" },
        @{ given_name = "gabriel"; family_name = "rutledge" },
        @{ given_name = "ron"; family_name = "kinney" },
        @{ given_name = "mitchell"; family_name = "clements" },
        @{ given_name = "roland"; family_name = "castaneda" },
        @{ given_name = "arnold"; family_name = "slater" },
        @{ given_name = "harvey"; family_name = "hahn" },
        @{ given_name = "jared"; family_name = "emerson" },
        @{ given_name = "adrian"; family_name = "conrad" },
        @{ given_name = "karl"; family_name = "burks" },
        @{ given_name = "cory"; family_name = "delaney" },
        @{ given_name = "claude"; family_name = "pate" },
        @{ given_name = "erik"; family_name = "lancaster" },
        @{ given_name = "darryl"; family_name = "sweet" },
        @{ given_name = "jamie"; family_name = "justice" },
        @{ given_name = "neil"; family_name = "tyson" },
        @{ given_name = "jessie"; family_name = "sharpe" },
        @{ given_name = "christian"; family_name = "whitfield" },
        @{ given_name = "javier"; family_name = "talley" },
        @{ given_name = "fernando"; family_name = "macias" },
        @{ given_name = "clinton"; family_name = "irwin" },
        @{ given_name = "ted"; family_name = "burris" },
        @{ given_name = "mathew"; family_name = "ratliff" },
        @{ given_name = "tyrone"; family_name = "mccray" },
        @{ given_name = "darren"; family_name = "madden" }
    )

    $user = $users[$index]
    if ($null -eq $user) {
        return $null
    }
    $user_id = ($user.given_name.Substring(0, 1) + $user.family_name).ToLower()
    return $user_id
}


$ip_prefix = "172.16.77."
if (-not $ComputerIP.StartsWith($ip_prefix)) {
    Write-Host "No users are associated to ${ComputerIP}."
    exit 1
}
$ip_index = [int]::Parse($ComputerIP.Substring($ip_prefix.Length)) - 1
if ($ip_index -lt 0) {
    Write-Host "No users are associated to ${ComputerIP}."
    exit 1
}
$computer_name = "{0:d4}" -f ($ip_index + 1)

$domain_user_id = FindDomainUserByIndex $ip_index
if ([string]::IsNullOrEmpty($domain_user_id)) {
    Write-Host "No users are associated to ${ComputerIP}."
    exit 1
}

$local_user_id = "lab-user"
$local_password = ReadPassword "Enter the password for ${local_user_id}" "Paloalto1!"

$domain_name = "corp.cortex.lan"
$domain_password = ReadPassword "Enter the password for ${domain_user_id}@${domain_name}" "Paloalto1!"
$script_name = "byos-setup-slp-00xx.ps1"
$script_path = DownloadFile "https://github.com/spearmin10/xsiam-instant-poc-pack/blob/main/slp-endpoints/byos/scripts/${script_name}?raw=true" $script_name

& $script_path `
  -ComputerIP $ComputerIP `
  -ComputerName $computer_name `
  -ComputerDnsServers "172.16.77.240" `
  -LocalUserID $local_user_id `
  -LocalPassword $local_password `
  -DomainUserID $domain_user_id `
  -DomainPassword $domain_password `
  -DomainDnsName $domain_name
