//
//  LimaBandClient.swift
//  Lima
//
//  Created by Leandro Tami on 4/20/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

public typealias ScanHandler       = (_ success: Bool, _ devices: [BluetoothDevice]?) -> Void
public typealias ConnectHandler    = (_ success: Bool, _ fitnessDevice: FitnessDevice?) -> Void
public typealias DisconnectHandler = (_ fitnessDevice: FitnessDevice?) -> Void

public class LimaBandClient: FitnessDeviceManagerDelegate
{

    public static let shared    = LimaBandClient()
    public static var verbose   = false
    
    private var manager         : FitnessDeviceManager!

    public var isBluetoothAvailable : Bool {
        return manager.isBluetoothAvailable
    }

    public var currentDevice : FitnessDevice? {
        return manager.fitnessDevice
    }
    
    public var rssiFilterValue: Double = -80.0 {
        didSet {
            manager.rssiFilterValue = rssiFilterValue
        }
    }
    
    private var scanHandler       : ScanHandler?
    private var connectHandler    : ConnectHandler?
    private var disconnectHandler : DisconnectHandler?
    
    private init()
    {
    }

    static func log(_ text: String) {
        if LimaBandClient.verbose {
            print("[-] LimaBandClient: \(text)")
        }
    }

    static func error(_ text: String) {
        print("[X] LimaBandClient: \(text)")
    }

    public func start()
    {
        manager = FitnessDeviceManager()
        manager.delegate = self
    }
    
    public func scan(filterBySignalLevel: Bool, handler: @escaping ScanHandler)
    {
        // wait some time until Bluetooth is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scanHandler = handler
            self.manager.scan(filterBySignalLevel: filterBySignalLevel)
        }
    }
    
    public func connect(device: BluetoothDevice, handler: @escaping ConnectHandler)
    {
        self.connectHandler = handler
        manager.connect(toDevice: device)
    }
    
    public func notifyDisconnection(handler: @escaping DisconnectHandler)
    {
        self.disconnectHandler = handler
    }
    
    // MARK: - FitnessDeviceManagerDelegate
    
    func didFind(success: Bool, devices: [BluetoothDevice])
    {
        scanHandler?(success, devices)
        scanHandler = nil
    }
    
    func didConnect(success: Bool, fitnessDevice: FitnessDevice?)
    {
        connectHandler?(success, fitnessDevice)
        connectHandler = nil
    }

    func didDisconnect(fitnessDevice: FitnessDevice?)
    {
        scanHandler?(false, nil)
        scanHandler = nil
        disconnectHandler?(fitnessDevice)
    }

}
