//
//  DSignUpViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 16..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    // MARK: - Background
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signBackground")
        return iv
    }()
    
    // MARK: - User name
    let userNameView: UIView = {
        let ev = UIView()
        ev.backgroundColor = UIColor.white
        return ev
    }()
    
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.textColor = UIColor.white
        tf.clearButtonMode = .whileEditing
        tf.attributedPlaceholder = NSAttributedString(string: "NAME",
                                                      attributes: [.font : UIFont.systemFont(ofSize: 15)])
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()
    
    let userNameWarningLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.red
        lb.text = ""
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    // MARK: - Email
    let emailView: UIView = {
        let ev = UIView()
        ev.backgroundColor = UIColor.white
        return ev
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.textColor = UIColor.white
        tf.clearButtonMode = .whileEditing
        tf.attributedPlaceholder = NSAttributedString(string: "EMAIL",
                                                      attributes: [.font : UIFont.systemFont(ofSize: 15)])
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()

    let emailWarningLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.red
        lb.text = ""
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()

    // MARK: - Password
    let passwordView: UIView = {
        let ev = UIView()
        ev.backgroundColor = UIColor.white
        return ev
    }()

    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.textColor = UIColor.white
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "PASSWORD",
                                                      attributes: [.font : UIFont.systemFont(ofSize: 15)])
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()

    let passwordWarningLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.red
        lb.text = ""
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()

    // MARK: - Buttons
    
    let dismissButton: UIButton = {
        let bt = UIButton()
        let buttonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        bt.setImage(buttonImage, for: .normal)
        bt.tintColor = UIColor.white
        bt.addTarget(self,
                     action: #selector(dismissButtonTapped),
                     for: .touchUpInside)
        return bt
    }()
    
    let signUpButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        let attributes: [NSAttributedStringKey : Any] = [.font : UIFont.systemFont(ofSize: 15),
                                                         .foregroundColor : UIColor.white]
        let attributedString = NSMutableAttributedString(string: "Sign Up", attributes: attributes)
        bt.setAttributedTitle(attributedString, for: .normal)
        bt.layer.cornerRadius = 5
        bt.addTarget(self,
                     action: #selector(signUpButtonTapped),
                     for: .touchUpInside)
        return bt
    }()

    deinit {
        self.printDeinitMessage()
    }
}

// MARK: - Life Cycle
extension SignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.isEnabled = false
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.userNameTextField.becomeFirstResponder()
    }
    
    // 키브도외에 다른 부분을 터치시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Setup Views
extension SignUpViewController {

    func setupViews() {

        [backgroundImageView,
         emailView,
         emailTextField,
         emailWarningLabel,
         userNameView,
         userNameTextField,
         userNameWarningLabel,
         passwordView,
         passwordTextField,
         passwordWarningLabel,
         signUpButton,
         dismissButton].forEach { self.view.addSubview($0)}

        let signInButtonWidth = self.view.frame.width * 0.7
        let signInButtonHeight = self.view.frame.height * 0.068
        let viewCenterX = self.view.centerXAnchor
        
        backgroundImageView.anchor(top: self.view.topAnchor,
                                   leading: self.view.leadingAnchor,
                                   bottom: self.view.bottomAnchor,
                                   trailing: self.view.trailingAnchor)
        
        userNameTextField.anchor(top: dismissButton.bottomAnchor,
                                 leading: userNameView.leadingAnchor,
                                 bottom: nil,
                                 trailing: userNameView.trailingAnchor,
                                 padding: .init(top: signInButtonHeight, left: 0, bottom: 0, right: 0))
        
        userNameView.anchor(top: userNameTextField.bottomAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: nil,
                            centerX: viewCenterX,
                            padding: .init(top: 4, left: 0, bottom: 0, right: 0),
                            size: .init(width: signInButtonWidth, height: 1))
        
        userNameWarningLabel.anchor(top: userNameView.bottomAnchor,
                                    leading: userNameView.leadingAnchor,
                                    bottom: nil,
                                    trailing: userNameView.trailingAnchor,
                                    padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        emailTextField.anchor(top: userNameView.bottomAnchor,
                              leading: userNameView.leadingAnchor,
                              bottom: nil,
                              trailing: userNameView.trailingAnchor,
                              padding: .init(top: 24, left: 0, bottom: 0, right: 0))
        
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
        
        passwordTextField.anchor(top: emailView.bottomAnchor,
                                 leading: emailView.leadingAnchor,
                                 bottom: nil,
                                 trailing: emailView.trailingAnchor,
                                 padding: .init(top: 24, left: 0, bottom: 0, right: 0))
        
        passwordView.anchor(top: passwordTextField.bottomAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: nil,
                            centerX: viewCenterX,
                            padding: .init(top: 4, left: 0, bottom: 0, right: 0),
                            size: .init(width: signInButtonWidth, height: 1))


        passwordWarningLabel.anchor(top: passwordView.bottomAnchor,
                                    leading: passwordView.leadingAnchor,
                                    bottom: nil,
                                    trailing: passwordView.trailingAnchor,
                                    padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        dismissButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                             leading: self.view.safeAreaLayoutGuide.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 16, left: 16, bottom: 0, right: 0),
                             size: .init(width: signInButtonHeight, height: signInButtonHeight))
        
        signUpButton.anchor(top: passwordView.bottomAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: nil,
                            centerX: viewCenterX,
                            padding: .init(top: 48, left: 0, bottom: 0, right: 0),
                            size: .init(width: signInButtonWidth, height: signInButtonHeight))
    }
}

