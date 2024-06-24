//
//  ContentView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLoginMode = false
    
    var body: some View {
        NavigationView {
            ScrollView{
                Picker(selection: $isLoginMode) {
                    Text("Login")
                    Text("Create Account")
                } label: {
                   Text("Picker Here")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Text("Here is my creation account page")
            }
            .navigationTitle("Create Account")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
