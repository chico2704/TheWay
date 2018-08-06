//
//  AppDelegate.swift
//  FirstProject
//
//  Created by ROGER on 2018. 6. 15..
//  Copyright © 2018년 hexcon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn
import Crashlytics
import Fabric
import NVActivityIndicatorView
import UserNotifications


let appDelegate = UIApplication.shared.delegate as! AppDelegate



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        Fabric.sharedSDK().debug = true
        
        setupNavi()
                
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.frame = UIScreen.main.bounds
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Firebase 초기화 코드
        setupFIB()
        
        // 구글 로그인 셋업
        setupGoogleLogin()
        // 오토 로그인
        checkAutoLogin()
        // FCM 셋팅
        setupFCM(application: application)
 
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

   
}

//MARK:- URL
extension AppDelegate {
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: [:])
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication, annotation: annotation)
        
    }

}




//MARK:- Private Func
extension AppDelegate {
    
    // 파이어 베이스 초기화 및 셋팅
    private func setupFIB() {
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
    }

    /* 체크 오토 로그인
     
        1. 구글 로그인검사
        2. Email 로그인검사
     
     */
    
    private func checkAutoLogin() {
        
        let loginType = User.shared.getLoginType
        
        /*
         이메일,페이스북,구글 로그인은 파이어베이스로 공유됨
         차후 카카오톡,네이버 같은경우는 자체적인 토큰을 받을수있음
        */
        
        if Auth.auth().currentUser == nil {
            
            
            // Auth 인증값없음 ( 로그아웃,네이버,카카오톡 )
            // 차후 처리 지금은 일단 로그아웃 상태 or 로그인 한번도 하지않은 상태
    
            let signInVC = SignInViewController()
            window?.rootViewController = signInVC
            
        } else {
            
            // Auth 인증값이 존재하는경우 ( 이메일,구글,페이스북 )
            switch loginType {
                
            case LoginType.Email.rawValue,
                 LoginType.Google.rawValue,
                 LoginType.Facebook.rawValue:
                
                setUserDataWithLogin(completion:{
                    self.changeRootViewController()
                })
                
                break

                // 차후 로그인 추가 때 넣을 예정
            default: ()
            }
        }

    }
    
    
    // 루트뷰 컨트롤러 바꿔주기
    public func changeRootViewController() {
        
        guard let window = window else { return }
        let tabBarController = TabBarController()
        UIView.transition(with: window, duration: 1, options: .transitionCrossDissolve, animations: {
            window.rootViewController = tabBarController
        }, completion: { completed in

        })
    }
    
}


//MARK:- SignUp
extension AppDelegate {
    
    private func setUserDataWithLogin(completion : @escaping () -> Void) {
        let currentUser = Auth.auth().currentUser
        guard let uid = currentUser?.uid else { return }
        
        Firebase.searchUser(uid) { (isUser) in
            if isUser {
                completion()
            }
        }
    }
}


//MARK:- Social Login
extension AppDelegate {
    
    private func setupGoogleLogin() {
    
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
    }

}

//MARK:- Setup Navigation Appearence

extension AppDelegate {
    
    private func setupNavi() {
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.mainColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        UISearchBar.appearance().tintColor = UIColor.mainColor
        let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
}

//MARK:- FCM
extension AppDelegate : MessagingDelegate ,UNUserNotificationCenterDelegate {
    
    
    private func setupFCM(application:UIApplication) {
        
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
  
    }
     /*
        토큰 생성 모니터링
        토큰이 업데이트될 때마다 알림을 받으려면 메시지 대리자 프로토콜을 준수하는 대리자를 제공합니다. 다음 예제에서는 대리자를 등록하고 적절한 대리자 메소드를 추가합니다.
     */
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        let token = Messaging.messaging().fcmToken
        print("==================================================")
        print("FCM token: \(token ?? "")")
        print("==================================================")
        
    }
    /*
        재구성 사용 중지됨: APN 토큰과 등록 토큰 매핑
        메소드 재구성을 사용 중지했다면 APN 토큰을 명시적으로 FCM 등록 토큰에 매핑해야 합니다. didRegisterForRemoteNotificationsWithDeviceToken 메소드를 재정의하여 APN 토큰을 검색한 다음 APNSToken 속성을 사용합니다.
    */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        
        
    }
    
}

