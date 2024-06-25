//
//  ContentView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/24.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject{

    let auth: Auth

    static let shared = FirebaseManager()

    override init(){
        FirebaseApp.configure()

        self.auth = Auth.auth()

        super.init()


    }

}

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
        Auth.auth().signIn(withEmail: email, password: password){
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
        Auth.auth().createUser(withEmail: email, password: password){
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

        

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
