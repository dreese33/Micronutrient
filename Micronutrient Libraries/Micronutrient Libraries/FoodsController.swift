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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodsArray = []
        
        self.api = FoodsApi()
        self.searchForFoods(food: "potatoes")
    }
    
    //Table handler functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodsArray!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        cell.textLabel?.text = self.foodsArray![indexPath.row]

        return cell
    }
    
    /*
     * Searches USDA FoodData Central for food specified and populates table view as a result
     *
     * Parameters:
     *   - food - String to search for
     *
     * Throws:
     */
    private func searchForFoods(food: String) {
        self.api!.getSearchId(food: food) { (ids) in
            for id in ids {
                self.api!.foodDataRequest(fdcId: String(id)) { (data) in
                    self.foodsArray?.append(String(data: data, encoding: .utf8)!)
                    print(String(data: data, encoding: .utf8)!)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
