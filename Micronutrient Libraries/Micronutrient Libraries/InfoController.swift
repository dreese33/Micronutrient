//
//  InfoController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/15/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import Foundation
import UIKit

class InfoController: UIViewController, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "About Micronutrients"
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
    }
}
