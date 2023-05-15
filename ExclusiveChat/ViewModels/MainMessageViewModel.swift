//
//  MainMessageViewModel.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 07.05.2023.
//

import Foundation
import SwiftUI

@MainActor
class MainMessageViewModel: ObservableObject{
    @Published var errorMessage = ""
   

    init(){
        print("🚹🚹🚹 \(FirebaseManager.shared.auth.currentUser?.uid)")
    }

    func handleSignOut(){
        FirebaseManager.shared.signOut()
    }
}
