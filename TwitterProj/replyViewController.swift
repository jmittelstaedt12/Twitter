//
//  replyViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class replyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var tweet: Tweet?
    var replyText: String!
    var replyID: String!
    var replyHandle: String!
    //weak var delegate: ReplyAndCancelFuncDelegate?
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func replyButton(_ sender: UIBarButtonItem) {
        
        replyText = "@" + replyHandle + " " + replyTextView.text
        
        print(replyHandle)
        let paramsDict: NSDictionary = NSDictionary(dictionary: ["status" : replyText!,"in_reply_to_status_id" : replyID!])
        
        TwitterClient.sharedInstance.createTweet(tweetText: replyText!, params: paramsDict, completion: { (error) -> () in
            
            print("Composing")
            
            print(error?.localizedDescription)
            
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextView.delegate = self
        replyTextView.text = "Write your reply here..."
        replyTextView.textColor = .lightGray
        replyID = tweet?.id
        replyHandle = tweet?.screenName
        usernameLabel.text = tweet?.name
        handleLabel.text = "@" + (tweet?.screenName)!
        profileImageView.setImageWith((tweet?.profileURL)!)
        
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
