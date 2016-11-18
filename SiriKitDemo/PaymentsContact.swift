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
                    var emailStr = ""
                    
                    var number: CNPhoneNumber!
                    
                    if contact.phoneNumbers.count > 0 {
                        number = contact.phoneNumbers[0].value
                        phoneStr = number.stringValue.replacingOccurrences(of: "-", with: "")
                    }
                    if contact.emailAddresses.count > 0 {
                        emailStr = contact.emailAddresses[0].value as String
                    }
                    nameStr = contact.givenName  + " " + contact.middleName + " " + contact.familyName
                    if !nameStr.isEmpty && !phoneStr.isEmpty {
                        //print(contact.givenName + contact.familyName)
                        //print(contact.identifier)
                        pcAry.append(PaymentsContact(name: nameStr, emailAddress: "foo email", phoneNumber: phoneStr))
                    }
                    if !nameStr.isEmpty && !emailStr.isEmpty{
                        pcAry.append(PaymentsContact(name: nameStr, emailAddress: emailStr, phoneNumber: "foo phone"))
                    }
                }
                DispatchQueue.main.async {
                    comp(pcAry)
                }
            }
        })
    }
    
    public func inPerson() -> INPerson {
        let nameFormatter = PersonNameComponentsFormatter()
        var personHandle:INPersonHandle!

        if self.emailAddress == "foo email" {
            personHandle = INPersonHandle(value: phoneNumber, type: INPersonHandleType.phoneNumber)
        }else if self.phoneNumber == "foo phone" {
            personHandle = INPersonHandle(value: emailAddress, type: INPersonHandleType.emailAddress)
        }else {
            personHandle = INPersonHandle(value: phoneNumber, type: INPersonHandleType.emailAddress)
        }
        
        if let nameComponents = nameFormatter.personNameComponents(from: name) {
            
            var displayNameStr = ""
            if self.emailAddress == "foo email" {
                displayNameStr = (nameComponents.givenName == nil ? "" : (nameComponents.givenName!+" ")) + (nameComponents.middleName == nil ? "" : (nameComponents.middleName!+" ")) + (nameComponents.familyName == nil ? "" : nameComponents.familyName!) + ":" + self.phoneNumber
            }else if self.phoneNumber == "foo phone" {
                displayNameStr = (nameComponents.givenName == nil ? "" : (nameComponents.givenName!+" ")) + (nameComponents.middleName == nil ? "" : (nameComponents.middleName!+" ")) + (nameComponents.familyName == nil ? "" : nameComponents.familyName!) + ":" + self.emailAddress
            }else {
                displayNameStr = (nameComponents.givenName == nil ? "" : (nameComponents.givenName!+" ")) + (nameComponents.middleName == nil ? "" : (nameComponents.middleName!+" ")) + (nameComponents.familyName == nil ? "" : nameComponents.familyName!) + ":" + self.phoneNumber
            }
            
            return INPerson(personHandle: personHandle, nameComponents: nameComponents, displayName: displayNameStr, image: nil, contactIdentifier: nil, customIdentifier: nil)
        }else {
            return INPerson(personHandle: personHandle, nameComponents: nil, displayName: "Name Unavailable", image: nil, contactIdentifier: nil, customIdentifier: nil)
        }
    }
}
