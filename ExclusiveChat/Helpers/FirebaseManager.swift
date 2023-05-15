//
//  FirebaseManager.swift
//  ExclusiveChat
//
//  Created by Vladimir Vinageras on 05.05.2023.
//

////////////////////////////IMPORTANT//////////////////////////////////////////
///Remember to put the code below in the <YOUR APP>app.swift file  with a result like this:
///
//import SwiftUI
//import Firebase
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}
//
//@main
//struct <YOUR APP>App: App {

//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate  //You need to add this here 
//
//    var body: some Scene {
//        WindowGroup {
//            <MAIN>View()
//        }
//    }
//}




import SwiftUI
import Firebase
import CryptoKit
import FirebaseAuth
import FirebaseStorage
import AuthenticationServices

class FirebaseManager: NSObject {
    let auth : Auth
    let storage : Storage
    let firestore : Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    

    ////SIGN IN WITH APPLE CREDENTIALS OPTION  AND EMAIL-PASSWORD OPTION
    
    var currentNonce: String?

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    ///////////////////////////SIGN IN WITH APPLE CREDENTIALS
    
    func handleRequest(request: ASAuthorizationAppleIDRequest){
        let nonce = self.randomNonceString()
        self.currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = self.sha256(nonce)
    }
    
    func handleResult(result: Result<ASAuthorization, Error>, _ action:()) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                guard let nonce = self.currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    fatalError("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                FirebaseManager.shared.auth.signIn(with: credential) { (authResult, error) in
                    if (error != nil) {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription as Any)
                        return
                    }
                    print("Sign in succesfully")
                   
                    

                    action
                }
                print("\(String(describing: FirebaseManager.shared.auth.currentUser?.uid))")
            default:
                break
            }
        default:
            break
        }
    }
   
    //////////// EMAIL & PASSWORD
    ///

    func signInWithEmail (email: String, password: String){
          FirebaseManager.shared.auth.signIn(withEmail: email, password: password){result, error in
            if let err = error {
                fatalError("❌ Failed to login user. Fatal Error: \(err.localizedDescription)")
            }
            print("Succesfully login user: \(result?.user.uid ?? "") // \(email)")
        }
    }
    
    ///////////////CREATING A NEW USER ACCOUNT
    
    func createNewAccount(email: String, password: String, image: UIImage?, absoluteUrl: URL) {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){ result, error in
            if let err = error {
                fatalError("❌ Failed to create user. Fatal Error: \(err)")
            }
            print("✅ Succesfully created New Account")
            self.persistImageToStorage(email: email, password: password, image: image, absoluteUrl: absoluteUrl)
        }
    }
        
    func storeUserInformation(email: String, uid: String, profileImageUrl : URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let userData = ["email": email, "uid" : uid, "profileImageUrl": profileImageUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) {err in
                if let err = err {
                    print("❌ \(err.localizedDescription)")
                    return
                }
            }
        print("✅  User information succesfully stored ")
        print("\(email)")
        print("\(uid)")
        print("\(profileImageUrl.absoluteString)")
    }
    
    
    
    func persistImageToStorage(email: String, password: String, image: UIImage?, absoluteUrl: URL)
    {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {return}
        ref.putData(imageData){ metadata, errr in
            if let errr = errr{
                fatalError("❌ Failed to upload image. Fatal Error: \(errr.localizedDescription)")
                
            }
            ref.downloadURL{ url, errr in
                if let errr = errr{
                    fatalError("❌ Failed to retrieve downloadURL. (\(errr.localizedDescription))")
                
                }
                print("Image succesfully stored with url: \(url?.absoluteString ?? "")")
                print(url?.absoluteString as Any)
                guard let url = url else {return}
                self.storeUserInformation(email: email, uid: uid, profileImageUrl: url)
                
            }
        }
    }
   
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Succesfully signedOut")
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    ///TODO Manejar los estados de cada intento de creacion o login (error o exito en creacion y en upload de la imagen
    
}
