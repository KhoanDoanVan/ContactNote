//
//  NoContactView.swift
//  CoreData-ContactNote
//
//  Created by Đoàn Văn Khoan on 01/04/2024.
//

import SwiftUI

struct NoContactsView: View {
    var body: some View {
        VStack{
            Text("No Contacts")
                .font(.largeTitle)
            Text("It's seem a lil empty here create some contacts")
                .font(.callout)
        }
    }
}

#Preview {
    NoContactsView()
}
