//
//  MainMessageViewModel.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 07.05.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Identifiable, Codable {
   @DocumentID var id : String?
    let text : String
    let fromId: String
    let toId : String
    let email : String
    let profileImageUrl : String
    let timeStamp : Date
}

@MainActor
class MainMessageViewModel: ObservableObject{
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
   @Published var recentMessages = [RecentMessage]()

    init(){
        fetchCurrentUser()
        fetchRecentMessages()
        print("🚹🚹🚹 \(FirebaseManager.shared.auth.currentUser?.uid)")
    }
    
    func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recent_messages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timeStamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error{
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print("Failed to listen for recent messages: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach({change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: {recentMessage in
                        return recentMessage.id == docId
                    }){
                        self.recentMessages.remove(at: index)
                    }
                    
                    do{
                        if let recentMessage = try change.document.data(as: RecentMessage.self) as RecentMessage? {
                            self.recentMessages.insert(recentMessage, at: 0)

                        }
                    }catch{
                        print(error)
                    }
                })
                
            }
    }

    func handleSignOut(){
        FirebaseManager.shared.signOut()
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
