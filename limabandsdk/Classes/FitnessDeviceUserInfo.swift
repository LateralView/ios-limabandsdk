//
//  FitnessDeviceUserInfo.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

public enum UserInfoGender {
    case male
    case female
}

public class FitnessDeviceUserInfo
{
    var gender      : UserInfoGender
    var birthDate   : Date
    var height      : Int
    var weight      : Int
    
    public init(gender: UserInfoGender, birthDate: Date, height: Int, weight: Int)
    {
        self.gender = gender
        self.birthDate = birthDate
        self.height = height
        self.weight = weight
    }
}
