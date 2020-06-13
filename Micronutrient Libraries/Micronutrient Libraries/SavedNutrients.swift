//
//  SavedNutrients.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/13/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

//Note: This class is no longer needed, the table SavedNutrients has
//      been replaced with the SavedFoods attribute `nutrients`
//

import SQLite3

struct SavedNutrients: Table {
    static var createStatement: String {
        return """
        CREATE TABLE SavedNutrients(
            fdcId INTEGER,
            name TEXT,
            amount TEXT,
            PRIMARY KEY(fdcId, name)
        );
        """
    }
    
    static var name: String {
        return "SavedNutrients"
    }
    
    var insertSql: String {
        return """
        REPLACE INTO \(SavedNutrients.name) (date, fdcId, description) VALUES (\'\(fdcId)\', (\'\(name)\'), (\'\(amount)\'))
        """
    }
    
    static var dropTableSql: String {
        return "DROP TABLE \(SavedNutrients.name)"
    }
    
    static var clearTableSql: String {
        return "DELETE FROM \(SavedNutrients.name)"
    }
    
    func bindStatements(insertStatement: OpaquePointer?, database: Database) throws {
        guard sqlite3_bind_int(insertStatement, 1, Int32(self.fdcId)) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
        
        guard sqlite3_bind_text(insertStatement, 2, self.name, -1, nil) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
        
        guard sqlite3_bind_text(insertStatement, 3, self.amount, -1, nil) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
    }
    
    var id: Int
    var fdcId: Int
    var name: String
    var amount: String
}
