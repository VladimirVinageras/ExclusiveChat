//
//  MainMessageViewModel.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 07.05.2023.
//

import Foundation
import SwiftUI
import Firebase

struct RecentMessage: Identifiable {
    var id : String {documentId}
    
    let documentId : String
    let text : String
    let fromId: String
    let toId : String
    let email : String
    let profileImageUrl : String
    let timestamp : Timestamp
    
    init(documentId: String, data : [String : Any] ){
        self.documentId = documentId
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.fromId = data[FirebaseConstants.formId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.email = data[FirebaseConstants.email] as? String ?? ""
        self.profileImageUrl = data[FirebaseConstants.profileImageUrl] as? String ?? ""
        self.timestamp = data[FirebaseConstants.timeStamp] as? Timestamp ?? Timestamp(date: Date())
    }
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
                        return recentMessage.documentId == docId
                    }){
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
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
