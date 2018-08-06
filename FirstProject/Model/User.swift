//
//  User.swift
//  FirstProject
//
//  Created by ROGER on 25/06/2018.
//  Copyright © 2018 hexcon. All rights reserved.
//

import Foundation
import UIKit

//enum FieldKey {
//    case email
//    case token
//    case name
//    case date
//    case
//}



// 싱글톤 유저 클래스
class User {
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    static let shared = User()
    
    var email : String = ""
    var name : String = ""
    var uid : String = ""
    var token : String = ""
    var profileImagePath : String = ""
    var backgroundImagePath : String = ""
    var bookmark : [String] = []
    
    
    public func setLoginType(_ type : String) { userDefaults.set(type, forKey:"loginType") }
        
    public func setUid(_ uid:String) { UserDefaults.standard.set(uid, forKey: "uid")}
    public func setEmail(_ email:String) { UserDefaults.standard.set(email, forKey:"email") }
    public func setToken(_ token:String) { UserDefaults.standard.set(token, forKey: "token")}
    public func setName(_ name:String) { UserDefaults.standard.set(name, forKey: "name")}
    
    public func setSearchHistory(_ word:String) {
        
        var history = [String]()

        if let searchHistory = userDefaults.array(forKey:"searchHistory") as? [String] { history = searchHistory }

        history.append(word)
        userDefaults.set(history, forKey: "searchHistory")

    }
    
    public var getSearchHistory : [String]? {
        
        guard let searchHistory = userDefaults.array(forKey:"searchHistory") as? [String]  else { return nil }
        return searchHistory
        
    }
    
    public var getUid : String? {

        guard let uid = UserDefaults.standard.string(forKey:"uid") else { return nil }
        return uid
    }
    
    public var getLoginType : String? {
        
        guard let email = userDefaults.string(forKey:"loginType") else { return nil }
        return email
    }
    
//    public var getToken : String? {
//
//        guard let token = UserDefaults.standard.string(forKey:"token") else { return nil}
//        return token
//    }
    
//    public var getName : String? {
//
//        guard let name = UserDefaults.standard.string(forKey:"name") else { return nil}
//        return name
//    }
    
}
