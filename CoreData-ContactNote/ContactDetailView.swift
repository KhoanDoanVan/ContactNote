//
//  ContactDetailView.swift
//  CoreData-ContactNote
//
//  Created by Đoàn Văn Khoan on 01/04/2024.
//

import SwiftUI

struct ContactDetailView: View {
    
    let contact : Contact
    
    var body: some View {
        List {
            Section("General"){
                LabeledContent {
                    Text(contact.email)
                } label: {
                    Text("Email")
                }
                LabeledContent {
                    Text(contact.phoneNumber)
                } label: {
                    Text("Phone Number")
                }
                LabeledContent {
                    Text(contact.dob, style: .date)
                } label: {
                    Text("Birthday")
                }
            }
            
            Section("Notes") {
                Text(contact.notes)
            }
        }
        .navigationTitle(contact.formattedName)
    }
}

#Preview {
    NavigationStack{
        ContactDetailView(contact: .preview())
    }
}
