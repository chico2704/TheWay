//
//  SettingTableViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 20..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingViewController: UITableViewController {
    
    // MARK: - Views
    let leftBarButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
    
    lazy var leftBarButton = UIBarButtonItem(image: leftBarButtonImage,
                                             style: .done,
                                             target: self,
                                             action: #selector(leftBarButtonTapped))
    
    let switchControl: UISwitch = {
        let sc = UISwitch()
        sc.isOn = true
        sc.onTintColor = UIColor.mainColor
        return sc
    }()
    
    let versionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "1.0.0"
        lb.textColor = UIColor.mainColor
        return lb
    }()
    
    let signOutButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sign Out", for: .normal)
        bt.setTitleColor(#colorLiteral(red: 1, green: 0.2314, blue: 0.1882, alpha: 1), for: .normal)
        return bt
    }()
    
    deinit {
        self.printDeinitMessage()
    }
}

// MARK: - Life Cycle
extension SettingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.backgroundGray
        self.tableView.separatorStyle = .none
        setupNavi()
    }
}

// MARK: - Navi
extension SettingViewController {
    func setupNavi() {
        navigationItem.title = "Setting"
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

// MARK: - Table View
extension SettingViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // version
        case 1: return 1 // profile
        case 2: return 1 // push Alarm
        case 3: return 1 // service Q&A
        case 4: return 1 // signOut
        default : return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "ID"
        case 2: return "BASIC SETTING"
        case 3: return "CUSTOMER CENTER"
        case 4: return nil
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Static Cells
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingTabelViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SettingTabelViewCell")
        }
        
        switch (indexPath.section, indexPath.row) {
            
        case(0, 0):
            cell?.textLabel?.text = "Version"
            cell?.textLabel?.textColor = UIColor.titleBlack
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            cell?.addSubview(versionLabel)
            versionLabel.anchor(top: nil,
                                leading: nil,
                                bottom: nil,
                                trailing: cell?.contentView.trailingAnchor,
                                centerY: cell?.centerYAnchor,
                                padding: .init(top: 0, left: 0, bottom: 0, right: 8))
            return cell!
            
        case(1, 0):
            cell?.textLabel?.text = "Profile"
            cell?.textLabel?.textColor = UIColor.titleBlack
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            return cell!
            
        case(2, 0):
            cell?.textLabel?.text = "Push Alarm"
            cell?.textLabel?.textColor = UIColor.titleBlack
            cell?.selectionStyle = .none
            cell?.addSubview(switchControl)
            switchControl.isOn = true
            switchControl.anchor(top: nil,
                                 leading: nil,
                                 bottom: nil,
                                 trailing: cell?.trailingAnchor,
                                 centerY: cell?.centerYAnchor,
                                 padding: .init(top: 0, left: 0, bottom: 0, right: 16))
            switchControl.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
            return cell!
            
        case(3, 0):
            cell?.textLabel?.text = "Service Q&A"
            cell?.textLabel?.textColor = UIColor.titleBlack
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            return cell!

        case(4, 0):
            cell?.selectionStyle = .none
            cell?.addSubview(signOutButton)
            signOutButton.anchor(top: cell?.topAnchor,
                                 leading: cell?.leadingAnchor,
                                 bottom: cell?.bottomAnchor,
                                 trailing: cell?.trailingAnchor,
                                 size: .init(width: 0, height: 44))
            signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
            return cell!
            
        default:
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
            
        case(0, 0):
            let versionVC = VersionViewController()
            navigationController?.pushViewController(versionVC, animated: true)
            
        case(1, 0):
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)

        case(3, 0):
            let serviceQnAVC = ServiceQnAViewController()
            navigationController?.pushViewController(serviceQnAVC, animated: true)
            
        default: ()
        }
    }
}

// MARK: - Action
extension SettingViewController {
    
    @objc func signOutButtonTapped() {
        
        let alert = UIAlertController(title: nil, message: "Would you like to sign out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOut = UIAlertAction(title: "OK", style: .destructive) { _ in
            
            // 구글 로그아웃
            GIDSignIn.sharedInstance().signOut()
            // 자동 로그아웃 nil
            User.shared.setLoginType("")
            // 이메일 로그아웃
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let signInVC = SignInViewController()
                self.view.window?.rootViewController = signInVC
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        alert.addAction(cancel)
        alert.addAction(logOut)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func switchValueDidChange() {
        if switchControl.isOn {
            print("switch on")
        } else {
            print("switch off")
        }
    }
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
