//
//  MasterMicronutrientController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/4/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

final class MasterMicronutrientController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func saveFoods(_ sender: UIButton) {
        print("Saving")
        
        //Save food here
        
        print("Saved")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View loaded")
    }
}
