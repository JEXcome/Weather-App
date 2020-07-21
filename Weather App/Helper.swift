//
//  Extensions.swift
//  Weather App
//
//  Created by (-.-) on 17.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation
import UIKit

import SwiftyJSON


public typealias RichObject = SwiftyJSON.JSON


extension StringProtocol
{
    var firstUppercased: String
    {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var firstCapitalized: String
    {
        return prefix(1).capitalized + dropFirst()
    }
    
    var localized: String
    {
        let val = self as! String
        return NSLocalizedString(val, value: val, comment: "")
    }
}


extension UIAlertController
{
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?)
    {
        self.addAction(UIAlertAction( title: title, style: style, handler: handler))
    }
    
    static func simpleAlert(title: String, message: String? = nil, dismissHandler: (() -> Void)? = nil) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        alert.addAction(title: "OK", style: .default)
        { (action) in
            
            dismissHandler?()
        }
        
        return alert
    }
}

