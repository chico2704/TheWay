//
//  ProfileImageViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 21..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import FirebaseUI

class ProfileImageViewController: UIViewController {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        return imageView
    }()

    let viewCloseButton: UIButton = {
        let button = UIButton()
        let viewCloseButtonImage = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        button.setImage(viewCloseButtonImage, for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    deinit {
        self.printDeinitMessage()
    }

}

// MARK: - Life Cycle
extension ProfileImageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        slideDown.direction = .down
        self.view.addGestureRecognizer(slideDown)
        
        let profileImage = StorageRef.profileImageRef.child(User.shared.uid)
        profileImageView.sd_setImage(with: profileImage, placeholderImage: UIImage.profilePlaceHoderImage)
    }
}

// MARK: - Setup Views
extension ProfileImageViewController {

    func setupViews() {

        [profileImageView,
         viewCloseButton].forEach { self.view.addSubview($0) }

        viewCloseButton.tintColor = UIColor.white

        let buttonWidth = self.view.frame.width * 0.1

        viewCloseButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                               leading: self.view.leadingAnchor,
                               bottom: nil, trailing: nil,
                               padding: .init(top: 16, left: 16, bottom: 0, right: 0),
                               size: .init(width: buttonWidth, height: buttonWidth))

        profileImageView.anchor(top: self.view.topAnchor,
                                leading: self.view.leadingAnchor,
                                bottom: self.view.bottomAnchor,
                                trailing: self.view.trailingAnchor)
    }
}

// MARK: - Action
extension ProfileImageViewController {

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