// MARK: - Action
extension SignUpViewController {

    @objc func signUpButtonTapped() {

        func emailViewRedWarning() {
            self.emailView.layer.borderWidth = 1
            self.emailView.layer.borderColor = UIColor.red.cgColor
        }

        func userNameViewRedWarning() {
            self.userNameView.layer.borderWidth = 1
            self.userNameView.layer.borderColor = UIColor.red.cgColor
        }

        func passwordViewRedWarning() {
            self.passwordView.layer.borderWidth = 1
            self.passwordView.layer.borderColor = UIColor.red.cgColor
        }

        func emailViewRedWarningReset() {
            self.emailView.layer.borderWidth = 0
            self.emailWarningLabel.text = ""
        }

        func userNameViewRedWarningReset() {
            self.userNameView.layer.borderWidth = 0
            self.userNameWarningLabel.text = ""
        }

        func passwordViewRedWarningReset() {
            self.passwordView.layer.borderWidth = 0
            self.passwordWarningLabel.text = ""
        }

        // check if all TFs have valid text value and unwrap
        guard let email = emailTextField.text, let pw = passwordTextField.text else { return }
    
        // unless they are empty, we can move forward
        Auth.auth().createUser(withEmail: email, password: pw) {[weak self] (user, error) in
            
            if let error = error {
                switch AuthErrorCode(rawValue: error._code) {
                case .weakPassword? :
                    emailViewRedWarningReset()
                    userNameViewRedWarningReset()
                    passwordViewRedWarning()
                    self?.passwordWarningLabel.text = "Strong passwords have at least 6 characters"

                case .invalidEmail? :
                    userNameViewRedWarningReset()
                    passwordViewRedWarningReset()
                    emailViewRedWarning()
                    self?.emailWarningLabel.text = "That email address isn't correct"

                case .emailAlreadyInUse? :
                    userNameViewRedWarningReset()
                    passwordViewRedWarningReset()
                    emailViewRedWarning()
                    self?.emailWarningLabel.text = "You already have an account"

                default :
                    userNameViewRedWarningReset()
                    emailViewRedWarning()
                    self?.emailWarningLabel.text = "Unexpected error!"
                    passwordViewRedWarning()
                    self?.passwordWarningLabel.text = "This might Cuz you are too cute!"
                }
            }

            guard let uid = user?.user.uid else { return }
            guard let email = user?.user.email else { return }
            guard let name = self?.userNameTextField.text else { return }
            
            User.shared.uid = uid
            User.shared.email = email
            User.shared.name = name
            
            var data = [String : Any]()
            data.updateValue(email, forKey: "email")
            data.updateValue(uid, forKey: "uid")
            data.updateValue(name, forKey: "name")
            data.updateValue(LoginType.Email.rawValue, forKey: "type")
            
            Indicator.shared.show()
            Firebase.addUserDoc(data, completion: {
                User.shared.setLoginType(LoginType.Email.rawValue)
                let welcomeVC = WelcomeViewController()
                self?.present(welcomeVC, animated: true, completion: nil)
            })
        }
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if let name = userNameTextField.text, name.count >= 1,
            let email = emailTextField.text, email.count >= 6,
            let password = passwordTextField.text, password.count >= 6 {
            signUpButton.backgroundColor = UIColor.mainColor
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            signUpButton.isEnabled = false
        }
    }
    
    @objc func dismissButtonTapped() {
        self.userNameTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Text Field Delegate
extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
