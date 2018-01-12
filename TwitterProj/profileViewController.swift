//
//  profileViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellActions{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    
    var tweet: Tweet?
    var screen_name: String?
    var userTweets: [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        usernameLabel.text = tweet?.name
        handleLabel.text = "@" + (tweet?.screenName)!
        
        profileImageView.setImageWith((tweet?.profileURL)!)
        
        if let backgroundURL = tweet?.profileBackgroundURL{
            bannerImageView.setImageWith(backgroundURL)
        }
        
        tweetCountLabel.text = "\((tweet?.statusCount)!)"
        followingCountLabel.text = "\((tweet?.followingCount)!)"
        followersCountLabel.text = "\((tweet?.followersCount)!)"
        TwitterClient.sharedInstance.userTimelineRequest(screen_name: screen_name!, success: { (tweets: [Tweet]) in
            self.userTweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
            
        }
        
        let ourTimeStamp: Date = (tweet?.timestamp)!
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy, h:mm a"
        let ourDate = dateformatter.string(from: ourTimeStamp)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweetcount = self.userTweets?.count {
            return tweetcount
        } else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell",for: indexPath) as! TwitterTableViewCell
        let ourTweet = self.userTweets![indexPath.row]
        cell.tweet = ourTweet
        cell.delegate = self
        return cell
    }
    
    func toggleRetweet(_ tweet: Tweet) {

    }
    
    func toggleFavor(_ tweet: Tweet) {
        
    }
    
    func tweetSegue(_ cell: UITableViewCell) {
        
    }
    
    func profileSegue(_ cell: UITableViewCell) {
        
    }

}
