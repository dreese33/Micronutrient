//
//  MicronutrientController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 3/17/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

class MicronutrientController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public static var micronutrients: Dictionary<String, String>?
    private var values: [String]?
    
    //TableView component
    @IBOutlet var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        values = []
        var i = 0
        
        print(FoodsController.searchState)
        switch FoodsController.searchState {
        case 0:
            print("Needs implemented")
        case 1:
            print("Searching for history value")
        case 2:
            if let micronutrients = MicronutrientController.micronutrients {
                for micronutrient in micronutrients {
                    values!.append(micronutrient.key + "        " + micronutrient.value)
                    print(values![i])
                    i += 1
                }
            }
        default:
            print("Something went wrong")
        }
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        cell.textLabel?.text = self.values![indexPath.row]

        return cell
    }
}
