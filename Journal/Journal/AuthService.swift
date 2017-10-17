//
//  AuthService.swift
//  Journal
//
//  Created by Aditya Deepak on 10/16/17.
//  Copyright © 2017 Aditya Deepak. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let instance = AuthService()
    
    func firebaseAuth(email: String, password: String, completion: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Error: \(error)")
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print("Error: \(error)")
                        completion(false)
                        return
                    }
                    
                    guard let uid = user?.uid else {
                        completion(false)
                        return
                    }
                    let userData: [String:Any] = ["email":email as Any, "providor":user?.providerID as Any]
                    
                    DataService.instance.createUser(userID: uid, userData: userData)
                    completion(true)
                    return
                })
            }
            
            completion(true)
        }
    }
}
