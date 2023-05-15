//
//  ChatUser.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 09.05.2023.
//

import SwiftUI

struct ChatUser: Identifiable{
    var id: String { uid }
    let uid: String
    let email: String
    let profileImageUrl: String
}

