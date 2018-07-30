# Summary

`ISHMonitor` is a PowerShell module on SDL Tridion Docs Content Manager (Knowledge Center Content Manager, LiveContent Architect, Trisoft InfoShare). Its goal is to offer a monitor dashboard over the Component Content Management System. This library is constructed close to the "Web Services API" relying on the [ISHRemote](https://github.com/sdl/ISHRemote) module.

The visualization part is handled through PowerShell [Universal Dashboard](https://www.poshud.com/Home). At the time of writing Adam Driscoll was looking into creating a community edition, where the commercial edition would offer the following extras: Commercial Licensing, Branding and Dashboard/REST API Authentication.

# Features & Samples

* List the version
* See OneNote

# Install & Update

## Prerequisites

When you have PowerShell 5 on your client machine, the PSVersion entry in `$PSVersionTable` reads 5.0... and PackageManagement is there implicitly.
When you have a PowerShell version lower than 5 on your client machine, the PSVersion entry in `$PSVersionTable` reads 4.0 or even 3.0. Note that up to Knowledge Center 2016SP3/12.0.3 release is only verified with PowerShell 4 (not 5 or above), so don't upgrade your servers. 

So either upgrade to [Windows Management Framework 5.0](https://www.microsoft.com/en-us/download/details.aspx?id=50395) or stay on PowerShell 4 and install [Package Management Preview – March 2016 for PowerShell 4 & 3](https://blogs.msdn.microsoft.com/powershell/2016/03/08/package-management-preview-march-2016-for-powershell-4-3-is-now-available/).

At least PowerShellGet 1.6.0.0 is required to support `-AllowPrerelease` parameter on `Install-Module`. You can verify the version by `Get-PackageProvider`. To raise the version run a PowerShell `As Administrator` and execute: `Install-Module -Name PowershellGet,PackageManagement -Repository PSGallery -Force -confirm:$false -Verbose`.

## Install
Open a PowerShell, then you can find and install the ISHMonitor module. CurrentUser `-Scope` indicates that you don't have to run PowerShell as Administrator. The `-Force` will make you bypass some security/trust questions.

		Install-Module UniversalDashboard.Community -Repository PSGallery -Scope CurrentUser -Force -AllowPrerelease
        ~~Install-Module ISHMonitor -Repository PSGallery -Scope CurrentUser -Force~~
		Import-Module .\ISHMonitor -Force 

## Update

Open a PowerShell and run.

        Update-Module UniversalDashboard.Community -Force
        ~~Update-Module ISHMonitor~~
		Import-Module .\ISHMonitor -Force 

 
## Uninstall

Open a PowerShell and run.

        ~~Uninstall-Module UniversalDashboard.Community -AllVersion~~
        ~~Uninstall-Module ISHMonitor -AllVersion~~

## Execute

A simple invoke would come down to, make sure a `__ISHMonitor` folder exists in the root of your CMS folder structure.

        $ishSession =  New-IshSession -WsBaseUrl https://example.com/ISHWS/ -PSCredential ddemeyer
        Enable-UDLogging -FilePath C:\GITHUB\ISHMonitor\UniversalDashboard.log -Level Debug
        .\Invoke-ISHMonitor.ps1
        Disable-UDLogging
		
# Backlog & Feedback
Any feedback is welcome. Please log a GitHub issue, make sure you submit your version number, expected and current result,...

# Known Issues & FAQ

## Execution Known Issues
* If `Universal Dashboard` returns `New-UDPage : Method not found: 'Void NLog.Logger.Error(System.Exception, System.String)'.`. The module relies on 4.5.3 (or higher), and in the GAC it was overruled with a 4.0.0 NLog.dll version making it all fail.
        gacutil /lr NLog
        NLog, Version=4.0.0.0, Culture=neutral, PublicKeyToken=5120e14c03d0593c, processorArchitecture=MSIL
              SCHEME: <WINDOWS_INSTALLER>  ID: <MSI>  DESCRIPTION : <Windows Installer>
        gacutil /i C:\GITHUB\ISHMonitor\NLog.dll
* If `Universal Dashboard` returns `Unable to find type [Microsoft.AspNetCore.Http.CookieOptions]` when doing a Get-Help on New-UDGrid. It simply means that the library didn't load successfully, running a `Start-UDDashboard` did load it correctly and the ISE help worked.
* If you get `New-IshSession : Reference to undeclared entity 'raquo'. Line 98, position 121.`, most likely you specified an existing "Web Services API" url. Make sure your url ends with an ending slash `/`.
* If a test fails with `The communication object, System.ServiceModel.Channels.ServiceChannel, cannot be used for communication because it is in the Faulted state.`,
  it probably means you didn't provide enough (mandatory) parameters to the WCF/SVC code so passing null parameters. Typically an `-IshPassword` is missing or using an existing username.
* ISHDeploy `Enable-ISHIntegrationSTSInternalAuthentication/Disable-ISHIntegrationSTSInternalAuthentication` adds a /ISHWS/Internal/connectionconfiguration.xml that a different issuer should be used. As ISHMonitor doesn't have an app.config, all the artifacts are derived from the RelyingParty WSDL provided mex endpoint (e.g. /ISHSTS/issue/wstrust/mex).  
If you get error `New-IshSession : The communication object, System.ServiceModel.Channels.ServiceChannel, cannot be used for communication because it is in the Faulted state.`, it probably means you initialized `-WsBaseUrl` without the `/Internal/` (or `/SDL/`) segment, meaning you are using the primary configured STS.

## Testing Known Issues

N/A

## Documentation Known Issues

N/A

# Standards To Respect

## Coding Standards 

* Any code change should 
    * respect the coding standard like [Strongly Encouraged Development Guidelines](https://msdn.microsoft.com/en-us/library/dd878270(v=vs.85).aspx) and [Windows PowerShell Cmdlet Concepts](https://msdn.microsoft.com/en-us/library/dd878268(v=vs.85).aspx)
    * come with matching acceptance/unit test, to further improve stability and predictability
    * come with matching tripple-slash `///` documentation verification or adaptation. Remember `Get-Help` drives PowerShell!
    * double check backward compatibility; if you break provide an alternative through `Set-Alias`, Get-Help,...
	* Any url reference should be specified with `...example.com` in samples and Service References.
* Respect PowerShell concepts
    * parameters are Single not plural, so IshObject over IshObjects or FilePath over FilePaths
    * implement `-WhatIf`/`-Confirm` flags for write operations
* ISHMonitor-build project holds the artefacts for in-house testing, signing, and publishing the library

## Documentation Standards

* Every function should be document to allow `Get-Help` to work.

## Testing Standards

* Most Pester tests are acceptance test, enriched which some unit tests where possible.
* Data initialization and breakdown are key but also time consuming. BeforeEach/AfterEach are run for every It block, so makes things slow.

# Coding Prerequisites  

## Testing and Debugging

Refreshing all module artefacts in a PowerShell ISE session can be done using

		Import-Module .\ISHMonitor -Force 

*Module structure credits go to RamblingCookieMonster like [PSStackExchange](https://github.com/RamblingCookieMonster/PSStackExchange)*