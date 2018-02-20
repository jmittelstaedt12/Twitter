//
//  replyViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit
import MBProgressHUD

class replyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func replyButton(_ sender: UIBarButtonItem) {
        
        replyText = "@" + replyHandle + " " + replyTextView.text
        
        let paramsDict: NSDictionary = NSDictionary(dictionary: ["status" : replyText!,"in_reply_to_status_id" : replyID!])
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance.createTweet(tweetText: replyText!, params: paramsDict, success: {() -> () in
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "", message: "Posted!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error) -> () in
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Failed Login", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        })
    }
    
    var tweet: Tweet?
    var replyText: String!
    var replyID: String!
    var replyHandle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextView.delegate = self
        replyTextView.text = "Write your reply here..."
        replyTextView.textColor = .lightGray
        replyID = tweet?.id
        replyHandle = tweet?.screenName
        usernameLabel.text = tweet?.name
        handleLabel.text = "@" + (tweet?.screenName)!
        profileImageView.setImageWith((tweet?.profileURLHD)!)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if replyTextView.text == "Write your reply here..."{
            replyTextView.text = ""
            replyTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if replyTextView.text == ""{
            replyTextView.text = "Write your reply here..."
            replyTextView.textColor = .lightGray
        }
    }

}
