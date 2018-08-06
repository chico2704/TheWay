//
//  Date.swift
//  FirstProject
//
//  Created by Euijae Hong on 2018. 7. 2..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import Firebase
import UIKit

extension Timestamp {
    
    func timeAgoDisplay() -> String {
        
//        let currentDate = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        formatter.locale = Locale(identifier:"ko_KR")
//        formatter.timeZone = TimeZone(identifier:"KST")
        
//        let strDate = formatter.string(from:currentDate)
//        guard let date = formatter.date(from: strDate) else { return "" }
        
        let secondsAgo = Int(Date().timeIntervalSince(self.dateValue()))

        let min = 60
        let hour = 60 * min
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < min {
            
            return "just now"
//            return "\(secondsAgo) seconds ago"
            
        } else if secondsAgo < hour {
            
            return "\(secondsAgo / min) minutes ago"
            
        } else if secondsAgo < day {
            
            return "\(secondsAgo / hour) hours ago"
            
        } else if secondsAgo < week {
            
            return "\(secondsAgo / day) days ago"
            
        }
        
        return "\(secondsAgo / week) weeks ago"
        
    }
    
    var changeTimeToString : String? {
        
        let date = self.dateValue()
        
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "YYYY.MM.dd-HH.mm.ss"
        let strDate = dateFomatter.string(from: date)
        
        return strDate
        
    }
    
}
