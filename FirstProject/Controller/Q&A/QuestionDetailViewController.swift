//
//  QuestionDetailViewController.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 16..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase

/*
    메뉴 버튼을 눌렀을때 나오는 액션 시트 타입
    Me = 나의 게시물일때
    Other = 다른사람 게시물일때
*/

enum MenuType {
    case Me
    case Other
}

protocol QuestionDetailViewControllerDelegate : class {
    func updateQuestionData(data:[CommentData],row:Int)
    func deleteQuestionData(row:Int)
}

class QuestionDetailViewController : UIViewController {
    
    var delegate : QuestionDetailViewControllerDelegate?
    var row = 0
    
    var questionData : QuestionData? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    var menuType : MenuType? {
        return self.questionData?.uid == User.shared.uid ? MenuType.Me : MenuType.Other
    }

    lazy var commentView : CommentView = {
        let cv = CommentView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: self.view.frame.width,
                                           height: 56))
        cv.commentTextView.delegate = self
        return cv
    }()

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return self.commentView
    }
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.registerCell(ofType: QuestionDetailProfileCell.self)
        tv.registerCell(ofType: QuestionDetailContentCell.self)
        tv.registerCell(ofType: QuestionDetailCommentCell.self)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 1000
        tv.rowHeight = UITableViewAutomaticDimension
        tv.showsVerticalScrollIndicator = false
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    deinit {
        self.printDeinitMessage()
        NotificationCenter.default.removeObserver(self) // bookmarkDidDeselect 노티 해제
    }
}

//MARK:- Life Cycle

extension QuestionDetailViewController {
    override func loadView() {
        super.loadView()
        view = tableView
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupViews()
        
        // bookmarkDidDeselect 노티 옵저버 (QuestionDetailVC-> MyPageVC)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyBookmarkButtonDidDeselect), name: .bookmarkButtonDidDeselect, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 텍스트뷰 디폴트 사이즈 리로드
        textViewDidChange(commentView.commentTextView)
    }
}

//MARK:- SetupViews
extension QuestionDetailViewController {
    
    fileprivate func setupNavi() {
        
        let leftBarButton = UIBarButtonItem(image:UIImage(named:"back"), style: .done, target: self, action: #selector(backToQuestionVC))
        leftBarButton.tintColor = .white
        navigationItem.title = "Q&A"
        navigationItem.leftBarButtonItem = leftBarButton
        
    
    }
    
    fileprivate func setupViews() {
        
        commentView.doneButton.addTarget(self, action: #selector(uploadComment(sender:)), for: .touchUpInside)
    }

}

//MARK:- TableViewDelegate , TableViewDataSource
extension QuestionDetailViewController : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 댓글 갯수 카운트 + 0번셀 프로필뷰 + 1번셀 콘텐츠 뷰
        
        guard let count = questionData?.commentData?.count else { return 2 }
        print("countcountcountcount",count)
        return count+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.row) {
        case 0:
            let cell = tableView.dequeueCell(ofType: QuestionDetailProfileCell.self, indexPath: indexPath)
            cell.menuButton.addTarget(self, action: #selector(popMenuAlert(sender:)), for: .touchUpInside)
            cell.questionData = self.questionData
            return cell
        case 1:
            let cell = tableView.dequeueCell(ofType: QuestionDetailContentCell.self, indexPath: indexPath)
//            cell.bookmarkButton.addTarget(self, action: #selector(popMenuAlert(sender:)), for: .touchUpInside)
            cell.questionData = self.questionData
            return cell
        default:
            let cell = tableView.dequeueCell(ofType: QuestionDetailCommentCell.self, indexPath: indexPath)
            cell.commentData = self.questionData?.commentData![indexPath.row - 2]
            cell.isSelectedButton.addTarget(self, action: #selector(isSelectedButtonTapped), for: .touchUpInside)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if questionData?.uid == User.shared.uid {

            switch indexPath.row {
            case 0,1:
                break
            default:
                guard let postIdx = self.questionData?.idx else { return }
                guard let commentIdx = self.questionData?.commentData![indexPath.row-2].idx else { return }
                var data = [String:Any]()

                let alertVC = UIAlertController(title:nil, message:"Would you like to select/deselect this answer?", preferredStyle: .alert)
                let cancel = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
                alertVC.addAction(cancel)

                if let isSelected = self.questionData?.commentData![indexPath.row-2].isSelected {

                    if isSelected {
                        data.updateValue(false, forKey:"isSelected")
                        let deselect = UIAlertAction(title:"Deselect", style: .destructive) { _ in

                            FirestoreRef.commentRef(postIdx).document(commentIdx).setData(data, merge: true, completion: {[weak self] (error) in
                                if let err = error {
                                    print(err.localizedDescription)
                                } else {
                                    self?.questionData?.commentData![indexPath.row-2].isSelected = false
                                }
                            })
                        }
                        alertVC.addAction(deselect)
                    } else {
                        data.updateValue(true, forKey:"isSelected")
                        let select = UIAlertAction(title:"Select", style: .default) { _ in

                            FirestoreRef.commentRef(postIdx).document(commentIdx).setData(data, merge: true, completion: {[weak self] (error) in
                                if let err = error {
                                    print(err.localizedDescription)
                                } else {
                                    self?.questionData?.commentData![indexPath.row-2].isSelected = true
                                }
                            })
                        }
                        alertVC.addAction(select)
                    }
                }
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        switch indexPath.row {
        case 0,1:()
            
            return false
            
        default:
            
            if let uid = self.questionData?.commentData?[indexPath.row-2].uid {
                if uid == User.shared.uid { return true }
            }
            
            return false

        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let index = indexPath.row-2
        
        guard let postIdx = self.questionData?.idx else { return }
        guard let commentIdx = self.questionData?.commentData?[index].idx else { return }
        
        if User.shared.uid == self.questionData?.commentData?[index].uid {
            
            switch editingStyle {
            case .delete:
                
                // 데이트 인덱스에서 삭제
                self.questionData?.commentData?.remove(at:index)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .none)
                tableView.endUpdates()
                
                deleteCommentDoc(postIdx:postIdx, docIdx:commentIdx)
                
            default:()
                
            }
            
        }
        
    }

}


//MARK:- CommentView
extension QuestionDetailViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: view.frame.width-(64*2), height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        commentView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimateSize.height+16
            }
        }
        
