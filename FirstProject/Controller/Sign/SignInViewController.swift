//
//  SignInViewController.swift
//  WAYWAY
//
//  Created by Suzy Park on 2018. 6. 15..
//  Copyright © 2018년 Suzy Park. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn


enum LoginType : String {
    
    case Email = "E"
    case Google = "G"
    case Facebook = "F"
    case Naver = "N"
    case Kakao = "K"
    
}

class SignInViewController: UIViewController {
    
    // MARK: - Background Views
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signBackground")
        return iv
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "tempLogo")
        return iv
    }()
    
    // MARK: - Email Views
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .none
        tf.textColor = UIColor.white
        tf.clearButtonMode = .whileEditing
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.attributedPlaceholder = NSAttributedString(string: "EMAIL",
                                                      attributes: [.font : UIFont.systemFont(ofSize: 15)])
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()
    
    // separator under emailTextField
    let emailView: UIView = {
        let ev = UIView()
        ev.backgroundColor = UIColor.white
        return ev
    }()

    let emailWarningLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.red
        l.font = UIFont.systemFont(ofSize: 15)
        l.text = ""
        l.adjustsFontSizeToFitWidth = true
        return l
    }()

    // MARK: - Password Views
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .none
        tf.textColor = UIColor.white
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.attributedPlaceholder = NSAttributedString(string: "PASSWORD",
                                                      attributes: [.font : UIFont.systemFont(ofSize: 15)])
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()
    
    // separator under passwordTextField
    let passwordView: UIView = {
        let pv = UIView()
        pv.backgroundColor = UIColor.white
        return pv
    }()

    let passwordWarningLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.red
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.text = ""
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()

    // MARK: - Buttons
    let forgotPasswordButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.clear
        let attributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.white,
                                                         .font : UIFont.systemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string: "Forgot password?", attributes: attributes)
        bt.setAttributedTitle(attributedString, for: .normal)
        bt.contentHorizontalAlignment = .trailing
        bt.addTarget(self, action: #selector(recoverPasswordButtonTapped), for: .touchUpInside)
        bt.titleLabel?.adjustsFontSizeToFitWidth = true
        return bt
    }()
    
    let signInButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        bt.setAttributedTitle(NSAttributedString(string: "Sign In", attributes: [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 15)]), for: .normal)
        bt.isEnabled = false
        bt.layer.cornerRadius = 5
        bt.addTarget(self, action: #selector(emailSignInButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    let leftSeparatorView: UIView = {
        let lsv = UIView()
        lsv.backgroundColor = UIColor.white
        return lsv
    }()
    
    let orLabel: UILabel = {
        let ol = UILabel()
        ol.textColor = UIColor.white
        ol.text = "OR"
        ol.font = UIFont.systemFont(ofSize: 10)
        return ol
    }()
    
    let rightSeparatorView: UIView = {
        let rsv = UIView()
        rsv.backgroundColor = UIColor.white
        return rsv
    }()

    let googleSignInButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.white
        bt.setAttributedTitle(NSAttributedString(string: "Sign In with Google", attributes: [.foregroundColor : UIColor.mainColor, .font : UIFont.systemFont(ofSize: 15)]), for: .normal)
        bt.setImage(UIImage(named: "googleLogo"), for: .normal)
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        bt.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        bt.layer.cornerRadius = 5
        bt.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)
        return bt
    }()

    let signUpButton: UIButton = {
        let bt = UIButton()

        let descriptionAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : UIColor.white]
        let descriptionAttributedString = NSMutableAttributedString(string: "Don't have an account? ", attributes: descriptionAttributes)
        
        let joinAttributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                             NSAttributedStringKey.underlineStyle  : NSUnderlineStyle.styleSingle.rawValue]
        let joinAttributedString = NSMutableAttributedString(string: "Join us!", attributes: joinAttributes)
        
        descriptionAttributedString.append(joinAttributedString)
        bt.setAttributedTitle(descriptionAttributedString, for: .normal)
        bt.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        bt.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return bt
    }()
    
    // MARK: - Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    deinit {
        self.printDeinitMessage()
    }
}

