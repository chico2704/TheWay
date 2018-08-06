//
//  QuestionDetailCommentCell.swift
//  FirstProject
//
//  Created by ROGER on 25/06/2018.
//  Copyright © 2018 hexcon. All rights reserved.
//

import Foundation
import UIKit



class QuestionDetailCommentCell : BasicTableViewCell {
    
    var commentIdx = ""
    
    var commentData : CommentData? {
        
        didSet {
            
            guard let uid = commentData?.uid else { return }
            guard let isSelectStatus = commentData?.isSelected else { return }
            
            self.nameLabel.text = commentData?.name
            self.contentLabel.text = commentData?.content
            self.dateLabel.text = commentData?.date?.timeAgoDisplay()
            
            let isSelectButtonBackgroundColor = isSelectStatus ? UIColor.mainColor : UIColor.white
            self.isSelectedButton.backgroundColor = isSelectButtonBackgroundColor
            let profileImage = StorageRef.profileImageRef.child(uid)
            self.profileImageView.sd_setImage(with: profileImage, placeholderImage: UIImage.profilePlaceHoderImage)
        }
    }

    var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        return iv
    }()
    
    var nameLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.textColor = UIColor.titleBlack
        return l
    }()
    
    var dateLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = UIColor.contentGray
        return l
    }()

    var contentLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = UIColor.contentGray
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        return l
    }()
    
    var isSelectedButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.placeHoderColor
        b.setAttributedTitle(NSAttributedString(string: "Selected Answer", attributes: [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 13)]), for: .normal)
        b.setAttributedTitle(NSAttributedString(string: "Choose Answer", attributes: [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 13)]), for: .disabled)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.layer.cornerRadius = 5
        return b
    }()
    
    let seperateLineView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.backgroundGray
        return v
    }()
    
    override func prepareForReuse() {
        
        guard let uid = commentData?.uid else { return }
        guard let isSelectStatus = commentData?.isSelected else { return }
        
        self.nameLabel.text = commentData?.name
        self.contentLabel.text = commentData?.content
        self.dateLabel.text = commentData?.date?.timeAgoDisplay()
        
        let isSelectButtonBackgroundColor = isSelectStatus ? UIColor.mainColor : UIColor.placeHoderColor
        self.isSelectedButton.backgroundColor = isSelectButtonBackgroundColor
        let profileImage = StorageRef.profileImageRef.child(uid)
        self.profileImageView.sd_setImage(with: profileImage, placeholderImage: UIImage.profilePlaceHoderImage)
    }

    override func initial() {
        super.initial()
        setupViews()
    }
}

extension QuestionDetailCommentCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func setupViews() {

        [profileImageView,
        nameLabel,
        dateLabel,
        contentLabel,
        isSelectedButton,
        seperateLineView].forEach({contentView.addSubview($0)})
        
        let selectButtonWidth = self.frame.width * 0.4
        profileImageView.anchor(top: contentView.topAnchor,
                                leading: contentView.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: .init(top: 16, left: 16, bottom: 0, right: 0),
                                size: .init(width: 48, height: 48))
        
        nameLabel.anchor(top: nil,
                         leading: profileImageView.trailingAnchor,
                         bottom: profileImageView.centerYAnchor,
                         trailing: nil,
                         padding:.init(top: 0, left: 16, bottom: 2, right: 0))
        
        dateLabel.anchor(top: profileImageView.centerYAnchor,
                         leading: profileImageView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding:.init(top: 2, left: 16, bottom: 0, right: 0))
        
        isSelectedButton.anchor(top: nil,
                                leading: nil,
                                bottom: nil,
                                trailing: contentView.trailingAnchor,
                                centerY: dateLabel.centerYAnchor,
                                padding:.init(top: 0, left: 0, bottom: 0, right: 16),
                                size:.init(width: selectButtonWidth, height: 20))
        
        contentLabel.anchor(top: dateLabel.bottomAnchor,
                            leading: profileImageView.trailingAnchor,
                            bottom: contentView.bottomAnchor,
                            trailing: contentView.trailingAnchor,
                            padding:.init(top: 16, left: 16, bottom: 16, right: 16))
        
        seperateLineView.anchor(top: nil,
                                leading: profileImageView.trailingAnchor,
                                bottom: contentView.bottomAnchor,
                                trailing: contentView.trailingAnchor,
                                padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                                size: .init(width: 0, height: 1.0))
    }
}

extension QuestionDetailCommentCell {
    
}
