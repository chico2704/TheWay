//
//  MyPageBookmarkCell.swift
//  FirstProject
//
//  Created by Suzy Park on 2018. 7. 19..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import UIKit
import FirebaseStorage
import SDWebImage

class MyPageBookmarkCell: BasicTableViewCell {
    
    var bookmarkData: QuestionData? {
        didSet{
            setupData()
        }
    }
    
    override func initial() {
        super.initial()
        setupViews()
    }
    
    // MARK: - Views
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "basicProfile")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.titleBlack
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.titleBlack
        label.text = "cell test"
        return label
    }()
    
    let detailLabel: UILabel = UILabel()
    
    // MARK: - Methods
    func setupData() {
        self.titleLabel.text = bookmarkData?.title
        
        // detailLabel: answerdCount, commentCount
        let answeredCount = bookmarkData?.answeredCount ?? "0"
        let commentCount = bookmarkData?.commentCount ?? "0"
        
        let detailAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.gray,
            NSAttributedStringKey.font            : UIFont.systemFont(ofSize: 13)]
        
        let detailAttributedString = NSMutableAttributedString(string: "answer \(answeredCount)  |  comment \(commentCount)",
            attributes: detailAttributes)
        
        self.detailLabel.attributedText = detailAttributedString
        
        // nameLable: userName, date
        let name = bookmarkData?.userData?.name ?? "unknown"
        let date = self.bookmarkData?.date?.timeAgoDisplay() ?? "eternal univere time"
        
        let nameAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack,
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let nameAttributedString = NSMutableAttributedString(string: name,
                                                             attributes: nameAttributes)
        
        let dateAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.contentGray,
            NSAttributedStringKey.font            : UIFont.systemFont(ofSize: 13)]
        let dateAttributedString = NSMutableAttributedString(string: "\n\(date)",
            attributes: dateAttributes)
        
        nameAttributedString.append(dateAttributedString)
        
        // paragraph Style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        // add paragraph Style to main AttributedString
        nameAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, nameAttributedString.string.count))
        self.nameLabel.attributedText = nameAttributedString
        
        // profileImage
        let uid = bookmarkData?.userData?.uid ?? ""
        let profileImage = Storage.storage().reference(withPath: "profileImage").child(uid)
        self.profileImageView.sd_setImage(with: profileImage, placeholderImage: UIImage.profilePlaceHoderImage)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setupData()
    }
    
    func clearSDImageCacheMemoryAndDisk() {
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
}

// MARK: - Setup Views
extension MyPageBookmarkCell {
    
    func setupViews() {
        
        [profileImageView,
         nameLabel,
         titleLabel,
         detailLabel].forEach { addSubview($0) }
        
        let profileImageViewWidth = self.frame.width * 0.15
        
        profileImageView.anchor(top: self.topAnchor,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: .init(top: 24, left: 16, bottom: 0, right: 0),
                                size: .init(width: profileImageViewWidth, height: profileImageViewWidth))
        
        nameLabel.anchor(top: profileImageView.topAnchor,
                         leading: profileImageView.trailingAnchor,
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
        
        profileImageView.layer.cornerRadius = profileImageViewWidth / 2
        profileImageView.clipsToBounds = true
    }
}
