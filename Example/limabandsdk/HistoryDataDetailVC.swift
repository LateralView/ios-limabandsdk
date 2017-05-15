//
//  HistoryDataDetailVC.swift
//  limabandsdk
//
//  Created by Leandro Tami on 5/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import limabandsdk

class HistoryDataDetailVC: UITableViewController
{
    var entry: HistoryDataEntry!
    var sortedDates   =  [Date]()
    
    override func viewDidLoad() {
        self.sortedDates = entry.partials.keys.sorted()
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.sortedDates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let key = self.sortedDates[indexPath.row]
        let partialEntry = entry.partials[key]!
        
        let df = DateFormatter()
        df.dateFormat = "HHmm"
        cell.textLabel?.text = df.string(from: key)
        
        let steps = partialEntry.steps
        cell.detailTextLabel?.text = "Steps: \(steps)"
        
        return cell
    }
    
}
