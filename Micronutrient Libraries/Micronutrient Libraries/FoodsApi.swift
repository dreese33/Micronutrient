//
//  FoodsApi.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 2/1/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import Foundation

class FoodsApi {
    
    private final let acceptableDataTypes: [String] = ["survey(fndds)", "srlegacy"]
    
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
    private func constructBasicURL() -> String {
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
    private func constructSearchURL(searchVal: String) -> String {
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
    private func constructDataURL(foodId: String) -> String {
        return currentUrl! + foodId + "?" + apiKey
    }
    
    
    /*
     * Resets the URL to the base
     *
     */
    private func resetUrl() {
        currentUrl = urlBase
    }
    
    /*
     * Get the search ID associated with a specific food item
     *
     */
    func getSearchId(food: String, _ completion: @escaping ([Int]) -> ()) {
        foodSearchRequest(food: food) { (data) in

            var fdcIds: [Int] = []
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                        if let values = json["foods"] as? NSArray {
                            if values.count != 0 {
                                var i = 0
                                var upper = FoodsController.tableUpperBound
                                while i < upper {
                                    if i >= values.count {
                                        break
                                    }
                                    
                                    let value = values[i] as! NSDictionary
                                    //let dataType = self.simplifyDataType(dataType: value.object(forKey: "dataType")! as! String)
                                    
                                    //Delete this code if you bring back code below
                                    
                                    i += 1
                                    fdcIds.append(value.object(forKey: "fdcId")! as! Int)
                                    /*
                                    innerLoop: for str in self.acceptableDataTypes {
                                        i += 1
                                        if dataType == str {
                                            fdcIds.append(value.object(forKey: "fdcId")! as! Int)
                                            break innerLoop
                                        } else {
                                            upper += 1
                                            print("Retrying")
                                        }
                                    }*/
                                }
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
     * Simplifies dataType String to determine if it is acceptable
     */
    func simplifyDataType(dataType: String) -> String {
        return dataType.replacingOccurrences(of: " ", with: "").lowercased()
    }
    
    /*
     * Search USDA Database for specified food item
     *
     * Parameters:
     *   - food: The food being searched for by the user
     *
     * Throws:
     *
     * Returns: JSON response containing food data for SR Legacy and Survey (FNDDS) types
     * Note: Multiple foods are returned in this function
     */
    func foodSearchRequest(food: String, completion: @escaping (Data) -> ()) {
        let searchVal = self.makeSearchValueSafe(food)
        
        guard let url = URL(string: constructSearchURL(searchVal: searchVal)) else {
            
            return
        }
        
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
                if let data = data {
                    completion(data)
                }
            }
        }
        
        task.resume()
    }
    
    
    /*
     * Removes escape sequences and special characters from search so app does not crash
     *
     * Parameters:
     *    - food: String containing user search input
     *
     * Throws:
     *
     * Returns: String safe to put in url for FoodData Central search query
     */
    func makeSearchValueSafe(_ food: String) -> String{
        return food.replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "\\", with: "")
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
    func foodDataRequest(fdcId: String, completion: @escaping (Food) -> ()) {
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
                if let data = data {
                    completion(self.parseFoodData(data, fdcId: Int(fdcId)!))
                }
            }
        }
        
        task.resume()
    }
    
    
    //TODO -- Make sure to add error handling for parsing is handled well
    /*
     * Parses food data from JSON
     *
     * Parameters:
     *   - foodJSON: JSON returned from foodDataRequest
     *
     * Throws:
     *
     * Returns: Food object containing all necessary information from JSON
     */
    func parseFoodData(_ foodJSON: Data, fdcId: Int) -> Food {
        var food: Food?
        do {
            if let json = try JSONSerialization.jsonObject(with: foodJSON, options: []) as? [String: Any] {
                
                var foodParsed: Bool = true
                
                if let nutrientInfo = json["foodNutrients"] as? NSArray {
                    var micronutrients = Dictionary<String, String>()
                    var currAmount = ""
                    var currName = ""
                    
                    for nutrient in nutrientInfo {
                        currAmount = ""
                        currName = ""
                        
                        let value = nutrient as! NSDictionary
                        let nutrients = value["nutrient"] as! NSDictionary
                        
                        if let amount = value["amount"] as? NSNumber{
                            currAmount += amount.stringValue
                        } else {
                            foodParsed = false
                            break
                        }
                        
                        if let name = nutrients["name"] as? String {
                            currName += name
                        } else {
                            foodParsed = false
                            break
                        }
                        
                        if let unit = nutrients["unitName"] as? String {
                            currAmount += unit
                        } else {
                            foodParsed = false
                            break
                        }
                        
                        micronutrients[currName] = currAmount
                    }
                    
                    if foodParsed {
                        food = Food(description: json["description"] as! String, fdcId: fdcId, micronutrients: micronutrients)
                    } else {
                        return self.getDefaultFood()
                    }
                } else {
                    return self.getDefaultFood()
                }
            }
        } catch {
            print("JSONSerialization error:", error)
        }
        
        return food!
    }
    
    
    /*
     * Gets default food when error occurs
     *
     * Throws:
     *
     * Returns: A Food object with default values set
     */
    func getDefaultFood() -> Food {
        print("Error occurred parsing micronutrient data")
        return Food(description: "", fdcId: -1, micronutrients: Dictionary<String, String>())
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
