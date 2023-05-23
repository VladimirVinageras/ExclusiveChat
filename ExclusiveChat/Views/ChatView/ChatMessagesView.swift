//
//  ChatMessagesView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 12.05.2023.
//

import SwiftUI

struct ChatMessagesView: View{
    @EnvironmentObject var userAuth : UserAuth
    @StateObject var chatMessagesViewModel = ChatMessagesViewModel()

       
    
    
    var body: some View{
        ScrollView{
            ScrollViewReader{scrollViewProxy in
                ForEach(chatMessagesViewModel.chatMessages){message in
                    MessageView(message: message)
                }
                
                HStack{
                    Spacer()
                }
                .id("Empty")
                .onReceive(chatMessagesViewModel.$scrollerUpdater){ _ in
                    withAnimation(.easeOut(duration: 0.5)){
                        scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                    }
                }
                
            }
            
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom){
            ChatBottomBarView(chatMessagesViewModel: chatMessagesViewModel)
                .environmentObject(userAuth)
                .background(Color.white)
        }
        .navigationTitle(userAuth.recipientUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            chatMessagesViewModel.fetchMessages(chatRecipientUser: userAuth.recipientUser)
        }
        .onDisappear{
            chatMessagesViewModel.firestoreListener?.remove()
        }
    }
    
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationView{
        //            ChatLogView(chatUser: .init(ChatUser(uid: "REAL USER ID", email: "fake@mail.com", profileImageUrl: "")))
        //        }
        ChatsListView()
    }
}
