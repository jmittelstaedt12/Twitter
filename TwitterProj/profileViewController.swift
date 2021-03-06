//
//  profileViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit
import MBProgressHUD

class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellActions{
    
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    
    var tweet: Tweet?
    var userTweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tweet = tweet else {
            print("Tweet not found")
            return
        }
        usernameLabel.text = tweet.name
        handleLabel.text = "@" + tweet.screenName
        profileImageView.setImageWith(tweet.profileURLHD)
        
        if let backgroundURL = tweet.profileBackgroundURL{
            bannerImageView.setImageWith(backgroundURL)
        }
        
        tweetCountLabel.text = Tweet.shortenNumber(num: tweet.statusCount)
        followingCountLabel.text = Tweet.shortenNumber(num: tweet.followingCount)
        followersCountLabel.text = Tweet.shortenNumber(num: tweet.followersCount)
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.tableHeaderView = headerView
        TwitterClient.sharedInstance.userTimelineRequest(screen_name: tweet.screenName, success: { (tweets: [Tweet]) in
            self.userTweets = tweets
            self.tweetsTableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
            
        }
        DispatchQueue.main.async {
            self.tweetsTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.bannerImageView.frame.height+71.5)
            self.tweetsTableView.reloadData()
        }
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
        Tweet.toggleRetweet(tweet, tweetArray: userTweets, success: { (tweet,index) in
            self.userTweets[index] = tweet
            self.tweetsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func toggleFavor(_ tweet: Tweet) {
        Tweet.toggleFavor(tweet, tweetArray: userTweets, success: { (tweet,index) in
            self.userTweets[index] = tweet
            self.tweetsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tweetSegue(_ cell: UITableViewCell) {
        performSegue(withIdentifier: "profileTweetTapSegue", sender: cell)
    }
    
    func profileSegue(_ cell: UITableViewCell) {
        let tweet = userTweets[tweetsTableView.indexPath(for: cell)!.row]
        guard tweet.screenName != self.tweet?.screenName else{
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.tweet = tweet
        viewDidLoad()
        tweetsTableView.setContentOffset(CGPoint.zero, animated: false)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "profileTweetTapSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tweetsTableView.indexPath(for: cell)
            let tweet = userTweets[indexPath!.row]
            let navVC = segue.destination as? UINavigationController
            let detailedVC = navVC?.viewControllers.first as! TweetDetailsViewController
            detailedVC.tweet = tweet
        }
    }
}
