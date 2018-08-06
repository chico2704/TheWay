//
//  VersionViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 20..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit

class VersionViewController: UITableViewController {
    
    lazy var leftBarButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
    lazy var leftBarButton = UIBarButtonItem(image: leftBarButtonImage,
                                             style: .done,
                                             target: self,
                                             action: #selector(leftBarButtonTapped))
    deinit {
        self.printDeinitMessage()
    }
}

// MARK: - Life Cycle
extension VersionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.backgroundGray
        setupNavi()
    }
}

// MARK: - Setup Navi
extension VersionViewController {
    
    func setupNavi() {
        navigationItem.title = "Version 1.0.0"
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
}

// MARK: - Table View
extension VersionViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Support Environment: over iOS 8"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingTabelViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SettingTabelViewCell")
        }
        
        cell?.textLabel?.text = "Update to the newest version 1.1.0"
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - Action
extension VersionViewController {
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
