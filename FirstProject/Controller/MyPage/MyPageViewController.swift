//
//  MyPageViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 18..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImage


class MyPageViewController: UIViewController {
    
    var selectedSegmentIndex: Int = 0
    var questionCount: Int = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)
        return rc
    }()
    
    var postData = [QuestionData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var bookmarkData = [QuestionData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let myPageTableViewHeaderView = MyPageHeaderView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ofType: MyPagePostCell.self)
        tableView.registerCell(ofType: MyPageBookmarkCell.self)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
    
    func clearSDImageCacheMemoryAndDisk() {
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
    
    private func getPostData() {
        self.postData.removeAll()
        self.questionCount = 0
        Indicator.shared.show()
        FirestoreRef.postRef(User.shared.uid).getDocuments { (documents, error) in
            if let error = error {
                UIAlertController.showMessage(error.localizedDescription)
            } else {
                let dispatchGroup = DispatchGroup()
                documents?.documents.forEach({[weak self] documents in
                    
                    dispatchGroup.enter()
                    
                    var idxs = documents.data()
                    guard let idx = idxs["idx"] as? String else { return }
                    
                    FirestoreRef.questionRef.document(idx).getDocument{ (document, error) in
                        Firebase.getUserDoc(User.shared.uid, completion: {[weak self] (user) in
                            Firebase.getCommentDoc(idx, completion: {[weak self] (comment) in
                                
                                guard var data = document?.data() else { return }
                                
                                var answerCount = 0
                                comment.forEach({ (data) in
                                    guard let isSelected = data.isSelected else { return }
                                    if isSelected { answerCount += 1 }
                                })
                                
                                data.updateValue("\(answerCount)", forKey: "answeredCount")
                                data.updateValue("\(comment.count)", forKey: "commentCount")
                                
                                let finalData = QuestionData(questionData: data, userData: user, commentData: comment)
                                self?.postData.append(finalData)
                                self?.questionCount += 1
                                
                                guard let sortedQuestionData = self?.postData.sorted(by: {$0.date!.dateValue().compare(($1.date?.dateValue())!) == .orderedDescending}) else { return }
                                self?.postData = sortedQuestionData
                                dispatchGroup.leave()
                            })
                        })
                    }
                })
                
                // 모든작업완료
                dispatchGroup.notify(queue: .main, execute: {
                    Indicator.shared.hide()
                    print("▶︎ get post data done")
                    self.setupCountingLabel(label: self.myPageTableViewHeaderView.questionLabel, title: "Question", countingString: "\(self.questionCount)")
                })
            }
        }
    }
    
    func getBookmarkData() {
        self.bookmarkData.removeAll()
        User.shared.bookmark.forEach({[weak self] idx in
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            FirestoreRef.questionRef.document(idx).getDocument { (document, error) in
                
                if let error = error{
                    UIAlertController.showMessage(error.localizedDescription)
                }

                guard var data = document?.data() else { return }
                guard let uid = data["uid"] as? String else { return }
                
                Firebase.getUserDoc(uid, completion: { [weak self] (user) in
                    Firebase.getCommentDoc(idx, completion: {[weak self] (comment) in
                        
                        var answerCount = 0
                        comment.forEach({ (data) in
                            guard let isSelected = data.isSelected else { return }
                            if isSelected { answerCount += 1 }
                        })
                        
                        data.updateValue("\(answerCount)", forKey: "answeredCount")
                        data.updateValue("\(comment.count)", forKey: "commentCount")
                        
                        let finalData = QuestionData(questionData: data, userData: user, commentData: comment)
                        self?.bookmarkData.append(finalData)
                        
                        guard let sortedQuestionData = self?.bookmarkData.sorted(by: {$0.date!.dateValue().compare(($1.date?.dateValue())!) == .orderedDescending}) else { return }
                        self?.bookmarkData = sortedQuestionData
                        dispatchGroup.leave()
                    })
                })
            }
            dispatchGroup.notify(queue: .main, execute: {
                print("▶︎ get bookmark data done")
            })
        })
    }
    
    func setupCountingLabel(label: UILabel, title: String, countingString: String) {
        label.numberOfLines = 2
        
        let numberAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack,
            NSAttributedStringKey.font            : UIFont.boldSystemFont(ofSize: 22)]
        let numberAttributedString = NSMutableAttributedString(string: countingString, attributes: numberAttributes)
        
        let titleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : UIColor.titleBlack,
            NSAttributedStringKey.font            : UIFont.systemFont(ofSize: 15)]
        let titleAttributedString = NSMutableAttributedString(string: "\n" + "\(title)", attributes: titleAttributes)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        numberAttributedString.append(titleAttributedString)
        numberAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                            value: paragraph,
                                            range: NSMakeRange(0, numberAttributedString.string.count))
        label.attributedText = numberAttributedString
    }
    
    deinit {
        self.printDeinitMessage()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Life Cycle
extension MyPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavi()
        getPostData()
        getBookmarkData()
        setupViews()
        setupTabelViewHeaderView()
        setupHeaderView()
        setupProfileImageViewGesture()
        setupNotificationObserver()
        setProfileSDImage()
        setBackgroundSDImage()

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
}

