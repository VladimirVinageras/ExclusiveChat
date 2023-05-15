//
//  LoginViewModel.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 02.05.2023.
//
import SwiftUI
import CryptoKit
import FirebaseAuth
import FirebaseStorage
import AuthenticationServices

@MainActor class LoginViewModel: ObservableObject {
    @State var profileImageUrl : URL = URL(fileURLWithPath: "")
    @Published var isLoggedin = false
    
    
    init(){
    }
    
    func handleRequest(request: ASAuthorizationAppleIDRequest){
        FirebaseManager.shared.handleRequest(request: request)
    }
    
    func handleResult(result: Result<ASAuthorization, Error>, _ action:()) {
        FirebaseManager.shared.handleResult(result: result, action)
    }
    
    //////////// EMAIL & PASSWORD
    
    func createNewAccount(email: String, password: String, image: UIImage?){
        FirebaseManager.shared.createNewAccount(email: email, password: password, image: image, absoluteUrl: profileImageUrl)

    }
    
    ///TODO Manejar los estados de cada intento de creacion o login (error o exito en creacion y en upload de la imagen
    func signInWithEmail (email: String, password: String) {
            FirebaseManager.shared.signInWithEmail(email: email, password: password)
    }    
}

