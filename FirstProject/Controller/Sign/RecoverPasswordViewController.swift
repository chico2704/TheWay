//
//  RecoverPasswordViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 17..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecoverPasswordViewController: UIViewController {

    // MARK: - Background
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signBackground")
        return iv
    }()
    
    let keyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "key")
        return iv
    }()
    
    // MARK: - Description Label
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.preferredFont(forTextStyle: .title2)
        lb.textColor = UIColor.white
        lb.text = "Forgot Password?"
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    let contentLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.numberOfLines = 2
        lb.text = "Enter your email address\nto reset your password"
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()

    // MARK: - Email Views
    let emailView: UIView = {
        let ev = UIView()
        ev.backgroundColor = UIColor.white
        return ev
    }()

    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .none
        tf.textColor = UIColor.white
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.clearButtonMode = .whileEditing
        tf.attributedPlaceholder = NSAttributedString(string: "EMAIL",
                                                      attributes: [.font : UIFont.systemFont(ofSize: 15)])
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()

    let emailWarningLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.red
        lb.text = ""
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()

    // MARK: - Buttons
    let resetPasswordButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        bt.setAttributedTitle(NSAttributedString(string: "Send Email", attributes: [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 15)]), for: .normal)
        bt.layer.cornerRadius = 5
        bt.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        return bt
    }()

    let dismissButton: UIButton = {
        let bt = UIButton()
        let buttonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        bt.setImage(buttonImage, for: .normal)
        bt.tintColor = UIColor.white
        bt.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return bt
    }()

    deinit {
        self.printDeinitMessage()
    }
}

// MARK: - Life Cycle
extension RecoverPasswordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPasswordButton.isEnabled = false
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailTextField.becomeFirstResponder()
    }
}

// MARK: - Setup Views
extension RecoverPasswordViewController {

    func setupViews() {

        [backgroundImageView,
         keyImageView,
         titleLabel,
         contentLabel,
         emailView,
         emailTextField,
         emailWarningLabel,
         resetPasswordButton,
         dismissButton].forEach { self.view.addSubview($0) }

        let signInButtonWidth = self.view.frame.width * 0.7
        let signInButtonHeight = self.view.frame.height * 0.068
        let imageViewWidth = self.view.frame.width * 0.3
        let viewCenterX = self.view.centerXAnchor
    
        backgroundImageView.anchor(top: self.view.topAnchor,
                                   leading: self.view.leadingAnchor,
                                   bottom: self.view.bottomAnchor,
                                   trailing: self.view.trailingAnchor)
        
        dismissButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                             leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 16, left: 16, bottom: 0, right: 0),
                             size: .init(width: signInButtonHeight, height: signInButtonHeight))
        
        keyImageView.anchor(top: dismissButton.bottomAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: nil,
                            centerX: viewCenterX,
                            padding: .init(top: 8, left: 0, bottom: 0, right: 0),
                            size: .init(width: imageViewWidth, height: imageViewWidth))

        titleLabel.anchor(top: keyImageView.bottomAnchor,
                                     leading: nil,
                                     bottom: nil,
                                     trailing: nil,
                                     centerX: viewCenterX,
                                     padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        contentLabel.anchor(top: titleLabel.bottomAnchor,
                                      leading: nil,
                                      bottom: nil,
                                      trailing: nil,
                                      centerX: viewCenterX,
                                      padding: .init(top: 8, left: 0, bottom: 0, right: 0))

        emailTextField.anchor(top: contentLabel.bottomAnchor,
                              leading: emailView.leadingAnchor,
                              bottom: nil,
                              trailing: emailView.trailingAnchor,
                              padding: .init(top: imageViewWidth / 2, left: 0, bottom: 0, right: 0))
        
        emailView.anchor(top: emailTextField.bottomAnchor,
                         leading: nil,
                         bottom: nil,
                         trailing: nil,
                         centerX: viewCenterX,
                         padding: .init(top: 4, left: 0, bottom: 0, right: 0),
                         size: .init(width: signInButtonWidth, height: 1))

        emailWarningLabel.anchor(top: emailView.bottomAnchor,
                                 leading: emailView.leadingAnchor,
                                 bottom: nil,
                                 trailing: emailView.trailingAnchor,
                                 padding: .init(top: 4, left: 0, bottom: 0, right: 0))

        resetPasswordButton.anchor(top: emailView.bottomAnchor,
                                   leading: nil,
                                   bottom: nil,
                                   trailing: nil,
                                   centerX: viewCenterX,
                                   padding: .init(top: 24, left: 0, bottom: 0, right: 0),
                                   size: .init(width: signInButtonWidth, height: signInButtonHeight))

    }
}

// MARK: - Text Field Delegate
extension RecoverPasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

// MARK: - Action
extension RecoverPasswordViewController {

    @objc func editingChanged(_ textField: UITextField) {
        if let email = emailTextField.text, email.count >= 6 {
            resetPasswordButton.backgroundColor = UIColor.mainColor
            resetPasswordButton.isEnabled = true
        } else {
            resetPasswordButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            resetPasswordButton.isEnabled = false
        }
    }
    
    @objc func resetPasswordButtonTapped() {

        guard let email = self.emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("error: ", error.localizedDescription)
            }
            weak var pvc = self.presentingViewController
            self.dismiss(animated: true, completion: {
                let checkEmailVC = CheckEmailViewController()
                pvc?.present(checkEmailVC, animated: true, completion: nil)
            })
        }
    }

    @objc func dismissButtonTapped() {
        self.emailTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}
