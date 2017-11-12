//
//  DataService.swift
//  Journal
//
//  Created by Aditya Deepak on 10/16/17.
//  Copyright © 2017 Aditya Deepak. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DataService {
    static let instance = DataService()
    
    private var _REF_DB = Database.database().reference()
    private var _REF_USERS = Database.database().reference().child("Users")
    
    var REF_DB: DatabaseReference {
        return _REF_DB
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createUser(userID: String, userData: [String:Any]) {
        _REF_USERS.child(userID).updateChildValues(userData)
        
    }
    
    func addPlace(placeData: [String: Any]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        _REF_USERS.child(uid).child("Places").childByAutoId().updateChildValues(placeData)
    }
}
