# Lima Band SDK Documentation

### Swift version

The Lima Band SDK was built using Swift 3. It is currently not planned to port the SDK to a newer version, however, we believe the update should require little effort.

## Searching and connecting to devices

In order to find nearby devices you need to use the `scan` method of the `LimaBandClient` shared instance. If you wish to restrict the distance (based on RSSI signal strength) you can do so by previously setting a value to the `rssiFilterValue` property.

```swift
LimaBandClient.shared.rssiFilterValue = -80
    
LimaBandClient.shared.scan(filterBySignalLevel: true) { 
	(success, devices) in
    
    // do something here
    
}
```

`devices` is a list of `BluetoothDevice` objects. You can connect to a `BluetoothDevice` by using the `connect` method. Some devices need to go through an initialization phase after connecting, so we will perform it too. The initialization phase often involves setting the current date and time, obtaining device information and setting the user information as well. In order to properly initialize a band you should provide the user information before initializing.

```swift
LimaBandClient.shared.connect(
    device: bluetoothDevice) { 
    (success, fitnessDevice) in

	 // prepare the user information before initializing
	 // you should ask beforehand this information to your user
    fitnessDevice.userInfo = FitnessDeviceUserInfo(
        gender: .female,
        birthDate: Date(),
        height: 173,
        weight: 73
    )
                        
    // after connecting we initialize the device
	fitnessDevice.initialize { success in
		if (success) {
		    print("Fitness device is connected and initialized.")
		} else {
		    print("Failed to initialize fitness device")
		}
	}
}
```

After initialization is complete you can perform the rest of the operations provided by the band.

## Band operations

The SDK currently supports the following operations:

### Vibration

Causes the device to vibrate

```swift
fitnessDevice?.vibrate.execute(handler: { (success) in
    if success {
        print("Wristband should be vibrating right now")
    }
})
```

### Get Device Information

Gets device information such as hardware or firmware version.

> This method is automatically called during initialization

```swift
fitnessDevice?.getDeviceInfo.execute(handler: { (success) in
    if success {
		print("Got device info successfully")
		// info is available at fitnessDevice?.deviceInfo
    }
})
```

### Set date and time

Sets the current date and time

> This method is automatically called during initialization

```swift
fitnessDevice?.setDateTime.execute(handler: { (success) in
    if (success) {
        print("Date and time set successfully")
    }
})
```
### Get battery level

Retrieves the current battery level from the wristband

```swift
if let op = fitnessDevice?.getBatteryLevel
{
    op.execute(handler: { (success) in
        
        guard let batteryLevel = op.returnInt else {
            return
        }
        print("Battery level is \(batteryLevel)")
    })
}
```

### Set user information

Sets the user information such as height, weight and age. The values used are the ones present at `fitnessDevice.userInfo`

> This method is automatically called during initialization

```swift
fitnessDevice?.setUserInfo.execute(handler: { (success) in
    if success {
        print("User Information has been set successfully")
    }
})
```

### Get real time step count values

Returns the step count accumulator value for the current day, refreshed each time the wristband detects new steps.

```swift
let op = fitnessDevice.getRealTimeStepValues
op.execute { (success) in
    if let stepCount : Int = op.returnInt {
        print("Step count: \(stepCount)")
    }
}
```

### Get History data (step count and sleep information)

Returns a dictionary with `Date` as keys and `HistoryDataEntry` as values, containing the daily steps, total slept time for the day. Also returns partial information, divided in 10 minute segments. 

```swift
if let op = fitnessDevice.getHistoryData
{
    op.execute { (success) in
        if success,
            let historyData = op.historyData
        {
        	// do something...
        }
    }
}
```

The `HistoryDataEntry` type is defined as follows:

```swift
public struct HistoryDataEntry {
    public var dailySteps : Int
    public var totalSlept : Int
    public var partials   : [Date: HistoryDataPartialEntry]
}
```

To interpret partial values refer to the `HistoryDataPartialEntry` that tracks partial steps values and a `datakind` value that represent the type of sleep recorded in that time window.
