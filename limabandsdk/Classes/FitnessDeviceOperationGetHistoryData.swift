//
//  FitnessDeviceOperationGetHistoryData.swift
//  Pods
//
//  Created by Leandro Tami on 4/27/17.
//
//

import Foundation

public enum HistoryDataKind: Int {
    case notWearing = 0    // user was not wearing the band
    case activity   = 1    // user was performing activity of some kind
    case lightSleep = 2    // user was lightly sleeping
    case deepSleep  = 3    // user was deeply asleep
}

public struct HistoryDataPartialEntry {
    public var steps    : Int
    public var dataKind : HistoryDataKind
}

public struct HistoryDataEntry {
    public var dailySteps : Int
    public var totalSlept : Int
    public var partials   : [Date: HistoryDataPartialEntry]
}

public typealias HistoryData = [Date: HistoryDataEntry]

public class FitnessDeviceOperationGetHistoryData: FitnessDeviceOperation
{
    public var historyData : HistoryData?
}
