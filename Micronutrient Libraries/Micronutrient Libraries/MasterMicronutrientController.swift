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
        
        //Get current date
        let currentDate = self.getCurrentDate()
        
        
        //Save food here
        if let food = MicronutrientController.currentFood {
            
        } else {
            print("Error: MicronutrientController.currentFood does not exist")
        }
        
        print("Saved")
    }
    
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View loaded")
    }
}
