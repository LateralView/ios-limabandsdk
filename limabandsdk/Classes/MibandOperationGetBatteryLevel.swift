//
//  MibandOperationGetBatteryLevel.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationGetBatteryLevel: FitnessDeviceOperation
{
    let serviceUUID        = "FEE0"
    let characteristicUUID = "FF0C"
    
    override func received(data: Data, fromCharacteristicUUID: String)
    {
        if fromCharacteristicUUID == characteristicUUID
        {
            let level : UInt8 = data.scanValue(start: 0, length: 1)

            let cycles : UInt16 = data.scanValue(start: 7, length: 2)
            let status : UInt8 = data.scanValue(start: 9, length: 1)
            LimaBandClient.log("Battery level:\(level), cycles:\(cycles), status:\(status)")
            
            self.returnValue = Int(level)

            self.handler?(true)
            self.handler = nil
        }
    }
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)

        guard fitnessDevice.isConnected else {
            LimaBandClient.error("Cannot perform action because it is disconnected")
            handler(false)
            return;
        }

        LimaBandClient.log("Getting battery level")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            peripheral.readValue(for: characteristic)
        }
    }
}
