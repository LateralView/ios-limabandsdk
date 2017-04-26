//
//  MibandOperationPair.swift
//  Lima
//
//  Created by Leandro Tami on 4/21/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationPair: FitnessDeviceOperation
{
    let serviceUUID        = "FEE0"
    let characteristicUUID = "FF0F"

    override func received(data: Data, fromCharacteristicUUID: String)
    {
        if fromCharacteristicUUID == characteristicUUID
        {
            // got a pairing notification response
            if data.elementsEqual([0x02]) {
                // successful pairing
                print("- Successfully paired")
                self.handler?(true)
                self.handler = nil
            }
        }
    }
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)
        
        print("- Asking for device pairing")
        
        if let characteristic = self.characteristic(serviceUUID: serviceUUID, UUID: characteristicUUID)
        {
            peripheral.setNotifyValue(true, for: characteristic)
            let data = Data([0x02])
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            peripheral.readValue(for: characteristic)
        }
        
    }

}
