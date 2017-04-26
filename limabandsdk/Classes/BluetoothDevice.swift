//
//  BluetoothDevice.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation
import CoreBluetooth

public class BluetoothDevice
{
    public var name     : String
    public var rssi     : Int

    var centralManager  : CBCentralManager
    var peripheral      : CBPeripheral
    
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
