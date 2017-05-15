//
//  HistoryDataVC.swift
//  limabandsdk
//
//  Created by Leandro Tami on 4/27/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import limabandsdk

class HistoryDataVC: UITableViewController
{
    var fitnessDevice: FitnessDevice!
    
    var historyData  : HistoryData!
    var sortedDates   =  [Date]()
    
    override func viewDidLoad() {
        if let op = fitnessDevice.getHistoryData
        {
            op.execute { (success) in
                if success,
                    let historyData = op.historyData
                {
                    self.historyData = historyData
                    self.sortedDates = self.historyData.keys.sorted()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? HistoryDataDetailVC,
            let indexPath = tableView.indexPathForSelectedRow
        {
            let key = self.sortedDates[indexPath.row]
            let entry = historyData[key]
            vc.entry = entry
        }
    }
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sortedDates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let date = sortedDates[indexPath.row]
        let df = DateFormatter()
        df.dateStyle = .short
        cell.textLabel?.text = df.string(from: date)

        if let value = historyData[date] {
            
            cell.detailTextLabel?.text = "Steps:\(value.dailySteps), Sleep:\(value.totalSlept)"
        }
        return cell
    }
    
    
    
}

