//
//  QuestionDetailContentCell.swift
//  FirstProject
//
//  Created by ROGER on 25/06/2018.
//  Copyright © 2018 hexcon. All rights reserved.
//

import Foundation
import UIKit


class QuestionDetailContentCell : BasicTableViewCell {
    
    var questionData : QuestionData? {
        
        didSet {
            // 북마크 체크
            checkisBookmark()
            
            self.titleLabel.text = self.questionData?.title
            self.contentLabel.text = self.questionData?.content
            self.answerLabel.text = "answer \(self.questionData?.answeredCount ?? "0")"
            self.commentLabel.text = "comment \(self.questionData?.commentCount ?? "0")"
        }
    }
    
    var titleLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 17)
        l.textColor = UIColor.titleBlack
        l.numberOfLines = 0
        return l
    }()
    
    var contentLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = UIColor.contentGray
        l.numberOfLines = 0
        return l
    }()
    
    var answerLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.contentGray
        return l
    }()
    
    var commentLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.contentGray
        return l
    }()

    lazy var bookmarkButton : UIButton = {
        let b = UIButton()
        let image = UIImage(named: "bookmarkSelected")?.withRenderingMode(.alwaysTemplate)
        b.setImage(image, for: .normal)
        b.tintColor = UIColor.placeHoderColor
        b.isUserInteractionEnabled = true
        b.addTarget(self, action: #selector(tappedBookmarkButton), for: .touchUpInside)
        return b
    }()
    
    let seperateLineView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.backgroundGray
        return v
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = self.questionData?.title
        self.contentLabel.text = self.questionData?.content
        self.answerLabel.text = "answer \(self.questionData?.answeredCount ?? "0")"
        self.commentLabel.text = "comment \(self.questionData?.commentCount ?? "0")"
    }
    
    override func initial() {
        super.initial()
        setupViews()
    }
}

extension QuestionDetailContentCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func setupViews() {
        
        [titleLabel,
        contentLabel,
        answerLabel,
        commentLabel,
        bookmarkButton,
        seperateLineView].forEach({self.contentView.addSubview($0)})
        
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          bottom: nil,
                          trailing: contentView.trailingAnchor,
                          padding:.init(top: 16, left: 16, bottom: 0, right: 16))
        
        contentLabel.anchor(top: titleLabel.bottomAnchor,
                            leading: contentView.leadingAnchor,
                            bottom: nil,
                            trailing: contentView.trailingAnchor,
                            padding:.init(top: 16, left: 16, bottom: 0, right: 16))
        
        answerLabel.anchor(top: contentLabel.bottomAnchor,
                           leading: contentView.leadingAnchor,
                           bottom: nil,
                           trailing: nil,
                           padding:.init(top: 16, left: 16, bottom: 0, right: 0))
        
        commentLabel.anchor(top: answerLabel.topAnchor,
                            leading: answerLabel.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding:.init(top: 0, left: 16, bottom: 0, right: 0))
        
        bookmarkButton.anchor(top: nil,
                              leading: nil,
                              bottom: nil,
                              trailing: contentView.trailingAnchor,
                              centerY: answerLabel.centerYAnchor,
                              padding:.init(top: 0, left: 0, bottom: 0, right: 16),
                              size:.init(width: 30, height: 30))
        
        seperateLineView.anchor(top: bookmarkButton.bottomAnchor,
                                leading: contentView.leadingAnchor,
                                bottom: contentView.bottomAnchor,
                                trailing: contentView.trailingAnchor,
                                padding:.init(top: 16, left: 0, bottom: 0, right: 0),
                                size:.init(width: 0, height: 10))
    }
}

//MARK:- private Func
extension QuestionDetailContentCell {

    // 북마크 색깔 바꾸기
    private func changeBookmarkColor(isSelected:Bool) {
        
        let bookmarkImage = UIImage(named:"bookmarkSelected")?.withRenderingMode(.alwaysTemplate)
        let color = isSelected ? UIColor.mainColor : UIColor.placeHoderColor
    
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        bookmarkButton.tintColor = color
        bookmarkButton.isSelected = isSelected
    }

    // 북마크 체크
    private func checkisBookmark() {
        
        guard let questionIdx = questionData?.idx else { return }
        if User.shared.bookmark.contains(questionIdx) { changeBookmarkColor(isSelected: true) }
    }
}

//MARK:- Action
extension QuestionDetailContentCell {
    
    @objc func tappedBookmarkButton() {
        
        guard let idx = self.questionData?.idx else { return }
        
        let isSelected = self.bookmarkButton.isSelected
        
        if isSelected {
            
            changeBookmarkColor(isSelected:false)
            self.bookmarkButton.isUserInteractionEnabled = true
            
            // 북마크 해제
            Firebase.removeBookmarkDoc(idx) {
                
                if let index = User.shared.bookmark.index(of:idx) {
                    User.shared.bookmark.remove(at: index)
                    
                    print("==============================")
                    print("success remove bookmark",User.shared.bookmark)
                }
                // bookmarkDidDeselect 노티 보내기
                NotificationCenter.default.post(name: .bookmarkButtonDidDeselect, object: nil)
            }
            
        } else {
            
            changeBookmarkColor(isSelected:true)
            self.bookmarkButton.isUserInteractionEnabled = true
            
            // 북마크 등록
            Firebase.addBookmarkDoc(idx) {
                
                User.shared.bookmark.append(idx)
                print("==============================")
                print("success add bookmark",User.shared.bookmark)
            
            }
        }
    }
}
