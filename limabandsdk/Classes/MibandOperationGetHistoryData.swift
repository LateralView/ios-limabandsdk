//
//  MibandOperationGetActivityData.swift
//  Lima
//
//  Created by Leandro Tami on 4/25/17.
//  Copyright © 2017 LateralView. All rights reserved.
//

import Foundation

class MibandOperationGetHistoryData: FitnessDeviceOperationGetHistoryData
{
    let serviceUUID                     = "FEE0"
    let activityCharacteristicUUID      = "FF07"
    let controlPointCharacteristicUUID  = "FF05"
    
    private var activityData                 : Data?
    private var activityDataReferenceDate    : Date?
    private var activityDataSummary          : HistoryData?
    private var activityDataBytesTransferred : Int = 0
    
    override func received(data: Data, fromCharacteristicUUID: String)
    {
        if fromCharacteristicUUID == activityCharacteristicUUID
        {
            let activityMetadataLength = 11
            if data.count == activityMetadataLength {
                receivedActivityMetadataValue(data)
            } else {
                receivedActivityDataValue(data)
            }
        }
    }
    
    override func execute(handler: @escaping OperationHandler)
    {
        super.execute(handler: handler)

        guard fitnessDevice.isConnected else {
            LimaBandClient.error("Cannot perform action because it is disconnected")
            handler(false)
            return;
        }
        
        LimaBandClient.log("Getting Activity Data")
        
        if let activityDataChar = self.characteristic(serviceUUID: serviceUUID, UUID: activityCharacteristicUUID),
            let controlPointChar = self.characteristic(serviceUUID: serviceUUID, UUID: controlPointCharacteristicUUID)
        {
            activityDataSummary = HistoryData()
            peripheral.setNotifyValue(true, for: activityDataChar)
            self.peripheral.writeValue(Data([0x06]), for: controlPointChar, type: .withResponse)
        }
    }
 
    func receivedActivityDataValue(_ value: Data)
    {
        activityData?.append(value)
    }
    
    func receivedActivityMetadataValue(_ value: Data)
    {
        // byte 0 is the data type: 1 means that each minute is represented by a triplet of bytes
        let dataType : UInt8 = value.scanValue(start: 0, length: 1)
        
        // byte 1 to 6 represent a timestamp
        let timestamp = Date.fromWristbandData(data: value.subdata(in: 1..<7))!
        
        // counter of all data held by the band
        //        let bytesPerMinute = (dataType == 0x1) ? 3 : 1
        //        let totalDataToRead : UInt16 = (value.scanValue(start: 7, length: 1) & 0xFF) | ((value.scanValue(start: 8, length: 1) & 0xFF) << 8)
        //        let fixedTotalDataToRead = Int(totalDataToRead) * bytesPerMinute
        
        // counter of this data block
        let dataUntilNextHeader : UInt16 = (value.scanValue(start: 9, length: 1) & 0xFF) | ((value.scanValue(start: 10, length: 1) & 0xFF) << 8)
        let fixedDataUntilNextHeader = dataUntilNextHeader * ((dataType == 1) ? 3 : 1);
        
        // we are starting a new block of data. Before that we process the previous one.
        if let previousData = activityData {
            // we have previous data from other blocks that need processing
            processActivityData(data: previousData)
            
            let timeDifference = 60 * 60 * 24 * 2 // two days
            if abs(timestamp.timeIntervalSinceNow) >= Double(timeDifference) {
                // this block is old enough to be acknowledged
                sendActivityAcknowledgement(
                    timestamp: timestamp,
                    byteCount: Int(fixedDataUntilNextHeader)
                )
            }
        }
        
        // now we start a new block for this segment
        activityData = Data()
        activityDataReferenceDate = timestamp
        
        if fixedDataUntilNextHeader == 0 {
            
            // this means we have read all available data, we should submit the summary
            activityData = nil
            activityDataReferenceDate = nil
            if let summary = activityDataSummary
            {
                self.historyData = summary
                self.handler?(true)
                self.handler = nil
            }
        }
    }
    
    func processActivityData(data: Data)
    {
        guard data.count % 3 == 0 else {
            LimaBandClient.error("Activity data block is not a multiple of 3!")
            return
        }
        
        guard activityDataSummary != nil else {
            LimaBandClient.error("Without an active summary!")
            return
        }
        
        guard var timestamp = activityDataReferenceDate else {
            LimaBandClient.error("Without a current timestamp!")
            return
        }
        
        let readingPeriodInSeconds : TimeInterval = 60
        
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        
        for i in stride(from:0, to: data.count, by: 3) {
            let category : Int8 = data.scanValue(start: i, length: 1)
            //            let intensity : UInt8 = data.scanValue(start: i+1, length: 1)
            let steps : UInt8 = data.scanValue(start: i+2, length: 1)
            
            let strippedTimeStamp = df.date(from: df.string(from: timestamp))!
            
            let dataKind = DataKindFor(value: category)
            
            if var previousEntry = activityDataSummary![strippedTimeStamp] {
                
                // there is already an entry for this timestamp
                previousEntry.steps = previousEntry.steps + Int(steps)
                previousEntry.dataKind = DataKindMax(
                    a: previousEntry.dataKind,
                    b: dataKind
                )
                activityDataSummary![strippedTimeStamp] = previousEntry
                
            } else {
                
                // this is the first entry for this timestamp
                let entry = HistoryDataEntry(
                    steps: Int(steps),
                    dataKind: dataKind
                )
                
                activityDataSummary![strippedTimeStamp] = entry
            }
            
            
            timestamp = timestamp.addingTimeInterval(readingPeriodInSeconds)
        }
    }
    
    private func DataKindFor(value: Int8) -> HistoryDataKind
    {
        switch value {
        case 4:
            return .deepSleep
        case 5:
            return .lightSleep
        case -1:
            return .activity
        default:
            return .notWearing
        }
    }

    private func DataKindMax(a: HistoryDataKind, b: HistoryDataKind) -> HistoryDataKind
    {
        if (a == .deepSleep) || (b == .deepSleep) {
            return .deepSleep
        } else if (a == .lightSleep) || (b == .lightSleep) {
            return .lightSleep
        } else if (a == .activity) || (b == .activity) {
            return .activity
        } else {
            return .notWearing
        }
    }
    
    private func sendActivityAcknowledgement(timestamp date: Date, byteCount: Int)
    {
        if let controlPointChar = self.characteristic(serviceUUID: serviceUUID, UUID: controlPointCharacteristicUUID)
        {
            LimaBandClient.log("Sending ACK for date:\(date), byteCount:\(byteCount)")
            var ackData = Data([0x0A])
            ackData.append(date.toWristbandData())
            ackData.append(Data([
                UInt8(byteCount & 0xff),
                UInt8((byteCount >> 8) & 0xff)
                ]))
            self.peripheral.writeValue(ackData, for: controlPointChar, type: .withResponse)
        }
    }
    
}
