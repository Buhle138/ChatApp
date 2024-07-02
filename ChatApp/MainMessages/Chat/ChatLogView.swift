//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/07/01.
//

import SwiftUI
import Firebase

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
}
//model for fetching the messages.
struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
    
}

class ChatLogViewModel: ObservableObject{
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
        
    }
    
    
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
        //for messages we use an addSnapshotListener in order to get messages in real time
            .addSnapshotListener { querySnapshot, error in
                if let error = error{
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                }
                
                //Preventing the server from  giving us too many messages each time we enter a new message. We want one message at a time to be generated.
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                       let data =  change.document.data()
                        let chatMessage = ChatMessage(documentId: change.document.documentID, data: data)
                        self.chatMessages.append(chatMessage)
                    }
                })
                
                
//                querySnapshot?.documents.forEach({ queryDocumentSnapshot in
//                    let data = queryDocumentSnapshot.data()
//                    let docId = queryDocumentSnapshot.documentID
//                    let chatMessage = ChatMessage(documentId: docId, data: data)
//                    self.chatMessages.append(chatMessage)
//
//                })
            }
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
        
        let messageData = [FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: self.chatText, "timeStamp": Timestamp()] as [String : Any]
    
        document.setData(messageData){ error in
            if let error = error {
                self.errorMessage = "Failed to save message into firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            self.chatText = ""
            
        }
        let recipientMessageDocument =   FirebaseManager.shared.firestore
              .collection("messages")
              .document(toId)
              .collection(fromId)
              .document()
        
        recipientMessageDocument.setData(messageData){ error in
            if let error = error {
                self.errorMessage = "Failed to save message into firestore: \(error)"
                return
            }
            
            print("Recipiend saved message as well")
            
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
            .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
      
        }
    
    private var messageView: some View {
        ScrollView{
            
            ForEach(vm.chatMessages) {message in
                
                HStack{
                    Spacer()
                    HStack{
                        Text(message.text)
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
//        NavigationView {
//            ChatLogView(chatUser: .init(data: ["uid": "g8DbNrAijnapTnfIjTmBl5xBWxX2", "email": "fake@gmail.com"]))
//        }
//
        MainMessagesView()
    }
}
