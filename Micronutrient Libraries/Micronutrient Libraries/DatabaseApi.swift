//
//  DatabaseApi.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/15/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import SQLite3

class DatabaseApi {
    
    static func openDatabase() {
        do {
            AppDelegate.database = try Database.open(path: Database.createDatabase(name: "IDatabase.sqlite").absoluteString)
            print("Successfully opened connection to the database")
        } catch DatabaseError.OpenDatabase(message: _) {
            print("Unable to open database")
        } catch {
            print("Other error occurred")
        }
    }
    
    
    static func dropTable(table: Table.Type) {
        if let dbase = AppDelegate.database {
            do { //Drop table test
                try dbase.dropTable(table: table)
            } catch {
                print("Unable to drop table")
            }
        }
    }
    
    
    static func clearTable(table: Table.Type) {
        if let dbase = AppDelegate.database {
            do {
                try dbase.clearTable(table: table)
            } catch {
                print("Unable to clear table")
            }
        }
    }
    
    
    static func getAllExistingTables() -> [String] {
        var tables: [String] = []
        if let dbase = AppDelegate.database {
            do {
                tables = try dbase.getAllExistingTables()
            } catch {
                print("Error occurred obtaining existing tables")
            }
        }
        
        return tables
    }
    
    
    static func createNecessaryTables(existingTables: [String]) -> [String] {
        var newTables: [String] = []
        if let dbase = AppDelegate.database {
            do {
                newTables = try dbase.createNecessaryTables(existingTables: existingTables)
            } catch {
                print("Error occurred creating necessary tables")
            }
        }
        
        return newTables
    }
    
    
    /*
    static func checkTableExists(table: Table.Type) -> Bool {
        if let dbase = AppDelegate.database {
            
        }
        
        return false
    }*/
    
    
    static func createTable(table: Table.Type) {
        if let dbase = AppDelegate.database {
            do {
                try dbase.createTable(table: table)
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    static func insertTable(entry: Table) {
        if let dbase = AppDelegate.database {
            do {
                try dbase.insert(table: entry)
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    //Test function do not use
    static func queryGeneric(table: Table.Type) {
        if let dbase = AppDelegate.database {
            do {
                try dbase.queryGeneric(query: "SELECT * FROM " + table.name)
            } catch {
                print("Failed query")
            }
        }
    }
    
    
    static func getHistoryValues() {
        if let dbase = AppDelegate.database {
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
    
    
    static func loadRecentHistory() {
        if let dbase = AppDelegate.database {
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
    
    
    static func insertTest1() {
        if let dbase = AppDelegate.database {
            for _ in 0...100 {
                do {
                    try dbase.insert(table: History(id: -1, entry: "Random Entry"))
                } catch {
                    print(dbase.errorMessage)
                }
            }
        }
    }
    
    
    static func getActiveDays() {
        if let dbase = AppDelegate.database {
            var activeDays: [String] = []
            do {
                try activeDays = dbase.getActiveDays()
                for day in activeDays {
                    print(day)
                }
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    static func getSavedFoods() {
        if let dbase = AppDelegate.database {
            var foods: [SavedFoods] = []
            do {
                try foods = dbase.getSavedFoods()
                for food in foods {
                    print(food.date, food.description, String(food.fdcId), String(food.foodId))
                }
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
    
    
    static func getSavedNutrients() {
        if let dbase = AppDelegate.database {
            var nutrients: [SavedNutrients] = []
            do {
                try nutrients = dbase.getSavedNutrients()
                for nutrient in nutrients {
                    print(nutrient.amount, String(nutrient.foodId), String(nutrient.id), nutrient.insertSql)
                }
            } catch {
                print(dbase.errorMessage)
            }
        }
    }
}
