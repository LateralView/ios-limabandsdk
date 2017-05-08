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
    @IBOutlet weak var stepCount: UILabel!

    var fitnessDevice: FitnessDevice!
    var dailyGoalLastNotification : Date?

    
    override func viewWillAppear(_ animated: Bool)
    {
        let op = fitnessDevice.getRealTimeStepValues
        op.execute { (success) in
            if let stepCount : Int = op.returnInt {
                self.stepCount.text = "\(stepCount)"
                self.checkDailyGoal(stepCount: stepCount)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        let op = fitnessDevice.getRealTimeStepValues
        op.cancel { (success) in
        }
    }
    
    func checkDailyGoal(stepCount: Int)
    {
        let dailyGoal = 5800
        
        let goalSuccess = stepCount > dailyGoal
        let now = Date()
        if goalSuccess && (dailyGoalLastNotification == nil || dailyGoalLastNotification!.day != now.day)
        {
            dailyGoalLastNotification = now
            let notification = UILocalNotification()
            notification.fireDate = now
            notification.alertBody = "You reached your daily goal of \(dailyGoal) steps!"
            notification.alertAction = "Great!"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
            
        }
    }
    
}
