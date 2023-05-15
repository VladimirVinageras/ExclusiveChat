//
//  CreateNewMessageView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 10.05.2023.
//

import SwiftUI

struct CreateNewMessageView: View {
    let didSelectNewUSer : (ChatUser)-> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var createNewMessageViewModel = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                Text(createNewMessageViewModel.errorMessage)
                ForEach(createNewMessageViewModel.users){ user in
                    Button {
                        presentationMode.wrappedValue
                            .dismiss()
                        didSelectNewUSer(user)
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
                        Spacer()
                    }.padding(.horizontal)
                    Divider()
                        .padding(.vertical)
                }
                }
                    
                    
            }
            .navigationTitle("New Message")
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
      //  CreateNewMessageView()
        
        MainMessagesView()
    }
}
