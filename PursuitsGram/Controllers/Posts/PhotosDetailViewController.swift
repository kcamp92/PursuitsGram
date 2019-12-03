//
//  PhotosDetailViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/26/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

class PhotosDetailViewController: UIViewController {
    
    
    var post: Post! {
        didSet {
            view.layoutSubviews()
            DispatchQueue.main.async {
                if let photoUrl = self.post?.photoUrl{
                    self.getSelectedPhoto(photoUrl: photoUrl)
                }
            }
        }
    }
 
    //MARK:- UI Objects
    
      lazy var detailImage: UIImageView = {
          let image = UIImageView()
          image.backgroundColor = .clear
          image.contentMode = .scaleAspectFill
          image.layer.borderWidth = 0
          return image
      }()
      
      lazy var profileImage: UIImageView = {
          let image = UIImageView()
          image.backgroundColor = .clear
          image.image = UIImage(systemName: "person")
          image.tintColor = .white
          return image
      }()
     
     lazy var imageDetailLabel: UILabel = {
             let label = UILabel()
             label.textColor = .white
             label.backgroundColor = .clear
             label.text = "Image Detail"
             label.textAlignment = .left
             return label
         }()
         
     
      lazy var subNameLabel: UILabel = {
          let label = UILabel()
          label.textColor = .white
          label.backgroundColor = .clear
          label.text = "Submitted By:"
          label.textAlignment = .left
          return label
      }()
      
      lazy var dateCreatedLabel: UILabel = {
          let label = UILabel()
          label.textColor = .white
          label.backgroundColor = .clear
          label.text = "Posted: mm/dd/yyyy"
          label.textAlignment = .left
          return label
      }()
     

    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        dateLabelSetup()
        
        }
       
   
    //MARK: -Private Methods
    
    private func getSelectedPhoto(photoUrl: String){
        FirebaseStorageService.manager.getImage(url: photoUrl) { (result) in
              switch result {
              case .failure(let error):
                  print(error)
              case .success(let firebaseImage):
                  self.detailImage.image = firebaseImage
                  self.getUserName()
              }
          }
      }
      
      private func getUserName(){
        FirestoreService.manager.getUserFromPost(creatorID: self.post.creatorID) { (result) in
              switch result {
              case .failure(let error):
                  print(error)
              case .success(let user):
                  self.subNameLabel.text = user.userName
                  self.getProfileImage(user: user)
              }
          }
      }
      
      private func getProfileImage(user: AppUser) {
        FirebaseStorageService.manager.getUserImage(photoURL: URL(string: user.photoURL!)!) { (result) in
              switch result {
              case .failure(let error):
                  print(error)
              case .success(let image):
                  self.profileImage.image = image
              }
          }
      }
      
      private func dateLabelSetup(){
          if let date = post.dateCreated {
           let formatter = DateFormatter()
              formatter.dateStyle = .long
              formatter.timeStyle = .medium

              self.dateCreatedLabel.text = formatter.string(from: date as Date)
          }
      }
      
      
    //MARK: -UI Constraints
    func addSubviews(){
        view.addSubview(detailImage)
        view.addSubview(profileImage)
        view.addSubview(imageDetailLabel)
        view.addSubview(subNameLabel)
        view.addSubview(dateCreatedLabel)
       
    }
    func setupConstraints() {
            
        imageDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        imageDetailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageDetailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageDetailLabel.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageDetailLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true

               
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        detailImage.topAnchor.constraint(equalTo: imageDetailLabel.bottomAnchor, constant: 50).isActive = true
        detailImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
       // detailImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        detailImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
 
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        subNameLabel.translatesAutoresizingMaskIntoConstraints = false
        subNameLabel.topAnchor.constraint(equalTo: detailImage.bottomAnchor, constant: 20).isActive = true
        subNameLabel.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        subNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        subNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        dateCreatedLabel.translatesAutoresizingMaskIntoConstraints = false
        dateCreatedLabel.topAnchor.constraint(equalTo: subNameLabel.bottomAnchor, constant: 30).isActive = true
        dateCreatedLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10).isActive = true
        dateCreatedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dateCreatedLabel.heightAnchor.constraint(equalTo: subNameLabel.heightAnchor).isActive = true
    }
  
}

