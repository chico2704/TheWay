//
//  CommentView.swift
//  FirstProject
//
//  Created by Euijae Hong on 2018. 7. 2..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class CommentView : UIView {
    
    let commentImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.image = UIImage(named:"comment")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.placeHoderColor
        return iv
    }()
    
    let commentTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.textColor = UIColor.titleBlack
        tv.isScrollEnabled = false
        tv.backgroundColor = UIColor.backgroundGray
        tv.layer.cornerRadius = 5
        return tv
    }()
    
    let doneButton : UIButton = {
        let b = UIButton()
        b.setTitle("Up", for: .disabled)
        b.setTitleColor(UIColor.placeHoderColor, for: .disabled)
        b.setTitle("Up", for: .normal)
        b.setTitleColor(UIColor.mainColor, for: .normal)
        b.isEnabled = false
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: SubViews Layout
extension CommentView {
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let window = window {
            bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
        }
    }
    
    private func setupViews() {
        
        [commentImageView,
        commentTextView,
        doneButton].forEach({self.addSubview($0)})
        
        commentImageView.anchor(top: nil,
                                leading: self.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                centerY: self.centerYAnchor,
                                padding:.init(top: 0, left: 16, bottom: 0, right: 0),
                                size:.init(width: 30, height: 30))
        
        commentTextView.anchor(top: self.topAnchor,
                               leading: commentImageView.trailingAnchor,
                               bottom: self.bottomAnchor,
                               trailing: doneButton.leadingAnchor,
                               padding:.init(top: 8, left: 8, bottom: 8, right: 0))
        
        doneButton.anchor(top: nil,
                          leading: nil,
                          bottom: nil,
                          trailing: self.trailingAnchor,
                          centerY: commentImageView.centerYAnchor,
                          padding:.init(top: 0, left: 0, bottom: 8, right: 16),
                          size:.init(width: 40, height: 40))
    }
}
