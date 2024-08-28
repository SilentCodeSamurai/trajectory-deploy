# LoadEnv.ps1
param (
    [string]$envFilePath = ".env"
)

if (-Not (Test-Path $envFilePath)) {
    throw "The .env file '$envFilePath' does not exist."
}

$envContent = Get-Content $envFilePath -ErrorAction Stop

foreach ($line in $envContent) {
    $line = $line.Trim()
    if (-Not [string]::IsNullOrWhiteSpace($line) -and -Not $line.StartsWith("#")) {
        $parts = $line -split '=', 2
        if ($parts.Count -eq 2) {
            $name = $parts[0].Trim()
            $value = $parts[1].Trim()
            [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Process)
        }
    }
}