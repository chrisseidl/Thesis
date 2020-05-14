//
//  MusicView.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation
import MediaPlayer


class MusicView : UIViewController {
    let authManager = AuthorizationManager(appleMusicManager: AppleMusicManager())
    
    var audioPlayer = AVAudioPlayer()

    // ---- VIEWS ----
    
    // Music Home View
     let musicVolumeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        let volumeView = MPVolumeView()
        view.addSubview(volumeView)
        view.layer.masksToBounds = true
        return view
    }()
    // Segmented controller inititalization
    let mainSegmentedControl : UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Users", "Music","Now",
        "Inbox", "Settings"])
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.layer.shadowColor = UIColor.white.cgColor
        seg.layer.shadowOffset = CGSize(width: 5, height: 5)
        seg.layer.shadowRadius = 5
        seg.layer.shadowOpacity = 1.0
        seg.layer.borderColor = UIColor.black.cgColor
        seg.layer.borderWidth = 1.25
        seg.tintColor = .white
        seg.backgroundColor = .white
        seg.selectedSegmentIndex = 2
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
    
    
    // Music Play/Pause button
    let playPauseButton: UIButton = {
        let button = UIButton()
       // button.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        button.layer.cornerRadius = 25.0
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        let image = UIImage(named:"Play.pdf")
        button.setImage(image, for: .normal)
       // button.setTitle("Play", for: .normal)
       // button.setTitleColor(.white, for: .normal)
       // button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(playPauseButtonTap), for: .touchUpInside)
        return button
    }()
    // Music next button
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 25.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        let image = UIImage(named:"Forward.pdf")
        button.setImage(image, for: .normal)
        //button.setTitle("Next", for: .normal)
        //button.setTitleColor(.white, for: .normal)
       // button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(nextButtonTap), for: .touchUpInside)
        return button
    }()
    // Music Restart button
    let restartButton: UIButton = {
       let button = UIButton()
       button.layer.cornerRadius = 25.0
       button.layer.shadowColor = UIColor.white.cgColor
       button.layer.shadowOffset = CGSize(width: 5, height: 5)
       button.layer.shadowRadius = 5
       button.layer.shadowOpacity = 1.0
       button.layer.borderColor = UIColor.black.cgColor
       button.layer.borderWidth = 1.25
       button.translatesAutoresizingMaskIntoConstraints = false
       button.backgroundColor = .white
       let image = UIImage(named:"Backward.pdf")
       button.setImage(image, for: .normal)
       //button.setTitle("Restart", for: .normal)
       //button.setTitleColor(.white, for: .normal)
       //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
       
       button.addTarget(self, action: #selector(restartButtonTap), for: .touchUpInside)
        return button
    }()

    
    var musicSongLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Simple Man"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 5, height: 5)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1.0
        return label
    }()
    

    var musicArtistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lynyrd Skynyrd"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .red
        label.layer.shadowColor = UIColor.red.cgColor
        label.layer.shadowOffset = CGSize(width: 5, height: 5)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1.0
        return label
    }()
    var musicImageView: UIImageView = {
        let image = UIImageView()
        //image.backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 7.5
        image.layer.shadowColor = UIColor.lightGray.cgColor
        image.layer.shadowOffset = CGSize(width: 5, height: 5)
        image.layer.shadowRadius = 5
        image.layer.shadowOpacity = 1.0
        let currentImage = UIImage(named:"Lynyrdskynyrd.jpg")
        image.image = currentImage
        return image
    }()
    
    
    var spectatorLabel: UILabel = {
        let label = UILabel()
        label.text = "Listening Now - chrisseidl"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 5, height: 5)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1.0
        return label
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blackSpectrumBackground.png")!)
        view.layer.masksToBounds = true
        view.addSubview(playPauseButton)
        view.addSubview(nextButton)
        view.addSubview(restartButton)
        view.addSubview(mainSegmentedControl)
        view.addSubview(musicImageView)
        view.addSubview(musicSongLabel)
        view.addSubview(musicArtistLabel)
        view.addSubview(spectatorLabel)
        view.addSubview(musicVolumeView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        setMusicConstraints()
        updateCurrentMusicData()
        
        
        // Authorization methods that do not work from Apple
        // Always returns " cannot connect to Itunes store" or
        // "Error occured when requesting capabilities"
        //self.authManager.requestUserToken()
        //self.authManager.requestCloudServiceAuthorization()
        //self.authManager.requestStorefrontCountryCode()
        //self.authManager.requestCloudServiceCapabilities()
        
        
    }
    
    @objc func handleLogout() {
        
    }
    
    func setMusicConstraints() {
        
        musicImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        musicImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        musicImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        nextButton.leftAnchor.constraint(equalTo: playPauseButton.rightAnchor, constant: 20).isActive = true
        nextButton.topAnchor.constraint(equalTo: musicImageView.bottomAnchor, constant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant:70).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playPauseButton.topAnchor.constraint(equalTo: musicImageView.bottomAnchor, constant: 50).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant:70).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        restartButton.rightAnchor.constraint(equalTo: playPauseButton.leftAnchor, constant: -20).isActive = true
        restartButton.topAnchor.constraint(equalTo: musicImageView.bottomAnchor, constant: 50).isActive = true
        restartButton.widthAnchor.constraint(equalToConstant:70).isActive = true
        restartButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        mainSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainSegmentedControl.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        mainSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainSegmentedControl.heightAnchor.constraint(equalToConstant: 100).isActive = true
        musicArtistLabel.leftAnchor.constraint(equalTo: musicImageView.leftAnchor).isActive = true
        musicArtistLabel.bottomAnchor.constraint(equalTo: musicImageView.topAnchor, constant: -10).isActive = true
        musicArtistLabel.widthAnchor.constraint(equalTo: musicImageView.widthAnchor).isActive = true
        musicArtistLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        musicSongLabel.leftAnchor.constraint(equalTo: musicImageView.leftAnchor).isActive = true
        musicSongLabel.bottomAnchor.constraint(equalTo: musicArtistLabel.topAnchor).isActive = true
        musicSongLabel.widthAnchor.constraint(equalTo: musicImageView.widthAnchor).isActive = true
        musicSongLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        spectatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spectatorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        spectatorLabel.widthAnchor.constraint(equalTo: musicImageView.widthAnchor).isActive = true
        spectatorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        musicVolumeView.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 10).isActive = true
        musicVolumeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicVolumeView.widthAnchor.constraint(equalTo: musicImageView.widthAnchor).isActive = true
        musicVolumeView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    // Button handlers
    
    @objc func playPauseButtonTap(){
         //audioPlayer.play()
        

        
    }
    @objc func nextButtonTap(){
        
    }
    @objc func restartButtonTap(){
        
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
        let settingsController = SettingsView()
        settingsController.modalPresentationStyle = .fullScreen
        present(settingsController, animated: false, completion: nil)
       }
    func nowPlayingTap() {

          }
    
    func updateCurrentMusicData() {
        

    }
    
    
    
}





