# Control-MELCloudDevice

A PowerShell module for controlling your Mitsubishi Electric's MELCloud device(s).

## Installation
Open a new PowerShell session, navigate to the folder containing the manifest (and the functions) and then import the module.

*Example:*
````powershell
Import-Module .\Control-MELCloudDevice.psd1 -Force
````

You can then use the ````Get-Command```` cmdlet to verify the available commands in this module:
````powershell
Get-Command -Module Control-MELCloudDevice
````



````powershell
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-MELCloudContextKey                             1.0        Control-MELCloudDevice
Function        Get-MELCloudDevice                                 1.0        Control-MELCloudDevice
Function        Get-MELCloudDeviceInfo                             1.0        Control-MELCloudDevice
Function        Set-MELCloudDevice                                 1.0        Control-MELCloudDevice
````



## Available functions:

HS-modification: All parameters are made optional with default values 

1. **Get-MELCloudContextKey**

This first function is the place to begin. In order to communicate with the MELCloud API and your device, you must authenticate yourself. To successfully retrieve an API-key (*Mitsubishi uses the term 'ContextKey', so I decided to use that name*), you must provide a valid ````username```` and ````password````.
Accept default credential (in variable $MelCredential)
Return Context object (rather than Table-formated output)
store $MelContextKey for following commands

2. **Get-MELCloudDeviceInfo**

Will list all kind of technical information about your MELCloudDevice(s).
Accept default $MelContextKey (retrieved by Get-MelCloudContextKey)
Return PSObject (rather than Table-formated output)

3. **Get-MELCloudDevice** (actually 2nd command in list)

Will list all of your registered MELCloud devices.
Accept default $MelContextKey (retrieved by Get-MelCloudContextKey)
Return PSObject (rather than Table-formated output)

5. **Set-MELCloudDevice**

This is probably the most useful function in this module. 
This badboy allows you to set different settings on your device. 
You can adjust the temperature, set desired fan speed and change the mode (heating or cooling).

Accept default $MelContextKey (retrieved by Get-MelCloudContextKey)
Accept default $MelDeviceID (retrieved by Get-MelCloudDevice)

All parameters are default and defaulted - Default for most is "don't change"
added parameter -Power On/Off - allows swipe off commands Start- and Stop-MelCloudDevice

Some examples:

Get-MelCloudContextKey
Get-MelCloudDevice
Set-MelCloudDevice -Temperature 20

Get-MelCloudContextKey
Get-MelCloudDevice
Set-MelCloudDevice -Power Off

Get-MelCloudContextKey
Get-MelCloudDevice
Set-MELCloudDevice -VaneHorizontal 5 -VerticalSwing Auto

...etc

## More information:

Please refer to my blog post found [here](https://www.cloudpilot.no/blog/Control-your-Mitsubishi-heat-pump-using-PowerShell/) for more details and examples.

This Module is simplified and small errors removed by Henn Sarv
Included Cmdlets ext  

## History

1.0 - Initial Build 
X.0 - modified by HS


## Credit

Developed by: Freddie Christiansen | [CloudPilot.no](http://www.cloudpilot.no)
Modified and refactored by: Henn Sarv

## License

The MIT License
