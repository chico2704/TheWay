 //
//  Firebase.swift
//  FirstProject
//
//  Created by ROGER on 23/06/2018.
//  Copyright © 2018 hexcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import FirebaseStorage
import FirebaseFirestore


// 파이어 스토어 레퍼런스
struct FirestoreRef {
    
    static let userRef = Firestore.firestore().collection("user")
    static let questionRef = Firestore.firestore().collection("question")
    
    static func bookmarkRef(_ uid:String) -> CollectionReference {
        let ref = Firestore.firestore().collection("user").document(uid).collection("bookmark")
        return ref
    }
    
    static func postRef(_ uid:String) -> CollectionReference {
        let ref = Firestore.firestore().collection("user").document(uid).collection("post")
        return ref
    }
    
    static func commentRef(_ postIdx:String) -> CollectionReference {
        let ref = Firestore.firestore().collection("question").document(postIdx).collection("comment")
        return ref
    }
    
    static func supportRef(_ uid: String) -> CollectionReference {
        let ref = Firestore.firestore().collection("support").document(uid).collection("list")
        return ref
    }

}

// 스토리지 레퍼런스
struct StorageRef {
    
    static let profileImageRef = Storage.storage().reference().child("profileImage")
    static let backgroundImageRef = Storage.storage().reference().child("backgroundImage")
    
}



struct Firebase {
        
    // 디비에 유저등록
    static func addUserDoc(_ data : [String:Any],completion: @escaping () -> Void) {

        guard let uid = data["uid"] as? String else { return }
    
        FirestoreRef.userRef.document(uid).setData(data) { error in
            if let err = error {
                UIAlertController.showMessage(err.localizedDescription)
            } else {
                print("addUserDoc Document successfully written!")
                Indicator.shared.hide()                
                completion()
            }
        }
    }
    
    
    // 유저 데이터 가져오기
    // parameter : uid == 유저 고유 아이디
    static func getUserDoc(_ uid:String,completion: @escaping (UserData) -> Void) {
        
        FirestoreRef.userRef.document(uid).getDocument {(snap, error) in
            
            if let err = error {
                
                UIAlertController.showMessage(err.localizedDescription)
                
            } else {
                
                guard let data = snap?.data() else { return }
                let userData = UserData(data: data)
                completion(userData)
            }
            
        }
    }
    

    
    // 디비에 유저검색
    // 유저가 존재하면 컴플리션으로 true 반환 밑 싱글톤 객체에 데이터 삽입, 없으면 false 반환
    // parameter : uid == 유저 고유 아이디
    static func searchUser(_ uid: String ,completion: ((Bool) -> ())? = nil) {
        
        let user = Firestore.firestore().collection("user").document(uid)
        
        user.getDocument { (doc, error) in
            if let err = error {
                print("searchUser :",err.localizedDescription)
            } else {
                
                if let data = doc?.data() {
                    guard let email = data["email"] as? String else { return }
                    guard let uid = data["uid"] as? String else { return }
                    guard let name = data["name"] as? String else { return }
                    //                    guard let profileImagePath = data["profileImagePath"] as? String else { return }
                    
                    User.shared.email = email
                    User.shared.uid = uid
                    User.shared.name = name
                    //                    User.shared.profileImagePath = profileImagePath
                    completion?(true)
                }
            }
            completion?(false)
        }
    }

    

    // 포스팅 데이터 포스터 컬렉션에 등록 밑 유저 컬렉션 - 포스트컬렉션에 등록
    static func addQuestionDoc(_ data : [String:Any],completion:@escaping (String) -> Void) {
        Indicator.shared.show()
        
        // 난수로 이루어진 도큐먼트 아이디 가지고오기
        let ref = FirestoreRef.questionRef.document()
        let idx = ref.documentID
        
        var questionData = data
        questionData.updateValue(idx, forKey: "idx")
        
        ref.setData(questionData) { error in
            
            if let err = error {
                
                UIAlertController.showMessage(err.localizedDescription)
                
            } else {
                
                var data = [String:Any]()
                data.updateValue(idx, forKey:"idx")
                FirestoreRef.postRef(User.shared.uid).document(idx).setData(data, completion: { error in
                    
                    if let err = error {
                        
                        UIAlertController.showMessage(err.localizedDescription)
                        
                    } else {
                        
                        Indicator.shared.hide()
                        completion(idx)
                    }
                })
            }
        }
    }
    
    
    // 북마크 등록
    static func addBookmarkDoc(_ idx:String,completion:(() -> Void)? = nil) {
        
        let parameter : [String:Any] = ["idx" : idx]
        
        FirestoreRef.bookmarkRef(User.shared.uid).document(idx).setData(parameter, merge: true) { (error) in
            if let err = error {
                UIAlertController.showMessage(err.localizedDescription)
            } else {
                completion?()
            }
        }
    }
    
