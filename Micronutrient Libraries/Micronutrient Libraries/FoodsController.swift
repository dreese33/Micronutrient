//
//  FoodsController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/1/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

class FoodsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var key: String?
        
        if let path = Bundle.main.path(forResource: "key", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                key = myStrings[0]
            } catch {
                print(error)
            }
        } else {
            print("Failed")
        }
        
        print(key!)
        
        let api = FoodsApi(key: key!)
        api.foodSearchRequest(food: "Corn on the Cob")
        api.foodDataRequest(fdcId: "559734")
    }
}
