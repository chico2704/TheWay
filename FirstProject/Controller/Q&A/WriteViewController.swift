//
//  WriteViewController.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 16..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol WriteViewControllerDelegate : class {
    func reloadTableView(questionData : QuestionData)
}

class WriteViewController : UIViewController {
    
    weak var delegate : WriteViewControllerDelegate?
    
    // 네비바 아이템
    lazy var leftBarButton = UIBarButtonItem(title:"Cancel", style: .done, target: self, action: #selector(goBackToQuestionVC))
    lazy var rightBarButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(done))
    
    let titleTextField : UITextField = {
        let tf = UITextField()
        let placeholderAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.placeHoderColor,
                                                                    .font            : UIFont.systemFont(ofSize: 17)]
        tf.attributedPlaceholder = NSAttributedString(string: "Title", attributes: placeholderAttributes)
        tf.textAlignment = .left
        tf.contentVerticalAlignment = .center
        tf.textColor = UIColor.titleBlack
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()
    
    let seperateLineView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    let contentTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.text = "Content"
        tv.textColor = UIColor.placeHoderColor
        tv.font = UIFont.systemFont(ofSize: 17)
        return tv

    }()

    deinit {
        self.printDeinitMessage()
    }
}

//MARK:- Life Cycle
extension WriteViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavi()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.titleTextField.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

//MARK:- SetupViews
extension WriteViewController {
    
    private func setupNavi() {
        // title
        navigationItem.title = "Q&A"
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.titleBlack]
        
        // buttons
        let leftBarButtonAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.mainColor]
        let rightBarButtonDisabledAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.placeHoderColor]
        let rightBarButtonNormalAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.mainColor]

        leftBarButton.setTitleTextAttributes(leftBarButtonAttributes, for: .normal)
        rightBarButton.setTitleTextAttributes(rightBarButtonDisabledAttributes, for: .disabled)
        rightBarButton.setTitleTextAttributes(rightBarButtonNormalAttributes, for: .normal)
        rightBarButton.isEnabled = false
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupViews() {
        
        // 델리게이트
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        // 텍스트 필드 액션
        titleTextField.addTarget(self, action: #selector(detectEditingTextField), for: .editingChanged)
        
        
        // 레이아웃
        [
            titleTextField,
            seperateLineView,
            contentTextView
            
        ].forEach({self.view.addSubview($0)})
        
        titleTextField.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding : .init(top: 0, left: 16, bottom: 0, right: 16),size:.init(width: 0 ,height: 48))
        seperateLineView.anchor(top: titleTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size:.init(width: 0, height: 0.5))
        contentTextView.anchor(top: seperateLineView.bottomAnchor , leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding :.init(top: 0, left: 12, bottom: 0, right: 12))
        
    }
    
}
//MARK:- Private Func
extension WriteViewController {
    
    /*
     titleTextField 5자 이상,
     contentTextView 8자 이상 입력시 오른쪽 상단 네비 버튼 활성화
     (cuz contentTextView's placeholder is already 7 letters)
    */
    
    fileprivate func validateTitleAndContent() {
        
        if let title = titleTextField.text, let content = contentTextView.text {
            if title.count >= 5, content.count >= 8 {
                rightBarButton.isEnabled = true
            } else {
                rightBarButton.isEnabled = false
            }
        }
    }
}

//MARK:- UITextFieldDelegate
extension WriteViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
        validateTitleAndContent()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Title"
        validateTitleAndContent()
    }
}

//MARK:- UITextViewDelegate
extension WriteViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeHoderColor {
            textView.text = nil
            textView.textColor = UIColor.contentGray
            validateTitleAndContent()
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Content"
            textView.textColor = UIColor.placeHoderColor
            validateTitleAndContent()
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validateTitleAndContent()
    }
}

//MARK:- Action
extension WriteViewController {
    
    @objc func goBackToQuestionVC() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func done() {
        
        guard let titleText = self.titleTextField.text else { return }
        
        var question = [String:Any]()
        question.updateValue(User.shared.uid, forKey: "uid")
        question.updateValue(titleText, forKey: "title")
        question.updateValue(self.contentTextView.text, forKey: "content")
        question.updateValue(Timestamp(), forKey:"date")
        
        
        var user = [String:Any]()
        user.updateValue(User.shared.uid, forKey: "uid")
        user.updateValue(User.shared.name, forKey: "name")
        user.updateValue(User.shared.email, forKey: "email")
        
        let userData = UserData(data: user)
        var questionData = QuestionData(questionData: question, userData: userData, commentData: nil)
        
        Firebase.addQuestionDoc(question) {[weak self] (postIdx) in
            
            self?.titleTextField.resignFirstResponder()
            self?.contentTextView.resignFirstResponder()
            
            questionData.idx = postIdx
            self?.dismiss(animated: true, completion: {
                self?.delegate?.reloadTableView(questionData: questionData)
            })
        }
    }
    
    // 텍스트 필드 텍스트 바뀔때 마다 감지
    @objc func detectEditingTextField() {
        validateTitleAndContent()
    }
}
