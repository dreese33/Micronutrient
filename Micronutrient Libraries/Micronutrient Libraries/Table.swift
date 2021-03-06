//
//  Table.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/2/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import Foundation

protocol Table {
    static var createStatement: String { get }
    static var name: String { get }
    var insertSql: String { get }
    static var dropTableSql: String { get }
    static var clearTableSql: String { get }
    func bindStatements(insertStatement: OpaquePointer?, database: Database) throws
}
