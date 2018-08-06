//
//  HeaderView.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 19..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI

class MyPageHeaderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    // MARK: - Views
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let segmentedControl: UISegmentedControl = {

        let segmentedControl = UISegmentedControl(items: ["menu", "bookmark"])
        segmentedControl.tintColor = UIColor.clear
        segmentedControl.backgroundColor = UIColor.clear
    

        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "menu", at: 0, animated: true)
        sc.insertSegment(withTitle: "bookmark", at: 1, animated: true)
        sc.tintColor = UIColor.clear
        sc.backgroundColor = UIColor.clear
        sc.selectedSegmentIndex = 0
        
        let menuSelectedImage = UIImage(named: "menuSelected")
        let bookmarkImage = UIImage(named: "bookmark")
        sc.setImage(menuSelectedImage, forSegmentAt: 0)
        sc.setImage(bookmarkImage, forSegmentAt: 1)
        return sc
    }()
    
    let segmentedControlBar: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.mainColor
        return bv
    }()
    
    let profileImageView: UIImageView = UIImageView()
    
    let userNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = UIColor.white
        lb.text = User.shared.name
        
        return lb
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        let numberAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack,
            NSAttributedStringKey.font            : UIFont.boldSystemFont(ofSize: 22)]
        let numberAttributedString = NSMutableAttributedString(string: " ", attributes: numberAttributes)
        
        let titleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack,
            NSAttributedStringKey.font            : UIFont.systemFont(ofSize: 15)]
        let titleAttributedString = NSMutableAttributedString(string: "\nQuestion", attributes: titleAttributes)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        numberAttributedString.append(titleAttributedString)
        numberAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                            value: paragraph,
                                            range: NSMakeRange(0, numberAttributedString.string.count))
        label.attributedText = numberAttributedString
        return label
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        let numberAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack,
            NSAttributedStringKey.font            : UIFont.boldSystemFont(ofSize: 22)]
        let numberAttributedString = NSMutableAttributedString(string: "24", attributes: numberAttributes)
        
        let titleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack,
            NSAttributedStringKey.font            : UIFont.systemFont(ofSize: 15)]
        let titleAttributedString = NSMutableAttributedString(string: "\nAnswered", attributes: titleAttributes)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        numberAttributedString.append(titleAttributedString)
        numberAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                            value: paragraph,
                                            range: NSMakeRange(0, numberAttributedString.string.count))
        label.attributedText = numberAttributedString
        return label
    }()
}

// MARK: - Setup Views
extension MyPageHeaderView {
    
    func setupViews() {        
        [backgroundImageView,
         segmentedControl,
         segmentedControlBar,
         profileImageView,
         userNameLabel,
         questionLabel,
         answerLabel].forEach { addSubview($0) }
    }
}
