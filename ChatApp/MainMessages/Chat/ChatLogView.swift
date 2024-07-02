//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/07/01.
//

import SwiftUI


class ChatLogViewModel: ObservableObject{
    
    init() {
        
    }
    
    func handleSend(text:  String){
        
    }
    
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @State var chatText = ""
    
    @ObservedObject var vm = ChatLogViewModel()
   
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
        
                TextEditor(text: $chatText)
                    .opacity(chatText.isEmpty ? 0.5 : 1)
                
                
                //Adding a placeholder into the TextEditor!
                if chatText.isEmpty {
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
                vm.handleSend(text: self.chatText)
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
