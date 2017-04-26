//
//  FitnessDeviceFactory.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class FitnessDeviceFactory {
    
    static func validDevicePrefixes() -> [String]
    {
        return [
            MibandDevice.namePrefix
        ]
    }
    
    static func createFitnessDevice(fromBluetoothDevice device: BluetoothDevice) -> FitnessDevice?
    {
        if device.name.hasPrefix(MibandDevice.namePrefix) {
            return MibandDevice(withDevice: device)
        }
        
        return nil
    }
    
}
