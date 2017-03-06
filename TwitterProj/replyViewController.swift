//
//  replyViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class replyViewController: UIViewController {

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
        performSegue(withIdentifier: "replyToDetailSegue", sender: tweet)
    }

    @IBAction func replyButton(_ sender: UIBarButtonItem) {
        
        replyText = "@" + replyHandle + " " + replyTextView.text
        
        print(replyHandle)
        let paramsDict: NSDictionary = NSDictionary(dictionary: ["status" : replyText!,"in_reply_to_status_id" : replyID!])
        
        TwitterClient.sharedInstance.createTweet(tweetText: replyText!, params: paramsDict, completion: { (error) -> () in
            
            print("Composing")
            
            print(error?.localizedDescription)
            
        })
        performSegue(withIdentifier: "replyToDetailSegue", sender: tweet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        replyID = tweet?.id
        replyHandle = tweet?.screenName
        usernameLabel.text = tweet?.name
        handleLabel.text = "@" + (tweet?.screenName)!
        profileImageView.setImageWith((tweet?.profileURL)!)
        
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "replyToDetailSegue") {
//            let detailVC = segue.destination as! TweetDetailsViewController
//            let tweetPass = self.tweet
//
//            detailVC.tweet = tweetPass
//        }
    }
    

}

//protocol ReplyAndCancelFuncDelegate: class{
//    func didCancel()
//    func didReply(tweetText: String)
//}
