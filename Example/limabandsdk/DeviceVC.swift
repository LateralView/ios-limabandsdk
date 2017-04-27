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
    @IBOutlet weak var stackView: UIStackView!

    var bluetoothDevice: BluetoothDevice!
    var fitnessDevice: FitnessDevice?
    
    override func viewDidLoad()
    {
        stackView.isUserInteractionEnabled = false
        stackView.alpha = 0.3
        LimaBandClient.shared.connect(
            device: bluetoothDevice) { (success, fitnessDevice) in
                
                if let fitnessDevice = fitnessDevice
                {
                    print("- Connected to fitness device")
                    self.fitnessDevice = fitnessDevice
                    self.stackView.isUserInteractionEnabled = true
                    self.stackView.alpha = 1
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
            if success {
                print("Wristband just vibrated!")
            }
        })
    }
    
    @IBAction func doGetDeviceInfo(_ sender: Any)
    {
        fitnessDevice?.getDeviceInfo.execute(handler: { (success) in
            if success {
                print("Got device info successfully")
            }
        })
    }
    
    @IBAction func doSetUserInfo(_ sender: Any)
    {
        fitnessDevice?.userInfo = FitnessDeviceUserInfo(
            gender: .female,
            birthDate: Date(),
            height: 173,
            weight: 73
        )
        
        fitnessDevice?.setUserInfo.execute(handler: { (success) in
            if success {
                print("User Information has been set successfully")
            }
        })
    }
}
