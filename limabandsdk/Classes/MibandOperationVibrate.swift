//
//  MibandOperationVibrate.swift
//  Lima
//
//  Created by Leandro Tami on 4/24/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationVibrate: FitnessDeviceOperation
{
    let serviceUUID        = "1802"
    let characteristicUUID = "2A06"
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)
        
        guard fitnessDevice.isConnected else {
            LimaBandClient.error("Cannot perform action because it is disconnected")
            handler(false)
            return;
        }

        LimaBandClient.log("Vibrating wristband")
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            let data = Data([0x04])
            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            self.handler?(true)
            self.handler = nil
        }
        
    }
    
}
