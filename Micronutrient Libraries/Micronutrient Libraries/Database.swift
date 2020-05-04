//
//  Database.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/2/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import Foundation
import SQLite3

class Database {
    
    private let dbPointer: OpaquePointer?
    
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    deinit {
        if self.dbPointer != nil {
            sqlite3_close(self.dbPointer)
        }
    }
    
    static func createDatabase(name: String) -> URL {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(name)
        return fileURL
    }
    
    
    static func open(path: String) throws -> Database {
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK {
            return Database(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            
            if let errorPointer = sqlite3_errmsg(db) {
              let message = String(cString: errorPointer)
              throw DatabaseError.OpenDatabase(message: message)
            } else {
              throw DatabaseError
                .OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    //Returns most recent error
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
            
        } else {
            return "No errors from sqlite."
            
        }
    }
    
    //Prepares statement for execution
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw DatabaseError.Prepare(message: errorMessage)
        }
        
        return statement
    }
    
    //Create table
    func createTable(table: Table.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        
        defer {
            sqlite3_finalize(createTableStatement)
        }
        
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw DatabaseError.Step(message: errorMessage)
        }
        
        print("\(table) table created.")
    }
    
    //Insert into table
    func insert(table: Table) throws {
        let insertStatement = try prepareStatement(sql: table.insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        
        do {
            try table.bindStatements(insertStatement: insertStatement, database: self)
        } catch {
            print(self.errorMessage)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw DatabaseError.Step(message: errorMessage)
        }
        
        print("Successfully inserted row.")
    }
    
    //Generic Query Function -- Test function, do not use
    func queryGeneric(query: String, params: [Any]? = nil) throws {
        let queryStatement = try prepareStatement(sql: query)
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var i: Int32 = 0
        if let parameters = params {
            for param in parameters {
                switch param {
                case is String:
                    guard sqlite3_bind_text(queryStatement, i, param as! String, -1, nil) == SQLITE_OK
                        else {
                            throw DatabaseError.Bind(message: self.errorMessage)
                    }
                case is Int:
                    guard sqlite3_bind_int(queryStatement, i, param as! Int32) == SQLITE_OK
                        else {
                            throw DatabaseError.Bind(message: self.errorMessage)
                    }
                case is Double:
                    guard sqlite3_bind_double(queryStatement, i, param as! Double) == SQLITE_OK
                        else {
                            throw DatabaseError.Bind(message: self.errorMessage)
                    }
                default:
                    print("Unknown type")
                }
                i += 1
            }
        }
        
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            throw DatabaseError.Step(message: errorMessage)
        }
        
        guard let results = sqlite3_column_text(queryStatement, 1) else {
            print("Error")
            return
        }
        
        print("Query completing " + String(cString: results))
    }
    
    
    //Drop table
    func dropTable(table: Table.Type) throws {
        let dropTableStatement = try prepareStatement(sql: table.dropTableSql)
        
        defer {
            sqlite3_finalize(dropTableStatement)
        }
        
        guard sqlite3_step(dropTableStatement) == SQLITE_DONE else {
            throw DatabaseError.Step(message: "Step " + errorMessage)
        }
        
        print("Successfully dropped table")
    }
    
    
    //Clear table of all entries
    func clearTable(table: Table.Type) throws {
        let clearTableStatement = try prepareStatement(sql: table.clearTableSql)
        
        defer {
            sqlite3_finalize(clearTableStatement)
        }
        
        guard sqlite3_step(clearTableStatement) == SQLITE_DONE else {
            throw DatabaseError.Step(message: "Step " + errorMessage)
        }
        
        print("Successfully cleared table")
    }
    
    
    //Gets all rows from history table
    func getHistory() throws -> [History] {
        
        let query = """
            SELECT * FROM History
        """
        let queryStatement = try prepareStatement(sql: query)
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var rows: [History] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(queryStatement, 0))
            let entry = String(cString: sqlite3_column_text(queryStatement, 1))
            rows.append(History(id: id, entry: entry))
        }
        
        return rows
    }
    
    //Gets most recent 50 items from history
    func getRecentHistory() throws -> [History] {
        
        let query = """
            SELECT * FROM History ORDER BY id DESC LIMIT 50
        """
        let queryStatement = try prepareStatement(sql: query)
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var rows: [History] = []
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(queryStatement, 0))
            let entry = String(cString: sqlite3_column_text(queryStatement, 1))
            rows.append(History(id: id, entry: entry))
        }
        
        return rows
    }
}
