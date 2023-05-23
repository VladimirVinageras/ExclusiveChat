//
//  CustomNavBarView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 18.05.2023.
//

import SwiftUI

struct CustomNavBarView: View {
    @EnvironmentObject var userAuth : UserAuth
    @ObservedObject var chatsListViewModel : ChatsListViewModel
    @Binding var  shouldShowLogoutOptions : Bool
    
    var body: some View {
        HStack(spacing: 16){
            AsyncImage(url: URL(string: chatsListViewModel.chatCurrentUser?.profileImageUrl ?? "Default")){ image in
                image.resizable()
            }placeholder: {
                // ProgessView()
            }
            .frame(width: 64, height: 64)
            .cornerRadius(32)
            
            VStack(alignment: .leading, spacing: 4){
                /////////////////////////////////////////////////////////////////////////////////////////////////////////
                Text("\(chatsListViewModel.chatCurrentUser?.email ?? "UPPSS")")
                    .font(.system(size: 24, weight: .semibold ))
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 12, height: 12)
                    Text("online")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button{
                shouldShowLogoutOptions.toggle()
            }label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .onAppear(){
            print(" printed(✳️✳️ \(FirebaseManager.shared.auth.currentUser?.uid))")
        }
    
        .padding()
        .actionSheet(isPresented: $shouldShowLogoutOptions){
            .init(title: Text("Settings"),
                  message: Text("What do you want to do?"),
                  buttons: [
                    .destructive(
                        Text("Sign Out"),
                        action: {
                            self.handleSignOut()
                            ScreenDispatcherView()
                        }),
                    .cancel()
                  ])
        }
    }
    
    private func handleSignOut(){
        userAuth.logOut()
        userAuth.isLoggedin = false
        ScreenDispatcherView()
    }
    
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
    }
}
