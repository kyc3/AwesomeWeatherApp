//
//  EURODB.swift
//  Awesome Weather App
//
//  Created by Winter, Yannick on 18.03.16.
//  Copyright © 2016 Winter, Yannick. All rights reserved.
//

import Foundation
import SQLite

class EURODB {
    enum DBError: ErrorType {
        case NO_CONNECTION(String)
    }
    internal var connection: Connection?
    private let filePath: String
    private let fileName: String = "cities.sqlite"
    
    init() {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.filePath = documentsURL.URLByAppendingPathComponent(self.fileName).path!
        self.connection = nil
        self.copyDB()
        do {
            self.connection = try Connection(self.filePath)
            
        }
        catch {
            print("couldnotConnect")
        }
    }// connect to the database
    
    private func copyDB() {
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(self.filePath) {
            let documentsURL = NSBundle.mainBundle().resourceURL
            let fromPath = documentsURL!.URLByAppendingPathComponent(self.fileName as String)
            var error : NSError?
            do {
                try fileManager.copyItemAtPath(fromPath.path!, toPath: self.filePath)
            } catch let error1 as NSError {
                error = error1
            }
            //let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
            } else {
                print("Successfully copied")
            }
        }
    }// use the deployed DB here
    internal func runStatementInQueue(handler:(Statement) -> Void) {
        
    }  // use this to run statements in regard of read and write thread safety.
    
    // MARK: - Utility functions to create queries
    
    internal static func selectAll(tableName: String) -> String {
        return self.createSelectPartOfStatement(tableName, columns: ["*"])
    }
    
    internal static func selectWithoutCondition(tableName: String, columns: Array<String>) -> String {
        return self.createSelectPartOfStatement(tableName, columns: columns)
    }
    
    internal static func selectAllWithCondition(tableName: String, conditionColumns: Array<String>, conditionValues: Array<String>) -> String {
        return "\(self.createSelectPartOfStatement(tableName, columns: ["*"]))\(self.createConditionPartOfStatement(conditionColumns, values: conditionValues))"
    }
    
    internal static func selectWithCondition(tableName: String, columns:Array<String>, values:Array<String>) -> String {
        return "\(self.createSelectPartOfStatement(tableName, columns: columns))\(self.createConditionPartOfStatement(columns, values: values))"
    }
    
    internal static func insert(tableName: String, columns: Array<String>) -> String {
        return self.createInsertStatement(tableName, columns: columns)
    }
    
    internal static func deleteAll(tableName: String) -> String {
        return self.createDeleteStatement(tableName)
    }
    
    internal static func deleteWithCondition(tableName: String, columns: Array<String>, values: Array<String>) -> String{
        return "\(self.createDeleteStatement(tableName))\(self.createConditionPartOfStatement(columns, values: values))"
    }
    
    internal static func updateAll(tableName: String, updateColumns: Array<String>) -> String {
        return self.createUpdatePartOfStatement(tableName, columns: updateColumns)
    }
    
    internal static func updateWithCondition(tableName: String, updateColumns:Array<String>, conditionColumns: Array<String>, conditionValues: Array<String>) -> String {
        return "\(self.createUpdatePartOfStatement(tableName, columns: updateColumns))\(self.createConditionPartOfStatement(conditionColumns, values: conditionValues))"
    }
    
    // MARK: - Helper functions to build the query
    
    internal static func createInsertStatement(tableName: String, columns: Array<String>) -> String {
        var insertStatement = "INSERT INTO \(tableName)"
        var columnPart = "("
        var valuePart = "("
        for i in 0..<columns.count {
            columnPart = "\(columnPart)\(columns[i])"
            valuePart = "\(valuePart)?"
            if i != columns.count-1 {
                columnPart = "\(columnPart),"
                valuePart = "\(valuePart),"
            }
        }
        columnPart = "\(columnPart))"
        valuePart = "\(valuePart))"
        insertStatement = "\(insertStatement) \(columnPart) VALUES \(valuePart)"
        return insertStatement
    }
    
    internal static func createDeleteStatement(tableName: String) -> String{
        return "DELETE FROM \(tableName)"
    }
    
    /**
    Creates the first part of a select query.
    
    - parameter tableName: The name of the table on which the query will be invoked
    - parameter columns: The name of the columns on which the query will be invoked
    
    - returns: A string which may look like this: 'SELECT <column1>, <column2>, <column3> FROM <tableName>'
    */
    internal static func createSelectPartOfStatement(tableName: String, columns: Array<String>) -> String {
        var selectPart: String = "SELECT "
        for column: String in columns {
            selectPart = "\(selectPart) \(column)"
            if columns.indexOf(column) != columns.count-1 {
             selectPart = "\(selectPart),"
            }
        }
        selectPart = "\(selectPart) FROM \(tableName)"
        return selectPart
    }
    
    /**
     Creates the condition part of a query.
     
     - parameter columns: The name of the columns on which the query will be invoked
     - parameter values: The values of the query
     
     - returns: A string which may look like this: ' WHERE <column1> = <value1> AND <column2> = <value2>'
     */
    internal static func createConditionPartOfStatement(columns: Array<String>, values: Array<String>) -> String {
        var conditionPart: String = " WHERE"
        for var i=0;i<values.count;++i {
            conditionPart = "\(conditionPart) \(columns[i]) = \(values[i])"
            if i != values.count-1 {
                conditionPart = "\(conditionPart) AND"
            }
        }
        return conditionPart
    }
    
    internal static func createUpdatePartOfStatement(tableName: String, columns: Array<String>) -> String {
        var statement = "UPDATE \(tableName) SET "
        for i in 0..<columns.count {
            statement = "\(statement)\(columns[i])=?"
            if i != columns.count-1 {
                statement = "\(statement),"
            }
        }
        return statement
    }
}