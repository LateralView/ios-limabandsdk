//
//  FitnessDeviceDummyOperation.swift
//  Lima
//
//  Created by Leandro Tami on 4/24/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class FitnessDeviceDummyOperation: FitnessDeviceOperation
{
    
    override func execute(handler: @escaping OperationHandler)
    {
        handler(true)
    }
    
}
