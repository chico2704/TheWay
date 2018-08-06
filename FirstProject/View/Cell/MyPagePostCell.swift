//
//  MyPagePostCell.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 18..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import SDWebImage

class MyPagePostCell: BasicTableViewCell {

    var postData: QuestionData? {
        didSet {
            setupData()
        }
    }
    
    override func initial() {
        super.initial()
        setupViews()
    }
    
    // MARK: - Views
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "waiting")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.textColor = UIColor.titleBlack
        return l
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = UIFont.boldSystemFont(ofSize: 17)
        l.textColor = UIColor.titleBlack
        l.text = "cell test"
        return l
    }()
    
    let detailLabel: UILabel = UILabel()

    private func setupData() {
        
        self.titleLabel.text = postData?.title
        
        // nameLable: userName, date
        let name = User.shared.name
        let date = postData?.date?.timeAgoDisplay() ?? "eternal univere time"
        
        let nameAttributes: [NSAttributedStringKey : Any] = [.font : UIFont.boldSystemFont(ofSize: 15),
                                                             .foregroundColor : UIColor.titleBlack]
        
        let nameAttributedString = NSMutableAttributedString(string: name,
                                                             attributes: nameAttributes)
        
        let dateAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.gray,
                                                             .font : UIFont.systemFont(ofSize: 13)]
        let dateAttributedString = NSMutableAttributedString(string: "\n\(date)", attributes: dateAttributes)
        nameAttributedString.append(dateAttributedString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        nameAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, nameAttributedString.string.count))
        self.nameLabel.attributedText = nameAttributedString
        
        // detailLabel: answerdCount, commentCount
        let answeredCount = postData?.answeredCount ?? "0"
        let commentCount = postData?.commentCount ?? "0"
        
        let detailAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.gray,
                                                               .font : UIFont.systemFont(ofSize: 13)]
        
        let detailAttributedString = NSMutableAttributedString(string: "answer \(answeredCount)  |  comment \(commentCount)",
            attributes: detailAttributes)
        
        self.detailLabel.attributedText = detailAttributedString
    }
}

// MARK: - Setup Views
extension MyPagePostCell {
    
    private func setupViews() {
        
        [statusImageView,
         nameLabel,
         titleLabel,
         detailLabel].forEach { addSubview($0) }
        
        let profileImageViewWidth = self.frame.width * 0.15
        
        statusImageView.anchor(top: self.topAnchor,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: .init(top: 24, left: 16, bottom: 0, right: 0),
                                size: .init(width: profileImageViewWidth, height: profileImageViewWidth))
        
        nameLabel.anchor(top: statusImageView.topAnchor,
                         leading: statusImageView.trailingAnchor,
                         bottom: nil,
                         trailing: self.trailingAnchor,
                         padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        
        titleLabel.anchor(top: nameLabel.bottomAnchor,
                            leading: nameLabel.leadingAnchor,
                            bottom: nil,
                            trailing: self.trailingAnchor,
                            padding: .init(top: 8, left: 0, bottom: 0, right: 16))
        
        detailLabel.anchor(top: titleLabel.bottomAnchor,
                           leading: nameLabel.leadingAnchor,
                           bottom: self.bottomAnchor,
                           trailing: self.trailingAnchor,
                           padding: .init(top: 8, left: 0, bottom: 16, right: 16))
        
        statusImageView.layer.cornerRadius = profileImageViewWidth / 2
        statusImageView.clipsToBounds = true
    }
}
