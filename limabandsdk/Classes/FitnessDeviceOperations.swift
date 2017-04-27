//
//  FitnessDeviceOperations.swift
//  Lima
//
//  Created by Leandro Tami on 4/24/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

enum FitnessDeviceOperationType {
    case pair
    case vibrate
    case getDeviceInfo
    case setUserInfo
    case setDateTime
    case getHistoryData
    case getRealTimeStepValues
    case getBatteryLevel
}

public extension FitnessDevice
{
    public var dummy : FitnessDeviceOperation {
        return FitnessDeviceDummyOperation(fitnessDevice: self)
    }
        
    public var vibrate : FitnessDeviceOperation {
        return operations[.vibrate] ?? dummy
    }
    
    public var getDeviceInfo : FitnessDeviceOperation {
        return operations[.getDeviceInfo] ?? dummy
    }
    
    public var setUserInfo: FitnessDeviceOperation {
        return operations[.setUserInfo] ?? dummy
    }
    
    public var setDateTime: FitnessDeviceOperation {
        return operations[.setDateTime] ?? dummy
    }
    
    public var getHistoryData: FitnessDeviceOperation {
        return operations[.getHistoryData] ?? dummy
    }
    
    public var getRealTimeStepValues: FitnessDeviceOperation {
        return operations[.getRealTimeStepValues] ?? dummy
    }
    
    public var getBatteryLevel: FitnessDeviceOperation {
        return operations[.getBatteryLevel] ?? dummy
    }
    
}
