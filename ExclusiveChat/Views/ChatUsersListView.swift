//
//  ChatUsersListView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 10.05.2023.
//

import SwiftUI

struct ChatUsersListView: View {
    let didSelectNewUser : (ChatUser)-> ()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var chatUserListViewModel = ChatUsersListViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(chatUserListViewModel.users){ user in
                    Button {
                        presentationMode.wrappedValue
                            .dismiss()
                        didSelectNewUser(user)
                    }
                label:{
                    HStack(spacing: 16){
                        AsyncImage(url: URL(string: user.profileImageUrl)){ image in
                            image.resizable()
                        }placeholder: {
                            //
                        }
                        .frame(width: 64, height: 64)
                        .cornerRadius(32)
                        
                        Text("\(user.email)")
                            .foregroundColor(Color(.label))
                            .font(.title2)
                            .padding()
                        Spacer()
                    }.padding(.horizontal)
                    Divider()
                        .padding(.vertical)
                }
                }
                    
                    
            }
            .navigationTitle("Contacts:")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button {
                        presentationMode.wrappedValue
                            .dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        
        ChatsListView()
    }
}
