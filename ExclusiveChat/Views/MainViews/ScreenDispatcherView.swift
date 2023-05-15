//
//  ScreenDispatcherView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 03.05.2023.
//

import SwiftUI

struct ScreenDispatcherView: View {
    @StateObject var userAuth = UserAuth()
    
    var body: some View {
        NavigationStack{
            if !userAuth.isLoggedin{
                LoginView()
                    .environmentObject(userAuth)
            }else{
                MainMessagesView()
                    .environmentObject(userAuth)
            }
        }
        .environmentObject(userAuth)
        .onAppear(){
            userAuth.fetchCurrentUser()
        }
    }
}

struct ScreenDispatcherView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenDispatcherView()
    }
}
