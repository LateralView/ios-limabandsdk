//
//  FitnessDeviceOperationGetHistoryData.swift
//  Pods
//
//  Created by Leandro Tami on 4/27/17.
//
//

import Foundation

public enum HistoryDataKind {
    case deepSleep      // user was deeply asleep
    case lightSleep     // user was lightly sleeping
    case activity       // user was performing activity of some kind
    case notWearing     // user was not wearing the band
}

public struct HistoryDataPartialEntry {
    public var steps    : Int
    public var dataKind : HistoryDataKind
}

public struct HistoryDataEntry {
    public var dailySteps : Int
    public var partials   : [Date: HistoryDataPartialEntry]
}

public typealias HistoryData = [Date: HistoryDataEntry]

public class FitnessDeviceOperationGetHistoryData: FitnessDeviceOperation
{
    public var historyData : HistoryData?
}
