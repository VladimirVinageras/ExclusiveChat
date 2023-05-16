//
//  ChatLogView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 12.05.2023.
//

import SwiftUI

struct ChatLogView: View{
    
    let chatUser: ChatUser?
    @ObservedObject var chatLogViewModel : ChatLogViewModel
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.chatLogViewModel = ChatLogViewModel(chatUser: chatUser)
    }
    
    var body: some View{
        messagesView
            .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    var messagesView: some View {
        
        ScrollView{
            ScrollViewReader{scrollViewProxy in
                ForEach(chatLogViewModel.chatMessages){message in
                    MessageView(message: message)
                }
                
                HStack{
                    Spacer()
                }
                .id("Empty")
                .onReceive(chatLogViewModel.$scrollerUpdater){ _ in
                    withAnimation(.easeOut(duration: 0.5)){
                        scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                    }
                }
                
            }
            
        }
        
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom){
            chatBottomBarView
                .background(Color.white)
        }
    }
    
    
    struct MessageView: View{
        let message : ChatMessage
        var body: some View{
            
            VStack{
                if message.fromId == String(FirebaseManager.shared.auth.currentUser?.uid ?? ""){
                    HStack{
                        Spacer()
                        HStack{
                            Text(message.text)
                                .foregroundColor(.white)
                            
                        }
                        .padding()
                        .background(.mint)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4 )
                }
                else{
                    HStack{
                        
                        HStack{
                            Text(message.text)
                                .foregroundColor(.white)
                            
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(12)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 4 )
                }
            }
            
        }
        
    }
    
    var chatBottomBarView: some View {
        VStack{
            HStack{
                Image(systemName: "photo.on.rectangle.angled")
                    .padding()
                
                ZStack{
                    NewMessagePlaceHolder()
                    TextEditor(text: $chatLogViewModel.chatMessage)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.sentences)
                        .background(.white)
                        .opacity(chatLogViewModel.chatMessage.isEmpty ? 0.5 : 1)
                }
                .frame(height: 40)
                
                Button{
                    if(!chatLogViewModel.chatMessage.isEmpty){
                        chatLogViewModel.handleSend()
                    }
                }label: {
                    Text("Send")
                        .foregroundColor(Color(.init(white: 0.95, alpha: 1)))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            Divider()
            HStack{
                Spacer()
                Button{
                    ///Messages???
                }label:{
                    VStack{
                        Image(systemName: "message.fill")
                            .font(.title)
                        Text("Messages")
                    }
                }
                
                Spacer()
                Spacer()
                
                Button{
                    ///Settings screen or something
                }
            label:{
                VStack{
                    Image(systemName: "gear")
                        .font(.title)
                    Text("Settings")
                }
            }
            .foregroundColor(Color(.lightGray))
                
                Spacer()
            }
        }
    }
    
    private struct NewMessagePlaceHolder: View {
        var body: some View{
            HStack{
                Text("New message")
                    .foregroundColor(Color(.gray))
                    .padding(.leading, 5)
                    .padding(.top, -4)
                Spacer()
            }
        }
    }
    
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationView{
        //            ChatLogView(chatUser: .init(ChatUser(uid: "REAL USER ID", email: "fake@mail.com", profileImageUrl: "")))
        //        }
        MainMessagesView()
    }
}
