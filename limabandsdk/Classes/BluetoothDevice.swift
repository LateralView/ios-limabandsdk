//
//  BluetoothDevice.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDevice
{
    var centralManager  : CBCentralManager
    var peripheral      : CBPeripheral
    var name            : String
    var rssi            : Int
    
    var identifier      : String {
        return peripheral.identifier.uuidString
    }
    
    init(centralManager: CBCentralManager, peripheral: CBPeripheral, name: String, rssi: Int)
    {
        self.centralManager = centralManager
        self.peripheral = peripheral
        self.name = name
        self.rssi = rssi
    }
    
}
