//
//  History.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/2/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import Foundation
import SQLite3

struct History: Table {
    
    static var createStatement: String {
        return """
        CREATE TABLE History(
            id INTEGER PRIMARY KEY,
            entry VARCHAR(255)
        );
        """
    }
    
    static var dropTableSql: String {
        return "DROP TABLE History"
    }
    
    static var clearTableSql: String {
        return "DELETE FROM History"
    }
    
    var name: String {
        return "History"
    }
    
    var insertSql: String {
        return "INSERT INTO \(name) (entry) VALUES (\'\(entry)\');"
    }
    
    func bindStatements(insertStatement: OpaquePointer?, database: Database) throws {
        guard sqlite3_bind_text(insertStatement, 1, self.entry, -1, nil) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
    }
    
    var id: Int
    var entry: String
}
