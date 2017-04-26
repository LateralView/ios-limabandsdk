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
            if verbose {
                //        let timestamp = value.subdata(in: 1..<7)
                let cycles : UInt16 = data.scanValue(start: 7, length: 2)
                let status : UInt8 = data.scanValue(start: 9, length: 1)
                print ("- Battery level:\(level), cycles:\(cycles), status:\(status)")
            }
            
            self.returnValue = Int(level)

            self.handler?(true)
            self.handler = nil
        }
    }
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)
        
        print("- Getting battery level")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            peripheral.readValue(for: characteristic)
        }
    }
}
