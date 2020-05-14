//
//  SettingsView.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
//

import Foundation
import UIKit

class SettingsView : UIViewController, UITableViewDelegate,  UITableViewDataSource{

    

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
        seg.selectedSegmentIndex = 4
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
        setSettingsConstraints()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
            
    }
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
        let messagesController = MessagesView()
        messagesController.modalPresentationStyle = .fullScreen
        present(messagesController, animated: false, completion: nil)
       }
    func settingsTap() {
        
       }
    func nowPlayingTap() {
        let nowPlayingController = MusicView()
        nowPlayingController.modalPresentationStyle = .fullScreen
        present(nowPlayingController, animated: false, completion: nil)
          }
    func setSettingsConstraints(){
        mainSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainSegmentedControl.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        mainSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainSegmentedControl.heightAnchor.constraint(equalToConstant: 100).isActive = true
        tableview.centerXAnchor.constraint(equalTo: mainSegmentedControl.centerXAnchor).isActive = true
        tableview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: mainSegmentedControl.topAnchor).isActive = true
        tableview.delegate = self
        tableview.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.white
        return cell
    }
}
