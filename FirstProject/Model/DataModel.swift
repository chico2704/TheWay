//
//  DataModel.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 19..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct QuestionData {
    var idx : String?
    var uid : String?
    var nation : String?
    var title : String?
    var content : String?
    var answeredCount : String?
    var commentCount : String?
    var date : Timestamp?
    var userData : UserData?
    var commentData : [CommentData]?
    
    init(questionData:[String:Any],userData:(UserData)? = nil,commentData:([CommentData])? = nil) {
        
        self.idx = questionData["idx"] as? String
        self.uid = questionData["uid"] as? String
        self.nation = questionData["nation"] as? String
        self.title = questionData["title"] as? String
        self.content = questionData["content"] as? String
        self.answeredCount = questionData["answeredCount"] as? String
        self.commentCount = questionData["commentCount"] as? String
        self.date = questionData["date"] as? Timestamp
        self.userData = userData
        self.commentData = commentData
        
    }
}

struct CommentData {
    
//    var userData : UserData?
    var idx : String?
    var uid : String?
    var name : String?
    var content : String?
    var isSelected : Bool?
    var date : Timestamp?
    
    init(data:[String:Any]) {
        
//        self.userData = userData
        self.idx = data["idx"] as? String
        self.uid = data["uid"] as? String
        self.name = data["name"] as? String
        self.content = data["content"] as? String
        self.isSelected = data["isSelected"] as? Bool
        self.date = data["date"] as? Timestamp
        
    }
    
}

struct UserData {
    
    var uid : String?
    var email : String?
    var name : String?
    var token : String?
    var profileImagePath : String?
    var backgroundImagePath : String?
    
    init(data:[String:Any]) {
        
        self.uid = data["uid"] as? String
        self.email = data["email"] as? String
        self.name = data["name"] as? String
        self.token = data["token"] as? String
        self.profileImagePath = data["profileImagePath"] as? String
        self.backgroundImagePath = data["backgroundImagePath"] as? String
        
    }
}

struct SupportData {
    var uid: String?
    var email: String?
    var name: String?
    var content: String?
    var date: Timestamp?
    
    init(data: [String : Any]) {
        self.uid = data["uid"] as? String
        self.email = data["email"] as? String
        self.name = data["name"] as? String
        self.content = data["content"] as? String
        self.date = data["date"] as? Timestamp
    }
}


