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
                    print("- Connected to fitness device, initializing")
                    fitnessDevice.initialize {
                        print("- Fitness device is connected and initialized.")
                        self.fitnessDevice = fitnessDevice
                        self.stackView.isUserInteractionEnabled = true
                        self.stackView.alpha = 1
                    }
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
    
    @IBAction func doSetDateTime(_ sender: Any)
    {
        fitnessDevice?.setDateTime.execute(handler: { (success) in
            if (success) {
                print ("Did set date and time successfully")
            }
        })
    }
    
    @IBAction func doGetBatteryLevel(_ sender: Any)
    {
        if let op = fitnessDevice?.getBatteryLevel
        {
            op.execute(handler: { (success) in
                
                guard let batteryLevel = op.returnValue as? Int else {
                    return
                }
                print ("Battery level is \(batteryLevel)")
            })
        }
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
