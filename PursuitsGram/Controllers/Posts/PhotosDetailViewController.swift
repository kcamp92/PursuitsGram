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
                if let photoUrl = self.post?.imagePhoto {
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
        
        }
            
    //MARK: -Objc Methods
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
                  self.setProfileImage(user: user)
              }
          }
      }
      
      private func setProfileImage(user: AppUser) {
        FirebaseStorageService.manager.getUserImage(photoURL: URL(string: user.photoURL!)!) { (result) in
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

              self.dateCreatedLabel.text = formatter.string(from: date as Date)
          }
      }
      
      
    //MARK: -UI Constraints
    //MARK: -Extensions
            
}
