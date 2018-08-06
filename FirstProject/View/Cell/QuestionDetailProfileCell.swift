//
//  QuestionDetailProfileCell.swift
//  FirstProject
//
//  Created by ROGER on 25/06/2018.
//  Copyright © 2018 hexcon. All rights reserved.
//

import Foundation
import UIKit


class QuestionDetailProfileCell : BasicTableViewCell {
    
    var questionData : QuestionData? {
        didSet {
            guard let uid = self.questionData?.uid else { return }
            
            self.profileImageView.sd_setImage(with: StorageRef.profileImageRef.child(uid), placeholderImage: UIImage.profilePlaceHoderImage)
            self.nameLabel.text = questionData?.userData?.name
            self.dateLabel.text = questionData?.date?.timeAgoDisplay()
        }
    }
    
    var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.placeHoderColor
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
    
    let menuButton : UIButton = {
        let b = UIButton()
        let image = UIImage(named: "DetailFeedMenu")?.withRenderingMode(.alwaysTemplate)
        b.setImage(image, for: .normal)
        b.tintColor = UIColor.placeHoderColor
        return b
    }()
    
    override func prepareForReuse() {
        
        guard let uid = self.questionData?.uid else { return }
        
        self.profileImageView.sd_setImage(with: StorageRef.profileImageRef.child(uid), placeholderImage: UIImage.profilePlaceHoderImage)
        self.nameLabel.text = questionData?.userData?.name
        self.dateLabel.text = questionData?.date?.changeTimeToString
    }
    
    override func initial() {
        super.initial()
        setupViews()
    }
}

//MARK:-
extension QuestionDetailProfileCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    fileprivate func setupViews() {
        [profileImageView,
        nameLabel,
        dateLabel,
        menuButton].forEach({self.contentView.addSubview($0)})

        profileImageView.anchor(top: contentView.topAnchor,
                                leading: contentView.leadingAnchor,
                                bottom: contentView.bottomAnchor,
                                trailing: nil,
                                padding: .init(top: 16, left: 16, bottom: 16, right: 0),
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
        
        menuButton.anchor(top: nil,
                          leading: nil,
                          bottom: nil,
                          trailing: contentView.trailingAnchor,
                          centerY:profileImageView.centerYAnchor,
                          padding:.init(top: 0, left: 0, bottom: 0, right: 16),
                          size:.init(width: 24, height: 24))
    }
}
