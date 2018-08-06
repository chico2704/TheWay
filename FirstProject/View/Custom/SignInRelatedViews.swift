//
//  EmailAndPasswordViews.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 12..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit

class SignInRelatedViews: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.alpha = 0.8
        self.layer.cornerRadius = 5
    }
}
