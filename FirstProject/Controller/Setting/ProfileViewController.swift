//
//  ProfileViewController.swift
//  TheWay
//
//  Created by Suzy Park on 2018. 6. 20..
//  Copyright © 2018년 Hexcon. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseFirestore

enum ImagePickerType {
    case Profile
    case Background
}

class ProfileViewController: UITableViewController {

    let profileHeaderView: ProfileHeaderView = {
        let v = ProfileHeaderView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    let profileImagePicker = UIImagePickerController()
    
    // 이미지 피커 타입
    var imagePickerType : ImagePickerType = .Profile
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.contentGray
        label.text = ""
        return label
    }()
    
    func clearSDImageCacheMemoryAndDisk() {
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
    }
    
    deinit {
        self.printDeinitMessage()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Life Cycle
extension ProfileViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // email 보여주기
        emailLabel.text = User.shared.email
        // MARK: - tabelView Setting
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.backgroundGray
        self.tableView.separatorStyle = .none
        
        setupNavi()
        setupImagePicker()
        setupProfileImageViewGesture()
        setupTabelViewHeaderView()
        setupHeaderViewSubViews()
        setupNotificationObserver()
        setProfileSDImage()
        setBackgroundSDImage()
    }
}

// MARK: - Setup Navi
extension ProfileViewController {
    
