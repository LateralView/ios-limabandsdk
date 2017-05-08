//
//  Extensions.swift
//  limabandsdk
//
//  Created by Leandro Tami on 4/27/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIViewController
{
    
    func alert(_ text: String)
    {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension Date {

    var day : Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.day, from: self)
    }

}
