//
//  DeviceVC.swift
//  limabandsdk
//
//  Created by Leandro Tami on 4/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import limabandsdk

class DeviceVC: UIViewController
{
    var bluetoothDevice: BluetoothDevice!
    var fitnessDevice: FitnessDevice?
    
    override func viewDidLoad()
    {
        LimaBandClient.shared.connect(
            device: bluetoothDevice) { (success, fitnessDevice) in
                
                if let fitnessDevice = fitnessDevice
                {
                    print("Connected to fitness device")
                    self.fitnessDevice = fitnessDevice
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? StepCountVC
        {
            vc.fitnessDevice = self.fitnessDevice
        }
    }
    
    @IBAction func doVibrate(_ sender: Any)
    {
        fitnessDevice?.vibrate.execute(handler: { (success) in
            print("Wristband just vibrated!")
        })
    }
    
}
