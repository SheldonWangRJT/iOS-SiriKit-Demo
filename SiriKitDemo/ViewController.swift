//
//  ViewController.swift
//  SiriKitDemo
//
//  Created by Shinkangsan on 11/3/16.
//  Copyright © 2016 WhyQ Tech. All rights reserved.
//

import UIKit
import Intents
import LocalAuthentication
import Contacts

class ViewController: UIViewController {
    
    var error: NSError?
    var myLocalizedReasonString = "Authentication is required"
    
    
    @IBOutlet weak var contactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        INPreferences.requestSiriAuthorization { (status) in
            print(status)
        }
        
        self.authenticateUser()
        
        let groupId = "group.com.SiriKitDemo.Sheldon"
        let fileMnger = FileManager.default
        let sharedContainer = fileMnger.containerURL(forSecurityApplicationGroupIdentifier: groupId)
        print(sharedContainer)
        let filePath = sharedContainer!.appendingPathComponent("featureFile.plist")
        print(filePath)
        
        let flagDict = NSMutableDictionary()
        flagDict.setValue(true, forKey: "featureFlag")
        flagDict.write(to: filePath, atomically: true)
        
        //sharedFilePath = dirPath?.stringByAppendingPathComponent(
        //    "sharedtext.doc")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func authenticateUser() {
        
//        let context = LAContext()
//        guard context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
//            switch (error as! LAError).code.rawValue {
//            case LAError.Code.touchIDNotEnrolled.rawValue:
//                print("TouchID not enrolled")
//            case LAError.Code.passcodeNotSet.rawValue:
//                print("Passcode not set")
//            default:
//                print("TouchID not available")
//            }
//            return
//        }
//        
//        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString
//            , reply: {(success, error) -> Void in
//            
//                
//                if success {
//                    OperationQueue.main.addOperation({ () -> Void in
//                        print("auth successfully")
//                    })
//                }else {
//                    print(error)
//                }
//        })
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: .contacts, completionHandler: {(granted, error) -> Void in
            
            self.contactLabel.text = (granted) ? "Contacts Authorized" : "Contacts Unkown"
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

