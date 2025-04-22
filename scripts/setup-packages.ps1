param(
    [string]$PackagePath
)

# Helper function to ensure a directory exists
function Ensure-DirectoryExists {
    param([string]$Path)
    if (!(Test-Path $Path)) {
        Write-Host "Creating directory: $Path"
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

# Helper function to set a user environment variable
function Set-UserEnvironmentVariable {
    param(
        [string]$Name,
        [string]$Value
    )
    Write-Host "Setting environment variable: $Name = $Value"
    [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::User)
}

# Helper function to update or add a key-value pair in NuGet.Config
function Update-NuGetConfig {
    param(
        [string]$ConfigPath,
        [string]$Key,
        [string]$Value
    )
    [xml]$xmlConfig = Get-Content -Path $ConfigPath

    # Ensure the <config> node exists
    if (-not $xmlConfig.configuration.config) {
        $configNode = $xmlConfig.CreateElement("config")
        $xmlConfig.configuration.AppendChild($configNode) | Out-Null
    } else {
        $configNode = $xmlConfig.configuration.config
    }

    # Find or create the <add> node for the key
    $addNode = $configNode.SelectSingleNode("add[@key='$Key']")
    if (-not $addNode) {
        $addNode = $xmlConfig.CreateElement("add")
        $addNode.SetAttribute("key", $Key)
        $configNode.AppendChild($addNode) | Out-Null
    }

    # Update the value
    $addNode.SetAttribute("value", $Value)

    # Save the updated configuration
    $xmlConfig.Save($ConfigPath)
}

# Main function to configure NuGet settings
function Configure-NuGet {
    param([string]$NuGetPath)

    $NuGetConfigFile = "$env:APPDATA\NuGet\NuGet.Config"
    Ensure-DirectoryExists $NuGetPath

    if (!(Test-Path $NuGetConfigFile)) {
        Write-Host "Creating new NuGet.Config file at: $NuGetConfigFile"
        $xmlContent = @"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
    <add key="globalPackagesFolder" value="$NuGetPath" />
    <add key="repositoryPath" value="$NuGetPath" />
  </config>
</configuration>
"@
        Set-Content -Path $NuGetConfigFile -Value $xmlContent
    } else {
        Write-Host "Updating existing NuGet.Config file at: $NuGetConfigFile"
        Update-NuGetConfig -ConfigPath $NuGetConfigFile -Key "globalPackagesFolder" -Value $NuGetPath
        Update-NuGetConfig -ConfigPath $NuGetConfigFile -Key "repositoryPath" -Value $NuGetPath
    }
}

# Define package paths and environment variables
$PackageConfigs = @{
    "npm_config_cache"    = "$PackagePath\npm-cache"
    "NUGET_PACKAGES"      = "$PackagePath\nuget"
    "PIP_CACHE_DIR"       = "$PackagePath\pip-cache"
    "CARGO_HOME"          = "$PackagePath\cargo"
    "YARN_CACHE_FOLDER"   = "$PackagePath\yarn-cache"
}

# Ensure directories exist and set environment variables
foreach ($Key in $PackageConfigs.Keys) {
    Ensure-DirectoryExists $PackageConfigs[$Key]
    Set-UserEnvironmentVariable -Name $Key -Value $PackageConfigs[$Key]
}

# Configure NuGet
Configure-NuGet -NuGetPath $PackageConfigs["NUGET_PACKAGES"]

Write-Host "Package cache setup completed successfully!"
