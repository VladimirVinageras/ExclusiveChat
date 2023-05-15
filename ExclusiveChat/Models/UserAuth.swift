//
//  UserAuth.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 01.05.2023.
//

import Combine
import Firebase


@MainActor class UserAuth: ObservableObject{
    
    @Published var isLoggedin: Bool = false
    @Published var chatUser = ChatUser(uid: "", email: "", profileImageUrl: "")
   
    
    
    init(){
            self.isLoggedin = (FirebaseManager.shared.auth.currentUser?.uid != nil)
    }
    
    func login(){
        self.isLoggedin = true
        fetchCurrentUser()
    }
    
    func logOut(){
        self.isLoggedin = false
    }
    
    func fetchCurrentUser() {
        print("🌀🌀🌀🌀 \(FirebaseManager.shared.auth.currentUser?.uid)")
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid).getDocument { snapshot, error in
                if let error = error {
                  //  self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to fetch current user: \(error)")
                    return
                }
                guard let data = snapshot?.data() else {return}
                print(data )

                
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                
                self.chatUser = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
            }
    }
    
    
    
    
    
}
