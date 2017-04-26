//
//  MibandOperationSetUserInfo.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationSetUserInfo: FitnessDeviceOperation
{
    let serviceUUID        = "FEE0"
    let characteristicUUID = "FF04"

    override func received(data: Data, fromCharacteristicUUID: String)
    {
        // got user information set
        if fromCharacteristicUUID == characteristicUUID
        {
            if (data.count > 0) {
                
                if verbose {
                    let userID : UInt32 = data.scanValue(start: 0, length: 4)
                    let isMale : UInt8 = data.scanValue(start: 4, length: 1)
                    let age : UInt8 = data.scanValue(start: 5, length: 1)
                    let height : UInt8 = data.scanValue(start: 6, length: 1)
                    let weight : UInt8 = data.scanValue(start: 7, length: 1)
                    let alias : UInt32 = data.scanValue(start: 8, length: 4)
                    
                    print("Get User Information Received: \(data)")
                    print("\t User ID: \(userID)")
                    print("\t Is Male: \(isMale)")
                    print("\t Age: \(age)")
                    print("\t Height: \(height)")
                    print("\t Weight: \(weight)")
                    print("\t Alias: \(alias)")
                }
                
                self.handler?(true)
                self.handler = nil
                
            } else {
                print("Get User Information Received: \(data)")
            }
            
        }
    }
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)
        
        guard let userInfo = fitnessDevice.userInfo else {
            print("- Cannot set user information because it was not set")
            return
        }
        
        print("- Setting User Information")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            let uid     = Data([0xf6, 0xe4, 0x63, 0x5c])
            let gender  = Data([userInfo.gender == .male ? 1 : 0])
            let age     = Data([UInt8(userInfo.birthDate!.yearsSince)])
            let height  = Data([UInt8(userInfo.height!)])
            let weight  = Data([UInt8(userInfo.weight!)])
            let type    = Data([0])
            let name    = Data([0x5, 0x0, 0x31, 0x35, 0x35, 0x30, 0x30, 0x35, 0x30, 0x35])
            
            var packet = Data()
            packet.append(uid)
            packet.append(gender)
            packet.append(age)
            packet.append(height)
            packet.append(weight)
            packet.append(type)
            packet.append(name)
            packet.append(calculateCRC(data: packet))
            
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.writeValue(packet, for: characteristic, type: .withResponse)
            peripheral.readValue(for: characteristic)
        }
    }
    
    func calculateCRC(data: Data) -> UInt8
    {
        guard let addr = (fitnessDevice.deviceInfo as? MibandDeviceInfo)?.addressSuffix else {
            print("Cannot calculate crc because address is not available")
            return 0
        }
        
        var crc : UInt8 = 0
        for i in 0..<data.count {
            let byte : UInt8 = data.scanValue(start: i, length: 1)
            crc = crc ^ (byte & 0xff)
            
            for _ in 0..<8 {
                if (crc & UInt8(0x01)) != 0 {
                    crc = (crc >> 1) ^ UInt8(0x8c)
                } else {
                    crc = crc >> 1
                }
            }
        }
        
        // this xor with the last two bytes of the address is part of the standard
        crc = UInt8((UInt16(crc) ^ addr) & UInt16(0xff))
        
        return crc
        
    }
}
