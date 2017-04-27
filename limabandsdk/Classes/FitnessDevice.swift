//
//  FitnessDevice.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation
import CoreBluetooth

typealias ServiceScanHandler = (Void) -> Void

public class FitnessDevice: NSObject, CBPeripheralDelegate
{
    public var deviceInfo  : FitnessDeviceInfo?
    public var userInfo    : FitnessDeviceUserInfo?

    var device      : BluetoothDevice
    var operations  = [FitnessDeviceOperationType: FitnessDeviceOperation]()
    
    var identifier : String {
        return device.identifier
    }

    var deviceName  : String {
        return "Unknown"
    }
    
    var isConnected     : Bool {
        return device.peripheral.state == .connected
    }
    
    private var serviceScanHandler      : ServiceScanHandler?
    private var remainingServicesToScan : Int = 0
    
    // MARK - Initializer and methods

    init(withDevice device:BluetoothDevice)
    {
        self.device = device
        super.init()
        device.peripheral.delegate = self
    }
    
    func scan(_ handler: @escaping ServiceScanHandler)
    {
        guard isConnected else {
            print("- Cannot scan because it is disconnected")
            handler()
            return;
        }
        
        print("- Scanning services for this device")
        self.serviceScanHandler = handler
        device.peripheral.discoverServices(nil)
    }
    
    func disconnect()
    {
    }
    
    // MARK: - CBPeripheralDelegate
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        if let services = peripheral.services {
            remainingServicesToScan = services.count
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        remainingServicesToScan = remainingServicesToScan - 1
        if (remainingServicesToScan == 0) {
            // scanning of services and characteristics has ended
            // we are ready to use the device
            print("- Scan complete")
            self.serviceScanHandler?()
            self.serviceScanHandler = nil
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        guard let value = characteristic.value else {
            return
        }
        
        operations.values.forEach { (operation) in
            operation.received(
                data: value,
                fromCharacteristicUUID: characteristic.uuid.uuidString
            )
        }
    }
        
}
