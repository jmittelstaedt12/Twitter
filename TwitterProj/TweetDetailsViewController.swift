//
//  TweetDetailsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/3/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    
    var tweet: Tweet?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = tweet?.name
        handleLabel.text = "@" + (tweet?.screenName)!
        tweetLabel.text = tweet?.text
        let ourTimeStamp: Date = (tweet?.timestamp)!
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy, h:mm a"
        let ourDate = dateformatter.string(from: ourTimeStamp)
        print(ourDate)
        timeStampLabel.text = ourDate
        retweetLabel.text = "\((tweet?.retweetCount)!)"
        favoritesLabel.text = "\((tweet?.favoritesCount)!)"
        profileImageView.setImageWith((tweet?.profileURL)!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "replySegue") {
            let replyVC = segue.destination as! replyViewController
            let tweetPass = self.tweet
            
            
            replyVC.tweet = tweetPass
            
            
            print("hey")

        }
    }

}
