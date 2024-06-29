//
//  MainMessagesView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/27.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

struct ChatUser {
    let uid, email, profileImageUrl: String
}

class MainMessagesViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init(){
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut =  FirebaseManager.shared.auth.currentUser?.uid == nil
           
        }
       
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
     
        
        guard let uid =  FirebaseManager.shared.auth.currentUser?.uid else {
            
            self.errorMessage = "Could not find firebase uid"
            return
            
        }
        
        
       
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { snapshot, error in
                
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to fetch currennt user: ", error)
                     return
                }
                self.errorMessage = "123"
                guard let data = snapshot?.data() else {
                    
                    self.errorMessage = "No data found!"
                    return
                    
                    
                }
                
                //self.errorMessage = "Data: \(data)"
                
            //getting the individual details of the user so that we can use them inside of our application.
                let uid  = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                
                self.chatUser = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
                
                print(profileImageUrl)
              
            }
    }
    
    @Published var isUserCurrentlyLoggedOut = false
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
       try? FirebaseManager.shared.auth.signOut()
    }
    
}

struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            //Nav bar
            VStack{
                
               // Text("CURRENT USER ID \(vm.chatUser?.uid ?? "")" )
           
                customNavBar
                
                messagesView
                
             
            }
            

            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
    
        }
       
    }
    
    
    
    private var customNavBar: some View {
        HStack(spacing: 16){
            
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)
        
            VStack(alignment: .leading, spacing: 4){
                Text("\(vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "")")
                    .font(.system(size: 24, weight: .bold))
                
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                   
                }
                
              
            }
            
            Spacer()
            Button {
               shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                
            }

          
           
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("Whats do you want to d?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                   print("Handle sign out")
                    vm.handleSignOut()
                }),
//                        .default(Text("Default Button")),
                .cancel()
            ] )
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                
                
                self.vm.isUserCurrentlyLoggedOut = false
            })
        }
        
    }
    
 
    private var newMessageButton: some  View {
        Button {
            
        } label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
    }
    
    private var messagesView: some View {
        ScrollView{
            ForEach(0..<10, id: \.self){num in
                
                VStack{
                    
                    HStack(spacing: 16){
                       Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                        
                        
                        VStack(alignment: .leading){
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }
        }.padding(.bottom, 50)
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        MainMessagesView()
        
    }
}
