//
//  SearchViewController.swift
//  FirstProject
//
//  Created by Euijae Hong on 2018. 7. 11..
//  Copyright © 2018년 hexcon. All rights reserved.
//




import Foundation
import UIKit


enum TableViewMode {
    
    case Card
    case History
    
}

class SearchViewController : UIViewController {
    
    var searchQuestionData = [QuestionData]() {
        
        didSet {
            
            //            reloadTableView()
            
        }
    }
    
    let searchBar = UISearchBar()
    
    
    var startPoint = FirestoreRef.questionRef.order(by: "date", descending: true).limit(to: 5)
    
    var searchHistoryData : [String]? = User.shared.getSearchHistory {
        
        didSet {
            
            self.searchHistoryData = User.shared.getSearchHistory
            
        }
        
    }
    
    
    lazy var tableView : UITableView = {
        
        let tv = UITableView()
        tv.registerCell(ofType: QuestionCardCell.self)
        tv.registerCell(ofType: SearchHistoryCell.self)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 1000
        tv.contentInset = UIEdgeInsetsMake(16, 0, 16, 0)
        tv.rowHeight = UITableViewAutomaticDimension
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = .white
        
        return tv
        
    }()
    
    
    var scrollFlag : Bool = false
    
    var tableViewMode: TableViewMode = .History {
        
        didSet {
            
            reloadTableView()
            
        }
        
    }
    
    
    deinit {
        
        self.printDeinitMessage()
    }
    
    
}


//MARK:- Life Cycle
extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
        
        setupViews()
        setupSearchBar()
        
    }
    
}

//MARK:- SetupView
extension SearchViewController {
    
    private func setupViews() {
        
        view.addSubview(tableView)
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        definesPresentationContext = true
        
//        let searchIcon = UIImage(named: "searchIcon")?.withRenderingMode(.alwaysTemplate)
//        let xIcon = UIImage(named: "xIcon")?.withRenderingMode(.alwaysTemplate)
//        searchBar.setImage(searchIcon, for: .search, state: .normal)
//        searchBar.setImage(xIcon, for: .clear, state: .normal)
    }
}

//MARK: TableViewDelegate , TableviewDataSource
extension SearchViewController : UITableViewDelegate,UITableViewDataSource {
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableViewMode {
        case .Card:
            return searchQuestionData.count
            
        case .History:
            
            guard let searchHistoryCount = self.searchHistoryData?.count else { return 0 }
            return searchHistoryCount
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableViewMode {
        case .Card:
            
            let cell = self.tableView.dequeueCell(ofType: QuestionCardCell.self, indexPath: indexPath)
            cell.questionData = self.searchQuestionData[indexPath.row]
            
            return cell
        case .History:
            
            let cell = self.tableView.dequeueCell(ofType: SearchHistoryCell.self, indexPath: indexPath)
            
            guard let searchHistory = self.searchHistoryData else { return UITableViewCell() }
            
            cell.historyLabel.text = searchHistory[indexPath.row]
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 키보드 내리기
        self.searchBar.resignFirstResponder()
        
        switch tableViewMode {
            
        case .Card:
            
            let questionDetailVC = QuestionDetailViewController()
            questionDetailVC.questionData = self.searchQuestionData[indexPath.row]
            self.navigationController?.pushViewController(questionDetailVC, animated: true)
            
        case .History:
            
            guard let words = searchHistoryData else { return }
            getSeachData(word: words[indexPath.row], completion: nil)
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 10.0 {
            
            if scrollFlag {
                
                //                getQuestionData()
                scrollFlag = false
                
            }
        }
        
    }
    
}


//MARK:- SearchBarDelegate
extension SearchViewController : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.tableViewMode = .History
        
        // search icon image and color change (editing status)
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
            let searchIconImage = textField.leftView as? UIImageView {
            searchIconImage.image = UIImage(named: "searchIcon")
            searchIconImage.tintColor = UIColor.placeHoderColor
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let word = self.searchBar.text {
            //키보드 내리기
            self.searchBar.resignFirstResponder()
            
            // 데이터가져오기
            getSeachData(word: word) {
                // 검색어 저장 (직접입력했을때만 저장)
                User.shared.setSearchHistory(word)
                self.searchHistoryData?.append(word)
            }
        }
        self.searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        }
    }
}

//MARK: - Action
extension SearchViewController {
    @objc func textFieldValueChanged(_ textField: UITextField) {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
            let clearButton = textField.value(forKey: "clearButton") as? UIButton {
            // font and textColor
            textField.textColor = UIColor.titleBlack
            textField.font = UIFont.systemFont(ofSize: 17)
            // adjust clearButton size
            let edgePadding: CGFloat = 2
            clearButton.imageEdgeInsets = UIEdgeInsets(top: edgePadding, left: edgePadding, bottom: edgePadding, right: edgePadding)
            // clearButtonImage & tintColor
            if clearButton.isHidden == false {
                clearButton.setImage(UIImage(named: "xIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
                clearButton.imageView?.tintColor = UIColor.placeHoderColor
            }
        }
    }
}

// Private Func
extension SearchViewController {
    
    // 검색 데이터가 없는경우 알럿
    private func showAlert(word:String) {
        
        let alertVC = UIAlertController(title:"sorry", message:"there is no question about '\(word)'", preferredStyle: .alert)
        let OK = UIAlertAction(title:"OK", style: .default, handler: nil)
        alertVC.addAction(OK)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func getSeachData(word:String,completion: (() -> Void)? = nil) {
        // 기존 검색 데이터 초기화
        self.searchQuestionData = []
        
        FirestoreRef.questionRef.getDocuments {[weak self] (snap, error) in
            
            let dispatchGroup = DispatchGroup()
            
            if let err = error {
                
                UIAlertController.showMessage(err.localizedDescription)
                
            } else {
                
                snap?.documents.forEach({[weak self] (data) in
                    
                    var questionData = data.data()
                    guard let uid = data["uid"] as? String else { return }
                    guard let idx = data["idx"] as? String else { return }
                    
                    if let title = data["title"] as? String , let content = data["content"] as? String {
                        
                        if title.contains(word) || content.contains(word) {
                            print("==============START=============")
                            dispatchGroup.enter()
                            
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
                                    
                                    self?.searchQuestionData.append(data)
                                    
                                    // date 최근 순으로 게시물 sort
                                    guard let sortedQuestionData = self?.searchQuestionData.sorted(by: {$0.date!.dateValue().compare(($1.date?.dateValue())!) == .orderedDescending}) else { return }
                                    
                                    self?.searchQuestionData = sortedQuestionData
                                    //self?.scrollFlag = beforeCount+5 == self?.questionData.count ? true : false
                                    
                                    dispatchGroup.leave()
                                    
                                })
                            })
                        }
                    }
                })
                
                // 모든작업완료
                dispatchGroup.notify(queue: .main, execute: {
                    
                    print("==============FINISH============")
                    //  써치 데이터 있는지 없는지 체크
                    guard let isEmpty = self?.searchQuestionData.isEmpty else { return }
                    
                    if isEmpty {
                        // 써치 데이터가 없을때
                        self?.tableViewMode = .History
                        self?.showAlert(word:word)
                    } else {
                        // 써치 데이터가 있을때
                        self?.tableViewMode = .Card
                    }
                    Indicator.shared.hide()
                    completion?()
                })
            }
        }
    }
}
