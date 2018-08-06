//
//  Notification.swift
//  FirstProject
//
//  Created by Suzy Park on 2018. 7. 5..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let userNameButtonTextDidChanged = Notification.Name("userNameButtonTextDidChanged")
    static let profileImageViewImageDidChanged = Notification.Name("profileImageViewImageDidChanged")
    static let backgroundImageViewImageDidChanged = Notification.Name("backgroundImageViewImageDidChanged")
    static let profileImageViewImageDidInitialize = Notification.Name("profileImageViewImageDidInitialize")
    static let backgroundImageViewImageDidInitialize = Notification.Name("backgroundImageViewImageDidInitialize")
    static let bookmarkButtonDidDeselect = Notification.Name("bookmarkButtonDidDeselect")
    
}
