//
//  MibandDevice.swift
//  
//
//  Created by Leandro Tami on 4/21/17.
//
//

import Foundation

class MibandDevice: FitnessDevice
{
    static let namePrefix = "MI"

    override var deviceName  : String {
        return "Miband"
    }

    override init(withDevice device:BluetoothDevice)
    {
        super.init(withDevice: device)
        self.operations[.pair] = MibandOperationPair(fitnessDevice: self)
        self.operations[.vibrate] = MibandOperationVibrate(fitnessDevice: self)
        self.operations[.getDeviceInfo] = MibandOperationGetDeviceInfo(fitnessDevice: self)
        self.operations[.setUserInfo] = MibandOperationSetUserInfo(fitnessDevice: self)
        self.operations[.setDateTime] = MibandOperationSetDateTime(fitnessDevice: self)
        self.operations[.getHistoryData] = MibandOperationGetHistoryData(fitnessDevice: self)
        self.operations[.getRealTimeStepValues] = MibandOperationRealTimeSteps(fitnessDevice: self)
        self.operations[.getBatteryLevel] = MibandOperationGetBatteryLevel(fitnessDevice: self)
    }
    
    override func initialize(_ handler: @escaping InitializeHandler)
    {
        // first perform pairing
        self.pair.execute { (success) in
            if success {
                // then get device information
                self.getDeviceInfo.execute(handler: { (success) in
                    if success {
                        // finally set user information
                        self.setUserInfo.execute(handler: { (success) in
                            handler(success)
                        })
                    } else {
                        handler(false) // due to bad get device info
                    }
                })
            } else {
                handler(false) // due to bad pairing
            }
        }
    }
    
}
