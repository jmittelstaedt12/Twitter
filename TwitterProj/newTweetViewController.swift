//
//  newTweetViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit
import MBProgressHUD

class newTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        //performSegue(withIdentifier: "tweetToMainSegue", sender: nil)
    }
    
    @IBAction func tweetButton(_ sender: UIBarButtonItem) {
        tweetText = tweetTextView.text
        let paramsDict: NSDictionary = NSDictionary(dictionary: ["status" : tweetText!])
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance.createTweet(tweetText: tweetText!, params: paramsDict, success: {() -> () in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error) -> () in
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Failed Tweet", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    var tweetText: String!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self
        tweetTextView.text = "Write your tweet here..."
        tweetTextView.textColor = .lightGray
        usernameLabel.text = user?.name
        handleLabel.text = user?.screenName
        profileImageView.setImageWith((user?.profileURL)!)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tweetTextView.text == "Write your tweet here..."{
            tweetTextView.text = ""
            tweetTextView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if tweetTextView.text == ""{
            tweetTextView.text = "Write your tweet here..."
            tweetTextView.textColor = .lightGray
        }
    }
}