    func setupNavi() {
        let leftBarButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        let leftBarButton = UIBarButtonItem(image: leftBarButtonImage,
                                            style: .done,
                                            target: self,
                                            action: #selector(leftBarButtonTapped))
        
        navigationItem.title = "Profile"
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
}

// MARK: - Table View
extension ProfileViewController {
    
    func setupTabelViewHeaderView() {
        let headerViewWidth = self.view.frame.width
        let headerViewHeight = self.view.frame.height / 2
        profileHeaderView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: headerViewWidth,
                                         height: headerViewHeight)
        self.tableView.tableHeaderView = profileHeaderView
    }
    
    func setupHeaderViewSubViews() {
        
        let profileHeaderView              = self.profileHeaderView
        let backgroundImageView            = profileHeaderView.backgroundImageView
        let profileImageView               = profileHeaderView.profileImageView
        let usernameButton                 = profileHeaderView.userNameButton
        let profileCameraBackgroundView    = profileHeaderView.profileCameraBackgroundView
        let profileCameraImageView         = profileHeaderView.profileCameraImageView
        let backgroundCameraBackgroundView = profileHeaderView.backgroundCameraBackgroundView
        let backgroundCameraImageView      = profileHeaderView.backgroundCameraImageView
        let backgroundGuestureView         = profileHeaderView.backgroundGuestureView
        let profileGuestureView            = profileHeaderView.profileGuestureView
        
        let profileWidth                   = self.view.frame.width * 0.3
        let cameraBackgroundWidth          = self.view.frame.width * 0.08
        let cameraWidth                    = self.view.frame.width * 0.05
        let backgroundImageHeight          = self.view.frame.height / 3
        
        backgroundImageView.anchor(top: profileHeaderView.topAnchor,
                                   leading: profileHeaderView.leadingAnchor,
                                   bottom: nil,
                                   trailing: profileHeaderView.trailingAnchor,
                                   size: .init(width: 0, height: backgroundImageHeight))
        
        backgroundCameraBackgroundView.anchor(top: nil,
                                              leading: nil,
                                              bottom: backgroundImageView.bottomAnchor,
                                              trailing: backgroundImageView.trailingAnchor,
                                              padding: .init(top: 0, left: 0, bottom: 16, right: 16),
                                              size: .init(width: cameraBackgroundWidth, height: cameraBackgroundWidth))
        
        backgroundCameraImageView.anchor(top: nil,
                                         leading: nil,
                                         bottom: nil,
                                         trailing: nil,
                                         centerX: backgroundCameraBackgroundView.centerXAnchor,
                                         centerY: backgroundCameraBackgroundView.centerYAnchor,
                                         size: .init(width: cameraWidth, height: cameraWidth))
        
        backgroundGuestureView.anchor(top: backgroundImageView.topAnchor,
                                      leading: backgroundImageView.leadingAnchor,
                                      bottom: backgroundImageView.bottomAnchor,
                                      trailing: backgroundImageView.trailingAnchor)
        
        profileImageView.anchor(top: nil,
                                leading: nil,
                                bottom: nil,
                                trailing: nil,
                                centerX: profileHeaderView.centerXAnchor,
                                centerY: backgroundImageView.bottomAnchor,
                                size: .init(width: profileWidth, height: profileWidth))
        
        profileCameraBackgroundView.anchor(top: nil,
                                           leading: nil,
                                           bottom: profileImageView.bottomAnchor,
                                           trailing: profileImageView.trailingAnchor,
                                           size: .init(width: cameraBackgroundWidth, height: cameraBackgroundWidth))
        
        profileCameraImageView.anchor(top: nil,
                                      leading: nil,
                                      bottom: nil,
                                      trailing: nil,
                                      centerX: profileCameraBackgroundView.centerXAnchor,
                                      centerY: profileCameraBackgroundView.centerYAnchor,
                                      size: .init(width: cameraWidth, height: cameraWidth))
        
        profileGuestureView.anchor(top: profileImageView.topAnchor,
                                   leading: profileImageView.leadingAnchor,
                                   bottom: profileImageView.bottomAnchor,
                                   trailing: profileCameraBackgroundView.trailingAnchor)
        
        usernameButton.anchor(top: profileImageView.bottomAnchor,
                              leading: nil,
                              bottom: nil,
                              trailing: nil,
                              centerX: profileHeaderView.centerXAnchor,
                              padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        profileImageView.layer.cornerRadius = profileWidth / 2
        profileImageView.clipsToBounds = true
        
        profileCameraBackgroundView.layer.cornerRadius = cameraBackgroundWidth / 2
        profileCameraBackgroundView.clipsToBounds = true
        
        backgroundCameraBackgroundView.layer.cornerRadius = cameraBackgroundWidth / 2
        backgroundCameraBackgroundView.clipsToBounds = true
        
        usernameButton.addTarget(self, action: #selector(userNameButtonTapped), for: .touchUpInside)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PERSONAL INFO"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingTabelViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SettingTabelViewCell")
        }
        
        cell?.selectionStyle = .none
        cell?.textLabel?.text = "E-mail"
        cell?.addSubview(emailLabel)
        emailLabel.anchor(top: nil,
                          leading: nil,
                          bottom: nil,
                          trailing: cell?.trailingAnchor,
                          centerY: cell?.centerYAnchor,
                          padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK:- Setup Image Picker
extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func setupImagePicker() {
        profileImagePicker.delegate = self
        profileImagePicker.allowsEditing = true
        profileImagePicker.modalPresentationStyle = .popover
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        Indicator.shared.show()
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage.resize(image: editedImage, targetSize: CGSize(width: 1920, height: 1080))
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage.resize(image: originalImage, targetSize: CGSize(width: 1920, height: 1080))
        }
        
        if let selectedImage = selectedImage {
            
            switch imagePickerType {
                
            case .Profile :
                self.profileHeaderView.profileImageView.image = selectedImage
                if let profileImage = self.profileHeaderView.profileImageView.image, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                    Firebase.addProfileImage(User.shared.uid, profileImage: imageData, completion: {
                        self.setProfileSDImage()
                        NotificationCenter.default.post(name: .profileImageViewImageDidChanged, object: nil)
                        Indicator.shared.hide()
                    })
                }
                break
                
            case .Background :
                self.profileHeaderView.backgroundImageView.image = selectedImage
                if let backgroundImage = self.profileHeaderView.backgroundImageView.image, let imageData = UIImageJPEGRepresentation(backgroundImage, 0.1) {
                    Firebase.addBackgroundImage(User.shared.uid, backgroundImage: imageData, completion: {
                        self.setBackgroundSDImage()
                        NotificationCenter.default.post(name: .backgroundImageViewImageDidChanged, object: nil)
                        Indicator.shared.hide()
                    })
                }
                break
            }
        } // if let selectedImage = selectedImage End
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup Notification Observer
extension ProfileViewController {
    func setupNotificationObserver() {
        
        NotificationCenter.default.addObserver(forName: .userNameButtonTextDidChanged,
                                               object: nil,
                                               queue: nil,
                                               using: catchUserNameChangeNotification)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(whenProfileChangeNotify),
                                               name: .profileImageViewImageDidChanged,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(whenBackgroundChangeNotify),
                                               name: .backgroundImageViewImageDidChanged,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(whenProfileIntializeNotify),
                                               name: .profileImageViewImageDidInitialize,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(whenBackgroundIntializeNotify),
                                               name: .backgroundImageViewImageDidInitialize,
                                               object: nil)
    }
}


// MARK: - Write profile & background Image: sd_setImage
extension ProfileViewController {
    
    func setProfileSDImage() {
        let profileImage = StorageRef.profileImageRef.child(User.shared.uid)
        self.profileHeaderView.profileImageView.sd_setImage(with: profileImage, placeholderImage: UIImage.profilePlaceHoderImage)
    }
    
    func setBackgroundSDImage() {
        let backgroundImage = StorageRef.backgroundImageRef.child(User.shared.uid)
        self.profileHeaderView.backgroundImageView.sd_setImage(with: backgroundImage, placeholderImage: UIImage.backgroundPlaceHoderImage)
    }
}


// MARK: - Profile Image View Guesture
extension ProfileViewController {
    
    func setupProfileImageViewGesture() {
        
        let profileImageGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(ProfileViewController.profileImageTapped(gesture:)))
        let backgroundImageGesture = UITapGestureRecognizer(target: self,
                                                            action: #selector(ProfileViewController.backgroundImageTapped(gesture:)))
        
        profileHeaderView.profileGuestureView.addGestureRecognizer(profileImageGesture)
        profileHeaderView.backgroundGuestureView.addGestureRecognizer(backgroundImageGesture)
        
        profileHeaderView.profileGuestureView.isUserInteractionEnabled = true
        profileHeaderView.backgroundGuestureView.isUserInteractionEnabled = true
    }
    
    @objc func profileImageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            
            imagePickerType = .Profile
            
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let librarySelect = UIAlertAction.init(title: "Photo Library", style: .default) { _ in
                self.profileImagePicker.sourceType = .photoLibrary
                self.present(self.profileImagePicker, animated: true, completion: nil)
                self.clearSDImageCacheMemoryAndDisk()
            }
            
            let basicImageSelect = UIAlertAction.init(title: "Basic Profile", style: .default) { _ in
                Firebase.initializeProfileImage(User.shared.uid, completion: {
                    self.clearSDImageCacheMemoryAndDisk()
                    self.setProfileSDImage()
                    NotificationCenter.default.post(name: .profileImageViewImageDidInitialize, object: nil)
                    
                })
            }
            
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(librarySelect)
            alert.addAction(basicImageSelect)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func backgroundImageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            
            imagePickerType = .Background
            
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let librarySelect = UIAlertAction.init(title: "Photo Library", style: .default) { _ in
                self.profileImagePicker.sourceType = .photoLibrary
                self.present(self.profileImagePicker, animated: true, completion: nil)
                self.clearSDImageCacheMemoryAndDisk()
            }
            let basicImageSelect = UIAlertAction.init(title: "Basic Profile", style: .default) { _ in
                Firebase.initializeBackgroundImage(User.shared.uid, completion: {
                    self.clearSDImageCacheMemoryAndDisk()
                    self.setBackgroundSDImage()
                    NotificationCenter.default.post(name: .backgroundImageViewImageDidInitialize, object: nil)
                })
            }
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(librarySelect)
            alert.addAction(basicImageSelect)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Action
extension ProfileViewController {
    
    @objc func userNameButtonTapped() {
        let userNameChangeVC = UserNameChangeViewController()
        navigationController?.pushViewController(userNameChangeVC, animated: true)
    }
    
    @objc func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func catchUserNameChangeNotification(notification: Notification) -> Void {
        
        guard let name = notification.userInfo!["name"] as? String else { return }
        
        let nameAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : UIColor.titleBlack,
                                                             .font            : UIFont.systemFont(ofSize: 17)]
        let stringToDisplay = name + " "
        let nameAttributedString = NSMutableAttributedString(string: stringToDisplay, attributes: nameAttributes)
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "pencil")
        attachment.bounds = CGRect(x: 0, y: 2, width: 13, height: 13)
        nameAttributedString.append(NSAttributedString(attachment: attachment))
        
        profileHeaderView.userNameButton.setAttributedTitle(nameAttributedString, for: .normal)
    }
    
    @objc func whenProfileChangeNotify() {
        print("ProfileImage change Notify")
    }
    
    @objc func whenBackgroundChangeNotify() {
        print("BackgroundImage change Notify")
    }
    
    @objc func whenProfileIntializeNotify() {
        print("ProfileImage initialize Notify")
        self.profileHeaderView.profileImageView.image = UIImage.profilePlaceHoderImage
    }
    
    @objc func whenBackgroundIntializeNotify() {
        print("BackgroundImage initialize Notify")
        self.profileHeaderView.backgroundImageView.image = UIImage.backgroundPlaceHoderImage
    }
}
