//
//  FoodsApi.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/1/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import Foundation

class FoodsApi {
    
    let space = "%20"
    let urlBase = "https://api.nal.usda.gov/fdc/v"
    let urlVersion = 1
    var currentUrl: String?
    
    var apiKey = "api_key="
    
    init() {
        print("Api Object Initialized")
        currentUrl = constructBasicURL()
        apiKey = apiKey + getFoodApiKey()
    }
    
    /*
     * Base URL for USDA's FoodData Central
     *
     * Returns: USDA's FoodData Central endpoint with current version
     */
    func constructBasicURL() -> String {
        return urlBase + "\(urlVersion)" + "/"
    }
    
    /*
     * Constructs a URL for searching for food items
     *
     * Parameters:
     *   - searchVal: Food being searched for
     *
     * Returns: USDA REST API endpoint for food search
     */
    func constructSearchURL(searchVal: String) -> String {
        return currentUrl! + "search?" + apiKey + "&generalSearchInput=" + searchVal.replacingOccurrences(of: " ", with: space)
    }
    
    /*
     * Constructs a URL for a data request
     *
     * Parameters:
     *   - foodId: The FDC ID associated with the specific food item
     *
     * Returns: USDA REST API endpoint for food data
     */
    func constructDataURL(foodId: String) -> String {
        return currentUrl! + foodId + "?" + apiKey
    }
    
    
    /*
     * Resets the URL to the base
     *
     */
    func resetUrl() {
        currentUrl = urlBase
    }
    
    /*
     * Get the search ID associated with a specific food item
     *
     */
    func getSearchId(_ completion: @escaping ([Int]) -> ()) {
        foodSearchRequest(food: "Corn on the Cob") { (data) in

            var fdcIds: [Int] = []
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let values = json["foods"] as? NSArray {
                        for i in 0...FoodsController.tableUpperBound - 1 {
                            let value = values[i] as! NSDictionary
                            fdcIds.append(value.object(forKey: "fdcId")! as! Int)
                        }
                        completion(fdcIds)
                    } else {
                        print("Error parsing search response JSON")
                    }
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        }
    }
    
    /*
     * Search USDA Database for specified food item
     *
     * Parameters:
     *   - food: The food being searched for by the user
     *
     * Throws:
     *
     * Returns: JSON response containing food data
     */
    func foodSearchRequest(food: String, completion: @escaping (Data) -> ()) {
        let url = URL(string: constructSearchURL(searchVal: food))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(request)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    completion(data)
                }
            }
        }
        
        task.resume()
    }
    
    
    /*
     * Get data on foods by their FDC ID
     *
     * Parameters:
     *   - fdcId: ID associated with specific food item
     *
     * Throws:
     *
     * Returns: JSON containing data on a specific food item selected
     */
    func foodDataRequest(fdcId: String, completion: @escaping (Data) -> ()) {
        let url = URL(string: constructDataURL(foodId: fdcId))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    completion(data)
                }
            }
        }
        
        task.resume()
    }
    
    /*
    * Gets api key from ignored file
    *
    * Throws:
    *
    * Returns: USDA FoodData Central API Key, empty string if not found
    */
    func getFoodApiKey() -> String {
        var key: String = ""
        
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
        
        return key
    }
}
