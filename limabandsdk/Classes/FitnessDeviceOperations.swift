//
//  FitnessDeviceOperations.swift
//  Lima
//
//  Created by Leandro Tami on 4/24/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

extension FitnessDevice
{
    var dummy : FitnessDeviceOperation {
        return FitnessDeviceDummyOperation(fitnessDevice: self)
    }
    
    var pair : FitnessDeviceOperation {
        return operations[.pair] ?? dummy
    }
    
    var vibrate : FitnessDeviceOperation {
        return operations[.vibrate] ?? dummy
    }
    
    var getDeviceInfo : FitnessDeviceOperation {
        return operations[.getDeviceInfo] ?? dummy
    }
    
    var setUserInfo: FitnessDeviceOperation {
        return operations[.setUserInfo] ?? dummy
    }
    
    var setDateTime: FitnessDeviceOperation {
        return operations[.setDateTime] ?? dummy
    }
    
    var getHistoryData: FitnessDeviceOperation {
        return operations[.getHistoryData] ?? dummy
    }
    
    var getRealTimeStepValues: FitnessDeviceOperation {
        return operations[.getRealTimeStepValues] ?? dummy
    }
    
    var getBatteryLevel: FitnessDeviceOperation {
        return operations[.getBatteryLevel] ?? dummy
    }
    
}
