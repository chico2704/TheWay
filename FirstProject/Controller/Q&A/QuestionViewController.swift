//
//  QuestionViewController.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 15..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Crashlytics



class QuestionViewController : UIViewController {
    
    var questionData = [QuestionData]() {
        
        didSet {
            reloadTableView()
        }
    }

    var searchController = UISearchController(searchResultsController: nil)
    
    var startPoint = FirestoreRef.questionRef.order(by: "date", descending: true).limit(to: 5)

    lazy var tableView : UITableView = {
        
        let tv = UITableView()
        tv.registerCell(ofType: QuestionCardCell.self)
        tv.registerCell(ofType: SearchHistoryCell.self)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 1000
        tv.rowHeight = UITableViewAutomaticDimension
        tv.contentInset = UIEdgeInsetsMake(16, 0, 16, 0)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    
    var scrollFlag : Bool = false
//    var tableViewType : TableViewMode = .Card {
//        didSet {
//            reloadTableView()
//        }
//
//    }
    
    deinit {

        self.printDeinitMessage()
    }
    
    
}


//MARK:- Life Cycle
extension QuestionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupViews()
        getQuestionData()
    }
    

}

//MARK:- Setup SubViews
extension QuestionViewController {
    
    private func setupNavi() {
        let writeImage = UIImage(named: "write")
        let rightBarButton = UIBarButtonItem(image: writeImage, style: .done, target: self, action: #selector(goToWriteVC))
        navigationItem.title = "Q&A"
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController = self.searchController
        navigationController?.hidesBarsOnSwipe = true
        setupSearchBar()
    }
    
    private func setupViews() {
        
        view.addSubview(tableView)
        tableView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        let searchIcon = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysTemplate)
        let xIcon = UIImage(named: "xIcon")?.withRenderingMode(.alwaysTemplate)
        searchController.searchBar.setImage(searchIcon, for: .search, state: .normal)
        searchController.searchBar.setImage(xIcon, for: .clear, state: .normal)
    }
}

//MARK:- UISearchBarDelegate
extension QuestionViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let searchVC = SearchViewController()
        let searchNVC = UINavigationController(rootViewController: searchVC)
        searchVC.modalTransitionStyle = .crossDissolve
        searchVC.modalPresentationStyle = .currentContext
        self.present(searchNVC, animated: true, completion: nil)
        
        return false
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        
        if let textField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField,

           let backgroundview = textField.subviews.first {
            // search icon
            let searchIconImage = textField.leftView as! UIImageView
            searchIconImage.tintColor = UIColor.placeHoderColor
            
            // placeholder
            let attributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.placeHoderColor,
                                                             .font            : UIFont.systemFont(ofSize: 15)]
            textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
            
            // remove background shade
            for subview in backgroundview.subviews {
                subview.removeFromSuperview()
                
                // background color
                backgroundview.backgroundColor = UIColor.backgroundGray
                // background rounded corner
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
    }
}
    


//MARK:- Setup TableView
extension QuestionViewController : UITableViewDelegate,UITableViewDataSource {
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return questionData.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueCell(ofType: QuestionCardCell.self, indexPath: indexPath)
            cell.questionData = self.questionData[indexPath.row]
            
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let questionDetailVC = QuestionDetailViewController()
        questionDetailVC.questionData = self.questionData[indexPath.row]
        questionDetailVC.row = indexPath.row
        questionDetailVC.delegate = self
        self.navigationController?.pushViewController(questionDetailVC, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10.0 {
            
            if scrollFlag {
                
                getQuestionData()
                scrollFlag = false
                
            }
        }
        
    }
}


//MARK:- Data
extension QuestionViewController {
    
    private func getQuestionData() {
        Indicator.shared.show()
        self.startPoint.getDocuments { (snap, error) in

            if let err = error {

                UIAlertController.showMessage(err.localizedDescription)

            } else {
                
                let dispatchGroup = DispatchGroup()
                
                // 추가 로드 하기전의 question data 갯수
                let beforeCount = self.questionData.count
                snap?.documents.forEach({[weak self] doc in
                    
                    // 디스패치큐,그룹 공부해라
                    dispatchGroup.enter()
                
                    // 게시물 데이터 들고옴
                    var questionData = doc.data()
                    guard let uid = questionData["uid"] as? String else { return }
                    guard let idx = questionData["idx"] as? String else { return }

                    // 게시물안에 들어있는 작성자 uid를 통해서 유저 데이터 다시 쿼리
                    Firebase.getUserDoc(uid, completion: {[weak self] (user) in
                    
                        Firebase.getCommentDoc(idx, completion: {[weak self] (comment) in
                            
                            var answerCount = 0
                            comment.forEach({ (data) in
                                guard let isSelected = data.isSelected else { return }
                                if isSelected { answerCount += 1 }
                            })
                            
                            questionData.updateValue("\(comment.count)", forKey:"commentCount")
                            questionData.updateValue("\(answerCount)", forKey:"answerCount")
                            
                            let data = QuestionData(questionData: questionData, userData: user, commentData: comment)
                            
                            self?.questionData.append(data)
                            
                            // date 최근 순으로 게시물 sort
                            guard let sortedQuestionData = self?.questionData.sorted(by: {$0.date!.dateValue().compare(($1.date?.dateValue())!) == .orderedDescending}) else { return }
                            
                            self?.questionData = sortedQuestionData
                            self?.scrollFlag = beforeCount+5 == self?.questionData.count ? true : false
                            
                            // 디스패치큐,그룹 공부해라
                            dispatchGroup.leave()

                        })
  
                    })
 
                })
                
                // 모든작업완료
                dispatchGroup.notify(queue: .main, execute: {
        
                    Indicator.shared.hide()
                })
                
            }

            guard let lastSnapshot = snap?.documents.last else {
                // The collection is empty.
                Indicator.shared.hide()
                return
            }

            
            let next = FirestoreRef.questionRef.order(by: "date", descending : true).start(afterDocument: lastSnapshot).limit(to: 5)
            self.startPoint = next
            
        }
 
    }
    
}


//MARK: Actions
extension QuestionViewController {
    
    @objc fileprivate func goToWriteVC() {
        
        let writeVC = WriteViewController()
        writeVC.delegate = self
        let writeNVC = UINavigationController(rootViewController: writeVC)
        self.present(writeNVC, animated: true, completion: nil)
        
    }
    
//    private func animationTableView() {
//
//        DispatchQueue.main.async {
//
//            self.tableView.reloadData()
//            let cells = self.tableView.visibleCells
//
//            let tableViewHeight = self.tableView.bounds.size.height
//
//            for cell in cells {
//
//                cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
//
//            }
//
//            var delayCounter = 1
//            for cell in cells {
//
//                UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut,           animations: {
//
//                    cell.transform = CGAffineTransform.identity
//                }, completion: nil)
//
//                delayCounter += 1
//
//            }
//        }
//    }
    
}


//MARK:- QuestionDetailViewControllerDelegate
extension QuestionViewController : QuestionDetailViewControllerDelegate {
    
    func deleteQuestionData(row: Int) {
        
        self.questionData.remove(at: row)
    }

    
    func updateQuestionData(data: [CommentData], row: Int) {
        self.questionData[row].commentCount = String(data.count)
        self.questionData[row].commentData = data
//        reloadTableView()
        
    }

}


//MARK:- WriteViewControllerDelegate
extension QuestionViewController : WriteViewControllerDelegate {
    
    func reloadTableView(questionData: QuestionData) {
        
        self.questionData.insert(questionData, at: 0)
        
    }
    
}


