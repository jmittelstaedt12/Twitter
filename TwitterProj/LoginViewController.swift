//
//  LoginViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/21/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBAction func onLoginButton(_ sender: Any) {
        TwitterClient.sharedInstance.login(success: {
            print("I have logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) {( error: Error) in
            let alert = UIAlertController(title: "Failed Login", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
