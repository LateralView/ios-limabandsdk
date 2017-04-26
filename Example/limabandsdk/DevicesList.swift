//
//  DevicesList.swift
//  limabandsdk
//
//  Created by leandrinux on 04/26/2017.
//  Copyright (c) 2017 leandrinux. All rights reserved.
//

import UIKit
import limabandsdk

class DevicesList: UITableViewController {
    
    var devices = [BluetoothDevice]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadDevices()
    }

    @IBAction func doSearch(_ sender: Any) {
        loadDevices()
    }
    
    func loadDevices()
    {
        LimaBandClient.shared.scan(filterBySignalLevel: false) { (success, devices) in
            
            if let devices = devices {
                self.devices = devices
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let device = self.devices[indexPath.row]
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = "RSSI: \(device.rssi)"
        return cell
    }

}

