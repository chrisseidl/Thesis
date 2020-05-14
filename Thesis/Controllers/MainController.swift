//
//  MainController.swift
//  Thesis
//
//  Created by Christopher  on 12/10/19.
//  Copyright © 2019 Christopher . All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import StoreKit
import MediaPlayer
import Foundation


class MainController: UIViewController {

    
    
    
    // LogOut Button
      var logoutButton: UIButton = {
          let button = UIButton(type: .system)
          button.backgroundColor = .black
          button.setTitle("Log Out", for: .normal)
          button.setTitleColor(.white, for: .normal)
          button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 10
          button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
          return button
      }()
    
    // Segmented controller inititalization
    let mainSegmentedControl : UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Friends", "Music","Now",
        "Inbox", "Settings"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.tintColor = .white
        seg.selectedSegmentIndex = 1
        seg.addTarget(self, action: #selector(mainSegmentedControllerTap), for: .valueChanged)
        seg.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)

        return seg
    }()
    
    // Segmented controller "Listener"
    @objc func mainSegmentedControllerTap() {
           if mainSegmentedControl.selectedSegmentIndex == 0 {
               friendsTap()
           } else if mainSegmentedControl.selectedSegmentIndex == 1 {
               musicTap()
           }else if mainSegmentedControl.selectedSegmentIndex == 2 {
               nowPlayingTap()
           } else if mainSegmentedControl.selectedSegmentIndex == 3 {
               messagesTap()
           } else {
               settingsTap()
        }
       }
    
   
    // Username text label showing current user
    var usernameTextBox: UILabel = {
        let text = UILabel()
        
        text.font = UIFont.boldSystemFont(ofSize: 30)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainSegmentedControl)
        view.addSubview(logoutButton)
        view.addSubview(usernameTextBox)
        setMainControllerContraints()
        updateUserNameBox()
        
        // means that user is not logged in
       if Auth.auth().currentUser?.uid == nil {
          let loginController = LoginController()
            loginController.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true, completion: nil)
          present(loginController, animated:true, completion: nil)
      }
    }
    
    func setMainControllerContraints() {
        logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameTextBox.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        usernameTextBox.centerYAnchor.constraint(equalTo: logoutButton.centerYAnchor).isActive = true
        usernameTextBox.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        usernameTextBox.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mainSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainSegmentedControl.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        mainSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainSegmentedControl.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func friendsTap() {
        
       }
    func musicTap() {

       }
    func messagesTap() {
        
       }
    func settingsTap() {
        
       }
    func nowPlayingTap() {
           let musicController = MusicView()
           musicController.modalPresentationStyle = .fullScreen
           present(musicController, animated: false, completion: nil)
          }
    @objc func logoutTapped() {
        
        do {
            try Auth.auth().signOut()
            let loginController = LoginController()
            loginController.modalPresentationStyle = .fullScreen
            present(loginController, animated:true, completion: nil)
        } catch let logoutError {
            print(logoutError)
        }
      
        
    }

    
    func updateUserNameBox() {
        var updatedText = String()
        var username = NSString()
        let ref = Database.database().reference(withPath: "users")
        let userRef = ref.child(Auth.auth().currentUser!.uid).child("username")
        userRef.observe(.value, with: { snapshot in

            username = snapshot.value as! NSString
            print(snapshot.value as Any )
            updatedText = username as String
            self.usernameTextBox.text = updatedText
        })
        usernameTextBox.setNeedsDisplay()
    }
    
}