// MARK: - Table View
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedSegmentIndex == 0 {
            let cell = self.tableView.dequeueCell(ofType: MyPagePostCell.self, indexPath: indexPath)
            cell.postData = self.postData[indexPath.row]
            return cell
        } else {
            let cell = self.tableView.dequeueCell(ofType: MyPageBookmarkCell.self, indexPath: indexPath)
            cell.bookmarkData = self.bookmarkData[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmentIndex == 0 {
            return self.postData.count
        } else {
            return self.bookmarkData.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegmentIndex == 0 {
            let questionDetailVC = QuestionDetailViewController()
            questionDetailVC.questionData = self.postData[indexPath.row]
            self.navigationController?.pushViewController(questionDetailVC, animated: true)
        } else {
            let questionDetailVC = QuestionDetailViewController()
            questionDetailVC.questionData = self.bookmarkData[indexPath.row]
            self.navigationController?.pushViewController(questionDetailVC, animated: true)
        }
    }
}

// MARK: - Setup Navi
extension MyPageViewController {
    
    func setupNavi() {
        
        let rightBarButtonImage = UIImage(named: "setting")
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: rightBarButtonImage,
                                                              style: .done,
                                                              target: self,
                                                              action: #selector(settingBarButtonTapped))
        self.navigationItem.title = "My Page"
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: - Setup Views
extension MyPageViewController {
    
    func setupViews() {
        self.view.addSubview(tableView)
        self.tableView.addSubview(refreshControl)
        self.tableView.anchor(top: self.view.topAnchor,
                              leading: self.view.leadingAnchor,
                              bottom: self.view.bottomAnchor,
                              trailing: self.view.trailingAnchor)
    }
    
    func setupTabelViewHeaderView() {
        let headerViewWidth = self.view.frame.width
        let headerViewHeight = self.view.frame.height / 2
        
        myPageTableViewHeaderView.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: headerViewWidth,
                                                 height: headerViewHeight)
        
        self.tableView.tableHeaderView = myPageTableViewHeaderView
    }
    
    func setupHeaderView() {
        let headerView          = self.myPageTableViewHeaderView
        let backgroundImageView = headerView.backgroundImageView
        let profileImageView    = headerView.profileImageView
        let usernameLabel       = headerView.userNameLabel
        let questionLabel       = headerView.questionLabel
        let answerLabel         = headerView.answerLabel
        let segmentedControl    = headerView.segmentedControl
        let segmentedControlBar = headerView.segmentedControlBar
        let profileWidth        = self.view.frame.width * 0.3
        let segmentedControlBarWidth = self.view.frame.width / 2
                
        profileImageView.anchor(top: nil,
                                leading: nil,
                                bottom: segmentedControl.topAnchor,
                                trailing: nil,
                                centerX: backgroundImageView.centerXAnchor,
                                padding: .init(top: 0, left: 0, bottom: 16, right: 0),
                                size: .init(width: profileWidth, height: profileWidth))
        
        backgroundImageView.anchor(top: headerView.topAnchor,
                                   leading: headerView.leadingAnchor,
                                   bottom: profileImageView.centerYAnchor,
                                   trailing: headerView.trailingAnchor)
        
        usernameLabel.anchor(top: nil,
                             leading: nil,
                             bottom: profileImageView.topAnchor,
                             trailing: nil,
                             centerX: backgroundImageView.centerXAnchor,
                             padding: .init(top: 0, left: 0, bottom: 16, right: 0))
        
        questionLabel.anchor(top: backgroundImageView.bottomAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: profileImageView.leadingAnchor,
                             padding: .init(top: 24, left: 0, bottom: 0, right: 32))
        
        answerLabel.anchor(top: backgroundImageView.bottomAnchor,
                           leading: profileImageView.trailingAnchor,
                           bottom: nil,
                           trailing: nil,
                           padding: .init(top: 24, left: 32, bottom: 0, right: 0))
        
        segmentedControl.anchor(top: backgroundImageView.bottomAnchor,
                                leading: headerView.leadingAnchor,
                                bottom: nil,
                                trailing: headerView.trailingAnchor,
                                size: .init(width: 0, height: 50))
        
        segmentedControlBar.anchor(top: segmentedControl.bottomAnchor,
                                   leading: self.view.leadingAnchor,
                                   bottom: headerView.bottomAnchor, trailing: nil,
                                   size: .init(width: segmentedControlBarWidth, height: 2))
        
        profileImageView.layer.cornerRadius = profileWidth / 2
        profileImageView.clipsToBounds = true
        // segmented control
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }
}

// MARK: - Write profile & background Image: sd_setImage
extension MyPageViewController {
    
    func setProfileSDImage() {
        let profileImage = StorageRef.profileImageRef.child(User.shared.uid)
        self.myPageTableViewHeaderView.profileImageView.sd_setImage(with: profileImage, placeholderImage: UIImage.profilePlaceHoderImage)
    }
    
    func setBackgroundSDImage() {
        let backgroundImage = StorageRef.backgroundImageRef.child(User.shared.uid)
        self.myPageTableViewHeaderView.backgroundImageView.sd_setImage(with: backgroundImage, placeholderImage: UIImage.backgroundPlaceHoderImage)
    }
}

// MARK: - Setup Notification Observer
extension MyPageViewController {
    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(forName: .userNameButtonTextDidChanged,
                                               object: nil,
                                               queue: nil,
                                               using: catchUserNameChangeNotification)
        
        NotificationCenter.default.addObserver(forName: .profileImageViewImageDidChanged,
                                               object: nil,
                                               queue: nil,
                                               using: catchProfileChangeNotification)
        
        NotificationCenter.default.addObserver(forName: .backgroundImageViewImageDidChanged,
                                               object: nil, queue: nil,
                                               using: catchBackgroundChangeNotification)
        
        NotificationCenter.default.addObserver(forName: .profileImageViewImageDidInitialize,
                                               object: nil, queue: nil,
                                               using: catchProfileChangeNotification)
        
        NotificationCenter.default.addObserver(forName: .backgroundImageViewImageDidInitialize,
                                               object: nil, queue: nil,
                                               using: catchBackgroundChangeNotification)
        
        NotificationCenter.default.addObserver(self, selector: #selector(catchBookmarkButtonDeselected),
                                               name: .bookmarkButtonDidDeselect, object: nil)
    }
}

// MARK: - Action
extension MyPageViewController {
    
    @objc func refreshControlHandler(_ sender: UIRefreshControl) {
        getPostData()
        getBookmarkData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func segmentValueChanged() {
        
        let segmentedControl = myPageTableViewHeaderView.segmentedControl
        let segmentedControlBar = myPageTableViewHeaderView.segmentedControlBar
        
        let menuImage = UIImage(named: "menu")
        let menuSelectedImage = UIImage(named: "menuSelected")
        let bookmarkImage = UIImage(named: "bookmark")
        let bookmarkSelectedImage = UIImage(named: "bookmarkSelected")
        
        // segmentedControlBar animation
        let numberOfSeg = segmentedControl.numberOfSegments
        let selectedSegIndex = segmentedControl.selectedSegmentIndex
        
        UIView.animate(withDuration: 0.3) {
            segmentedControlBar.frame.origin.x = (segmentedControl.frame.width / CGFloat(numberOfSeg)) * CGFloat(selectedSegIndex)
        }
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            selectedSegmentIndex = 0
            print("▶︎ Selected Segment Index: \(segmentedControl.selectedSegmentIndex)_post")
            segmentedControl.setImage(menuSelectedImage, forSegmentAt: 0)
            segmentedControl.setImage(bookmarkImage, forSegmentAt: 1)
            
        case 1:
            selectedSegmentIndex = 1
            print("▶︎ Selected Segment Index: \(segmentedControl.selectedSegmentIndex)_bookmark")
            segmentedControl.setImage(menuImage, forSegmentAt: 0)
            segmentedControl.setImage(bookmarkSelectedImage, forSegmentAt: 1)
        default: ()
        }
        self.tableView.reloadData()
        print("""
                ⊂_ヽ
            　 　   ＼＼ Λ＿Λ
            　　 　　 ＼( 'ㅅ' ) tableView
            　　　 　　 >　⌒ヽ
            　　　　　　/ 　 へ＼
            　　 　　 /　　/　＼＼
            　　 　　 ﾚ　ノ　　 ヽ_つ
            　　　 　/　/
            　  　 /　/| reload
              　　(　(ヽ     done
              　　|　|、＼
              　　| 丿 ＼ ⌒)
              　　| |　　) /
               `ノ )　　Lﾉ
        """)
    }
    
    @objc func settingBarButtonTapped() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func catchBookmarkButtonDeselected() {
        getBookmarkData()
        self.tableView.reloadData()
        print("▶︎ bookmark list is reloaded")
    }
}

// MARK: - Profile Image View Guesture
extension MyPageViewController {
    
    fileprivate func setupProfileImageViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyPageViewController.profileImageTapped(gesture:)))
        myPageTableViewHeaderView.profileImageView.addGestureRecognizer(tapGesture)
        myPageTableViewHeaderView.profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func profileImageTapped(gesture: UIGestureRecognizer) {
        let profileImageVC = ProfileImageViewController()
        profileImageVC.modalPresentationStyle = .overFullScreen
        present(profileImageVC, animated: true, completion: nil)
    }
    
    func catchUserNameChangeNotification(notification: Notification) -> Void {
        
        guard let name = notification.userInfo!["name"] as? String else { return }
        myPageTableViewHeaderView.userNameLabel.text = name
    }
    
    func catchProfileChangeNotification(notification: Notification) -> Void {
        self.clearSDImageCacheMemoryAndDisk()
        setProfileSDImage()
    }
    
    func catchBackgroundChangeNotification(notification: Notification) -> Void {
        self.clearSDImageCacheMemoryAndDisk()
        setBackgroundSDImage()
    }
}

