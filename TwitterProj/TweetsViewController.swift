//
//  TweetsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/27/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellActions{


    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]!
    var user : User!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets : [Tweet])
            in
            self.tweets = tweets
            //self.tableView.reloadData()
            TwitterClient.sharedInstance.currentAccount(success: { (user : User)
                in
                self.user = user
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
            for tweet in tweets {
                print(tweet.text!)
            }
            }) { (error) in
            print(error.localizedDescription)
            }
        }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    func onRetweet(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweetcount = self.tweets?.count {
            return tweetcount
        } else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterTableViewCell",for: indexPath) as! TwitterTableViewCell
        let ourTweet = self.tweets![indexPath.row]
        
        cell.tweet = ourTweet
        cell.delegate = self
        return cell
    }
    
    func favorTweet(_ tweet: Tweet) {
        if let index = tweets.index(of: tweet) {
            let indexPath = IndexPath(row: index, section: 0)
            
            TwitterClient.sharedInstance.favorRequest(id: (tweet.id)!, success: { (tweet) in
                self.tweets[index] = tweet
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
            }) { (error) in
                
            }
        }
        
    }
    func retweet(_ tweet: Tweet) {
        if let index = tweets.index(of: tweet) {
           
            let indexPath = IndexPath(row: index, section: 0)
            print(tweet.favorited)
            TwitterClient.sharedInstance.retweetRequest(id: (tweet.id)!, success: { (tweet) in
                self.tweets[index] = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
            }) { (error) in
                
            }
        }
    }
    func toggleRetweet(_ tweet: Tweet) {
        
    }
    func toggleFavor(_ tweet: Tweet) {
        
    }
    
    func tweetSegue(_ cell: UITableViewCell) {
        performSegue(withIdentifier: "tweetTapSegue", sender: cell)
    }
    
    func profileSegue(_ cell: UITableViewCell) {
        
        performSegue(withIdentifier: "profileSegue", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tweetTapSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            let detailedVC = segue.destination as! TweetDetailsViewController
            
            detailedVC.tweet = tweet
            
        }
        if(segue.identifier == "profileSegue") {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            let profileVC = segue.destination as! profileViewController
            
            profileVC.tweet = tweet
            
        }
        if(segue.identifier == "newTweetSegue"){
            let currentUser = self.user
            let tweetVC = segue.destination as! newTweetViewController
            tweetVC.user = currentUser
        }
    }
}
