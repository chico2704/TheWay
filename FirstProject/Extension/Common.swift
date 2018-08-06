//
//  Common.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 15..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit


public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
