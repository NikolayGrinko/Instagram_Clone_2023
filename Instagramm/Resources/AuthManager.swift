//
//  AuthManager.swift
//  Instagramm
//
//  Created by Николай Гринько on 27.05.2023.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        // check if username is available
        //Check if email is available
        
        
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                //Create Account
                //Insets account to database
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        
                        // Firebase auth cloud not create account
                        completion(false)
                        return
                    }
                    // insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
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
                else {
                    // insert into database
                    completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping(Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
           print(username)
        }
        
    }
    // Выход из системы Farebase
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }
    
}
