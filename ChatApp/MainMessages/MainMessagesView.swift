//
//  MainMessagesView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/27.
//

import SwiftUI

struct MainMessagesView: View {
    var body: some View {
        NavigationView {
            
            //Nav bar
            VStack{
                ScrollView{
                    ForEach(0..<10, id: \.self){num in
                        
                        VStack{
                            
                            HStack(spacing: 16){
                               Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                VStack(alignment: .leading){
                                    Text("Username")
                                    Text("Message sent to user")
                                }
                                Spacer()
                                Text("22d")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            Divider()
                        }.padding(.horizontal)
                        
                        
                    }
                    
                }
                
            }
            .navigationTitle("Main Messages View")
    
        }
       
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
