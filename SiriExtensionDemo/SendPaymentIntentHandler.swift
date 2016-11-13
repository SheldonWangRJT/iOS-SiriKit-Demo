//
//  SendPaymentIntentHandler.swift
//  SiriKitDemo
//
//  Created by Shinkangsan on 11/3/16.
//  Copyright © 2016 WhyQ Tech. All rights reserved.
//

import Intents

class SendPaymentIntentHandler: NSObject, INSendPaymentIntentHandling {
    /*!
     @brief handling method
     
     @abstract Execute the task represented by the INSendPaymentIntent that's passed in
     @discussion This method is called to actually execute the intent. The app must return a response for this intent.
     
     @param  sendPaymentIntent The input intent
     @param  completion The response handling block takes a INSendPaymentIntentResponse containing the details of the result of having executed the intent
     
     @see  INSendPaymentIntentResponse
     */
    
    public func handle(sendPayment intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Swift.Void) {
        if let _ = intent.payee, let _ = intent.currencyAmount {
            // Handle the payment here!
            let userActivity = NSUserActivity(activityType: "")
            completion(INSendPaymentIntentResponse.init(code: .success, userActivity: userActivity))
        }
        else {
            completion(INSendPaymentIntentResponse.init(code: .success, userActivity: nil))
        }
    }
    
    public func resolvePayee(forSendPayment intent: INSendPaymentIntent, with completion: @escaping (INPersonResolutionResult) -> Swift.Void) {
        
        if let payee = intent.payee {
            let contacts = PaymentsContact.allContacts()
            var resolutionResult: INPersonResolutionResult?
            var matchedContacts: [PaymentsContact] = []
            
            for contact in contacts {
                print("Checking '\(contact.name)' against '\(payee.displayName)'")
                
                if contact.name == payee.displayName {
                    matchedContacts.append(contact)
                }
            }
            
            switch matchedContacts.count {
            case 2 ... Int.max:
                let disambiguationOptions: [INPerson] = matchedContacts.map { contact in
                    return contact.inPerson()
                }
                resolutionResult = INPersonResolutionResult.disambiguation(with: disambiguationOptions)
            case 1:
                let recipientMatched = matchedContacts[0].inPerson()
                print("Matched a recipient: \(recipientMatched.displayName)")
                resolutionResult = INPersonResolutionResult.success(with: recipientMatched)
                
            case 0:
                print("This is unsupported")
                resolutionResult = INPersonResolutionResult.unsupported()
            default:
                break
            }
            completion(resolutionResult!)
        } else {
            completion(INPersonResolutionResult.needsValue())
        }
        
    }
}
