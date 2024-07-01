//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/07/01.
//

import SwiftUI


struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @State var chatText = ""
   
        var body: some View{
            
            ZStack{
                messageView
               
                
                VStack{
                    Spacer()
                    chatBottomBar
                        .background(Color.white)
                }
             
            }
            
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
        .padding(.bottom, 65)
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16){
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
           
            TextField("Description", text: $chatText)
            Button {
                
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
