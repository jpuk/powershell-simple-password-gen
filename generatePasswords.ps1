param (
    [Parameter(,
    ParameterSetName = "number_of_passwords")]
    [Int]
    $number_of_passwords = 25,

    [Parameter(,
    ParameterSetName = "nouns")]
    [Int]
    $number_of_nouns = 1,

    [Parameter(,
    ParameterSetName = "verbs")]
    [Int]
    $number_of_verbs = 1,

    [Parameter(,
    ParameterSetName = "adverbs")]
    [Int]
    $number_of_adverbs = 1,

    [Parameter(,
    ParameterSetName = "adjectives")]
    [Int]
    $number_of_adjectives, 

    [Parameter(,
    ParameterSetName = "symbols")]
    [Int]
    $number_of_symbols = 1,

    [Parameter(Mandatory = $false,
    ParameterSetName = "shuffle_password")]
    [Switch]
    $shuffle_password = $false

)

# Simple powershell script to create random word based passwords 
$passwords = New-Object System.Collections.ArrayList
$number_range = (0,99)
#$shuffle_password = $false

# read in word lists
write-host "Reading word lists..."
$nouns = New-Object System.Collections.ArrayList
foreach($line in Get-Content "./1syllablenouns.txt") {
    $nouns.Add($line -replace "`n|`r")
}

$verbs = New-Object System.Collections.ArrayList
foreach($line in Get-Content "./1syllableverbs.txt") {
    $verbs.Add($line -replace "`n|`r")
}

$adverbs = New-Object System.Collections.ArrayList
foreach($line in Get-Content "./1syllableadverbs.txt") {
    $adverbs.Add($line -replace "`n|`r")
}

$adjectives = New-Object System.Collections.ArrayList
foreach($line in Get-Content "./1syllableadjectives.txt") {
    $adjectives.Add($line -replace "`n|`r")
}

$commonSymbols = '!','@','$','%','^','&','*','(',')','+','=','<','>','/','?'

$password_list = New-Object System.Collections.ArrayList

# get random words, number and symbol from each category and create passwords.
$i = 0
do {
    $password_components = New-Object System.Collections.ArrayList
    $password = ""
    $j = 0
    if ($number_of_nouns -ne 0) {
        do {
            $password_components.Add($nouns[(Get-Random -Maximum $nouns.Count -Minimum 0)])
            $j++
        } until ($j -eq $number_of_nouns)
    }
    $j = 0
    if ($number_of_verbs -ne 0) {
        do {
            $password_components.Add($verbs[(Get-Random -Maximum $verbs.Count -Minimum 0)])
            $j++
        } until ($j -eq $number_of_verbs)
    }
    $j = 0
    if ($number_of_adverbs -ne 0) {
        do {
            $password_components.Add($adverbs[(Get-Random -Maximum $adverbs.Count -Minimum 0)])
            $j++
        } until ($j -eq $number_of_adverbs)
    }
    $j = 0
    if ($number_of_adjectives -ne 0) {
        do {
            $password_components.Add($adjectives[(Get-Random -Maximum $adjectives.Count -Minimum 0)])
            $j++
        } until ($j -eq $number_of_adjectives)
    }
    $j = 0
    if ($number_of_symbols -ne 0) {
        do {
            $password_components.Add($commonSymbols[(Get-Random -Maximum $commonSymbols.Count -Minimum 0)])
            $j++
        } until ($j -eq $number_of_symbols)
    } 

    $number = get-Random -Maximum $number_range[1] -Minimum $number_range[0]
    $password_components.Add($number.ToString())

    if ($shuffle_password -eq $true){
        $password_components = $password_components | Sort-Object {Get-Random}
    }

    #create password string
    $password_components | ForEach-Object {
        $password = $password + (Get-Culture).TextInfo.ToTitleCase($_)
    }

    $passwords.Add($password.ToString())

    $i++
    } until ($i -eq $number_of_passwords)


$passwords | ForEach-Object {
    write-host $_
}