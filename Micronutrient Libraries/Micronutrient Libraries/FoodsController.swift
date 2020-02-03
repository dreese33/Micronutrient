//
//  FoodsController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/1/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

class FoodsController: UITableViewController {
    
    //Upper bound value for table
    public static var tableUpperBound: Int = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = FoodsApi()
        api.getSearchId() { (ids) in
            print(ids)
        }
        
        //api.foodSearchRequest(food: "Corn on the Cob") { (data) in
        //    print(data)
        //}
        
        
        /* How to make requests
        api.foodDataRequest(fdcId: "559734") { (data) in
            print(data)
        }
        */
        
        
        //Setup tableUpperBounds variable
    }
    
    
}
