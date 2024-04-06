//
//  ModelTests.swift
//  CoreData-ContactNoteTests
//
//  Created by Đoàn Văn Khoan on 02/04/2024.
//

import XCTest
@testable import CoreData_ContactNote

final class ModelTests: XCTestCase {

    private var provider: ContactsProvider!
    
    override func setUp(){
        provider = .shared
    }
    
    override func tearDown() {
        provider = nil
    }

    func testContactIsEmpty() {
        let contact = Contact.empty(context: provider.viewContext)
        XCTAssertEqual(contact.name, "")
        XCTAssertEqual(contact.email, "")
        XCTAssertEqual(contact.phoneNumber, "")
        XCTAssertFalse(contact.isFavourite)
        XCTAssertTrue(Calendar.current.isDateInToday(contact.dob))
    }
    
    func testContactIsNotValid() {
        let contact = Contact.empty(context: provider.viewContext)
        XCTAssertFalse(contact.isValid)
    }
    
    func testContactIsValid() {
        let contact = Contact.preview(context: provider.viewContext)
        XCTAssertTrue(contact.isValid)
    }
    
    func testContactsBirthdayIsValid() {
        let contact = Contact.preview(context: provider.viewContext)
        XCTAssertTrue(contact.isBirthday)
    }
    
    func testContactsBirthdayIsNotValid() throws {
        let contact = try XCTUnwrap(Contact.makePreview(count: 10,in: provider.viewContext).last)
        XCTAssertFalse(contact.isBirthday)
    }
    
    func testMakeContactsPreviewIsValid() {
        let count = 5
        let contacts = Contact.makePreview(count: count, in: provider.viewContext)
        
        for i in 0..<contacts.count {
            let item = contacts[i]
            XCTAssertEqual(item.name, "item \(i)")
            XCTAssertEqual(item.email, "item_\(i)@gmail.com")
            XCTAssertNotNil(item.isFavourite) // can be random just sure it's not nil
            XCTAssertEqual(item.phoneNumber, "0888\(i)")
            
            let dateToCompare = Calendar.current.date(byAdding: .day, value: -i, to: .now)
            let dobDay = Calendar.current.dateComponents([.day], from: item.dob, to: dateToCompare!).day
            
            XCTAssertEqual(dobDay, 0)
            XCTAssertEqual(item.notes, "This is preview for item \(i)")
        }
    }
    
    func testFilterFaveContactsRequestIsValid() {
        let request = Contact.filter(with: .init(filter: .fave))
        XCTAssertEqual("isFavourite == 1", request.predicateFormat)
    }
    
    func testFilterAllFaveContactsRequestIsValid() {
        let request = Contact.filter(with: .init(filter: .all))
        XCTAssertEqual("TRUEPREDICATE", request.predicateFormat)
    }
    
    func testFilterAllWithQueryContactsRequestIsValid() {
        let query = "simon"
        let request = Contact.filter(with: .init(query: query))
        XCTAssertEqual("name CONTAINS[cd] \"\(query)\"", request.predicateFormat)
    }
    
    func testFilterFaveWithQueryContactsRequestIsValid() {
        let query = "simon"
        let request = Contact.filter(with: .init(query: query, filter: .fave))
        XCTAssertEqual("name CONTAINS[cd] \"\(query)\" AND isFavourite == 1", request.predicateFormat)
    }
}
