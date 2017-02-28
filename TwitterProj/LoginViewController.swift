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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        TwitterClient.sharedInstance.login(success: {
            print("I have logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) {( error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    

}
