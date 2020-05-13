//
//  SavedFoods.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/13/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import SQLite3

struct SavedFoods: Table {
    static var createStatement: String {
        return """
        CREATE TABLE SavedFoods(
            foodId INTEGER PRIMARY KEY,
            date TEXT,
            fdcId INTEGER,
            description TEXT
        );
        """
    }
    
    static var name: String {
        return "SavedFoods"
    }
    
    var insertSql: String {
        return """
        INSERT INTO \(SavedFoods.name) (date, fdcId, description) VALUES (\'\(date)\', (\'\(fdcId)\'), (\'\(description)\'))
        """
    }
    
    static var dropTableSql: String {
        return "DROP TABLE \(SavedFoods.name)"
    }
    
    static var clearTableSql: String {
        return "DELETE FROM \(SavedFoods.name)"
    }
    
    func bindStatements(insertStatement: OpaquePointer?, database: Database) throws {
        guard sqlite3_bind_text(insertStatement, 1, self.date, -1, nil) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
        
        guard sqlite3_bind_int(insertStatement, 2, Int32(self.fdcId)) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
        
        guard sqlite3_bind_text(insertStatement, 3, self.description, -1, nil) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
    }
    
    var foodId: Int
    var date: String
    var fdcId: Int
    var description: String
}
