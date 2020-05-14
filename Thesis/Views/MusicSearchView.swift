//
//  MusicSearchView.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
//

import Foundation
import UIKit


class MusicSearchView : UIViewController, UITableViewDelegate,  UITableViewDataSource{

    // search Button
    var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Go", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let searchTextField : UITextField = {
       let text = UITextField()
        text.placeholder = "Search Apple Music"
        text.backgroundColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let friendsLabel: UILabel = {
        let text = UILabel()
        text.text = "Friends"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
        
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
    
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
            view.backgroundColor = UIColor(patternImage: UIImage(named: "blackSpectrumBackground.png")!)
            view.addSubview(mainSegmentedControl)
            view.addSubview(tableview)
            view.addSubview(searchTextField)
            view.addSubview(searchButton)
            setFriendsConstraints()
            setupTableView()
            
        
            
    }
    
    // SEGMENTED CONTROLLER HANDLERS
    func friendsTap() {
        let friendController = FriendView()
        friendController.modalPresentationStyle = .fullScreen
        present(friendController, animated: false, completion: nil)
       }
    func musicTap() {

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
    
    // search button handler
    @objc func searchButtonTapped() {

        
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
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.topAnchor.constraint(equalTo: tableview.topAnchor, constant: -50).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MediaCell
        cell.backgroundColor = UIColor.white
        return cell
    }
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MediaCell.self, forCellReuseIdentifier: "cellId")
        
    }
    
    
    
}

// Table view cells - for our table
class MediaCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

