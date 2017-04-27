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
        self.operations[.getHistoryData] = MibandOperationGetActivityData(fitnessDevice: self)
        self.operations[.getRealTimeStepValues] = MibandOperationRealTimeSteps(fitnessDevice: self)
        self.operations[.getBatteryLevel] = MibandOperationGetBatteryLevel(fitnessDevice: self)
    }
    
    override func initialize(_ handler: @escaping InitializeHandler)
    {
        if let op = self.operations[.pair] {
            op.execute { (success) in
                handler()
            }            
        }
    }
    
}
