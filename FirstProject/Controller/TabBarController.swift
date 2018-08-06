//
//  ViewController.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 15..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
        getBookmarkDoc()

    }
}

extension TabBarController : UITabBarControllerDelegate  {
    
    func setupTabBarController() {
        
        self.delegate = self
        self.view.backgroundColor = .white
        self.tabBar.isTranslucent = false
        
        let questionNVC = UINavigationController(rootViewController: QuestionViewController())
        questionNVC.tabBarItem.selectedImage = UIImage(named: "tabOneSelected")?.withRenderingMode(.alwaysOriginal)
        questionNVC.tabBarItem.image = UIImage(named: "tabOneDeselected")?.withRenderingMode(.alwaysOriginal)
        questionNVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
//        let searchNVC = UINavigationController(rootViewController: SearchViewController())
//        searchNVC.tabBarItem.title = "Search"
    
        let myPageNVC = UINavigationController(rootViewController: MyPageViewController())
        myPageNVC.tabBarItem.selectedImage = UIImage(named: "tabTwoSelected")?.withRenderingMode(.alwaysOriginal)
        myPageNVC.tabBarItem.image = UIImage(named: "tabTwoDeselected")?.withRenderingMode(.alwaysOriginal)
        myPageNVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        viewControllers = [questionNVC,myPageNVC]
    }
    
    //    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    //
    //        guard let index = viewControllers?.index(of: viewController) else { return false }
    //
    //        if (index == 2) {
    //
    ////            let postingVC = PostingVC()
    ////            let postingNVC = UINavigationController(rootViewController: postingVC)
    //
    ////            self.present(postingNVC, animated: true, completion: nil)
    //
    //            return false
    //        }
    //
    //        return true
    //    }
    
}


// Firebase
extension TabBarController {
    
    private func getBookmarkDoc() {
        
        FirestoreRef.bookmarkRef(User.shared.uid).getDocuments { (snap, error) in
            
            if let err = error {
                
                print(err.localizedDescription)
                
            } else {
                
                snap?.documents.forEach({ (doc) in
                    
                    let idx = doc.documentID
                    User.shared.bookmark.append(idx)
   
                })
            }
        }
    }
}
