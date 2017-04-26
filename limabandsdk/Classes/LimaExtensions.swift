//
//  LimaExtensions.swift
//  Lima
//
//  Created by Leandro Tami on 3/12/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

extension Data
{
    func scanValue<T>(start: Int, length: Int) -> T {
        return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }

    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Date
{
    var yearsSince : Int {
        let calendar : Calendar! = Calendar(identifier: .gregorian)
        let ageComponents = calendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year!
    }
    
    var simple : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
}
