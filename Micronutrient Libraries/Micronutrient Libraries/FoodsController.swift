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
    
    private var foodsArray: [Food]?
    private var api: FoodsApi?
    
    static var searchHistory: [String] = []
    static var searchState: Int = 0
    private var duplicateSearch: Bool = false
    
    static var listOfFoodsArray: [String] = ["Fruits", "Vegetables", "Breads"]
    static var database: Database?
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        foodsArray?.removeAll()
        if let text = searchBar.text {
            if text.count > 0 {
                self.searchForFoods(food: text)
            }
        } else {
            print("Not searching for results")
        }
        
        searchBar.resignFirstResponder()
    }
    
    //Transition to state 1
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("Editing Began")
        self.foodsArray?.removeAll()
        FoodsController.searchState = 1
        self.tableView.reloadData()
        return true
    }
    
    //Transition to state 2
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("Editing Ended")
        
        //MODIFY HERE
        if self.searchBar.text!.count > 1 && !self.duplicateSearch {
            
            //Append searchHistory and add to database
            let text = self.searchBar.text!
            FoodsController.searchHistory.append(text)
            
            if let dbase = FoodsController.database {
                do {
                    try dbase.insert(table: History(id: -1, entry: text))
                } catch {
                    print(dbase.errorMessage)
                }
            }
        } else {
            self.duplicateSearch = false
        }
        
        FoodsController.searchState = 2
        self.tableView.reloadData()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Search for Foods"
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        self.navigationController?.navigationBar.layer.borderColor = MainNavigationController.color.cgColor
        self.searchBar.layer.borderColor = MainNavigationController.color.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.foodsArray = []
        self.api = FoodsApi()
        
        FoodsController.tableUpperBound = self.numberOfCellsOnScreen()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.layer.shadowRadius = 10.5
        searchBar.layer.shadowColor = MainNavigationController.color.cgColor
        searchBar.layer.borderColor = MainNavigationController.color.cgColor
        searchBar.isTranslucent = false
        
        if let textField = self.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white

            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) {
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() })
            }
            
            backgroundView?.layer.masksToBounds = true
        }
        
        
        //Database initialization
        self.openDatabase()
        self.loadRecentHistory()
    }
    
    //Table handler functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FoodsController.searchState {
        case 0:
            return FoodsController.listOfFoodsArray.count
        case 1:
            return FoodsController.searchHistory.count
        case 2:
            return self.foodsArray!.count
        default:
            print("Something went wrong")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.textAlignment = .natural
        
        switch FoodsController.searchState {
        case 0:
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = FoodsController.listOfFoodsArray[indexPath.row]
        case 1:
            cell.textLabel?.text = FoodsController.searchHistory[FoodsController.searchHistory.count - indexPath.row - 1]
        case 2:
            cell.textLabel?.text = self.foodsArray![indexPath.row].description
        default:
            print("Something went wrong")
        }

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
    func searchForFoods(food: String) {
        self.api!.getSearchId(food: food) { (ids) in
            for id in ids {
                self.api!.foodDataRequest(fdcId: String(id)) { (data) in
                    if data.description.count > 0 {
                        self.foodsArray?.append(data)
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
     * Table cell clicked - opens micronutrient information
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MicronutrientController.micronutrients = foodsArray![indexPath.row].micronutrients
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch FoodsController.searchState {
        case 0:
            print("Default state cell clicked")
        case 1:
            print("History cell clicked")
            
            let count = FoodsController.searchHistory.count
            self.duplicateSearch = true
            self.searchBar.text = FoodsController.searchHistory[count - indexPath.row - 1]
            self.searchBarSearchButtonClicked(self.searchBar)
            
            return nil
        case 2:
            //Search results displayed
            print("Search result clicked")
            MicronutrientController.micronutrients = foodsArray![indexPath.row].micronutrients
            
            let infoViewController = storyboard?.instantiateViewController(withIdentifier: "MasterMicronutrientController") as! MasterMicronutrientController
            infoViewController.modalPresentationStyle = .overCurrentContext
            self.navigationController?.pushViewController(infoViewController, animated: true)

        default:
            print("Something went wrong")
        }
        
        return indexPath
    }
    
    
    /*
     * Returns: Total number of table cells that fit on the screen
     */
    private func numberOfCellsOnScreen() -> Int {
        return Int(UIScreen.main.bounds.height / FoodsController.tableCellHeight)
    }
    
    
    
    /*
     *
     Database handling
     *
     */
    
    
    func openDatabase() {
        do {
            FoodsController.database = try Database.open(path: Database.createDatabase(name: "IDatabase.sqlite").absoluteString)
            print("Successfully opened connection to the database")
        } catch DatabaseError.OpenDatabase(message: _) {
            print("Unable to open database")
        } catch {
            print("Other error occurred")
        }
    }
    
    
    func dropTable(table: Table.Type) {
        if let dbase = FoodsController.database {
            do { //Drop table test
                try dbase.dropTable(table: table)
            } catch {
                print("Unable to drop table")
            }
        }
    }
    
    
    func clearTable(table: Table.Type) {
        if let dbase = FoodsController.database {
            do {
                try dbase.clearTable(table: table)
            } catch {
                print("Unable to clear table")
            }
        }
    }
    
    
    func createTable(table: Table.Type) {
        if let dbase = FoodsController.database {
            do {
                try dbase.createTable(table: table)
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    func insertTable(entry: Table) {
        if let dbase = FoodsController.database {
            do {
                try dbase.insert(table: entry)
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    func queryGeneric(table: Table.Type) {
        if let dbase = FoodsController.database {
            do {
                try dbase.queryGeneric(query: "SELECT * FROM " + table.name)
            } catch {
                print("Failed query")
            }
        }
    }
    
    
    func getHistoryValues() {
        if let dbase = FoodsController.database {
            var history: [History] = []
            do {
                try history = dbase.getHistory()
                for hist in history {
                    print(hist.id, hist.entry)
                }
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    func loadRecentHistory() {
        if let dbase = FoodsController.database {
            do {
                let history = try dbase.getRecentHistory()
                for hist in history.reversed() {
                    //FoodsController.searchHistory.append(String(hist.id) + hist.entry)
                    FoodsController.searchHistory.append(hist.entry)
                }
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    func insertTest1() {
        if let dbase = FoodsController.database {
            for _ in 0...100 {
                do {
                    try dbase.insert(table: History(id: -1, entry: "Random Entry"))
                } catch {
                    print(dbase.errorMessage)
                }
            }
        }
    }
    
    
}
