//
//  MainNavigationController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/15/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    public static var color = UIColor(red: 54.0/255.0, green: 157.0/255.0, blue:158.0/255.0, alpha:1.0)
    
    override func viewDidLoad() {
        self.navigationBar.barTintColor = MainNavigationController.color
        self.navigationBar.layer.borderColor = MainNavigationController.color.cgColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.isTranslucent = false
        self.navigationBar.layer.shadowColor = UIColor.clear.cgColor
    }
}
