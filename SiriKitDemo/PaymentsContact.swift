//
//  Contact.swift
//  SiriKitDemo
//
//  Created by Shinkangsan on 11/3/16.
//  Copyright © 2016 WhyQ Tech. All rights reserved.
//

import UIKit
import Intents

public class PaymentsContact:NSObject {
    public let name: String
    public let emailAddress: String
    
    public init(name: String, emailAddress: String) {
        self.name = name
        self.emailAddress = emailAddress
    }
    
    public class func allContacts() -> [PaymentsContact] {
        return [
            PaymentsContact(name: "Naman", emailAddress: "tim@apple.com"),
            PaymentsContact(name: "Sheldon Wang", emailAddress: "phil@apple.com"),
            PaymentsContact(name: "", emailAddress: "noname@apple.com"),
            PaymentsContact(name: "Tim Cook", emailAddress: "tim@apple.com")
        ]
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
