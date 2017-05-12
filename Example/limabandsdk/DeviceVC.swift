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
                    // Set User Info. This is important data about the user
                    // that is required for initializing certain wristbands.
                    fitnessDevice.userInfo = FitnessDeviceUserInfo(
                        gender: .female,
                        birthDate: Date(),
                        height: 173,
                        weight: 73
                    )

                    print("Connected to fitness device, initializing")
                    fitnessDevice.initialize { success in
                        if (success) {
                            print("Fitness device is connected and initialized.")
                            self.fitnessDevice = fitnessDevice
                        } else {
                            print("Failed to initialize fitness device")
                        }
                        self.stackView.isUserInteractionEnabled = true
                        self.stackView.alpha = 1
                    }
                }
        }
        
        LimaBandClient.shared.notifyDisconnection { (fitnessDevice) in
            
            // band got disconnected
            let alert = UIAlertController(
                title: "Band disconnected",
                message: "The wristband became disconnected",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? StepCountVC
        {
            vc.fitnessDevice = self.fitnessDevice
        }
        else if let vc = segue.destination as? HistoryDataVC
        {
            vc.fitnessDevice = self.fitnessDevice
        }
    }
    
    @IBAction func doVibrate(_ sender: Any)
    {
        fitnessDevice?.vibrate.execute(handler: { (success) in
            if success {
                self.alert("Wristband should be vibrating right now")
            }
        })
    }
    
    @IBAction func doGetDeviceInfo(_ sender: Any)
    {
        fitnessDevice?.getDeviceInfo.execute(handler: { (success) in
            if success {
                self.alert("Got device info successfully")
            }
        })
    }
    
    @IBAction func doSetDateTime(_ sender: Any)
    {
        fitnessDevice?.setDateTime.execute(handler: { (success) in
            if (success) {
                self.alert("Date and time set successfully")
            }
        })
    }
    
    @IBAction func doGetBatteryLevel(_ sender: Any)
    {
        if let op = fitnessDevice?.getBatteryLevel
        {
            op.execute(handler: { (success) in
                
                guard let batteryLevel = op.returnInt else {
                    return
                }
                self.alert("Battery level is \(batteryLevel)")
            })
        }
    }
    
    @IBAction func doSetUserInfo(_ sender: Any)
    {
        fitnessDevice?.setUserInfo.execute(handler: { (success) in
            if success {
                self.alert("User Information has been set successfully")
            }
        })
    }
}
