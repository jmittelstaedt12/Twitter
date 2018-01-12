//
//  newTweetViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit
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
        
        TwitterClient.sharedInstance.createTweet(tweetText: tweetText!, params: paramsDict, completion: { (error) -> () in
            print("Composing")
            print(error?.localizedDescription as Any)
        })
        
        self.dismiss(animated: true, completion: nil)
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
