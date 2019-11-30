//
//  LoginViewController.swift
//  PursuitsGram
//
//  Created by Krystal Campbell on 11/25/19.
//  Copyright © 2019 Krystal Campbell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
//MARK:- UI Objects
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "suiteGram"
        label.font = UIFont(name: "Marker Felt", size: 72)
        label.textColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .center
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
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 18)
        button.backgroundColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account? ",
        
            attributes: [
                
                NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 14)!,
                
                NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up!",
                                                  attributes: [NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 14)!,
                                                               NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        return button
    }()
   
   
//MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = .darkGray
        setupSubViews()

    }
    
    //MARK: -Objc Methods
    
    @objc func fieldsValidated() {
        guard emailTextField.hasText, passwordTextField.hasText else {
            loginButton.backgroundColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
                loginButton.isEnabled = false
            return
            }
        loginButton.isEnabled = true
        loginButton.backgroundColor = #colorLiteral(red: 0.7356492877, green: 0.7233195901, blue: 1, alpha: 1)
    }
    
    @objc func showSignUp() {
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .formSheet
        present(signupVC, animated: true, completion: nil)
         }
    
    @objc func tryLogin() {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
        showAlert(with: "Error", and: "Please complete out all fields.")
        return
    }
        //MARK: TODO - remove whitespace (if any) from email/password
                
                guard email.isValidEmail else {
                    showAlert(with: "Error", and: "Please enter a valid email")
                    return
                }
                
                guard password.isValidPassword else {
                    showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
                    return
                }
                
                FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
                    self.handleLoginResponse(with: result)
                }
            }
  
    //MARK: -Private Methods
    
    
     private func showAlert(with title: String, and message: String) {
         let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         present(alertVC, animated: true, completion: nil)
     }
     
     private func handleLoginResponse(with result: Result<(), Error>) {
         switch result {
         case .failure(let error):
             showAlert(with: "Error", and: "Could not log in. Error: \(error)")
         case .success:
             
             guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                 let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                 else {
                     //MARK: TODO - handle could not swap root view controller
                     return
             }
             
             //MARK: TODO - refactor this logic into scene delegate
             UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                 if FirebaseAuthService.manager.currentUser?.photoURL != nil {
                     window.rootViewController =
                        PursuitTabBar()
                 } else {
                     window.rootViewController = {
                         let profileSetupVC = ProfileEditViewController()
                         profileSetupVC.settingFromLogin = true
                         return profileSetupVC
                     }()
                 }
             }, completion: nil)
         }
     }
//MARK: -UI Constraints
    
    private func setupSubViews() {
          setupLogoLabel()
          setupCreateAccountButton()
          setupLoginStackView()
      }
      
      private func setupLogoLabel() {
          view.addSubview(logoLabel)
          
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
         
        logoLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        logoLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        logoLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
      }
      
      private func setupLoginStackView() {
          let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,loginButton])
          stackView.axis = .vertical
          stackView.spacing = 35
          stackView.distribution = .fillEqually
          self.view.addSubview(stackView)
          
          stackView.translatesAutoresizingMaskIntoConstraints = false
        
         
        stackView.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -100).isActive = true
              stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
              stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
              stackView.heightAnchor.constraint(equalToConstant: 130).isActive = true
      }
      
      private func setupCreateAccountButton() {
          view.addSubview(createAccountButton)
          
          createAccountButton.translatesAutoresizingMaskIntoConstraints = false
      
              createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
              createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
              createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
              createAccountButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
      }
}
