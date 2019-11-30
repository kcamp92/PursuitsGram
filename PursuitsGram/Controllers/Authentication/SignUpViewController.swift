//
//  SignUpViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
//MARK:- UI Objects
    
    lazy var headerLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = "SuiteGram: Create Account"
    label.font = UIFont(name: "Marker Felt", size: 38)
    label.textColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
    label.backgroundColor = .clear
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    return label
    }()
  
    lazy var emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter Email"
    textField.font = UIFont(name: "Marker Felt", size: 16)
    textField.backgroundColor = .white
    textField.borderStyle = .bezel
    textField.autocorrectionType = .no
    textField.addTarget(self, action: #selector(fieldsValidated), for: .editingChanged)
    return textField
    }()
    
    lazy var passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter Password"
    textField.font = UIFont(name: "Marker Felt", size: 16)
    textField.backgroundColor = .white
    textField.borderStyle = .bezel
    textField.autocorrectionType = .no
    textField.isSecureTextEntry = true
    textField.addTarget(self, action: #selector(fieldsValidated), for: .editingChanged)
    return textField
    }()
    
    lazy var createButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Create", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Marker Felt", size: 18)
    button.backgroundColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(attemptSignUp), for: .touchUpInside)
    button.isEnabled = false
    return button
    }()
    
//MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupHeaderLabel()
        setupCreateStackView()
        // Do any additional setup after loading the view.
    }
    
//MARK: -Objc Methods
    
    @objc func fieldsValidated(){
        guard emailTextField.hasText, passwordTextField.hasText else {
            createButton.backgroundColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
            createButton.isEnabled = false
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    }
    
    @objc func attemptSignUp(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Error", and: "Please complete all fields!")
            return
        }
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email address!")
            return
        }
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return 
        }
        FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
            self?.handleCreateAccountResponse(with: result)
        }
    }
    
 //MARK: -Private methods
    
    private func showAlert(with title: String, and message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
        
    }
    
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async {
            [weak self] in
            switch result {
            case .success(let user):
                FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                    self?.handleUserCreatedInFirestore(result: newResult)
                }
            case .failure(let error):
                self?.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
            }
        }
    }
    
    private func handleUserCreatedInFirestore(result: Result<(), Error>){
        switch result {
        case .success:
            guard let windowScene =
                UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate,
                let window = sceneDelegate.window
                else {
                    //MARK: TODO - handle could not swap root view controller
                    return
                    
            }
             //MARK: TODO - refactor this logic into scene delegate
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                if FirebaseAuthService.manager.currentUser?.photoURL != nil {
                    window.rootViewController = PursuitTabBar()
                } else {
                    window.rootViewController = {
                        let profileSetupVC = ProfileEditViewController()
                        profileSetupVC.settingFromLogin = true
                        return profileSetupVC
                    }()
                }
            }, completion: nil)
        case .failure(let error):
            self.showAlert(with: "Error creating user", and: "An error occured wile creating new acocunt\(error)")
        }
        
    }
    
//MARK: -UI Constraints
    
    private func setupHeaderLabel() {
    view.addSubview(headerLabel)
            
headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        headerLabel.heightAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08).isActive = true
        }
        
    private func setupCreateStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,createButton])
            stackView.axis = .vertical
            stackView.spacing = 25
            stackView.distribution = .fillEqually
            self.view.addSubview(stackView)
            
        stackView.translatesAutoresizingMaskIntoConstraints = false
            
        stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 150).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
       // stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true 
        }
    }
    
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
