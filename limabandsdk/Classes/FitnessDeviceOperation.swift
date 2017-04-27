//
//  FitnessDeviceOperation.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation
import CoreBluetooth

public typealias OperationHandler = (_ success: Bool) -> Void

public class FitnessDeviceOperation
{
    public var verbose            = false
    public var returnValue: Any?

    var fitnessDevice: FitnessDevice
    var handler: OperationHandler!
    
    var peripheral : CBPeripheral {
        return fitnessDevice.device.peripheral
    }

    init(fitnessDevice: FitnessDevice) {
        self.fitnessDevice = fitnessDevice
    }
    
    func received(data: Data, fromCharacteristicUUID: String)
    {
    }
    
    public func execute(handler: @escaping OperationHandler)
    {
        self.handler = handler
    }
    
    public func cancel(handler: @escaping OperationHandler)
    {
        self.handler?(false)
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
