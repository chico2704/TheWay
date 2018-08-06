//
//  UIViewController.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 16..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public func printDeinitMessage() {
        print("#######################################")
        print("deinit : \(self.className)")
    }
    
}

