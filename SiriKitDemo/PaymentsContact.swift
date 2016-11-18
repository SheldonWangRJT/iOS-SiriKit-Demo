//
//  Contact.swift
//  SiriKitDemo
//
//  Created by Shinkangsan on 11/3/16.
//  Copyright © 2016 WhyQ Tech. All rights reserved.
//

import UIKit
import Intents
import Contacts

public class PaymentsContact:NSObject {
    public let name: String
    public let emailAddress: String
    public let phoneNumber: String
    
    public init(name: String, emailAddress: String, phoneNumber: String) {
        self.name = name
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
    }
    
    public class func allContacts(comp:@escaping ([PaymentsContact])->Void){
        
        let contactStroe = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey] as [Any]
        contactStroe.requestAccess(for: .contacts, completionHandler: {(granted, error) -> Void in
            if granted {
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactStroe.defaultContainerIdentifier())
                var contacts: [CNContact]! = []
                do {
                    contacts = try contactStroe.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])// [CNContact]
                }catch {
                    
                }
                
                var pcAry = [PaymentsContact]()
                for contact in contacts {
                    var phoneStr = ""
                    var nameStr = ""
                    var number: CNPhoneNumber!
                    if contact.phoneNumbers.count > 0 {
                        number = contact.phoneNumbers[0].value
                        phoneStr = number.stringValue.replacingOccurrences(of: "-", with: "")
                    }
                    nameStr = contact.familyName + contact.givenName
                    if !nameStr.isEmpty && !phoneStr.isEmpty {
                        print(contact.givenName + contact.familyName)
                        print(contact.identifier)
                        pcAry.append(PaymentsContact(name: nameStr, emailAddress: "foo email", phoneNumber: phoneStr))
                    }
                }
                DispatchQueue.main.async {
                    comp(pcAry)
                }
            }
        })
//        return [
//            PaymentsContact(name: "Naman", emailAddress: "tim@apple.com"),
//            PaymentsContact(name: "Sheldon Wang", emailAddress: "phil@apple.com"),
//            PaymentsContact(name: "", emailAddress: "noname@apple.com"),
//            PaymentsContact(name: "Tim Cook", emailAddress: "tim@apple.com")
//        ]
    }
    
    public func inPerson() -> INPerson {
        let nameFormatter = PersonNameComponentsFormatter()
        let personHandle = INPersonHandle(value: emailAddress, type: INPersonHandleType.emailAddress)

        if let nameComponents = nameFormatter.personNameComponents(from: name) {
            //return INPerson(handle: emailAddress, nameComponents: nameComponents, contactIdentifier: nil)
            return INPerson(personHandle: personHandle, nameComponents: nameComponents, displayName: nameComponents.familyName, image: nil, contactIdentifier: nil, customIdentifier: nil)
        }else {
            return INPerson(personHandle: personHandle, nameComponents: nil, displayName: "Name Unavailable", image: nil, contactIdentifier: nil, customIdentifier: nil)
        }
//        else {
//            return INPerson(handle: emailAddress, displayName: name, contactIdentifier: nil)
//        }
    }
}
