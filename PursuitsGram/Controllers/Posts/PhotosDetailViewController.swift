//
//  PhotosDetailViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/26/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

class PhotosDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- UI Objects
            
    //MARK: - Lifecycle Methods
            
    //MARK: -Objc Methods
    //MARK: -Private methods
    //MARK: -UI Constraints
    //MARK: - Extensions
            
}
/*
 
 

 import UIKit

 class PostDetailViewController: UIViewController {
     
     var post: Post!
     
     var comments = [Comment]() {
         didSet {
             DispatchQueue.main.async {
                 self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
             }
         }
     }
     
     lazy var tableView: UITableView = {
         let tableView = UITableView()
         tableView.backgroundColor = .lightGray
         //MARK: TODO - set up custom cells
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.postHeaderCell.rawValue)
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.commentCell.rawValue)
         return tableView
     }()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         setupTableView()
         setupNavigation()
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         loadComments()
     }
     
     @objc private func addButtonPressed() {
         let alertController = UIAlertController(title: "Add new comment", message: nil, preferredStyle: .alert)
         alertController.addTextField(configurationHandler: nil)
         
         let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak alertController, weak self] _ in
             guard let commentText = alertController?.textFields?[0].text, commentText != "", let title = self?.post.title, let postID = self?.post.id, let userID = FirebaseAuthService.manager.currentUser?.uid else {return}
             
             let comment = Comment(title: title, body: commentText, creatorID: userID, postID: postID)
             
             FirestoreService.manager.createComment(comment: comment) { (result) in
                 switch result {
                 case .success(_):
                     DispatchQueue.global(qos: .userInitiated).async {
                         self?.loadComments()
                     }
                 case .failure(let error):
                     print("error: \(error)")
                 }
             }
         }
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         
         alertController.addAction(submitAction)
         alertController.addAction(cancelAction)
         
         present(alertController, animated: true)
     }
     
     private func loadComments(){
         FirestoreService.manager.getComments(forPostID: post.id) { [weak self] (result) in
             switch result {
             case .success(let comments):
                 self?.comments = comments
             case .failure(let error):
                 print("couldn't get comments for \(self?.post.id ?? ""): \(error)")
             }
         }
     }
     
     private func setupNavigation() {
         self.title = post.title
         self.navigationItem.rightBarButtonItem =
             UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(addButtonPressed))
     }
     
     private func setupTableView() {
         view.addSubview(tableView)
         tableView.backgroundColor = .lightGray
         tableView.dataSource = self
         
         tableView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
     }
 }

 extension PostDetailViewController: UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
         return 2
     }
     
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         switch section {
         case 0:
             return "Post"
         case 1:
             return "Comments"
         default:
             return nil
         }
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         switch section {
         case 0:
             return 1
         case 1:
             return comments.count
         default:
             return 0
         }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         switch indexPath.section {
         case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.postHeaderCell.rawValue, for: indexPath)
             cell.textLabel?.text = post.title
             cell.detailTextLabel?.text = post.body
             return cell
         case 1:
             
             let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.commentCell.rawValue, for: indexPath)
             let comment = comments[indexPath.row]
             cell.textLabel?.text = comment.body
             //MARK: TODO - use custom cell
             return cell
         default:
             return UITableViewCell()
         }
     }
 }

 extension PostDetailViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         switch indexPath.row {
         case 0:
             return 100
         case 1:
             return 70
         default:
             return 0
         }
     }
 }

 
 
 
 */










/*
import UIKit

class PhotoDetailViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .init(white: 0.1, alpha: 0.8)
        setUpViews()
        setDateLabel()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    
    //MARK: Properties
    
    var post: Post! {
        didSet {
            view.layoutSubviews()
            DispatchQueue.main.async {
                if let photoUrl = self.post?.photoUrl {
                    self.getSelectedImage(photoUrl: photoUrl)
                }
            }
        }
    }
    
    
    //MARK: Private Methods
    private func getSelectedImage(photoUrl: String){
        FirebaseStorageService.uploadManager.getImage(url: photoUrl) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let firebaseImage):
                self.detailImage.image = firebaseImage
                self.setUserName()
            }
        }
    }
    
    private func setUserName(){
        FirestoreService.manager.getUserFromPost(creatorID: self.post.creatorID) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let user):
                self.nameLabel.text = user.userName
                self.setProfileImage(user: user)
            }
        }
    }
    
    private func setProfileImage(user: AppUser) {
        FirebaseStorageService.profileManager.getUserImage(photoUrl: URL(string: user.photoURL!)!) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let image):
                self.profileImage.image = image
            }
        }
    }
    
    private func setDateLabel(){
        if let date = post.dateCreated {
         let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium

            self.dateLabel.text = formatter.string(from: date as Date)
        }
    }
    
    
    
    
    //MARK: UI Elements
    
    lazy var detailImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 0
        return image
    }()
    
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 0.2, alpha: 0.9)
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        return image
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = "Posted: mm/dd/yyyy"
        label.textAlignment = .left
        return label
    }()
    
    
    //MARK: Constraint Methods
    func setUpViews(){
        setImageConstraints()
        setInfoViewConstraints()
        setProfileImageConstraints()
        setNameConstraints()
        setDateConstraints()
    }
    
    
    func setImageConstraints() {
        view.addSubview(detailImage)
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            detailImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailImage.widthAnchor.constraint(equalToConstant: detailImage.frame.width),
            detailImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2)])
    }
    
    func setProfileImageConstraints() {
        infoView.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20),
            profileImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70)])
    }
    
    func setNameConstraints() {
        infoView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    func setDateConstraints() {
        infoView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            dateLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)])
    }
    
    
    func setInfoViewConstraints(){
        view.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: detailImage.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: detailImage.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: detailImage.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 100)])
    }
    
}

*/
