//
//  CreateNewMessageView.swift
//  ChatApp
//
//  Created by Buhle Radzilani on 2024/06/30.
//

import SwiftUI

struct CreateNewMessageView: View {
    var body: some View {
       
        
        NavigationView {
            ScrollView{
                ForEach(0..<10) { num in
                    Text("New User")
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            <#code#>
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
    }
}
