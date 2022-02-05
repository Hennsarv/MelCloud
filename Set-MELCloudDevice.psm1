function Set-MELCloudDevice {
<#
.Synopsis
   Allows you to set different settings on your MELCloud device
     
.EXAMPLE
   Set-MELCloudDevice -DeviceID <DeviceID> -ContextKey <YourContextKey> -Temperature <10-31 degrees celsius> -FanSpeed <"1" to "5"> -VaneHorizontal <"1" to "5"> -VaneVertical <"1" to "5">`
   -Mode <"Heating" or "Cooling"> -HorizontalSwing<"On" or "Off"> -VerticalSwing <"On" or "Off">
    
   ContextKey can be found by using the "Get-MELCloudContextKey" function
   DeviceID can be found by using the "Get-MELCloudDevices" function

.INPUTS
   DeviceID                      
   ContextKey          
   Temperature         
   FanSpeed            
   VaneHorizontal      
   VaneVertical        
   Mode          
   HorizontalSwing     
   VerticalSwing
   Power # added by HS - this allos to swicth on of
   all parameters are made optional exept DeviceID nd ContextKey

.OUTPUTS
   Writes current Power, Temperature, FanSpeed, OperationMode, VaneHorizontal and VaneVertical settings to the console
      
.NOTES
   Author:     Freddie Christiansen
   Website:    https://www.cloudpilot.no
   LinkedIn:   https://www.linkedin.com/in/freddie-christiansen-64305b106
   Refactored: by Henn Sarv

.LINK
   https://www.cloudpilot.no/blog/Control-your-Mitsubishi-heat-pump-using-PowerShell/
#>
        [CmdletBinding()]

        param(
  
        [Parameter(Mandatory = $false,
        ValueFromPipeline = $False,
        HelpMessage = "Enter your DeviceID)")]
        [Alias('DevID')]
        [string[]]$DeviceID = $null,


        [Parameter(Mandatory = $false,
        ValueFromPipeline = $False,
        HelpMessage = "Enter your ContextKey")]
        [Alias('CT')]
        [string[]]$ContextKey = $null,

        [Parameter(Mandatory = $false,
        ValueFromPipeline = $False,
        HelpMessage = "Select your Mode)")]
        [ValidateSet ('Heating','Cooling', ignorecase=$True)]
        [Alias('ModeSelect')]
        [string[]]$Mode = 'Heating',             # default value added by HS

        [Parameter(Mandatory = $false,
        ValueFromPipeline = $False,
        HelpMessage = "Enter your desired temperature")]
        [ValidateRange (10,31)]
        [Alias('Temp')]
        [string[]]$Temperature = '0',           # default value added by HS - 0 means no change

 #<#                                             # fan speed ignored by setting - commented out
        [Parameter(Mandatory = $false,
        ValueFromPipeline = $False,
        HelpMessage = "Set fan speed")]
        [ValidateRange (0,7)]
        [Alias('Fan')]
        [int]$FanSpeed = 7,                   # default value added by HS - 7 means no change
                                              # value 0 means AUTO  
#>
        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateRange (0,5)]
        [Alias('VaneHorizon')]
        [string[]]$VaneHorizontal = '0',        # default value added by HS - 0 means no change

        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateRange (0,5)]
        [Alias('VaneVert')]
        [string]$VaneVertical = '0',        # default value added by HS - 0 means no change

        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateSet ('On','Off', 'Auto', ignorecase=$True)]
        [Alias('HorizonSwing')]
        [string]$HorizontalSwing,

        [Parameter(Mandatory = $False,
        ValueFromPipeline = $False)]
        [ValidateSet ('On','Off', 'Auto', ignorecase=$True)]
        [Alias('VertSwing')]
        [string]$VerticalSwing,

        [Parameter(Mandatory=$False,
        ValueFromPipeline = $False)]
        [ValidateSet ('On', 'Off', ignorecase = $True)]
        [string]$Power = 'On',

        [Parameter(Mandatory=$False)]
        [Switch]$FanSpeedAuto
        

)

BEGIN {}


PROCESS {

        if ($ContextKey -eq $null) {$ContextKey = $Global:melContextKey}
        if ($ContextKey -eq $null) 
        {
            Write-Error 'please provide Conext key'
        }

        if ($DevideID -eq $null) {$DeviceID = $Global:melDeviceID}
        if ($DeviceID -eq $null) 
        {
            Write-Error 'please provide Device ID'
        }

        try {

        #OperationMode 1 = Heating | OperationMode 3 = Cooling
        if ($Mode -eq "Heating") {$ModeSetting = "1"}
        else {$ModeSetting = "3"}

        #PowerMode 'true' = On | PowerMode 'false' = Off
        if ($Power -eq 'Off') {$PowerMode = 'false'} else {$PowerMode = 'true'}
        
        if ($HorizontalSwing -eq "On") {$VaneHorizontalMode = "12"}
        elseif ($HorizontalSwing -eq "Auto") {$VaneHorizontalMode = "6"}
        else {$VaneHorizontalMode = $VaneHorizontal}

        if ($VerticalSwing -eq "On") {$VaneVerticalMode = "7"}
        elseif ($VerticalSwing -eq "Auto") {$VaneVerticalMode = "6"}
        else {$VaneVerticalMode = $VaneVertical}

        if ($VaneHorizontalMode -eq '0' -or $VaneHorizontalMode -eq '0' -or $FanSpeed -eq '7')
        {
            $deviceinfo = Get-MELCloudDeviceInfo -ContextKey $ContextKey | select -Property *direction, FanSpeed
            if ($VaneHorizontalMode -eq '0') {$VaneHorizontalMode = $deviceinfo.VaneHorizontalDirection}
            if ($VaneVerticalMode -eq '0') {$VaneVerticalMode = $deviceinfo.VaneVerticalDirection}
            if ($FanSpeed -eq '7') {$FanSpeed = $deviceinfo.FanSpeed}
        }
        if ($FanSpeedAuto) {$FanSpeed = 0}
        

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $URL = "https://app.melcloud.com/Mitsubishi.Wifi.Client/Device/SetAta"

        $ContentType ="application/json; charset=UTF-8"

        $Header = @{

        "X-MitsContextKey"= "$ContextKey"
        "Sec-Fetch-Site"="same-origin"
        "Origin"="https://app.melcloud.com"
        "Accept-Encoding"="gzip, deflate, br"
        "Accept-Language"="et-EE,nb;q=0.9,no;q=0.8,nn;q=0.7,en-US;q=0.6,en;q=0.5"
        "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36"
        "Sec-Fetch-Mode"="cors"
        "Accept"="application/json, text/javascript, */*; q=0.01"
        "Referer"="https://app.melcloud.com/"
        "X-Requested-With"="XMLHttpRequest"
        "Cookie"="policyaccepted=true"
        "Context-Type"="application/json"
        }
        
        $Body = @{
        EffectiveFlags = 15
        SetTemperature = "$Temperature"
        SetFanSpeed = "$FanSpeed"  # miskipärast FanSpeedi  seadet ignoreeritakse
        OperationMode = "$ModeSetting"
        VaneHorizontal = "$VaneHorizontalMode"
        VaneVertical = "$VaneVerticalMode"
        DeviceID = "$DeviceID"
        DeviceType = "0"
        Power = $PowerMode # power asjaga saab sättida sisse-välja - added by HS
        HasPendingCommand = "false"
        Offline = "false"
        Scene = "null"
        SceneOwner = "null"
        
        } | ConvertTo-Json
        Write-Debug 'ootan'
        
        $Set = Invoke-WebRequest -Uri $URL -Headers $Header -ContentType $ContentType -Body $Body -Method POST
        $Set | ConvertFrom-Json | select Power, SetTemperature, RoomTemperature, SetFanSpeed, OperationMode, VaneHorizontal, VaneVertical #| Format-Table -AutoSize # removed formating to allow further processing

        }

        catch {

        Write-Debug $_
        Write-Error "An unexpected error occurred. Please try again." -Category ConnectionError


        }

}

END {}
        


}
