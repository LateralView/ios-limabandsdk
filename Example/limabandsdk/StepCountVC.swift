//
//  StepCountVC.swift
//  limabandsdk
//
//  Created by Leandro Tami on 4/26/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import limabandsdk

class StepCountVC: UIViewController
{
    var fitnessDevice: FitnessDevice!
    
    @IBOutlet weak var stepCount: UILabel!
    
    override func viewWillAppear(_ animated: Bool)
    {
        let op = fitnessDevice.getRealTimeStepValues
        op.execute { (success) in
            if let value = op.returnInt {
                self.stepCount.text = "\(value)"
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        let op = fitnessDevice.getRealTimeStepValues
        op.cancel { (success) in
        }
    }
    
}
