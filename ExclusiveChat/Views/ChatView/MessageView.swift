//
//  MessageView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 18.05.2023.
//

import SwiftUI

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

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
    }
}
