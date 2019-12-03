//
//  UploadViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit
import Photos

class UploadViewController: UIViewController {
    
    var image = UIImage() {
        didSet {
            self.uploadImageView.image = image
        }
    }
    
    var imageURL: String? = nil

    //MARK:- UI Objects
            
     lazy var uploadImageLabel: UILabel = {
     let label = UILabel()
     label.numberOfLines = 0
     let attributedTitle = NSMutableAttributedString(string: "New Post", attributes: [NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 60)!, NSAttributedString.Key.foregroundColor: UIColor.white])
     label.attributedText = attributedTitle
     label.backgroundColor = .clear
     label.textAlignment = .center
     return label
 }()
     
     lazy var uploadImageView: UIImageView = {
     let image = UIImageView()
     //image.image = UIImage(named: "noImage")
     image.backgroundColor = .lightGray
     image.contentMode = .scaleAspectFill
     return image
 }()
     
    lazy var addButton: UIButton = {
    let button = UIButton()
    button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
    button.backgroundColor = .init(white: 0.2, alpha: 0.9)
    button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    button.showsTouchWhenHighlighted = true
    return button
     }()
 
     lazy var uploadButton: UIButton = {
     let button = UIButton()
     button.setTitle("Upload", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.titleLabel?.font = button.titleLabel?.font.withSize(34)
     button.backgroundColor = .init(white: 0.2, alpha: 0.9)
     button.showsTouchWhenHighlighted = true
     button.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
     return button
 }()
 

 
 
    //MARK: - Lifecycle Methods
            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupConstraints()

        // Do any additional setup after loading the view.
    }
    
    //MARK: -Objc Methods
    
    
     @objc func addTapped() {
         switch PHPhotoLibrary.authorizationStatus() {
         case .notDetermined, .denied, .restricted:
             PHPhotoLibrary.requestAuthorization({[weak self] status in
                 switch status {
                 case .authorized:
                     self?.presentPhotoPickerController()
                 case .denied:
                   
                     print("Permission Denied")
                 default:
             
                     print("No")
                 }
             })
         default:
             presentPhotoPickerController()
         }
     }
     
     @objc func uploadTapped() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
       guard let photoUrl = imageURL else {return}
        let newPost = Post(title: "", body: "", creatorID: user.uid, dateCreated: nil, photoUrl: photoUrl)
        FirestoreService.manager.createPost(post: newPost) { (result) in
       // createPost(post: Post(from: photoUrl, id: user.uid)) { (result) in
         switch result {
            case .failure(let error):
               self.showAlert(with: "Couldn't add post", and: "Error: \(error)")
            case .success:
               self.showAlert(with: "Success", and: "Post created!")
                self.uploadImageView.image = nil

             }
       }
     }

  
    
    //MARK: -Private methods

private func presentPhotoPickerController() {
       DispatchQueue.main.async{
           let imagePickerViewController = UIImagePickerController()
           imagePickerViewController.delegate = self
           imagePickerViewController.sourceType = .photoLibrary
           imagePickerViewController.allowsEditing = true
        imagePickerViewController.mediaTypes = ["public.image"]
           self.present(imagePickerViewController, animated: true, completion: nil)
       }
   }
   
    func showAlert(with title: String, and message: String) {
       let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
       present(alertVC, animated: true, completion: nil)
   }
   
 
    //MARK: -UI Constraints
    
    private func setupConstraints(){
    
            view.addSubview(uploadImageLabel)
            uploadImageLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            uploadImageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            uploadImageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            uploadImageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)])
      
            view.addSubview(uploadImageView)
            uploadImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            uploadImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 100),
            uploadImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 300),
            uploadImageView.heightAnchor.constraint(equalToConstant: 300)])
   
            view.addSubview(uploadButton)
            uploadButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            uploadButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uploadButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 70)])
      
            view.addSubview(addButton)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: uploadImageView.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: uploadImageView.trailingAnchor,constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            addButton.widthAnchor.constraint(equalToConstant: 40)])
    }
}
    //MARK: - Extensions

    extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.editedImage] as? UIImage else {
                //MARK: TODO - handle couldn't get image :(
                showAlert(with: "Error", and: "Couldn't get image")
                return
            }
            self.image = image
            
            guard let imageData = image.jpegData(compressionQuality: 0.4) else {
                //MARK: TODO - gracefully fail out without interrupting UX
                showAlert(with: "Error", and: "could not compress image")
                return
            }
            
            FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
                switch result{
                case .success(let url):
                    self?.imageURL = "\(url)"
                    
                case .failure(let error):
                    print(error)
                }
            })
            dismiss(animated: true, completion: nil)
        }
    }




