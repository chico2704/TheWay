//
//  WelcomeViewController.swift
//  FirstProject
//
//  Created by Suzy Park on 2018. 7. 17..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Background
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
    
    // MARK: - Labels
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .title2)
        l.textColor = UIColor.white
        l.text = "Welcome!"
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    let contentLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.white
        l.text = "You have successfully signed up"
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    // MARK: - Button
    let startButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.mainColor
        let attributes: [NSAttributedStringKey : Any] = [.font : UIFont.systemFont(ofSize: 15),
                                                         .foregroundColor : UIColor.white]
        let attributedString = NSMutableAttributedString(string: "START", attributes: attributes)
        bt.setAttributedTitle(attributedString, for: .normal)
        bt.layer.cornerRadius = 5
        bt.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return bt
    }()

    
    deinit {
        self.printDeinitMessage()
    }
}

// MARK:- Life Cycle
extension WelcomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK:- Setup Views
extension WelcomeViewController {
    func setupViews() {
        [backgroundImageView,
         logoImageView,
         titleLabel,
         contentLabel,
         startButton].forEach { self.view.addSubview($0) }
        
        let logoWidth = self.view.frame.width * 0.35
        let signInButtonWidth = self.view.frame.width * 0.7
        let signInButtonHeight = self.view.frame.height * 0.068
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
        
        titleLabel.anchor(top: logoImageView.bottomAnchor,
                                     leading: nil,
                                     bottom: nil,
                                     trailing: nil,
                                     centerX: viewCenterX,
                                     padding: .init(top: logoWidth / 2, left: 0, bottom: 0, right: 0))
        
        contentLabel.anchor(top: titleLabel.bottomAnchor,
                                      leading: nil,
                                      bottom: nil,
                                      trailing: nil,
                                      centerX: viewCenterX,
                                      padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        startButton.anchor(top: contentLabel.bottomAnchor,
                           leading: nil,
                           bottom: nil,
                           trailing: nil,
                           centerX: viewCenterX,
                           padding: .init(top: logoWidth / 2, left: 0, bottom: 0, right: 0),
                           size: .init(width: signInButtonWidth, height: signInButtonHeight))
    }
}

//MARK:- Actions
extension WelcomeViewController {
    @objc func startButtonTapped() {
        appDelegate.changeRootViewController()
    }
}
