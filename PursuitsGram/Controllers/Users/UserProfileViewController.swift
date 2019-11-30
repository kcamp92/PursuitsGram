//
//  UserProfileViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit
import FirebaseAuth

private let cellIdentifier = "postCell"
class UserProfileViewController: UIViewController {
    
    var user: AppUser!
    var isCurrentUser = false
    
    var posts = [Post]() {
        didSet {
            postsCollectionView.reloadData()
        }
    }
    var imageURL: String? = nil
    var postsCount = 0 {
        didSet {
            totalPostAmount.text = "\(postsCount) \n Posts"
        }
    }

//MARK:- UI Objects
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Profile"
        label.font = UIFont(name: "Marker Felt", size: 42)
        label.textColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    lazy var profileImage: UIImageView = {
           let image = UIImageView()
           image.backgroundColor = .darkGray
           image.image = UIImage(systemName: "person.fill")
           image.tintColor = .white
           return image
       }()
    
    lazy var userDisplayName: UILabel = {
           let label = UILabel()
           label.textAlignment = .left
           label.text = "Hello\(user.userName)"
           label.font = UIFont(name: "Marker Felt", size: 22)
           label.textColor = .white
           label.backgroundColor = .clear
           return label
       }()
    
    lazy var editButton: UIButton = {
          let button = UIButton()
          button.setTitle("Edit Profile", for: .normal)
          button.tintColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
          button.backgroundColor = .init(white: 0.4, alpha: 0.8)
          button.addTarget(self, action: #selector(editProButt), for: .touchUpInside)
          return button
      }()
    
      lazy var totalPostAmount: UILabel = {
          let label = UILabel()
          label.text = "0 \n Posts"
          label.font = UIFont(name: "Marker Felt", size: 16)
          label.numberOfLines = 0
          label.textAlignment = .center
          label.textColor = .white
          return label
      }()
    lazy var postsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(postCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.backgroundColor = .init(white: 0.2, alpha: 0.9)
        cv.delegate = self
        cv.dataSource = self
        return cv
        }()
    
    lazy var logOutButton: UIButton = {
      let button = UIButton()
          button.titleLabel?.text = "Log Out"
          button.backgroundColor = .clear
          button.titleLabel?.textColor = .white
          button.setTitle("Log Out", for: .normal)
          button.showsTouchWhenHighlighted = true
          button.addTarget(self, action: #selector(userLogOut), for: .touchUpInside)
      return button
      }()
      
      
//MARK: - Lifecycle Methods
        override func viewDidLoad() {
            super.viewDidLoad()
            addSubViews()
            setupConstraints()
        }
        
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         getPostsForUser()
         setUpUserName()
     }


        
//MARK: -Objc Methods
 
@objc private func editProButt(){
    let editVC = ProfileEditViewController()
    editVC.modalPresentationStyle = .fullScreen
    present(editVC, animated: true, completion: nil)
}
    
//     @objc private func editProfile() {
//         navigationController?.pushViewController(ProfileEditViewController(), animated: true)
//     }
//

  @objc func userLogOut(){
        let alert = UIAlertController(title: "Log Out", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Yes", style: .destructive, handler: .some({ (action) in
            DispatchQueue.main.async {
                FirebaseAuthService.manager.logoutUser { (result) in
                }
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                    else{
                        return
                }
                UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromTop, animations: {
                    window.rootViewController = LoginViewController()
                }, completion: nil)
            }
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
        }
    
//MARK: -Private methods
    
    private func getPostsForUser(){
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in FirestoreService.manager.getPosts(forUserID: self?.user.uid ?? "") { (result) in
                switch result {
                case .success(let FBposts):
                    self?.posts = FBposts
                case .failure(let error):
                    print(":(\(error)")
                }
            }
        }
        
    }
    /*
     private func getUserPosts() {
         if let userUID =  FirebaseAuthService.manager.currentUser?.uid {
             FirestoreService.manager.getPosts(forUserID: userUID, completion: { (result) in
             switch result {
             case .failure(let error):
                 print(error)
             case .success(let postsFromFirebase):
                 DispatchQueue.main.async {
                     self.posts = postsFromFirebase
                 }
             }
         }
         )}
     }
     
      */
    
    private func setUpUserName(){
           if let displayName =
               FirebaseAuthService.manager.currentUser?.displayName {
               userDisplayName.text = displayName
           }
       }
    
    /*   private func setupNavigation() {
         self.title = "Profile"
         if isCurrentUser {
             self.navigationItem.rightBarButtonItem =
                 UIBarButtonItem(image: UIImage(systemName: "pencil.circle"), style: .plain, target: self, action: #selector(editProfile))
         }
     }
     
    
     */
    
    private func setUpProfileImage(){
        if let imageUrl = FirebaseAuthService.manager.currentUser?.photoURL{
            FirebaseStorageService.manager.getUserImage(photoURL: imageUrl) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.profileImage.image = image
                }
            }
        }
    }
    
    private func getPostAmount(){
        if let userUID = FirebaseAuthService.manager.currentUser?.uid {
            DispatchQueue.global(qos: .default).async {
                FirestoreService.manager.getPosts(forUserID: userUID) { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let posts):
                        if posts.count > self.postsCount {
                            self.getPostsForUser()
                        }
                        self.postsCount = posts.count
                    }
                }
            }
        }
    }
    
//MARK: -UI Constraints
    
    private func addSubViews(){
        view.addSubview(logoLabel)
        view.addSubview(profileImage)
        view.addSubview(userDisplayName)
        view.addSubview(editButton)
        view.addSubview(totalPostAmount)
        view.addSubview(postsCollectionView)
        view.addSubview(logOutButton)
    }
    
    private func setupConstraints(){
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        logoLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        logoLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
             
        
        userDisplayName.translatesAutoresizingMaskIntoConstraints = false
        userDisplayName.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 10).isActive = true
        userDisplayName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 16).isActive = true
        userDisplayName.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        userDisplayName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 0).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.topAnchor.constraint(equalTo: userDisplayName.bottomAnchor, constant: 5).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
                
        
        totalPostAmount.translatesAutoresizingMaskIntoConstraints = false
        
        
        postsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        postsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        postsCollectionView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20).isActive = true
        postsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true

              }
              
    }
    
  
    /*
     private func setUpView(){
            setUserName()
            setProfileImage()
            constrainLogOutButton()
        }
*/


//MARK: -CollectionView Extensions

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! postCell
        cell.backgroundColor = UIColor.white
        let post = posts[indexPath.row]
        DispatchQueue.main.async {
            if let photoUrl = post.imagePhoto {
                FirebaseStorageService.manager.getImage(url: photoUrl) {(result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let fbImage):
                        cell.postImages.image = fbImage
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 140, height: 140)
           
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 0
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let postSelected = posts[indexPath.row]
         let detailVC = PhotosDetailViewController()
       //  detailVC.post = postSelected
         present(detailVC, animated: true, completion: nil)
     }
}

/*import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.1, alpha: 1)
    
        setUpView()
        getUserPosts()
        
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        getPostCount()
    }
   
    //MARK: Constraint Methods
    
    private func setUpView(){
        constrainProfileImage()
        constrainStats()
        constrainUserName()
        constrainEditButton()
        constrainCollectionView()
        setUserName()
        setProfileImage()
        constrainLogOutButton()
    }
    
    
    
    
    
    

*/
