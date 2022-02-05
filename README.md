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

1. **Get-MELCloudContextKey**

This first function is the place to begin. In order to communicate with the MELCloud API and your device, you must authenticate yourself. To successfully retrieve an API-key (*Mitsubishi uses the term 'ContextKey', so I decided to use that name*), you must provide a valid ````username```` and ````password````.

2. **Get-MELCloudDeviceInfo**

Will list all kind of technical information about your MELCloudDevice(s).

3. **Get-MELCloudDevice**

Will list all of your registered MELCloud devices.

5. **Set-MELCloudDevice**

This is probably the most useful function in this module. This badboy allows you to set different settings on your device. You can adjust the temperature, set desired fan speed and change the mode (heating or cooling).


## More information:

Please refer to my blog post found [here](https://www.cloudpilot.no/blog/Control-your-Mitsubishi-heat-pump-using-PowerShell/) for more details and examples.

This Module is simplified and small errors removed by Henn Sarv
Included Cmdlets ext  

## History

1.0 - Initial Build 



## Credit

Developed by: Freddie Christiansen | [CloudPilot.no](http://www.cloudpilot.no)
Modified and refactored by: Henn Sarv

## License

The MIT License
