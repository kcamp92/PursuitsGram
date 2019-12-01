//
//  ProfileEditViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit
import Photos

class ProfileEditViewController: UIViewController {
    
    var settingFromLogin = false
    var image = UIImage(){
        didSet {
            self.imageView.image = image
        }
    }

    var imageURL: URL? = nil
    
//MARK:- UI Objects
    
    lazy var imageView: UIImageView = {
         let iv = UIImageView()
         iv.backgroundColor = #colorLiteral(red: 0.8844706416, green: 0.9299592376, blue: 0.9251627922, alpha: 1)
         iv.image = UIImage(systemName: "person.crop.circle")
         return iv
     }()
     
    lazy var addImage: UIButton = {
          let button = UIButton()
          button.setTitle("Add Image", for: .normal)
          button.setTitleColor(.white, for: .normal)
          button.titleLabel?.font = UIFont(name: "Marker Felt", size: 14)
          button.backgroundColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
          button.layer.cornerRadius = 5
          button.showsTouchWhenHighlighted = true
          button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
          return button
      }()
    
    lazy var userNameTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Enter User Name"
         textField.font = UIFont(name: "Marker Felt", size: 16)
         textField.backgroundColor = .white
         textField.textAlignment = .left
         textField.borderStyle = .bezel
         textField.layer.cornerRadius = 5
         textField.autocorrectionType = .no
         textField.delegate = self
         textField.textColor = .darkGray
         return textField
     }()



    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 14)
        button.backgroundColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
       }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "System", size: 14)
        button.backgroundColor = .init(white: 0.2, alpha: 0.9)
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
//MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        addSubviews()
        setupConstraints()

     
    }
    
//MARK: -Objc Methods
    
    @objc private func savePressed(){
        
           guard let userName = userNameTextField.text, let imageURL = imageURL else {
             showAlert(with: "Failure", and: "Profile Not Updated")
               return
           }
        FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageURL) { (result) in
            switch result {
            case .success():
                FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageURL) { [weak self] (nextResult) in
                    switch nextResult {
                    case .success():
                        self?.handleNavAwayFromVC()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func addImagePressed(){
        switch PHPhotoLibrary.authorizationStatus(){
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentPhotoPickerController()
                case .denied:
                    print("Denied photo library permissions")
                default:
                    print("no status")
                }
            })
        default: presentPhotoPickerController()
        }
    }
    
    @objc private func cancelPressed(){
           dismiss(animated: true, completion: nil)
       }
 
//MARK: -Private Methods
    
    private func showAlert(with title: String, and message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentPhotoPickerController(){
        DispatchQueue.main.async {
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    
    private func handleNavAwayFromVC(){
        
        if settingFromLogin {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else {
                    print("cant transition")
                    return
            }
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = PursuitTabBar()
            }, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
  
//MARK: -UI Constraints

    func addSubviews(){
        view.addSubview(imageView)
        view.addSubview(addImage)
        view.addSubview(userNameTextField)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
    }
    
    func setupConstraints(){
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.view.bounds.width / 2).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2).isActive = true
            
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userNameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
    
       
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addImage.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50).isActive = true
        addImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addImage.widthAnchor.constraint(equalToConstant: view.bounds.width / 3).isActive = true
        
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3).isActive = true
          
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3).isActive = true
        
    }
    
}


//MARK: - Extensions

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.image = image
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            return
        }
        FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result {
            case .success(let url):
                self?.imageURL = url
            case .failure(let error):
                print(error)
            }
            
        })
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
