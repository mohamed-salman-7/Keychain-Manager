//
//  ViewController.swift
//  Keychain Demo
//
//  Created by Mohamed Salman on 18/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func onlyGenericPassword() {
        // only password update on keychain:
        let keychainItemQuery = [
            kSecValueData: "Pullip2020".data(using: .utf8)!,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let status = SecItemAdd(keychainItemQuery, nil)
        print("Operation finished with status: \(status)")
    }
    
    func createOneClass() {
        // one class update on keychain
        let keychainItem = [
            kSecValueData: "Test@123".data(using: .utf8)!,
            kSecAttrAccount: "Mohamed",
            kSecAttrServer: "sparktest.com",
            kSecClass: kSecClassInternetPassword
        ] as CFDictionary
        
        let status = SecItemAdd(keychainItem, nil)
        print("Operation finished with status: \(status)")
    }
    
    func addUser() {
        // add user in same class
        let keychainItem = [
            kSecValueData: "Test@123".data(using: .utf8)!,
            kSecAttrAccount: "andyibanez",
            kSecAttrServer: "sparktest.com",
            kSecClass: kSecClassInternetPassword,
            kSecReturnAttributes: true
        ] as CFDictionary
        
        var ref: AnyObject?
        
        let status = SecItemAdd(keychainItem, &ref)
        let result = ref as! NSDictionary
        print("Operation finished with status: \(status)")
        print("Returned attributes:")
        result.forEach { key, value in
            print("\(key): \(value)")
        }
    }
    
    func addUserWithPW() {
        let keychainItem = [
            kSecValueData: "Test@123".data(using: .utf8)!,
            kSecAttrAccount: "salman",
            kSecAttrServer: "sparktest.com",
            kSecClass: kSecClassInternetPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var ref: AnyObject?
        
        let status = SecItemAdd(keychainItem, &ref)
        let result = ref as! Data
        print("Operation finished with status: \(status)")
        let password = String(data: result, encoding: .utf8)!
        print("Password: \(password)")
    }
    
    func addArrayOfUser() {
        // array of user add
        let usernames = ["shanmu", "Parthi"]
        
        usernames.forEach { username in
            let keychainItem = [
                kSecValueData: "\(username)-Pullip2020".data(using: .utf8)!,
                kSecAttrAccount: username,
                kSecAttrServer: "google.com",
                kSecClass: kSecClassInternetPassword,
                kSecReturnData: true,
                kSecReturnAttributes: true
            ] as CFDictionary
            
            var ref: AnyObject?
            
            let status = SecItemAdd(keychainItem, &ref)
            let result = ref as! NSDictionary
            print("Operation finished with status: \(status)")
            print("Username: \(result[kSecAttrAccount] ?? "")")
            let passwordData = result[kSecValueData] as! Data
            let passwordString = String(data: passwordData, encoding: .utf8)
            print("Password: \(passwordString ?? "")")
        }
    }
    
    func getSingleDetailFromClass() {
        // single details get:
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: "google.com",
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        print("Operation finished with status: \(status)")
        let dic = result as! NSDictionary
        
        let username = dic[kSecAttrAccount] ?? ""
        let passwordData = dic[kSecValueData] as! Data
        let password = String(data: passwordData, encoding: .utf8)!
        print("Username: \(username)")
        print("Password: \(password)")
    }
    
    func multiDetailsGetfromClass() {
        // multi details get:
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: "google.com",
            kSecReturnAttributes: true,
            kSecReturnData: true,
            kSecMatchLimit: 5
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        print("Operation finished with status: \(status)")
        let array = result as! [NSDictionary]
        
        array.forEach { dic in
            let username = dic[kSecAttrAccount] ?? ""
            let passwordData = dic[kSecValueData] as! Data
            let password = String(data: passwordData, encoding: .utf8)!
            print("Username: \(username)")
            print("Password: \(password)")
        }
    }
    
    func updateAllValueInClass() {
        // update some field:
        let newQuery = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: "google.com",
        ] as CFDictionary
        
        let updateFields = [
            kSecValueData: "newPassword".data(using: .utf8)!
        ] as CFDictionary
        
        let getStatus = SecItemUpdate(newQuery, updateFields)
        print("Operation finished with status: \(getStatus)")
    }
    
    func updateSpecificValueInClass() {
        // specific username value change
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: "google.com",
            kSecAttrAccount: "salman"
        ] as CFDictionary
        
        let updateFields = [
            kSecValueData: "NewPassword".data(using: .utf8)!
        ] as CFDictionary
        
        let status = SecItemUpdate(query, updateFields)
        print("Operation finished with status: \(status)")
    }
    
    func deleteAccount() {
        // delete keychain Value
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: "google.com",
            kSecAttrAccount: "blackberry"
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        print(("Operation finished with status: \(status)"))
    }
}

