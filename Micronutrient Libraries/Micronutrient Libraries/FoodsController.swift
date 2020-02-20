//
//  FoodsController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/1/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//
import UIKit

class FoodsController: UIViewController, UISearchBarDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.foodsArray?.removeAll()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Search for Foods"
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        self.navigationController?.navigationBar.layer.borderColor = MainNavigationController.color.cgColor
        self.searchBar.layer.borderColor = MainNavigationController.color.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodsArray = []
        self.api = FoodsApi()
        
        FoodsController.tableUpperBound = self.numberOfCellsOnScreen()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.layer.borderWidth = 10.5
        searchBar.layer.shadowRadius = 10.5
        searchBar.layer.shadowColor = MainNavigationController.color.cgColor
        searchBar.layer.borderColor = MainNavigationController.color.cgColor
        searchBar.isTranslucent = false
        
        if let textField = self.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            //textField.font = myFont
            //textField.textColor = myTextColor
            //textField.tintColor = myTintColor
            // And so on...

            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) { // If `searchController` is in `navigationItem`
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3) //Or any transparent color that matches with the `navigationBar color`
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() }) // Fixes an UI bug when searchBar appears or hides when scrolling
            }
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
            //Continue changing more properties...
        }
    }
    
    //Table handler functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foodsArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
