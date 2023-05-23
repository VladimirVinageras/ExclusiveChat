//
//  RecentChatsListView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 18.05.2023.
//

import SwiftUI

struct RecentChatsListView: View {
   @ObservedObject var chatsListViewModel : ChatsListViewModel
    @EnvironmentObject var userAuth : UserAuth
    @Binding var shouldNavigateToMessagesView : Bool
    
    var body: some View {
        ScrollView{
            ForEach(chatsListViewModel.recentMessages) { message in
                let image =       AsyncImage(url: URL(string: message.profileImageUrl)){ image in
                    image.resizable()
                        .frame(width: 64, height: 64)
                        .cornerRadius(32)
                        .shadow(radius: 6)
                }placeholder: {
                //something here maybe in future
                }
                VStack{
                    Button{
                        let uid = userAuth.chatUser.uid == message.fromId ? message.toId : message.fromId
                        let chatUser = ChatUser(uid: message.toId, email: message.email, profileImageUrl: message.profileImageUrl)
                        userAuth.recipientUser = chatUser
                  
                        shouldNavigateToMessagesView = true
                        
                        ///Show View with chat Window
                    }label:{
                        HStack(spacing: 16){
                            image
                            VStack(alignment: .leading){
                                Text(message.email)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(message.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Text(message.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.init(gray: 0.1, alpha: 1)))
                        }
                    }
                }
                Divider()
                    .padding(.vertical, 2)
            }.padding(.horizontal)
            
        }

    }
}

struct ChatUsersListView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenDispatcherView()
    }
}

