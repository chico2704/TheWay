//
//  SearchHistoryCell.swift
//  FirstProject
//
//  Created by Euijae Hong on 2018. 7. 10..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit

class SearchHistoryCell : BasicTableViewCell {
    
    var historyLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17)
        l.textColor = UIColor.titleBlack
        return l
    }()
    
    override func initial() {
        super.initial()
                
        contentView.addSubview(historyLabel)
        historyLabel.anchor(top: nil,
                            leading: contentView.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            centerY:contentView.centerYAnchor,
                            padding:.init(top: 0, left: 32, bottom: 0, right: 0))
    }
}

extension SearchHistoryCell {
    
}
