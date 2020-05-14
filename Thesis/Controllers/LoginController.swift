//
//  LoginController.swift
//  Thesis
//
//  Created by Christopher  on 12/10/19.
//  Copyright © 2019 Christopher . All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth


// Login or Register Splash Screen
// Users will be able to log in or register their email and password
// to the database.
class LoginController: UIViewController {
    
    

    
    
    // Container for text fields ( email and password )
    let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    // Register Button
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(loginOrRegisterButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    

    
    let nameTextField : UITextField = {
        let name = UITextField()
        name.placeholder = "Username"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    //
    let emailTextField : UITextField = {
       let text = UITextField()
        text.placeholder = "Email"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let pwTextField : UITextField = {
       let text = UITextField()
        text.placeholder = "Password"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let nameSeparator : UIView = {
        let ns = UIView()
        ns.translatesAutoresizingMaskIntoConstraints = false
        ns.backgroundColor = .gray
        return ns
    }()
    let emailSeparator : UIView = {
        let ns = UIView()
        ns.translatesAutoresizingMaskIntoConstraints = false
        ns.backgroundColor = .gray
        return ns
    }()
    
    let brandTextField : UILabel = {
        let tf = UILabel()
        tf.text = ("WeDJ")
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.italicSystemFont(ofSize: 120)
        tf.layer.shadowColor = UIColor.white.cgColor
        tf.layer.shadowOffset = CGSize(width: 5, height: 5)
        tf.layer.shadowRadius = 5
        tf.layer.shadowOpacity = 1.0
        tf.textColor = .black
        
        return tf
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = ("Spring 2020")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 35)
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 5, height: 5)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1.0
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = ("Chris Seidl")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 40)
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 5, height: 5)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1.0
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let lrSegmentedControl : UISegmentedControl = {
        let lr = UISegmentedControl(items: ["Login", "Register"])
        lr.translatesAutoresizingMaskIntoConstraints = false
        lr.tintColor = .white
        lr.selectedSegmentIndex = 1
        lr.addTarget(self, action: #selector(lrChanged), for: .valueChanged)
        lr.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
        
        return lr
    }()
    
    
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "blackSpectrumBackground.png")!)
        view.addSubview(infoContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(brandTextField)
        view.addSubview(lrSegmentedControl)
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        
        setInfoContainerViewContraints()
        setLoginRegisterButtonConstraints()
        setBrandTextFieldConstraints()
        setLRSegmentedControl()
    }
    
    // -------- BUTTON HANDLER FUNCTIONS --------------
    
    // When Segmented Control is changed call this
    @objc func lrChanged() {
        
        emailTextField.text = ""
        pwTextField.text = ""
        
        
        let buttonName = lrSegmentedControl.titleForSegment(at: lrSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(buttonName, for: .normal)
        
        // Change height of info containter when on login - only show email and password
        // Change back to normal three fields when on register tab
        
        // if selected segment index is = 0 -> change height to 100. if not -> change to 150
        infoContainerViewHeightAnchor?.constant = lrSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change the height of text fields depending on which segmented control is selected
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor, multiplier: lrSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor, multiplier: lrSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        pwTextFieldHeightAnchor?.isActive = false
        pwTextFieldHeightAnchor = pwTextField.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor, multiplier: lrSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        pwTextFieldHeightAnchor?.isActive = true
        
        
    }
    
    @objc func loginOrRegisterButtonTap() {
        if lrSegmentedControl.selectedSegmentIndex == 0 {
            loginTap()
        } else {
            registerTap()
        }
    }
    
    @objc func loginTap() {
            guard let email = emailTextField.text, let password = pwTextField.text else {
                return
            }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error as Any)
                let alertController = UIAlertController(title: "Error", message: "Email or Password Invalid", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")}))
                self.present(alertController, animated: true, completion: nil)
                return
            } else {
                let musicController = MusicView()
                musicController.modalPresentationStyle = .fullScreen
                self.present(musicController, animated: true, completion: nil)
            }
        }
    }
    
    
    // Register Button tapped
    @objc func registerTap(){
        guard let email = emailTextField.text, let password = pwTextField.text,
            let username = nameTextField.text else{
            return
        }
        
        // Creating a user in firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error != nil {
                print(error as Any)
                let alertController = UIAlertController(title: "Error", message: "Username, Email or Password Invalid - Password must be >6 Characters", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),style: .default, handler: { _ in
                              NSLog("The \"OK\" alert occured.")}))
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
           // guard let uid = Auth.auth().currentUser?.uid else{
           //     return
           // }
            // Adding user info to realtime database
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference(fromURL: "https://thesiswedj.firebaseio.com/")
            let values = ["email": email, "username": username]
            let usersReference = ref.child("users").child(userID!)
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                print(err as Any)
              
                return
                }
                
                let musicController = MusicView()
                musicController.modalPresentationStyle = .fullScreen
                self.present(musicController, animated: true, completion: nil)
                
                
                print("Saved")
            })
        }
    }
    
    

    
    
    
    // ---------------------------------------------
    
    
    
    // ---------- CONSTRAINT FUNCTIONS -------------
    
    
    func setLRSegmentedControl() {
        // constraints
        lrSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lrSegmentedControl.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: -12).isActive = true
        lrSegmentedControl.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        lrSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var infoContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var pwTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    // sets constaints for username/password container
    func setInfoContainerViewContraints() {
        
        // need contraints
        infoContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        infoContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        infoContainerViewHeightAnchor = infoContainerView.heightAnchor.constraint(equalToConstant: 150)
        infoContainerViewHeightAnchor?.isActive = true
        
        infoContainerView.addSubview(nameTextField)
        
        // need constraints
        nameTextField.leftAnchor.constraint(equalTo: infoContainerView.leftAnchor, constant:12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: infoContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
     
        infoContainerView.addSubview(emailTextField)
        
        // need constraints
        emailTextField.leftAnchor.constraint(equalTo: infoContainerView.leftAnchor, constant:12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        infoContainerView.addSubview(pwTextField)
        pwTextField.leftAnchor.constraint(equalTo: infoContainerView.leftAnchor, constant:12).isActive = true
        pwTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        pwTextField.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        pwTextFieldHeightAnchor = pwTextField.heightAnchor.constraint(equalTo: infoContainerView.heightAnchor, multiplier: 1/3)
        pwTextFieldHeightAnchor?.isActive = true
        
        infoContainerView.addSubview(nameSeparator)
        nameSeparator.leftAnchor.constraint(equalTo: infoContainerView.leftAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparator.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        infoContainerView.addSubview(emailSeparator)
        emailSeparator.leftAnchor.constraint(equalTo: infoContainerView.leftAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 20).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: infoContainerView.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 40 ).isActive = true
        
        
        
        
    }
    
    // sets constraints for buttons
    func setLoginRegisterButtonConstraints(){
        // need constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: infoContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: infoContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    // set constraints of WeDJ label
    func setBrandTextFieldConstraints(){
        // need constraints
        brandTextField.bottomAnchor.constraint(equalTo: lrSegmentedControl.topAnchor, constant: -50).isActive = true
        brandTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
}

// -------------------------------------------


// Used for testing purposes. Allows a view of simulator inside of editor while coding - updates in real time.

