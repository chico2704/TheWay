//
//  ServiceQnAViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 20..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import Firebase

class ServiceQnAViewController: UIViewController {
    
    let leftBarButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
    lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: leftBarButtonImage,
                                                              style: .done,
                                                              target: self,
                                                              action: #selector(leftBarButtonTapped))

    let contentView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.backgroundGray
        return cv
    }()
    
    let requestTextBackgroundView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.white
        return bv
    }()
    
    lazy var requestTextView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.backgroundColor = UIColor.clear
        tv.textAlignment = .left
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.textColor = UIColor.placeHoderColor
        tv.text = "If you have any questions or requests, please do not hesitate and let us know."
        return tv
    }()
    
    let emailBackgroundView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.white
        return bv
    }()
    
    let emailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.placeHoderColor
        return iv
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing
        tf.adjustsFontSizeToFitWidth = true
        tf.attributedPlaceholder = NSAttributedString(string: "e-mail address to get the answer",
                                                      attributes: [.foregroundColor : UIColor.placeHoderColor,
                                                                   .font            : UIFont.systemFont(ofSize: 17)])
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.textColor = UIColor.titleBlack
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        tf.leftView = paddingView
        tf.leftViewMode = UITextFieldViewMode.always
        return tf
    }()
    
    let sendButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.placeHoderColor
        bt.isEnabled = false
        let attributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.white]
        let attributedString = NSMutableAttributedString(string: "Send email", attributes: attributes)
        bt.setAttributedTitle(attributedString, for: .normal)
        bt.layer.cornerRadius = 5
        bt.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return bt
    }()

    deinit {
        self.printDeinitMessage()
    }
}

// MARK: - Life Cycle
extension ServiceQnAViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupViews()
    }
}

// MARK: - Setup Navi
extension ServiceQnAViewController {
    func setupNavi() {
        navigationItem.title = "Service Q&A"
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
}

// MARK: - Setup Views
extension ServiceQnAViewController {
    
    func setupViews() {
        
        let textViewHeight = self.view.frame.height / 4
        let signInButtonHeight = self.view.frame.height * 0.068
        let viewCenterX = self.view.centerXAnchor
        
        // contentView
        self.view.addSubview(contentView)
        contentView.anchor(top: self.view.topAnchor,
                           leading: self.view.leadingAnchor,
                           bottom: self.view.bottomAnchor,
                           trailing: self.view.trailingAnchor)
        
        // contentView: requestTextBackgroundView & requestTextView & emailBackgroundView
        [requestTextBackgroundView,
         requestTextView,
         emailBackgroundView,
         emailImageView,
         emailTextField,
         sendButton].forEach { contentView.addSubview($0) }
        
        requestTextBackgroundView.anchor(top: contentView.topAnchor,
                                         leading: contentView.leadingAnchor,
                                         bottom: nil,
                                         trailing: contentView.trailingAnchor,
                                         padding: .init(top: 8, left: 0, bottom: 0, right: 0),
                                         size: .init(width: 0, height: textViewHeight))
        
        requestTextView.anchor(top: requestTextBackgroundView.topAnchor,
                               leading: requestTextBackgroundView.leadingAnchor,
                               bottom: requestTextBackgroundView.bottomAnchor,
                               trailing: requestTextBackgroundView.trailingAnchor,
                               padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        
        emailBackgroundView.anchor(top: requestTextBackgroundView.bottomAnchor,
                                   leading: contentView.leadingAnchor,
                                   bottom: nil,
                                   trailing: contentView.trailingAnchor,
                                   padding: .init(top: 8, left: 0, bottom: 0, right: 0),
                                   size: .init(width: 0, height: textViewHeight / 4))
        
        emailImageView.anchor(top: nil,
                              leading: emailBackgroundView.leadingAnchor,
                              bottom: nil,
                              trailing: nil,
                              centerY: emailBackgroundView.centerYAnchor,
                              padding: .init(top: 0, left: 16, bottom: 0, right: 0),
                              size: .init(width: textViewHeight / 7.5, height: textViewHeight / 7.5))
        
        emailTextField.anchor(top: nil,
                              leading: emailImageView.trailingAnchor,
                              bottom: nil,
                              trailing: emailBackgroundView.trailingAnchor,
                              centerY: emailImageView.centerYAnchor,
                              padding: .init(top: 0, left: 8, bottom: 0, right: 8))
        
        sendButton.anchor(top: emailBackgroundView.bottomAnchor,
                          leading: contentView.leadingAnchor,
                          bottom: nil,
                          trailing: contentView.trailingAnchor,
                          centerX: viewCenterX,
                          padding: .init(top: 16, left: 16, bottom: 0, right: 16),
                          size: .init(width: 0, height: signInButtonHeight))
    }
}

// MARK: - Action
extension ServiceQnAViewController {
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sendButtonTapped() {
        if let content = requestTextView.text,
            let email = emailTextField.text {
            
            let uid = User.shared.uid
            let name = User.shared.name
            let timeStamp = Timestamp()
            
            var dataToSave: [String : Any] = [:]
            dataToSave.updateValue(email, forKey: "email")
            dataToSave.updateValue(name, forKey: "name")
            dataToSave.updateValue(content, forKey: "content")
            dataToSave.updateValue(timeStamp, forKey: "date")
            
            FirestoreRef.supportRef(uid).addDocument(data: dataToSave) { error in
                if let error = error {
                    print("error: ", error.localizedDescription)
                } else {
                    print("▶︎ support QnA data has been saved")
                    self.requestTextView.textColor = UIColor.lightGray
                    // alert
                    let alert = UIAlertController(title: "Successfully sent", message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.requestTextView.text = "If you have any questions or requests, please do not hesitate and let us know."
                        self.emailTextField.text = ""
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func editingChanged() {
        
        if let clearButton = emailTextField.value(forKey: "clearButton") as? UIButton {
            let edgePadding: CGFloat = 2
            clearButton.imageEdgeInsets = UIEdgeInsets(top: edgePadding, left: edgePadding, bottom: edgePadding, right: edgePadding)
            clearButton.setImage(UIImage(named: "xIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.imageView?.tintColor = UIColor.placeHoderColor
        }
        
        if let content = requestTextView.text, content.count > 6,
        let email = emailTextField.text, email.count > 6 {
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor.mainColor
            emailImageView.tintColor = UIColor.mainColor
        } else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            emailImageView.tintColor = UIColor.lightGray
        }
    }
}

// MARK: - Text View Delegate
extension ServiceQnAViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeHoderColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "If you have any questions or requests, please do not hesitate and let us know"
            textView.textColor = UIColor.placeHoderColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
