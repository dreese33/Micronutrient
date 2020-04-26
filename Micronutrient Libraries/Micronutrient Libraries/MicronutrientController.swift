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
    private var simplifiedMicronutrients: [String]?
    
    //TableView component
    @IBOutlet var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        simplifiedMicronutrients = []
        var i = 0
        for micronutrient in MicronutrientController.micronutrients! {
            simplifiedMicronutrients!.append(micronutrient.key + "        " + micronutrient.value)
            print(simplifiedMicronutrients![i])
            i += 1
        }
        
        print("Micronutrient count: " + "\(simplifiedMicronutrients!.count)")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.simplifiedMicronutrients!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        cell.textLabel?.text = self.simplifiedMicronutrients![indexPath.row]

        return cell
    }
}
