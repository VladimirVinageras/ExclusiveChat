//
//  ChatMessagesViewModel.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 12.05.2023.
//

import Foundation
import SwiftUI
import Firebase


@MainActor class ChatMessagesViewModel: ObservableObject{
    @Published var chatMessage = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var scrollerUpdater = 0
        
    var firestoreListener : ListenerRegistration?
    
    func fetchMessages(chatRecipientUser: ChatUser?){
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatRecipientUser?.uid else {return} ///// el problema esta aquiiiiii
         firestoreListener?.remove()
              firestoreListener = FirebaseManager.shared.firestore
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
    
      
    func handleSend(chatRecipientUser: ChatUser?){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatRecipientUser?.uid else {return}
        
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
                self.persistRecentMessage(chatRecipientUser: chatRecipientUser)
                
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
    
    func persistRecentMessage(chatRecipientUser: ChatUser?){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatRecipientUser?.uid else {return}
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [FirebaseConstants.timeStamp : Timestamp(),
                    FirebaseConstants.text : self.chatMessage,
                    FirebaseConstants.formId : uid,
                    FirebaseConstants.toId : toId,
                    FirebaseConstants.profileImageUrl: chatRecipientUser?.profileImageUrl ?? "",
                    FirebaseConstants.email : chatRecipientUser?.email ?? ""
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

