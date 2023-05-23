//
//  RecentMessage.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 18.05.2023.
//

import Foundation
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
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = . abbreviated
        return formatter.localizedString(for: timeStamp, relativeTo: Date())
    }
}
