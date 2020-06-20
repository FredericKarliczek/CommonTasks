﻿$configData = Import-LocalizedData -BaseDirectory $PSScriptRoot\Assets -FileName Config.psd1 -SupportedCommand New-Object, ConvertTo-SecureString -ErrorAction Stop
$moduleName = $env:BHProjectName

Remove-Module -Name $env:BHProjectName -ErrorAction SilentlyContinue -Force
Import-Module -Name $env:BHProjectName -ErrorAction Stop

Import-Module -Name DscBuildHelpers

Describe "AdSitesSubnets DSC Resource compiles" -Tags 'FunctionalQuality' {
    It "AdSitesSubnets Compiles" {
        configuration "Config_AdSitesSubnets" {

            Import-DscResource -ModuleName CommonTasks

            node "localhost_AdSitesSubnets" {
                AdSitesSubnets adsitesub {
                    Sites = $ConfigurationData.AdSitesSubnets.Sites
                    Subnets = $ConfigurationData.AdSitesSubnets.Subnets
                }
            }
        }

        { & "Config_AdSitesSubnets" -ConfigurationData $configData -OutputPath $env:BHBuildOutput -ErrorAction Stop } | Should -Not -Throw
    }

    It "AdSitesSubnets should have created a mof file" {
        $mofFile = Get-Item -Path "$env:BHBuildOutput\localhost_AdSitesSubnets.mof" -ErrorAction SilentlyContinue
        $mofFile | Should -BeOfType System.IO.FileInfo
    }
}
