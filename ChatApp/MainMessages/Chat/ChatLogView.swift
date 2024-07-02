//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/07/01.
//

import SwiftUI
import Firebase


class ChatLogViewModel: ObservableObject{
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
    }
    
    func handleSend(text:  String){
        print(chatText)
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        
      let document =   FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId": fromId, "toId": toId, "text": self.chatText, "timeStamp": Timestamp()] as [String : Any]
    
        document.setData(messageData){ error in
            if let error = error {
                self.errorMessage = "Failed to save message into firestore: \(error)"
            }
            
        }
    }
    
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    @ObservedObject var vm: ChatLogViewModel
   
        var body: some View{
            messageView
//            ZStack{
//
//                VStack{
//                    Spacer()
//                    chatBottomBar
//                        .background(Color.white)
//                }
//
//            }
            
//            VStack{
//
//
//
//            }
            .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
      
        }
    
    private var messageView: some View {
        ScrollView{
            
            ForEach(0..<20) {num in
                
                HStack{
                    Spacer()
                    HStack{
                        Text("FAKE MESSAGE FOR NOW")
                            .foregroundColor(.white)
                           
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
               
                
                
            }
            
            HStack{ Spacer() }
            
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color(.systemBackground).ignoresSafeArea())
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16){
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            
            ZStack{
        
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
                
                
                //Adding a placeholder into the TextEditor!
                if vm.chatText.isEmpty {
                    VStack {
                        HStack{
                            Text("Description")
                                .foregroundStyle(.tertiary)
                                .padding(.leading, 5)
                            Spacer()
                        }
                    }
                }
                
                
            }
            .frame(height: 40)
           
            
            Button {
                vm.handleSend(text: vm.chatText)
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(8)

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
   
    
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid": "g8DbNrAijnapTnfIjTmBl5xBWxX2", "email": "fake@gmail.com"]))
        }
   
    }
}
