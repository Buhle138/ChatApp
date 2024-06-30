//
//  CreateNewMessageView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/30.
//

import SwiftUI

class CreateNewMessageViewModel: ObservableObject{
    
    @Published var users =  [ChatUser]()
    @Published var errorMessage = ""
    
    init(){
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapShot, error in
                if let error = error {
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapShot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    self.users.append(.init(data: data))
                    
                    
                })
                
               // self.errorMessage = "Fetched users successfully"
            }
    }
    
}

struct CreateNewMessageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
       
        
        NavigationView {
            ScrollView{
                
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                   
                    Text(user.email)
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }

                    }
                }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView()
       // MainMessagesView()
    }
}
