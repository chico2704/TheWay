//
//  QuestionCardCell.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 15..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit


class QuestionCardCell : BasicTableViewCell {
    
    var questionData : QuestionData? {
        didSet {
            setupData()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupData()
    }
    
    let cardView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.45
        v.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        v.layer.shadowRadius = 1.7
        v.layer.cornerRadius = 8
        return v
    }()

    var locationLabel : UILabel = {
        let l = UILabel()
        l.text = "Changwon, Sounth Korea"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = UIColor.contentGray
        return l
    }()
    
    var titleLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 17)
        l.textColor = UIColor.titleBlack
        l.numberOfLines = 0
        return l
    }()
    
    var answerLabel : UILabel = {
        let l = UILabel()
        l.text = "answer 0"
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.contentGray
        return l
    }()

    var commentLabel : UILabel = {
        let l = UILabel()
        l.text = "comment 0"
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.contentGray
        return l
    }()

    let seperateLineView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.placeHoderColor
        return v
    }()
    
    var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        return iv
    }()
    
    var nameLabel : UILabel = {
        let l = UILabel()
        l.text = "nameLabel"
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.textColor = UIColor.titleBlack
        return l
    }()
    
    var dateLabel : UILabel = {
        let l = UILabel()
        l.text = "dateLabel"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = UIColor.contentGray
        return l
    }()

    override func initial() {
        super.initial()
        setupViews()
    }
    
    
    private func setupData() {
        
        guard let uid = self.questionData?.uid else { return }
        
        self.titleLabel.text = questionData?.title
        self.nameLabel.text = questionData?.userData?.name
        self.dateLabel.text = questionData?.date?.timeAgoDisplay()
        self.answerLabel.text = "answer \(self.questionData?.answeredCount ?? "0")"
        self.commentLabel.text = "comment \(self.questionData?.commentCount ?? "0")"
        
        let profileImage = StorageRef.profileImageRef.child(uid)
        self.profileImageView.sd_setImage(with: profileImage, placeholderImage: UIImage.profilePlaceHoderImage)
    }
}

//MARK: SetupViews
extension QuestionCardCell {
    
    private func setupViews() {
        
        contentView.addSubview(cardView)
        cardView.anchor(top: contentView.topAnchor,
                        leading: contentView.leadingAnchor,
                        bottom: contentView.bottomAnchor,
                        trailing: contentView.trailingAnchor,
                        padding:.init(top: 16, left: 16, bottom: 16, right: 16))
        
        [locationLabel,
        titleLabel,
        answerLabel,
        commentLabel,
        seperateLineView,
        profileImageView,
        nameLabel,
        dateLabel].forEach({cardView.addSubview($0)})
        
        locationLabel.anchor(top: cardView.topAnchor,
                             leading: cardView.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding:.init(top: 16, left: 16, bottom: 0, right: 0))
        
        titleLabel.anchor(top: locationLabel.bottomAnchor,
                          leading: cardView.leadingAnchor,
                          bottom: nil,
                          trailing: cardView.trailingAnchor,
                          padding:.init(top: 8, left: 16, bottom: 0, right: 16))
        
        answerLabel.anchor(top: titleLabel.bottomAnchor,
                           leading: cardView.leadingAnchor,
                           bottom: nil,
                           trailing: nil,
                           padding:.init(top: 8, left: 16, bottom: 0, right: 0))
        
        commentLabel.anchor(top: answerLabel.topAnchor,
                            leading: answerLabel.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding:.init(top: 0, left: 16, bottom: 0, right: 0))
        
        seperateLineView.anchor(top: answerLabel.bottomAnchor,
                                leading: cardView.leadingAnchor,
                                bottom: nil, trailing: cardView.trailingAnchor,
                                padding:.init(top: 8, left: 0, bottom: 0, right: 0),
                                size:.init(width: 0, height: 0.5))
        
        profileImageView.anchor(top: seperateLineView.bottomAnchor,
                                leading: cardView.leadingAnchor,
                                bottom: cardView.bottomAnchor,
                                trailing: nil,
                                padding :.init(top: 16, left: 16, bottom: 16, right: 0),
                                size:.init(width: 48, height: 48))
        
        nameLabel.anchor(top: nil,
                         leading: profileImageView.trailingAnchor,
                         bottom: profileImageView.centerYAnchor,
                         trailing: nil,
                         padding:.init(top: 0, left: 8, bottom: 2, right: 0))
        
        dateLabel.anchor(top: profileImageView.centerYAnchor,
                         leading: profileImageView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,padding:.init(top: 2, left: 8, bottom: 0, right: 0))
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
