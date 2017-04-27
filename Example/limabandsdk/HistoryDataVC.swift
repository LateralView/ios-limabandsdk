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
    
    var historyData  : [String: Int]!
    var sortedKeys   =  [String]()
    
    override func viewDidLoad() {
        let op = fitnessDevice.getHistoryData
        op.execute { (success) in
            if success,
                let data = op.returnValue as? [String: Int]
            {
                self.historyData = data
                self.sortedKeys = self.historyData.keys.sorted()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sortedKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let key = sortedKeys[indexPath.row]
        let value = historyData[key]
        
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = "\(value!)"
        
        return cell
    }
    
}

