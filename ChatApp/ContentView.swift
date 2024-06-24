//
//  ContentView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/24.
//

import SwiftUI

struct ContentView: View {
    
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
                        
                    }label: {
                        HStack{
                            
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.blue)
                    }
                    

                   
                }
                    
                }
                .padding()
                .background(Color(.init(white: 0, alpha: 0.05)))
            
                
             
                .navigationTitle(isLoginMode ? "Login" : "Create Account")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
