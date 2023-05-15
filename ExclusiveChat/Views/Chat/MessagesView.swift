////
////  messagesView.swift
////  ExclusiveChat
////
////  Created by Vladimir Vinageras on 12.05.2023.
////
//
//import SwiftUI
//
//struct MessagesView: View {
//    @ObservedObject var chatLogViewModel : ChatLogViewModel
//    
//    init(chatLogViewModel: ChatLogViewModel){
//        self.chatLogViewModel = chatLogViewModel
//    }
//    
//    var body: some View {
//        ScrollView{
//            ForEach(0..<10) { num in
//                HStack{
//                    Spacer()
//                    HStack{
//                        Text("FAKE MESSAGE FOR NOW")
//                            .foregroundColor(.white)
//                    }
//                    .padding()
//                    .background(.blue)
//                    .cornerRadius(12)
//                }
//                .padding(.horizontal)
//                .padding(.top, 4 )
//            }
//            HStack{
//                Spacer()
//            }
//        }
//        .background(Color(.init(white: 0.95, alpha: 1)))
//        .safeAreaInset(edge: .bottom){
//            chatBottomBarView
//                .background(Color.white)
//        }
//    }
//}
//
//struct messagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView(chatLogViewModel: ChatLogViewModel(chatUser: nil))
//    }
//}
