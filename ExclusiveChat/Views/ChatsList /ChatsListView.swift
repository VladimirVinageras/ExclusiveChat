//
//  ChatsListView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 05.05.2023.
//

import SwiftUI


//First UI screen with all chats

struct ChatsListView: View {
    @EnvironmentObject var userAuth : UserAuth
    @State var shouldShowLogoutOptions = false
    @State var shouldNavigateToMessagesView = false
    @State var shouldShowNewMessageScreen = false
    @StateObject var chatsListViewModel = ChatsListViewModel()
 
       
    var body: some View {
            NavigationStack{
                NavigationLink("", isActive: $shouldNavigateToMessagesView){
                    ChatMessagesView()
                        .environmentObject(userAuth)
                }
                    VStack{
                        CustomNavBarView(chatsListViewModel: chatsListViewModel, shouldShowLogoutOptions: $shouldShowLogoutOptions)
                        
                        RecentChatsListView(chatsListViewModel: chatsListViewModel, shouldNavigateToMessagesView: $shouldNavigateToMessagesView)
                            .environmentObject(userAuth)
                    }
                
                .overlay(availableUsersButton,alignment: .bottom)
                .navigationBarHidden(true)
        }
    }
    
    private var availableUsersButton: some View{
        Button{
            shouldShowNewMessageScreen = true
        }label: {
            HStack{
                Spacer()
                Text("+ User ")
                
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
            ChatUsersListView(didSelectNewUser:{user in
                self.shouldNavigateToMessagesView.toggle()
                userAuth.recipientUser = user
            })
        }
        
    }
    
 
}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
        
        ChatsListView()
            .preferredColorScheme(.dark)
    }
}
