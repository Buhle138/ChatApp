//
//  ContentView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore




struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    
    
    
    
    var body: some View {
        NavigationView {
            ScrollView{
                
                VStack(spacing: 14){
                    
                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker Here")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if  !isLoginMode{
                        Button{
                            shouldShowImagePicker.toggle()
                        }label: {
                            
                            VStack{
                                
                                if let image = self.image{
                                    Image(uiImage: image)
                                    //reducing the large image
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                }else{
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                                
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3))
                            
                            
                            
                        }
                    }
                    
                    
                    
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(.white)
                    
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(.white)
                    
                    Button{
                        handleAction()
                    }label: {
                        HStack{
                            
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.blue)
                    }
                    
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                    
                    
                }
                
            }
            .padding()
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05)))
            
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
        
    }
    
    @State var image: UIImage?
    
    private func handleAction(){
        if isLoginMode{
            loginUser()
        }else {
            createNewAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, error in
            if let error = error {
                self.loginStatusMessage = "Failed to login user: \(error)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
    
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, error in
            if let error = error {
                self.loginStatusMessage = "Failed to create user: \(error)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage(){
    
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {return}
        ref.putData(imageData) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                ref.putData(imageData) { metadata, err in
                    if let err = err {
                        self.loginStatusMessage = "Failed to retrieve download url: \(err)"
                        return
                    }
                    
                    self.loginStatusMessage = "Successfully stored iamge with url: \(url?.absoluteString ?? "")"
                    
                    //making the Url optional so that it does not have to be an optional at the parameters
                    guard let url = url else {return}
                    storeUserInformation(imageProfileUrl: url)
                }
            }
        }
        
    func storeUserInformation(imageProfileUrl: URL){
          
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
                return
            }
            
            let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
            //adding the document to firestore
            FirebaseManager.shared.firestore.collection("users")
                .document(uid).setData(userData){err in
                    if let err = err {
                        print(err)
                        self.loginStatusMessage = "\(err)"
                        return
                    }
                    
                    print("Success")
                }
        }
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
    }
