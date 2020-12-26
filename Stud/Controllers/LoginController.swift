//
//  LoginController.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMAppAuth

// client id = 862064848398-3j4m11k37md3ss1ml42lb1rp7ahpbk4f.apps.googleusercontent.com
// url scheme = reversed client id =  com.googleusercontent.apps.862064848398-3j4m11k37md3ss1ml42lb1rp7ahpbk4f
// api key = AIzaSyAyFXHQV3DrxSI3lGrLIp-2qkSGiPUnZS4

public var username: String = ""
public var imageURL: URL?

class LoginController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    // MARK: - Properties
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.clientID = "862064848398-3j4m11k37md3ss1ml42lb1rp7ahpbk4f.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/calendar", "https://www.googleapis.com/auth/admin.directory.user.readonly"]
        
        if GIDSignIn.sharedInstance()?.hasAuthInKeychain() == false {
            GIDSignIn.sharedInstance().signIn()
        } else {
            GIDSignIn.sharedInstance()?.signInSilently()
//            guard let user = GIDSignIn.sharedInstance()?.currentUser {
//                // user is signed in
//            } else {
//                GIDSignIn.sharedInstance()?.signInSilently()
//            }
        }
        
        
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: view.center.y-300, width: view.frame.width, height: 50))
        titleLabel.text = "Stud"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 54)
        titleLabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        view.addSubview(titleLabel)
        
        let descLabel = UILabel(frame: CGRect(x: 50, y: view.center.y-225, width: view.frame.width-100, height: 150))
        descLabel.text = "Finding it difficult to manage your school life. Stud makes it easy. Add events and it will preset reminders to help you remember to study."
        descLabel.font = UIFont.systemFont(ofSize: 18)
        descLabel.textColor = .black
        descLabel.textAlignment = .center
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.numberOfLines = 7
        view.addSubview(descLabel)
        
        let loginButton = GIDSignInButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            //let userId = user.userID                  // For client-side use only!
            //let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            //let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            //let email = user.profile.email
            
            username = user.profile.name
            if user.profile.hasImage {
                imageURL = user.profile.imageURL(withDimension: 75)
            }
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(String(describing: fullName))"])
            
            // takes user to home screen
            let controller = UINavigationController(rootViewController: ContainerController())
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
}

