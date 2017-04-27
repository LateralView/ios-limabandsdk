//
//  FitnessDeviceOperationGetHistoryData.swift
//  Pods
//
//  Created by Leandro Tami on 4/27/17.
//
//

import Foundation

public typealias HistoryData = [Date: Int]

public class FitnessDeviceOperationGetHistoryData: FitnessDeviceOperation
{
    public var historyData : HistoryData?
}
