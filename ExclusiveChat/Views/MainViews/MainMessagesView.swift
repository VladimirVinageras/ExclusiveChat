//
//  MainMessagesView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 05.05.2023.
//

import SwiftUI

struct MainMessagesView: View {
    @EnvironmentObject var userAuth : UserAuth
    @State var shouldShowLogoutOptions = false
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject var mainMessageViewModel = MainMessageViewModel()
    
    private func handleSignOut(){
        mainMessageViewModel.handleSignOut()
        userAuth.isLoggedin = false
        ScreenDispatcherView()
    }
       
    var body: some View {
            NavigationStack{
                VStack{
                    customNavBar
                    messagesView
                    
                    NavigationLink("", isActive: $shouldNavigateToChatLogView){
                        ChatLogView( chatUser: self.chatUser)
                    }
                    
                    
                }
                .overlay(newMessageButton,alignment: .bottom)
                .navigationBarHidden(true)
        }
    }
    
    
    
    private var customNavBar: some View{
        HStack(spacing: 16){
            AsyncImage(url: URL(string: userAuth.chatUser.profileImageUrl)){ image in
                image.resizable()
            }placeholder: {
                // ProgessView()
            }
            .frame(width: 64, height: 64)
            .cornerRadius(32)
            
            VStack(alignment: .leading, spacing: 4){
                Text("\(userAuth.chatUser.email)")
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
            userAuth.fetchCurrentUser()
            print(" printed(✳️CNB✳️ \(FirebaseManager.shared.auth.currentUser?.uid))")
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
                        }),
                    .cancel()
                  ])
        }
    }
    
    
    private var messagesView: some View{
        ScrollView{
            ForEach(0..<10, id: \.self) { num in
                VStack{
                    NavigationLink{
                        Text("DESTINATION")
                        
                    }
                label:{
                        HStack(spacing: 16){
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color(.label), lineWidth: 0.5))
                            
                            VStack(alignment: .leading){
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text("Message to send to user ")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()
                            Text("22d")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                }
                Divider()
                    .padding(.vertical, 2)
            }.padding(.horizontal)
            
        }
    }
    
    @State var shouldShowNewMessageScreen = false
    private var newMessageButton: some View{
        Button{
            shouldShowNewMessageScreen = true
        }label: {
            HStack{
                Spacer()
                Text("+ New message")
                
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(24)
            .padding(.horizontal)
            .shadow(radius: 8)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen){
            CreateNewMessageView(didSelectNewUSer:{user in
                print(user.email)
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
            })
        }
    }
    
    @State var chatUser: ChatUser?
}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
        
        MainMessagesView()
            .preferredColorScheme(.dark)
    }
}