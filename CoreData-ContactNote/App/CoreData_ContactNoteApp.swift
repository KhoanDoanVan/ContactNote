//
//  CoreData_ContactNoteApp.swift
//  CoreData-ContactNote
//
//  Created by Đoàn Văn Khoan on 01/04/2024.
//

import SwiftUI

@main
struct CoreData_ContactNoteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
        }
    }
}
