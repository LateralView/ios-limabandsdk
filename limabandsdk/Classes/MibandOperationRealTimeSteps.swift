//
//  MibandOperationRealTimeSteps.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationRealTimeSteps: FitnessDeviceOperation
{
    let serviceUUID        = "FEE0"
    let characteristicUUID = "FF06"
    
    override func received(data: Data, fromCharacteristicUUID: String)
    {
        if fromCharacteristicUUID == characteristicUUID
        {
            // got a real time steps value
            let value : UInt32 = data.scanValue(start: 0, length: 4)
            if verbose {
                print(" - Real time steps value: \(value)")
            }
            self.returnValue = Int(value)
            self.handler?(true)
        }
    }
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)
        print("- Starting monitoring of real time steps values")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
        }
    }

    override func cancel(handler: @escaping OperationHandler)
    {
        super.cancel(handler: handler)
        print("- Stopping monitoring of real time steps values")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            peripheral.setNotifyValue(false, for: characteristic)
        }
    }

}
