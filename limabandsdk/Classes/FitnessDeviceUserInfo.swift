//
//  FitnessDeviceUserInfo.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

enum UserInfoGender {
    case male
    case female
}

class FitnessDeviceUserInfo
{
    var gender      : UserInfoGender!
    var birthDate   : Date!
    var height      : Int!
    var weight      : Int!
    
}
