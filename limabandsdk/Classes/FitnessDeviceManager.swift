//
//  FitnessDeviceManager.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol FitnessDeviceManagerDelegate: class
{
    func didFind(success: Bool, devices: [BluetoothDevice])
    func didConnect(success: Bool, fitnessDevice: FitnessDevice?)
    func didDisconnect()
}

class FitnessDeviceManager: NSObject, CBCentralManagerDelegate
{
    let rssiFilterValue             = -70.0
    
    weak var delegate               : FitnessDeviceManagerDelegate?
    var fitnessDevice               : FitnessDevice?
    private var centralManager      : BluetoothManager!
    private var currentPeripheral   : CBPeripheral?
    private var scanResults         = [BluetoothDevice]()
    private var filterBySignalLevel = false

    var isBluetoothAvailable : Bool {
        return centralManager.state == .poweredOn
    }

    override init()
    {
        super.init()
        self.centralManager = BluetoothManager(delegate: self, queue: nil, options: nil)
        self.centralManager.delegate = self
    }
    
    func scan(filterBySignalLevel: Bool)
    {
        guard centralManager.state == .poweredOn else {
            print("- Cannot find wristbands, bluetooth is in state \(centralManager.state.rawValue)")
            return
        }
            
        print ("- Wristband search started")
        scanResults = [BluetoothDevice]()
        self.filterBySignalLevel = filterBySignalLevel
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        let dispatchTime = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            print ("- Wristband search stopped")
            self.centralManager.stopScan()
            self.delegate?.didFind(success: true, devices: self.scanResults)
        }
    }
    
    func connect(toDevice device:BluetoothDevice)
    {
        print("- Connecting to \(device.identifier)")
        
        let connectionTimeout = 10
        
        // attempt to connect
        centralManager.connect(device.peripheral, options: nil)

        // wait 10 seconds. If still trying to connect then cancel connection, return error
        let dispatchTime = DispatchTime.now() + .seconds(connectionTimeout)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            if (self.fitnessDevice == nil) {
                print("- Failed to connect to \(device.identifier)")
                self.centralManager.cancelPeripheralConnection(device.peripheral)
                self.fitnessDevice = nil
                self.delegate?.didConnect(success: false, fitnessDevice: nil)
            }
        }
        
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        if central.state != .poweredOn {
            self.fitnessDevice?.disconnect()
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber)
    {
        
        // extract information needed for identification
        let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool
        let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        
        // verify the information matches the identification criteria
        let prefixes = FitnessDeviceFactory.validDevicePrefixes()
        let isValidName = prefixes.index { (prefix) -> Bool in
            return localName?.hasPrefix(prefix) ?? false
        } != nil
        let isCloseEnough = RSSI.doubleValue >= rssiFilterValue
        let passesSignalFilter = ((filterBySignalLevel && isCloseEnough) || !filterBySignalLevel)
        let isValidDevice = (isConnectable == true) && isValidName && passesSignalFilter
        
        if isValidName && !passesSignalFilter {
            print("Found \(peripheral.identifier.uuidString) but it is too far away (\(RSSI.doubleValue))")
        }
        
        if isValidDevice {
            
            // verify if this band has been detected before
            let index = scanResults.index(where: { $0.peripheral.identifier == peripheral.identifier } )
            if index == nil {
                // this is a new wristband
                let device = BluetoothDevice(
                    centralManager: central,
                    peripheral: peripheral,
                    name: localName ?? "",
                    rssi: Int(RSSI)
                )
                scanResults.append(device)
            }
            
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        // we have connected successfully.
        // find the wristband object for this peripheral and set it as the current wristband
        if let bluetoothDevice = scanResults.first(where: { $0.peripheral == peripheral }),
            let fitnessDevice = FitnessDeviceFactory.createFitnessDevice(fromBluetoothDevice: bluetoothDevice)
        {
            self.fitnessDevice = fitnessDevice
            print("- Connected to \(peripheral.identifier)")
            
            fitnessDevice.scan {
                self.delegate?.didConnect(success: true, fitnessDevice: fitnessDevice)
            }
            
        }
    }
    
    
}
