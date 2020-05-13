
//
//  ActiveDays.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/13/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import SQLite3

struct ActiveDays: Table {
    static var createStatement: String {
        return """
        CREATE TABLE ActiveDays(
            date TEXT PRIMARY KEY
        );
        """
    }
    
    static var name: String {
        return "ActiveDays"
    }
    
    var insertSql: String {
        return """
        INSERT INTO \(ActiveDays.name) (date) VALUES (\'\(date)\');
        """
    }
    
    static var dropTableSql: String {
        return "DROP TABLE \(ActiveDays.name)"
    }
    
    static var clearTableSql: String {
        return "DELETE FROM \(ActiveDays.name)"
    }
    
    func bindStatements(insertStatement: OpaquePointer?, database: Database) throws {
        guard sqlite3_bind_text(insertStatement, 0, self.date, -1, nil) == SQLITE_OK
            else {
                throw DatabaseError.Bind(message: database.errorMessage)
        }
    }
    
    var date: String
}
