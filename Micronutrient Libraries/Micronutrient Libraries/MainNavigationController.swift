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
    
    override func viewDidLoad() {
        self.navigationBar.barTintColor = UIColor(red:0.21, green:0.62, blue:0.62, alpha:1.0)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
