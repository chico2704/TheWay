//
//  ProfileHeaderView.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 20..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupViews()
    }
    
    // MARK: - Views
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.purple
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let backgroundCameraBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3882, green: 0.3882, blue: 0.3882, alpha: 1)
        view.alpha = 0.5
        return view
    }()
    
    let backgroundCameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let backgroundGuestureView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "basicProfile")
        return imageView
    }()
    
    let profileCameraBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3882, green: 0.3882, blue: 0.3882, alpha: 1)
        view.alpha = 0.5
        return view
    }()
    
    let profileCameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let profileGuestureView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    let userNameButton: UIButton = {
        let button = UIButton()
        
        let nameAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22),
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack]
        let stringToDisplay = User.shared.name + " "
        let nameAttributedString = NSMutableAttributedString(string: stringToDisplay, attributes: nameAttributes)
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "pencil")
        attachment.bounds = CGRect(x: 0, y: 2, width: 13, height: 13)
        nameAttributedString.append(NSAttributedString(attachment: attachment))
        button.setAttributedTitle(nameAttributedString, for: .normal)
        return button
    }()
}

// MARK: - Setup Views
extension ProfileHeaderView {
    
    func setupViews() {
        [backgroundImageView,
         backgroundCameraBackgroundView,
         backgroundCameraImageView,
         backgroundGuestureView,
         profileImageView,
         profileCameraBackgroundView,
         profileCameraImageView,
         profileGuestureView,
         userNameButton].forEach { addSubview($0) }
    }
}


