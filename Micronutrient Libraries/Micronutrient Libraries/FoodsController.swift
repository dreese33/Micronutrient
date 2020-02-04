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
    private var foodsArray: [String]?
    private var api: FoodsApi?
    private var test: [String] = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodsArray = []
        self.api = FoodsApi()
        self.api!.getSearchId(food: "Corn") { (ids) in
            print(ids)
            
            DispatchQueue.main.async {
                for id in ids {
                    self.foodsArray!.append(String(id))
                }
                
                self.tableView.reloadData()
            }
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
    
    //Table handler functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodsArray!.count
        //return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        //var identifier = ""
        /*self.api!.getSearchId(food: "Corn") { (ids) in
            for id in ids {
                print(String(id))
                cell.textLabel?.text = String(id)
                self.numberOfRows += 1
            }
        }*/
        cell.textLabel?.text = self.foodsArray![indexPath.row]
        //cell.textLabel?.text = self.test[indexPath.row]

        return cell
    }
}
