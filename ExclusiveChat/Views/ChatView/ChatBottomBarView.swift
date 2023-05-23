////
////  ChatBottomBarView.swift
////  ExclusiveChat
////
////  Created by Vladimir Vinageras on 12.05.2023.
////

import SwiftUI

struct ChatBottomBarView: View {
    @EnvironmentObject var userAuth : UserAuth
    
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
    
    @ObservedObject var chatMessagesViewModel : ChatMessagesViewModel
    

    var body: some View {
        VStack{
            HStack{
                Image(systemName: "photo.on.rectangle.angled")
                    .padding()
                
                ZStack{
                    NewMessagePlaceHolder()
                    TextEditor(text: $chatMessagesViewModel.chatMessage)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.sentences)
                        .background(.white)
                        .opacity(chatMessagesViewModel.chatMessage.isEmpty ? 0.5 : 1)
                }
                .frame(height: 40)
                
                Button{
                    if(!chatMessagesViewModel.chatMessage.isEmpty){
                        chatMessagesViewModel.handleSend(chatRecipientUser: userAuth.recipientUser!)
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
}

struct ChatBottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
    }
}

