//
//  FriendView.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FriendView : UIViewController, UITableViewDelegate,  UITableViewDataSource{
    
    
    let friendsLabel: UILabel = {
        let text = UILabel()
        text.text = "Users Online"
        text.textColor = .white
        text.font = UIFont.boldSystemFont(ofSize: 28)
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
        
    }()
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
      // LogOut Button
      var newFriendButton: UIButton = {
          let button = UIButton(type: .system)
          button.backgroundColor = .clear
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 25
          let image = UIImage(named: "add-plus-button.png")
          button.setImage(image, for: .normal)
          button.addTarget(self, action: #selector(newFriendButtonTapped), for: .touchUpInside)
          return button
      }()
    
    var users = [User]()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // Segmented controller inititalization
    let mainSegmentedControl : UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Users", "Music","Now",
        "Inbox", "Settings"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.layer.shadowColor = UIColor.black.cgColor
        seg.layer.shadowOffset = CGSize(width: 5, height: 5)
        seg.layer.shadowRadius = 5
        seg.layer.shadowOpacity = 1.0
        seg.layer.borderColor = UIColor.black.cgColor
        seg.layer.borderWidth = 1.25
        seg.tintColor = .white
        seg.backgroundColor = .white
        seg.selectedSegmentIndex = 0
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
    
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
            view.backgroundColor = UIColor(patternImage: UIImage(named: "blackSpectrumBackground.png")!)
            view.addSubview(mainSegmentedControl)
            view.addSubview(tableView)
            view.addSubview(friendsLabel)
            view.addSubview(logoutButton)
            view.addSubview(newFriendButton)
            setFriendsConstraints()
            setupTableView()
            getUser()
        
            
    }
    
    // Getting user to populate friends list
    func getUser() {
        
        Database.database().reference().child("users").observe(.childAdded, with:{ (DataSnapshot) in
            
            
            if let dictionary = DataSnapshot.value as? [String: AnyObject] {
                let user = User()
                let curUser = Auth.auth().currentUser?.email
                print(curUser!)
                    
                    user.username = dictionary["username"] as? String
                    user.email = dictionary["email"] as? String
                    print(user.username!, user.email!)
                    
                if curUser! == user.email! {
                    print("Match!")
                }else {
                
                    self.users.append(user)
                }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    
                   // print(user.email)
                }
            }
        }, withCancel:nil)
    }
    
    
    // new friend button handler
    @objc func newFriendButtonTapped() {
        
        
    }
    // logout button handler
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
    // SEGMENTED CONTROLLER HANDLERS
    func friendsTap() {

       }
    func musicTap() {
        let musicSearchController = MusicSearchView()
        musicSearchController.modalPresentationStyle = .fullScreen
        present(musicSearchController, animated: false, completion: nil)
       }
    func messagesTap() {
        let messagesController = MessagesView()
        messagesController.modalPresentationStyle = .fullScreen
        present(messagesController, animated: false, completion: nil)
       }
    func settingsTap() {
        let settingController = SettingsView()
        settingController.modalPresentationStyle = .fullScreen
        present(settingController, animated: false, completion: nil)
       }
    func nowPlayingTap() {
        let nowPlayingController = MusicView()
        nowPlayingController.modalPresentationStyle = .fullScreen
        present(nowPlayingController, animated: false, completion: nil)
          }
    // MORE CONTRAINTS!~!!!!!
    func setFriendsConstraints(){
        mainSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainSegmentedControl.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        mainSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainSegmentedControl.heightAnchor.constraint(equalToConstant: 100).isActive = true
        tableView.centerXAnchor.constraint(equalTo: mainSegmentedControl.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: mainSegmentedControl.topAnchor).isActive = true
        friendsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        friendsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        friendsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/6).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newFriendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        newFriendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        newFriendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        newFriendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // Actual table view things
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return users.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
       // let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = user.email
        cell.detailTextLabel?.text = "Now Playing - "
        cell.detailTextLabel?.textAlignment = .right
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
    }
    
    
    
}

// Table view cells - for our table
class UserCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View{
        ContView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContView>) -> UIViewController {
            FriendView()
        }
        
        
        func updateUIViewController(_ uiViewController: MainPreview.ContView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContView>) {
            
        }
        
    }
}

