//
//  UIAlertController.swift
//  FirstProject
//
//  Created by Euijae Hong on 2018. 6. 28..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func showText(vc:UIViewController ,title:String) {
        
        DispatchQueue.main.async {
            
            let alertVC = UIAlertController(title:title, message: nil, preferredStyle: .alert)
            let done = UIAlertAction(title:"done", style: .default, handler: nil)
            alertVC.addAction(done)
            
            vc.present(alertVC, animated: true, completion: nil)
            
        }
    }
    
    static func showMessage(_ message: String) {
        showAlert(title: "", message: message, actions: [UIAlertAction(title: "OK", style: .cancel, handler: nil)])
    }
    
    static func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for action in actions {
                alert.addAction(action)
                
            }
            
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let presenting = navigationController.topViewController {
                presenting.present(alert, animated: true, completion: nil)
            }
        }
    }
}
