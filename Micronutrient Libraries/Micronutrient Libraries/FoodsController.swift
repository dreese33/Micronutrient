//
//  FoodsController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/1/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//
import UIKit

class FoodsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Upper bound value for table
    public static var tableUpperBound: Int = 0
    public static var tableCellHeight: CGFloat = 43.5
    
    private var foodsArray: [String]?
    private var api: FoodsApi?
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if text.count > 0 {
                self.searchForFoods(food: text)
            }
        } else {
            print("Not searching for results")
        }
        
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodsArray = []
        self.api = FoodsApi()
        
        FoodsController.tableUpperBound = self.numberOfCellsOnScreen()
        
        searchBar.delegate = self
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
                    if data.description.count > 0 {
                        self.foodsArray?.append(data.description)
                        print("Food obtained")
                    } else {
                        print("Food not obtained")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    /*
     * Returns: Total table cells that fit on the screen
     */
    private func numberOfCellsOnScreen() -> Int {
        return Int(UIScreen.main.bounds.height / FoodsController.tableCellHeight)
    }
}
