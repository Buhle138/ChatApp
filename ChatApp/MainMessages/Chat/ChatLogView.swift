//
//  ChatLogView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/07/01.
//

import SwiftUI


struct ChatLogView: View {
    
    let chatUser: ChatUser?
   
        var body: some View{
            ScrollView{
                
                ForEach(0..<10) {num in
                    
                    HStack{
                        Text("FAKE MESSAGE FOR NOW")
                    }
                    .padding()
                    .background(Color.blue)
                    
                    
                }
                
            }.navigationTitle(chatUser?.email ?? "")
                .navigationBarTitleDisplayMode(.inline)
        }
    
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid": "g8DbNrAijnapTnfIjTmBl5xBWxX2", "email": "fake@gmail.com"]))
        }
   
    }
}
