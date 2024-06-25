//
//  ContentView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
 

    
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
                    
                    if isLoginMode{
                        Button{
                            
                        }label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
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
                .background(Color(.init(white: 0, alpha: 0.05)))
            
                
             
                .navigationTitle(isLoginMode ? "Login" : "Create Account")
        }
       
    }
    
    private func handleAction(){
        if isLoginMode{
            print("Should log into Firebase with existing credentials")
        }else {
            createNewAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount(){
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in
            if let error = error {
                self.loginStatusMessage = "Failed to create user: \(error)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
