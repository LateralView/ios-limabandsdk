//
//  FitnessDeviceOperation.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation
import CoreBluetooth

typealias OperationHandler = (_ success: Bool) -> Void

enum FitnessDeviceOperationType {
    case pair
    case vibrate
    case getDeviceInfo
    case setUserInfo
    case setDateTime
    case getHistoryData
    case getRealTimeStepValues
    case getBatteryLevel
}

class FitnessDeviceOperation
{
    var fitnessDevice: FitnessDevice

    var verbose            = false

    var peripheral : CBPeripheral {
        return fitnessDevice.device.peripheral
    }
    
    var returnValue: Any?
    
    var handler: OperationHandler!

    init(fitnessDevice: FitnessDevice) {
        self.fitnessDevice = fitnessDevice
    }
    
    func received(data: Data, fromCharacteristicUUID: String)
    {
    }
    
    func execute(handler: @escaping OperationHandler)
    {
        guard fitnessDevice.isConnected else {
            print("- Cannot perform action because it is disconnected")
            handler(false)
            return;
        }
        
        self.handler = handler
    }
    
    func cancel(handler: @escaping OperationHandler)
    {
        self.handler = nil
    }

    func characteristic(serviceUUID: String, UUID: String) -> CBCharacteristic?
    {    
        if let service = peripheral.services?.first(where: { $0.uuid.uuidString == serviceUUID } ),
            let characteristic = service.characteristics?.first(where: { $0.uuid.uuidString == UUID } )
        {
            return characteristic
        } else {
            return nil
        }
    }
}
