//
//  UITableView.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 15..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit


class BasicTableViewCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        initial()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initial() {
        
    }
    
}

class BasicCollectionViewCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func initial() {
        
    }

}

public protocol ReusableView: class { }

extension ReusableView where Self: UIView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }

extension UITableViewHeaderFooterView: ReusableView { }

extension UITableView {
    
    public func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
        
    }
    
    public func dequeueCell<T: UITableViewCell>(ofType type: T.Type , indexPath :IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
        
    }
    
}


