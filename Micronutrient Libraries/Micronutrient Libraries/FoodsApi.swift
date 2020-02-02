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
    
    init(key: String) {
        print("Api Object Initialized")
        currentUrl = constructBasicURL()
        apiKey = apiKey + key
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
     * Search USDA Database for specified food item
     *
     * Parameters:
     *   - food: The food being searched for by the user
     *
     * Throws:
     *
     * Returns: JSON response containing food data
     */
    func foodSearchRequest(food: String) {
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
                    print("data: \(dataString)")
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
    func foodDataRequest(fdcId: String) {
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
                    print("data: \(dataString)")
                }
            }
        }
        
        task.resume()
    }
}