        if commentView.commentTextView.text.count >= 2 {
            commentView.doneButton.isEnabled = true
        } else {
            commentView.doneButton.isEnabled = false
        }
    }
}




//MARK:- Action
extension QuestionDetailViewController {
    
    @objc func backToQuestionVC() {
        
        if let commentData = self.questionData?.commentData {
            
            self.delegate?.updateQuestionData(data:commentData, row: row)
            
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isSelectedButtonTapped(_ Sender: UIButton) {

    }
    
    @objc func popMenuAlert(sender:UIButton) {
        let alertVC = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancel)
    
        switch self.menuType {
        case .Me?:
            
            let delete = UIAlertAction(title:"Delete", style: .destructive) {[weak self] _ in
                
                self?.showAlertDelete()
            }
            
            alertVC.addAction(delete)
            
            break
            
        case .Other?:
            
            break
            
        default :
            break
        }
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @objc func uploadComment(sender:UIButton) {
        
        Indicator.shared.show()
        
        guard let idx = questionData?.idx else { return }
        
        var data = [String:Any]()
        data.updateValue(User.shared.uid, forKey:"uid")
        data.updateValue(User.shared.name, forKey: "name")
        data.updateValue(commentView.commentTextView.text, forKey:"content")
        data.updateValue(Timestamp(), forKey:"date")
        data.updateValue(false, forKey: "isSelected")
        
        Firebase.addCommentDoc(data, idx: idx) {[weak self] (commentIdx) in
            
            Indicator.shared.hide()
            data.updateValue(commentIdx, forKey:"idx")
            let commentData = CommentData(data: data)
            self?.questionData?.commentData?.append(commentData)
            
            if let commentCount = self?.questionData?.commentData?.count {
                
                self?.questionData?.commentCount = String(commentCount)
                
            }
            
            // 코멘트가 1개 이상일때 소트하기
            if let sortedCommentData = self?.questionData?.commentData?.sorted(by: { (first, second) -> Bool in
                first.date?.dateValue().compare((second.date?.dateValue())!) == .orderedDescending
            }) {
                
                self?.questionData?.commentData = sortedCommentData
                
            } else {
                
                self?.questionData?.commentData = [commentData]
            }
            
            self?.commentView.commentTextView.text = ""
            self?.commentView.commentTextView.resignFirstResponder()
            self?.textViewDidChange((self?.commentView.commentTextView)!)
            
        }
    
    }
    
    
    private func showAlertDelete() {
        
        let alertVC = UIAlertController(title:"Do you really want delete this post ?", message:nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title:"cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title:"delete", style: .default) {[weak self] _ in
            
            guard let postIdx = self?.questionData?.idx else { return }
            self?.deleteQuestionDoc(postIdx: postIdx)
            
        }
        
        alertVC.addAction(cancel)
        alertVC.addAction(delete)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @objc func notifyBookmarkButtonDidDeselect() {
        print("▶︎ bookmark button has been deselected")
    }
    
}



//MARK: Firestore
extension QuestionDetailViewController {
    
    // 리무브 코멘트 도큐먼트
    private func deleteCommentDoc(postIdx:String,docIdx:String) {
    
        Firestore.firestore().collection("question").document(postIdx).collection("comment").document(docIdx).delete {[weak self] (error) in
            if let err = error {
                
                print(err.localizedDescription)
                
            } else {
                
                UIAlertController.showText(vc: self!, title:"댓글이 성공적으로 삭제되었습니다")
                
            }
        }
   
    }
    
    private func deleteQuestionDoc(postIdx:String) {
        
        Firestore.firestore().collection("user").document(User.shared.uid).collection("post").document(postIdx).delete(completion: {[weak self] (error) in
            
            if let err = error {
                print(err.localizedDescription)
            } else {
                
                Firestore.firestore().collection("question").document(postIdx).delete(completion: {[weak self] (error) in
                    
                    if let err = error {
                        
                        print(err.localizedDescription)
                        
                    } else {
                        
                        self?.delegate?.deleteQuestionData(row: (self?.row)!)
                        self?.navigationController?.popViewController(animated: true)
                        
                    }
                    
                })
                
            }
        })
    
    }
    
}
