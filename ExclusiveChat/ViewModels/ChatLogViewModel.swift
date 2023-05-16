//
//  ChatLogViewModel.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 12.05.2023.
//

import Foundation
import SwiftUI
import Firebase

struct FirebaseConstants{
    static let formId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timeStamp = "timeStamp"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
    static let recent_messages = "recent_messages"
    static let messages = "messages"
}

///WAITING FOR CODABLE TRANSFORMATION

struct ChatMessage: Identifiable{
    var id: String{ documentId }
    
    let documentId: String
    let fromId : String
    let toId : String
    let text : String
    let timeStamp : String
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.formId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.timeStamp = data[FirebaseConstants.timeStamp] as? String ?? ""
        
    }
}

@MainActor class ChatLogViewModel: ObservableObject{
    @Published var chatMessage = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    
    @Published var scrollerUpdater = 0
    
    let chatUser : ChatUser?
    
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    private func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
                FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timeStamp)
            .addSnapshotListener{querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added{
                        let data = change.document.data()
                        let docId = change.document.documentID
                        self.chatMessages.append(.init(documentId: docId, data: data))
                    }
                    
                })
                DispatchQueue.main.async {
                    self.scrollerUpdater += 1
                }
            }
    }
    
      
    func handleSend(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [FirebaseConstants.formId:fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: self.chatMessage, FirebaseConstants.timeStamp: Timestamp()] as [String: Any]
        
            document.setData(messageData){ error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
           return
            }
                
                print("✳️✳️✳️✳️Succesfully saved message original")
                self.persistRecentMessage()
                
                self.chatMessage = ""
                self.scrollerUpdater += 1
            }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientMessageDocument.setData(messageData){ error in
        if let error = error {
            self.errorMessage = "Failed to save message into Firestore: \(error)"
       return
        }
            print("✳️✳️✳️✳️Succesfully saved message Recipient!!")
        }
        
           
        print("⚛️⚛️⚛️⚛️ A message form: \(fromId)")
        print("⚛️⚛️⚛️⚛️  A message to: \(toId)")
    }
    
    func persistRecentMessage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = self.chatUser?.uid else {return}
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [FirebaseConstants.timeStamp : Timestamp(),
                    FirebaseConstants.text : self.chatMessage,
                    FirebaseConstants.formId : uid,
                    FirebaseConstants.toId : toId,
                    FirebaseConstants.profileImageUrl: chatUser?.profileImageUrl ?? "",
                    FirebaseConstants.email : chatUser?.email ?? ""
        ] as [String : Any]
        
        
        document.setData(data){ error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("❌❌❌ Failed to save recent message: \(error)")
                return
            }
            
        }
    }
    
}

