//
//  UserNameChangeViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 21..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit

class UserNameChangeViewController: UITableViewController {

    lazy var leftBarButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
    lazy var leftBarButton: UIBarButtonItem = UIBarButtonItem(image: leftBarButtonImage,
                                                              style: .done,
                                                              target: self,
                                                              action: #selector(leftBarButtonTapped))
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.text = User.shared.name
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = UIColor.titleBlack
        return textField
    }()
    
    deinit {
        self.printDeinitMessage()
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Life Cycle
extension UserNameChangeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(whenUserNameChangeNotify),
                                               name: .userNameButtonTextDidChanged,
                                               object: nil)
        setupNavi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userNameTextField.becomeFirstResponder()
        if let clearButton = self.userNameTextField.value(forKey: "clearButton") as? UIButton {
            let image = UIImage(named: "clear")?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(image, for: .normal)
            clearButton.tintColor = UIColor.placeHoderColor
        }
    }
}

// MARK: - Setup Navi
extension UserNameChangeViewController {
    
    func setupNavi() {
        navigationItem.title = "User Name"
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
}

// MARK: - Table View
extension UserNameChangeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Enter your user name"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingTabelViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SettingTabelViewCell")
        }
        
        cell?.addSubview(userNameTextField)
        userNameTextField.anchor(top: cell?.topAnchor,
                                 leading: cell?.leadingAnchor,
                                 bottom: cell?.bottomAnchor,
                                 trailing: cell?.trailingAnchor,
                                 padding: .init(top: 0, left: 20, bottom: 0, right: 8),
                                 size: .init(width: 0, height: 44))
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - TextField Delegate
extension UserNameChangeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let changedName = textField.text {
            if changedName.count >= 1 {
                // 싱글톤 User 데이터 변경
                User.shared.name = changedName
                // DB User 필드 데이터 업데이트
                FirestoreRef.userRef.document(User.shared.uid).updateData([
                    "name": changedName]) { error in
                        if let error = error {
                            print("Error updating changed name: \(error)")
                        } else {
                            print("changed name successfully updated")
                        }
                }
                // 노티 쏘세요
                NotificationCenter.default.post(name: .userNameButtonTextDidChanged, object: nil, userInfo: ["name": changedName])
                userNameTextField.resignFirstResponder()
                self.navigationController?.popViewController(animated: true)
            } else {
                userNameTextField.resignFirstResponder()
                self.navigationController?.popViewController(animated: true)
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

// MARK: - Action
extension UserNameChangeViewController {
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func whenUserNameChangeNotify() {
        print("User name change Notify")
    }
}