    // 북마크 삭제
    static func removeBookmarkDoc(_ idx:String,completion:(() -> Void)? = nil) {
        
        FirestoreRef.bookmarkRef(User.shared.uid).document(idx).delete { (error) in
            if let err = error {
                UIAlertController.showMessage(err.localizedDescription)
            } else {
                completion?()
            }
        }
    }
    
    // 코멘트 가져오기
    // parameter : idx == 게시물 인덱스값
    static func getCommentDoc(_ idx:String, completion:@escaping ([CommentData]) -> Void) {
        
        FirestoreRef.commentRef(idx).order(by:"date", descending: true).getDocuments {(snap, error) in
            
            if let err = error {
                
                UIAlertController.showMessage(err.localizedDescription)
                
            } else {
                
                var comment = [CommentData]()
                
                guard let commentIsEmpty = snap?.isEmpty else { return }
                
                if commentIsEmpty {
                    
                    // 코멘트가 하나도 안달려있을때
                    completion([])
                    
                } else {
                    // 코멘트가 존재할때
                    snap?.documents.forEach({(doc) in
                    
                        let data = doc.data()
                        let commentData = CommentData(data: data)
                        comment.append(commentData)
                        
                    })
                    
                    completion(comment)
                }
            }
            
        }
        
    }
    
    
    // 코멘트 등록하기
    static func addCommentDoc(_ data :[String:Any] ,idx postIdx : String,completion:@escaping (String) -> Void) {
        
        let ref = FirestoreRef.commentRef(postIdx).document()
        let idx = ref.documentID
        var commentData = data
        commentData.updateValue(idx, forKey:"idx")

        ref.setData(commentData, merge: true) { error in
            
            if let err = error {
                
                UIAlertController.showMessage(err.localizedDescription)
                
            } else {
                
                completion(idx)
                
            }
        }
        
    }
    
    
    // 유저 데이터 변경하기
    static func setUserData(uid : String, data : [String:Any],completion: (() -> ())? = nil ) {
        FirestoreRef.userRef.document(uid).setData(data, merge: true)
        completion!()
    
    }

    // 퀘스쳔 데이터 변경하기
    static func setQuestionData(idx : String , data : [String:Any],completion: (() -> ())? = nil) {
        FirestoreRef.questionRef.document(idx).setData(data)
        completion!()
        
    }
    

    
    
    
    
    //스토리지 매써드 ==================================================
    
    // 프로파일 이미지 등록
    static func addProfileImage(_ uid: String, profileImage: Data, completion: @escaping () -> Void) {
        
        StorageRef.profileImageRef.child(uid).putData(profileImage, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print("Error writing profileImage into document: \(error!)")
                return
            }
            
            if let metadata = metadata {
                guard let path = metadata.path else { return }
                let dataToSave: [String : Any] = ["profileImagePath" : path]
                
                FirestoreRef.userRef.document(uid).updateData(dataToSave) { (error) in
                    if let error = error {
                        print("error: ", error.localizedDescription)
                    } else {
                        print("proifleImage data has been saved!")
                        Indicator.shared.hide()
                        completion()
                    }
                }
            }
        }
    }
    
    // 배경화면 이미지 등록
    static func addBackgroundImage(_ uid: String, backgroundImage: Data, completion: @escaping () -> Void) {
        
        StorageRef.backgroundImageRef.child(uid).putData(backgroundImage, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print("Error writing backgroundImage into document: \(error!)")
                return
            }
            
            if let metadata = metadata {
                guard let path = metadata.path else { return }
                let dataToSave: [String : Any] = ["backgroundImagePath" : path]
                
                FirestoreRef.userRef.document(uid).updateData(dataToSave) { (error) in
                    if let error = error {
                        print("error: ", error.localizedDescription)
                    } else {
                        print("backgroundImage data has been saved!")
                        completion()
                    }
                }
            }
        }
    }
    
    // 프로필 이미지 초기화
    static func initializeProfileImage(_ uid: String, completion: @escaping() -> Void) {

        FirestoreRef.userRef.document(uid).updateData([
            "profileImagePath": FieldValue.delete()]) { error in
                if let error = error {
                    print("Error deleting profile path: \(error)")
                } else {
                    print("profileImage path successfully deleted")
                }
        }
        
        StorageRef.profileImageRef.child(uid).delete { error in
            if let error = error {
                print("Error deleting profile file: \(error)")
            } else {
                print("profileImage file successfully deleted")
                completion()
            }
        }
    }
    
    // 백그라운드 이미지 초기화
    static func initializeBackgroundImage(_ uid: String, completion: @escaping() -> Void) {
        
        FirestoreRef.userRef.document(uid).updateData([
            "backgroundImagePath": FieldValue.delete()]) { error in
                if let error = error {
                    print("Error deleting background path: \(error)")
                } else {
                    print("backgroundImage path successfully deleted")
                }
        }
        
        StorageRef.backgroundImageRef.child(uid).delete { error in
            if let error = error {
                print("Error deleting profile file: \(error)")
            } else {
                print("backgroundImage file successfully deleted")
                Indicator.shared.hide()
                completion()
            }
        }
    }
}

