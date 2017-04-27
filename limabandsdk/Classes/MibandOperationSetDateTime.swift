//
//  MibandOperationSetDateTime.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationSetDateTime: FitnessDeviceOperation
{
    let serviceUUID        = "FEE0"
    let characteristicUUID = "FF0A"
    
    override func received(data: Data, fromCharacteristicUUID: String)
    {
        if fromCharacteristicUUID == characteristicUUID
        {
            self.handler?(true)
            self.handler = nil
        }
    }

    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)
        
        guard fitnessDevice.isConnected else {
            LimaBandClient.error("Cannot perform action because it is disconnected")
            handler(false)
            return;
        }

        LimaBandClient.log("Setting date and time")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            let packet = Date().toWristbandData()
            peripheral.writeValue(packet, for: characteristic, type: .withResponse)
            peripheral.readValue(for: characteristic)
        }
        
    }
    
}
