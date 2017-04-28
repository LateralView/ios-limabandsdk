//
//  FitnessDevice.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation
import CoreBluetooth

typealias ServiceScanHandler = (_ success: Bool) -> Void

public typealias InitializeHandler = (_ success: Bool) -> Void

public class FitnessDevice: NSObject, CBPeripheralDelegate
{
    public var deviceInfo  : FitnessDeviceInfo?
    public var userInfo    : FitnessDeviceUserInfo?

    public var identifier : String {
        return device.identifier
    }
    
    public var deviceName  : String {
        return "Unknown"
    }

    var device          : BluetoothDevice
    var isConnected     = false {
        didSet {
            if !isConnected {
                disconnect()
            }
        }
    }
    
    var operations  = [FitnessDeviceOperationType: FitnessDeviceOperation]()
    
    private var serviceScanHandler      : ServiceScanHandler?
    private var remainingServicesToScan : Int = 0
    
    // MARK - Initializer and methods

    init(withDevice device:BluetoothDevice)
    {
        self.device = device
        super.init()
        device.peripheral.delegate = self
    }
    
    func scanServices(_ handler: @escaping ServiceScanHandler)
    {
        guard device.peripheral.state == .connected else {
            LimaBandClient.error("Cannot scan because it is disconnected")
            handler(false)
            return;
        }
        
        LimaBandClient.log("Scanning services for this device")
        self.serviceScanHandler = handler
        device.peripheral.discoverServices(nil)
    }
    
    public func initialize(_ handler: @escaping InitializeHandler)
    {
        handler(true)
    }
    
    func disconnect()
    {
        // cancelling all ongoing operations
        operations.values.forEach { (operation) in
            operation.cancel(handler: { _ in })
        }
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
            LimaBandClient.log("Scan complete")
            self.serviceScanHandler?(true)
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
