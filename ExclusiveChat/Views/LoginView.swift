//
//  ContentView.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 02.05.2023.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var userAuth : UserAuth
    @StateObject var loginViewModel = LoginViewModel()
    @State var isSignInMode = true
    @State var shouldShowImagePicker = false
    @State var inputImage : UIImage? = UIImage(named: "Default.jpg")
    @State var email = ""
    @State var password = ""
    
    
    private func handleAction(){
        if isSignInMode {
            do{
                try loginViewModel.signInWithEmail(email: email, password: password)
            }
            catch{
              print(error)
            }
            userAuth.fetchCurrentUser()
            userAuth.isLoggedin = true
            ScreenDispatcherView()
            
        }else{
            loginViewModel.createNewAccount(email: email, password: password, image: inputImage)
            isSignInMode = true
        }
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Picker(selection: $isSignInMode){
                        Text("Sign in")
                            .tag(true)
                        Text("Create account")
                            .tag(false)
                    }label: {
                        Text("Pick your page")
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom)
                    
                    if !isSignInMode{
                        
                        Button{
                            shouldShowImagePicker.toggle()
                        }label: {
                            VStack{
                                if let image = self.inputImage{
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(75)
                                } else {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .font(.system(size: 96))
                                        .fontWeight(.ultraLight)
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            
                            
                        }
                    }
                    
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                        SecureField("Password (at least 6 characters)", text: $password)
                    }
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(.white)
                    
                    
                    Spacer()
                    Button{
                        handleAction()
                    }label:{
                        HStack{
                            Spacer()
                            Text(isSignInMode ? "Sign in" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(.blue)
                    }
                    .padding(.vertical)
                    Spacer()
                    Spacer()
                   
                //Authentication with apple Credentials
                   Group {
                        //                    Text("or")
                        //                    Spacer()
                        //
                        //                    SignInWithAppleButton(
                        //                        onRequest: { request in
                        //                            loginViewModel.handleRequest(request: request)
                        //                        },
                        //                        onCompletion: { result in
                        //                            loginViewModel.handleResult(result: result, userAuth.login())
                        //
                        //                        }
                        //                    )
                        //                    .frame(width: 350, height: 45,alignment: .center)
                        //                    .padding()
                        //
                        
                    }
                    
                }
                .padding()
            }
            .navigationTitle(isSignInMode ? "Sign in" : "Create Account")
            .background(Color(.init(white :0, alpha: 0.1)))
        }
        .environmentObject(userAuth)
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
            ImagePicker(image: $inputImage)
            
        }
        
    }
    
}


struct SignInCreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


