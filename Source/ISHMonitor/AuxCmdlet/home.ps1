New-UDPage -Name "Home" -Icon home -Content {
    New-UDExample -Title "Auto Refreshing Grids" -Description "A grid that auto refreshes" -Script $AutoRefresh
    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDHtml -Markup "<div class='center-align white-text'><h3>Beautiful dashboards. All PowerShell.</h3></h3><h5>Combining ISHRemote and Universal Dashboard for developing and hosting web-based dashboards.</h5></div>"
        }
    }
    New-UDRow {
        New-UDColumn -Size 4 {
            New-UDRow {
                New-UDColumn -Size 12 {
                    $clientVersion = $ishSession.ClientVersion
                    $serverVersion = $ishSession.ServerVersion
                    New-UDCard @Colors -Title "Client / Server Version" -Text "$clientVersion / $serverVersion"
                }
            }
            New-UDRow {
                New-UDColumn -Size 12 {
                    New-UDChart -Title "Favorite Sport by Country" -Type Bar -AutoRefresh -RefreshInterval 7 @Colors -Endpoint {
                        $features = @();
                        $features += [PSCustomObject]@{ "Country" = "United States"; "Football" = (Get-Random -Minimum 10 -Maximum 10000);  "Baseball" = (Get-Random -Minimum 10 -Maximum 10000);  "Curling" = (Get-Random -Minimum 10 -Maximum 10000) }
                        $features += [PSCustomObject]@{ "Country" = "Switzerland"; "Football" = (Get-Random -Minimum 10 -Maximum 10000);  "Baseball" = (Get-Random -Minimum 10 -Maximum 10000);  "Curling" = (Get-Random -Minimum 10 -Maximum 10000) }
                        $features += [PSCustomObject]@{ "Country" = "Germany"; "Football" = (Get-Random -Minimum 10 -Maximum 10000);  "Baseball" = (Get-Random -Minimum 10 -Maximum 10000);  "Curling" = (Get-Random -Minimum 10 -Maximum 10000) }
                        $features += [PSCustomObject]@{ "Country" = "Brazil"; "Football" = (Get-Random -Minimum 10 -Maximum 10000);  "Baseball" = (Get-Random -Minimum 10 -Maximum 10000);  "Curling" = (Get-Random -Minimum 10 -Maximum 10000) }
                        $features| Out-UDChartData -LabelProperty "Country" -Dataset @(
                            New-UDChartDataset -DataProperty "Football" -Label "Football" -BackgroundColor "#8052FFC7" -HoverBackgroundColor "#FF52FFC7"
                            New-UDChartDataset -DataProperty "Baseball" -Label "Baseball" -BackgroundColor "#80E841C8" -HoverBackgroundColor "#FFE841C8"
                            New-UDChartDataset -DataProperty "Curling" -Label "Curling" -BackgroundColor "#8052E837" -HoverBackgroundColor "#FF52E837"
                        )
                    }
                }
            }
        }
        New-UDColumn -Size 4 {
            New-UDRow {
                New-UDColumn -Size 12 {
                    New-UDCard @Colors -Title "Modern Technology" -Text "Using PowerShell Core, Material Design, ReactJS and ASP.NET Core, Universal Dashboard takes advantage of cutting-edge technology to provide cross-platform, cross-device dashboards that looks sleek and modern." 
                }
            }
        }
        New-UDColumn -Size 4 {
            New-UDRow {
                New-UDColumn -Size 12 {
                    New-UDCard @Colors -Title "Written in PowerShell" -Text "Develop both the front-end interface and backend endpoints in the same PowerShell script. Host dashboards right from the console or in Azure\IIS."  -Links @(New-UDLink -Text "View this dashboard's PowerShell Script" -Url "https://github.com/ironmansoftware/poshud")
                }
            }
            New-UDRow {
                New-UDColumn -Size 12 {
                    New-UDCard @Colors -Title "User Profile Count" -Text (Find-IshUser -IshSession $ishSession).Count 
                }
            }
            New-UDRow {
                New-UDColumn -Size 12 {
                    New-UDExample -Title "Auto Refreshing Grids" -Description "A grid that auto refreshes" -Script $AutoRefresh
                }
            }
            New-UDRow {
                New-UDColumn -Size 12 {
                    New-UDGrid -Title "Service Information" -Headers @("Status", "Name", "Display Name") -Properties @("Status", "Name", "DisplayName")  -Endpoint {
                        Get-Service | Out-UDGridData
                    } -FontColor "black"
                }
            }
        }
    }
} 
