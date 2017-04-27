//
//  MibandOperationGetDeviceInfo.swift
//  Lima
//
//  Created by Leandro Tami on 4/24/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationGetDeviceInfo: FitnessDeviceOperation
{
    let serviceUUID        = "FEE0"
    let characteristicUUID = "FF01"
    
    override func received(data: Data, fromCharacteristicUUID: String)
    {
        if fromCharacteristicUUID == characteristicUUID
        {
            // got device information
            let deviceID2 : UInt16 = data.scanValue(start: 2, length: 2)
            
            if verbose {
                let deviceID1 : UInt32 = data.scanValue(start: 0, length: 4)
                let profileVersion : UInt32 = data.scanValue(start: 4, length: 4)
                let feature : UInt16 = data.scanValue(start: 8, length: 2)
                let appearance : UInt16 = data.scanValue(start: 10, length: 2)
                let hardwareVersion : UInt16 = data.scanValue(start: 12, length: 2)
                let firmwareVersion : UInt16 = data.scanValue(start: 14, length: 2)
                
                print("Get Device Information Received: \(data)")
                print("\t Device ID1: \(deviceID1)")
                print("\t Device ID2: \(deviceID2)")
                print("\t Profile Version: \(profileVersion)")
                print("\t Feature: \(feature)")
                print("\t Appearance: \(appearance)")
                print("\t Hardware Version: \(hardwareVersion)")
                print("\t Firmware Version: \(firmwareVersion)")
            }
            
            let addressSuffix : UInt16 = (deviceID2 << 8) | (deviceID2 >> 8)
            
            // set the miband device info
            if fitnessDevice.deviceInfo == nil {
                fitnessDevice.deviceInfo = MibandDeviceInfo()
            }
            (fitnessDevice.deviceInfo as? MibandDeviceInfo)?.addressSuffix = addressSuffix
            
            self.handler?(true)
            self.handler = nil
        }
    }
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)

        guard fitnessDevice.isConnected else {
            print("- Cannot perform action because it is disconnected")
            handler(false)
            return;
        }

        print("- Getting Device Information")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
        }
        
    }

}