// MARK: - Life Cycle
extension SignInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSignUp()
    }
}

// MARK: - Setup Views
extension SignInViewController {

    func setupViews() {
        [backgroundImageView,
         logoImageView,
         emailView,
         emailTextField,
         emailWarningLabel,
         passwordView,
         passwordTextField,
         passwordWarningLabel,
         forgotPasswordButton,
         signInButton,
         leftSeparatorView,
         orLabel,
         rightSeparatorView,
         googleSignInButton,
         signUpButton,].forEach { self.view.addSubview($0) }
        
        let logoWidth = self.view.frame.width * 0.35
        let signInButtonWidth = self.view.frame.width * 0.7
        let signInButtonHeight = self.view.frame.height * 0.068
        let forgotPasswordButtonWidth = self.view.frame.width * 0.25
        let forgotPasswordButtonHeight = self.view.frame.height * 0.025
        let separatorWidth = self.view.frame.width * 0.3
        let joinButtonHeight = self.view.frame.height * 0.08
        let viewCenterX = self.view.centerXAnchor

        backgroundImageView.anchor(top: self.view.topAnchor,
                                   leading: self.view.leadingAnchor,
                                   bottom: self.view.bottomAnchor,
                                   trailing: self.view.trailingAnchor)
        
        logoImageView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: nil,
                             centerX: viewCenterX,
                             padding: .init(top: logoWidth / 2, left: 0, bottom: 0, right: 0),
                             size: .init(width: logoWidth, height: logoWidth))
        
        emailTextField.anchor(top: logoImageView.bottomAnchor,
                              leading: emailView.leadingAnchor,
                              bottom: nil,
                              trailing: emailView.trailingAnchor,
                              padding: .init(top: logoWidth / 4, left: 0, bottom: 0, right: 0))
        
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
                                    trailing: forgotPasswordButton.leadingAnchor,
                                    padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        
        forgotPasswordButton.anchor(top: passwordView.bottomAnchor,
                                    leading: passwordWarningLabel.trailingAnchor,
                                    bottom: nil,
                                    trailing: passwordView.trailingAnchor,
                                    padding: .init(top: 4, left: 8, bottom: 0, right: 0),
                                    size: .init(width: forgotPasswordButtonWidth, height: forgotPasswordButtonHeight))

        signInButton.anchor(top: forgotPasswordButton.bottomAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: nil,
                            centerX: viewCenterX,
                            padding: .init(top: 40, left: 0, bottom: 0, right: 0),
                            size: .init(width: signInButtonWidth, height: signInButtonHeight))
        
        leftSeparatorView.anchor(top: signInButton.bottomAnchor,
                                 leading: signInButton.leadingAnchor,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 32, left: 0, bottom: 0, right: 0),
                                 size: .init(width: separatorWidth, height: 1))
        
        orLabel.anchor(top: nil,
                       leading: nil,
                       bottom: nil,
                       trailing: nil,
                       centerX: viewCenterX,
                       centerY: leftSeparatorView.centerYAnchor)
        
        rightSeparatorView.anchor(top: nil,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: signInButton.trailingAnchor,
                                  centerY: orLabel.centerYAnchor,
                                  size: .init(width: separatorWidth, height: 1))

        googleSignInButton.anchor(top: orLabel.bottomAnchor,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: nil,
                                  centerX: viewCenterX,
                                  padding: .init(top: 12, left: 0, bottom: 0, right: 0),
                                  size: .init(width: signInButtonWidth, height: signInButtonHeight))
        
        signUpButton.anchor(top: nil,
                            leading: self.view.leadingAnchor,
                            bottom: self.view.bottomAnchor,
                            trailing: self.view.trailingAnchor,
                            size: .init(width: self.view.frame.width, height: joinButtonHeight))
    }
}

// MARK: - Text Field Delegate
extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

// MARK: - Action
extension SignInViewController {

