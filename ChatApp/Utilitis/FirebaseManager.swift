//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/27.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore


class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
  override  init() {
    FirebaseApp.configure()
      self.auth = Auth.auth()
      self.storage = Storage.storage()
      self.firestore = Firestore.firestore()
      
      super.init()
    }
    
}

