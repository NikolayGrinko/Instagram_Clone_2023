//
//  DatabaseManager.swift
//  Instagramm
//
//  Created by Николай Гринько on 27.05.2023.
//

import Foundation
import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    //MARK: Public
    
    
    
    // Check if username and email is available
    // - Parameters
    //   -email: String representing email
    //   - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        
        completion(true)
        
    }
    // insert new user data to database
    // - Parameters
    //   -email: String representing email
    //   - username: String representing username
    
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        let key = email.safeDatabaseKey()
        
        database.child(key).setValue(["username": username]) { error in
            if error == nil {
                completion(true)
                return
            }
            else {
                completion(false)
                return
            }
            
        }
    }
    
    
    
}
