$Colors = @{
    BackgroundColor = "#252525"
    FontColor = "#FFFFFF"
}

$AlternateColors = @{
    BackgroundColor = "#408100"
    FontColor = "#FFFFFF"
}

$ScriptColors = @{
    BackgroundColor = "#5A5A5A"
    FontColor = "#FFFFFF"
}


##
## REPORTING ON USERS
##
# Auxiliary function to make fields easily retrievable
Function Add-Properties {
param ([Parameter(ValueFromPipeline=$true)]$ishObject)
    foreach($ishField in $ishObject.IshField)
    { $ishObject = $ishObject | Add-Member -MemberType NoteProperty -Name $ishField.Name -Value $ishField.Value -PassThru -Force }
    Write-Output $ishObject
}


# On special autorefresh could actually refresh a lot of variables, and the other views simply only refersh +1 seconds later on the shared refreshed data
$AutoRefresh = {
    New-UDGrid -Title "User Profiles"  -Headers @("FISHUSERDISPLAYNAME", "FISHEMAIL", "FISHUSERLANGUAGE", "FISHOBJECTACTIVE", "FISHUSERDISABLED", "FISHLASTLOGINON", "FISHLOCKEDSINCE", "FISHPASSWORDMODIFIEDON", "CREATED-ON", "MODIFIED-ON") -Properties @("FISHUSERDISPLAYNAME", "FISHEMAIL", "FISHUSERLANGUAGE", "FISHOBJECTACTIVE", "FISHUSERDISABLED", "FISHLASTLOGINON", "FISHLOCKEDSINCE", "FISHPASSWORDMODIFIEDON", "CREATED-ON", "MODIFIED-ON") -Endpoint {
        $metadata = Set-IshRequestedMetadataField -IshSession $ishSession -Name USERNAME |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name CREATED-ON |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHEMAIL |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHOBJECTACTIVE |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHUSERDISABLED |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHUSERDISPLAYNAME |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHUSERLANGUAGE |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name MODIFIED-ON |
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHFAILEDATTEMPTS | # Since 13.0.0
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHLASTLOGINON | # Since 13.0.0
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHLOCKEDSINCE | # Since 13.0.0
                    Set-IshRequestedMetadataField -IshSession $ishSession -Name FISHPASSWORDMODIFIEDON # Since 13.0.0
        Find-IshUser -IshSession $ishSession -RequestedMetadata $metadata | 
        ForEach-Object { Add-Properties $_ }  | # Really need ISHRemote to offer these properties and allowing datetime sorting
        Select-Object -Property "FISHUSERDISPLAYNAME", "FISHEMAIL", "FISHUSERLANGUAGE", "FISHOBJECTACTIVE", "FISHUSERDISABLED", "FISHLASTLOGINON", "FISHLOCKEDSINCE", "FISHPASSWORDMODIFIEDON", "CREATED-ON", "MODIFIED-ON" |
        Out-UDGridData
    } -FontColor "black" # -AutoRefresh -RefreshInterval 3600 
}

$NavBarLinks = @((New-UDLink -Text "SDLDOC" -Url "https://sdldoc01.sdlproducts.com/ISHCM/" -Icon heart_o -OpenInNewWindow))

function New-UDCodeSnippet {
    param($Code) 
    
    New-UDElement -Tag "pre" -Content {
        $Code
    } -Attributes @{
        className = "white-text"
        style = @{
            backgroundColor = $ScriptColors.BackgroundColor
        }
    }
}

function New-UDHeader {
    param(
          [Parameter(ParameterSetName = "content")]
          [ScriptBlock]$Content, 
          [Parameter(ParameterSetName = "text")]
          [string]$Text,
          [Parameter()]
          [ValidateRange(1,6)]
          $Size, 
          [Parameter()]
          $Color)

    if ($PSCmdlet.ParameterSetName -eq "text") {
        New-UDElement -Tag "h$Size" -Content { $text } -Attributes @{
            style = @{
                color = $Color
            }
        } 
    } else {
        New-UDElement -Tag "h$Size" -Content $Content -Attributes @{
            style = @{
                color = $Color
            }
        } 
    }   
}

function New-UDExample {
    param($Title, $Description, $Script, [Switch]$NoRender) 

    New-UDRow -Columns {
        New-UDColumn -Size 2 {}
        New-UDColumn -Size 6 -Content {
            New-UDHeader -Text $Title -Size 2 -Color "white"
        }
    }

    New-UDRow -Columns {
        New-UDColumn -Size 2 {}
        New-UDColumn -Size 6 -Content {
            New-UDHeader -Text $Description -Size 5 -Color "white"
        }
    }
    
    if (-not $NoRender) {
        New-UDRow -Columns {
            New-UDColumn -Size 3 -Content { }
            New-UDColumn -Size 6 -Content {
                . $Script
            }
        }
    }

    New-UDRow -Columns {
        New-UDColumn -Size 2 -Content { }
        New-UDColumn -Size 8 -Content {
            New-UDCodeSnippet -Code ($Script.ToString())
        }
    }
}

function New-UDPageHeader {
    param($Title, $Icon, $Description, $DocLink)

    New-UDRow -Columns {
        New-UDColumn -Size 2 {}
        New-UDColumn -Size 8 -Content {
            New-UDHeader -Content {
                New-UDElement -Tag "i" -Attributes @{ className = "fa fa-$Icon" }
                "  $Title" 
            } -Size 1 -Color "white"

            New-UDHeader -Text $Description -Size 5 -Color "white"
            New-UDHeader -Content {
                New-UDElement -Tag "a" -Attributes @{ "href" = $DocLink } -Content {
                    New-UDElement -Tag "i" -Attributes @{ className = "fa fa-book" }
                    "  Documentation" 
                }
            } -Size 6 -Color "white"
            
        }
    }
}

$HomePage = . (Join-Path $PSScriptRoot "AuxCmdlet\home.ps1")
$Charts = . (Join-Path $PSScriptRoot "AuxCmdlet\charts.ps1")
$Counters = . (Join-Path $PSScriptRoot "AuxCmdlet\counters.ps1")
$Elements = . (Join-Path $PSScriptRoot "AuxCmdlet\elements.ps1")
$Formatting = . (Join-Path $PSScriptRoot "AuxCmdlet\formatting.ps1")
$Grids = . (Join-Path $PSScriptRoot "AuxCmdlet\grids.ps1")
$Images = . (Join-Path $PSScriptRoot "AuxCmdlet\images.ps1")
$Inputs = . (Join-Path $PSScriptRoot "AuxCmdlet\inputs.ps1")
$Monitors = . (Join-Path $PSScriptRoot "AuxCmdlet\monitors.ps1")
$RestApis = . (Join-Path $PSScriptRoot "AuxCmdlet\restapis.ps1")
$Tables = . (Join-Path $PSScriptRoot "AuxCmdlet\tables.ps1")
$Footer = . (Join-Path $PSScriptRoot "AuxCmdlet\footer.ps1")

Get-UDDashboard | Stop-UDDashboard
 
Start-UDDashboard -Content { 
    New-UDDashboard -NavbarLinks $NavBarLinks -Title "ISHMonitor" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFFF" `
    -Pages @(
        $HomePage,
        $Charts,
        $Counters,
        $Elements,
        $Formatting,
        $Grids,
        $Images,
        $Inputs,
        $Monitors,
        $RestApis,
        $Tables) `
     -Footer $Footer
} -Port 10001 -AutoReload
