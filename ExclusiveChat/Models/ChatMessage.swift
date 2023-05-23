//
//  ChatMessage.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 18.05.2023.
//

import Foundation

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
