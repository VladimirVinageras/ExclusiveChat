//
//  CreateNewMessageViewModel.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 11.05.2023.
//

import SwiftUI

class CreateNewMessageViewModel: ObservableObject{
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init(){
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage =  "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapShot in
                    let data = snapShot.data()
                    
                    let uid = data["uid"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                    if uid != FirebaseManager.shared.auth.currentUser!.uid{
                        self.users.append(.init(uid: uid, email: email, profileImageUrl: profileImageUrl))
                    }
                })
                
                self.errorMessage = "Fetched users succesfully "
            }
    }
}