    @objc func emailSignInButtonTapped() {

        func emailViewRedWarning() {
            self.emailView.backgroundColor = UIColor.red
        }

        func passwordViewRedWarning() {
            self.passwordView.backgroundColor = UIColor.red
        }

        func emailViewRedWarningReset() {
            self.emailView.backgroundColor = UIColor.white
            self.emailWarningLabel.text = ""
        }

        func passwordViewRedWarningReset() {
            self.passwordView.backgroundColor = UIColor.white
            self.passwordWarningLabel.text = ""
        }

        guard let email = emailTextField.text, let pw = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: pw) { (user, error) in
            
            if let error = error {
                
                switch AuthErrorCode(rawValue: error._code) {
                    
                case .wrongPassword? :
                    emailViewRedWarningReset()
                    passwordViewRedWarning()
                    self.passwordWarningLabel.text = "The email and password you entered don't match."
                    
                case .invalidEmail? :
                    passwordViewRedWarningReset()
                    emailViewRedWarning()
                    self.emailWarningLabel.text = "That email address isn't correct"
                    
                case .userNotFound? :
                    passwordViewRedWarningReset()
                    emailViewRedWarning()
                    self.emailWarningLabel.text = "That email address doesn’t match an existing account"
                    
                default:
                    emailViewRedWarning()
                    self.emailWarningLabel.text = "Unexpected error!"
                    passwordViewRedWarning()
                    self.passwordWarningLabel.text = "This might Cuz you are too cute!"
                }
                
            } else {
                
                guard let uid = user?.user.uid else { return }
                
                Firebase.searchUser(uid, completion: { isUser in
                    
                    if isUser {
                        
                        User.shared.setLoginType(LoginType.Email.rawValue)
                        appDelegate.changeRootViewController()
                        
                    } else {
                        
                    }
                })
            }
        }
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if let email = emailTextField.text, email.count >= 6, let password = passwordTextField.text, password.count >= 6 {
            signInButton.backgroundColor = UIColor.mainColor
            signInButton.isEnabled = true
        } else {
            signInButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            signInButton.isEnabled = false
        }
    }

    @objc func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        self.present(signUpVC, animated: true, completion: nil)
    }

    @objc func googleSignInButtonTapped() {
        GIDSignIn.sharedInstance().signIn()
    }

    @objc func recoverPasswordButtonTapped() {
        let recoverPasswordVC = RecoverPasswordViewController()
        self.present(recoverPasswordVC, animated: true, completion: nil)
    }
}

// MARK: - Sign In & Up
extension SignInViewController : GIDSignInDelegate, GIDSignInUIDelegate {
    
    private func setupSignUp() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }

 // 구글 로그인에 성공했을때 불리는 메써드
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        Indicator.shared.show()

        if let error = error {
            Indicator.shared.hide()
            print("didSignInFor error :",error.localizedDescription)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signInAndRetrieveData(with: credential) {[weak self] (user, error) in
            
            if let error = error {

                print("signInAndRetrieveData error",error.localizedDescription)

            } else {

                guard let uid = user?.user.uid else { return }
                
                // 디비에 사용자 정보 조회
                Firebase.searchUser(uid) { [weak self]  isUser in
                    
                    if isUser {                        
                        // 사용자가 디비에 존재한다면
                        User.shared.setLoginType(LoginType.Google.rawValue)
                        appDelegate.changeRootViewController()
                        
                    } else {
                        
                        // 사용자가 디비에 존재하지않는다면
                        guard let uid = user?.user.uid else { return }
                        guard let email = user?.user.email else { return }
                        guard let name = user?.user.displayName else { return }
                        
                        User.shared.uid = uid
                        User.shared.email = email
                        User.shared.name = name
                        
                        var data = [String : Any]()
                        data.updateValue(email, forKey: "email")
                        data.updateValue(uid, forKey: "uid")
                        data.updateValue(name, forKey: "name")
                        data.updateValue(LoginType.Google.rawValue, forKey: "type")

                        Firebase.addUserDoc(data, completion: {
                            
                            User.shared.setLoginType(LoginType.Google.rawValue)
                            appDelegate.changeRootViewController()
                        })
                    }
                    
                }
            }

        }

    }

    
 // 구글 로그인 끊겼을때 불려지는 메써드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            print("didDisconnectWith error :",error.localizedDescription)
            return
        }
    }
}
