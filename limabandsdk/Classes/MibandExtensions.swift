//
//  MibandExtensions.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

extension Date {
    
    static func fromWristbandData(data: Data) -> Date?
    {
        guard data.count == 6 else {
            return nil
        }
        
        let year : UInt8 = data.scanValue(start: 0, length: 1)
        let month : UInt8 = data.scanValue(start: 1, length: 1)
        let day : UInt8 = data.scanValue(start: 2, length: 1)
        let hour : UInt8 = data.scanValue(start: 3, length: 1)
        let minutes : UInt8 = data.scanValue(start: 4, length: 1)
        let seconds : UInt8 = data.scanValue(start: 5, length: 1)
        
        var components = DateComponents()
        components.year = 2000 + Int(year)
        components.month = Int(month) + 1 // given value is zero-based
        components.day = Int(day)
        components.hour = Int(hour)
        components.minute = Int(minutes)
        components.second = Int(seconds)
        
        let cal = Calendar.current
        return cal.date(from: components)
    }
    
    func toWristbandData() -> Data
    {
        let calendar = Calendar.current
        let year : UInt8 = UInt8(calendar.component(.year, from: self) - 2000)
        let month : UInt8 = UInt8(calendar.component(.month, from: self) - 1)
        let day : UInt8 = UInt8(calendar.component(.day, from: self))
        let hour : UInt8 = UInt8(calendar.component(.hour, from: self))
        let minutes : UInt8 = UInt8(calendar.component(.minute, from: self))
        let seconds : UInt8 = UInt8(calendar.component(.second, from: self))
        
        return Data([year, month, day, hour, minutes, seconds])
    }
    
}
