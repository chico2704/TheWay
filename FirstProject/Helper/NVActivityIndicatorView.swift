//
//  NVActivityIndicatorView.swift
//  FirstProject
//
//  Created by ROGER on 26/06/2018.
//  Copyright © 2018 hexcon. All rights reserved.
//

import Foundation
import NVActivityIndicatorView



class Indicator : NVActivityIndicatorViewable {

    static let shared = Indicator()
    
    func show() {
        
        let activityData = ActivityData(size:CGSize(width:48, height: 48), message:"Loading", messageFont: nil, messageSpacing: nil, type: .ballPulse, color: UIColor.mainColor, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: .white)
        
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
    }
    
    
    func hide() {
    
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        
    }
    
}
