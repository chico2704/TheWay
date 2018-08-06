//
//  CheckEmailViewController.swift
//  FirstProject
//
//  Created by Suzy Park on 2018. 7. 24..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import UIKit

class CheckEmailViewController: UIViewController {
    
    // MARK: - Background
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signBackground")
        return iv
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "check")
        return iv
    }()
    
    // MARK: - Labels
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.preferredFont(forTextStyle: .title2)
        lb.textColor = UIColor.white
        lb.text = "Please, check your email"
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    let contentLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.white
        lb.text = "Email has been successfully sent"
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    // MARK: - Button
    let goToMainButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.mainColor
        let attributes: [NSAttributedStringKey : Any] = [.font : UIFont.systemFont(ofSize: 15),
                                                         .foregroundColor : UIColor.white]
        let attributedString = NSMutableAttributedString(string: "Go to main", attributes: attributes)
        bt.setAttributedTitle(attributedString, for: .normal)
        bt.layer.cornerRadius = 5
        bt.addTarget(self, action: #selector(goToMainButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    
    deinit {
        self.printDeinitMessage()
    }

}

// MARK: - Life Cycle
extension CheckEmailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Setup Views
extension CheckEmailViewController {
    func setupViews() {
        [backgroundImageView,
         logoImageView,
         titleLabel,
         contentLabel,
         goToMainButton].forEach { self.view.addSubview($0) }
        
        let logoWidth = self.view.frame.width * 0.4
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
                             padding: .init(top: logoWidth, left: 0, bottom: 0, right: 0),
                             size: .init(width: logoWidth, height: logoWidth))
        
        titleLabel.anchor(top: logoImageView.bottomAnchor,
                                     leading: nil,
                                     bottom: nil,
                                     trailing: nil,
                                     centerX: viewCenterX,
                                     padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        contentLabel.anchor(top: titleLabel.bottomAnchor,
                                      leading: nil,
                                      bottom: nil,
                                      trailing: nil,
                                      centerX: viewCenterX,
                                      padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        goToMainButton.anchor(top: contentLabel.bottomAnchor,
                           leading: nil,
                           bottom: nil,
                           trailing: nil,
                           centerX: viewCenterX,
                           padding: .init(top: logoWidth / 2, left: 0, bottom: 0, right: 0),
                           size: .init(width: signInButtonWidth, height: signInButtonHeight))
    }
}

// MARK: - Actions
extension CheckEmailViewController {
    @objc func goToMainButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
