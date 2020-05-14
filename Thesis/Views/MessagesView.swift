//
//  MessagesView.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class MessagesView : UIViewController, UITableViewDelegate,  UITableViewDataSource{

    
    let inboxLabel: UILabel = {
        let text = UILabel()
        text.text = "Inbox"
        text.textColor = .white
        text.font = UIFont.boldSystemFont(ofSize: 36)
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
      var newMessageButton: UIButton = {
          let button = UIButton(type: .system)
          button.backgroundColor = .clear
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 25
          let image = UIImage(named: "add-plus-button.png")
          button.setImage(image, for: .normal)
          button.addTarget(self, action: #selector(newMessageButtonTapped), for: .touchUpInside)
          return button
      }()
    let tableview: UITableView = {
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
        seg.selectedSegmentIndex = 3
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
            view.addSubview(tableview)
            view.addSubview(inboxLabel)
            view.addSubview(logoutButton)
            view.addSubview(newMessageButton)
            setFriendsConstraints()
            setupTableView()
            
        
            
    }
    // new friend button handler
    @objc func newMessageButtonTapped() {

        
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
        let friendController = FriendView()
        friendController.modalPresentationStyle = .fullScreen
        present(friendController, animated: false, completion: nil)
       }
    func musicTap() {
        let musicSearchController = MusicSearchView()
        musicSearchController.modalPresentationStyle = .fullScreen
        present(musicSearchController, animated: false, completion: nil)
       }
    func messagesTap() {

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
        tableview.centerXAnchor.constraint(equalTo: mainSegmentedControl.centerXAnchor).isActive = true
        tableview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: mainSegmentedControl.topAnchor).isActive = true
        inboxLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        inboxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inboxLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/6).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newMessageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        newMessageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        newMessageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        newMessageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // Actual table view things
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MessageCell
        cell.backgroundColor = UIColor.white
        return cell
    }
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MessageCell.self, forCellReuseIdentifier: "cellId")
        
    }
    
    
    
}

// Table view cells - for our table
class MessageCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
