//
//  TweetsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/27/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//
//  ViewController for a timeline of tweets. User can look through tweets, refresh, or navigate
//  to a profile or tweet detail VC.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellActions, UIScrollViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    var tweets : [Tweet]!
    var user : User!
    var isMoreDataLoading = false
    var tweet_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up refresh gesture
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(networkRequest(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //API request for timeline, with a loading wheel
        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequest(nil)
    }
    
    /**
     Requests the current user's timeline from the API
     - refreshControl: If this request is being made using refresh, end refreshing on response
     */
    func networkRequest(_ refreshControl: UIRefreshControl?){
        TwitterClient.sharedInstance.homeTimeline(completionHandler: { (tweets,error)
            in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let refreshControl = refreshControl{
                refreshControl.endRefreshing()
            }
            if let error = error{
                print(error.localizedDescription)
                return
            }
            self.tweets = tweets!
            TwitterClient.sharedInstance.currentAccount(success: { (user)
                in
                self.user = user
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        })
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
        tweet_id = ourTweet.id
        cell.delegate = self
        return cell
    }
    
    
    /// Makes a request for more data when user reaches bottom of table view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isMoreDataLoading {
            return
        }
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging{
            isMoreDataLoading = true
            MBProgressHUD.showAdded(to: self.view, animated: true)
            loadMoreData()
        }
    }
    
    /// Is called when user scrolls to bottom of table view. Requests more tweets from API
    func loadMoreData(){
        TwitterClient.sharedInstance.homeTimeline(completionHandler: { (tweets,error)
            in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error{
                print(error.localizedDescription)
                return
            }
            self.isMoreDataLoading = false
            self.tweets.append(contentsOf:tweets!)
            self.tableView.reloadData()
        })
    }
    
    /** Calls Tweet class function that will toggle the corresponding tweet's retweeted property
     - tweet: The tweet corresponding with the selected cell
    */
    func toggleRetweet(_ tweet: Tweet) {
        Tweet.toggleRetweet(tweet, tweetArray: tweets, success: { (tweet,index) in
            self.tweets[index] = tweet
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /** Calls Tweet class function that will toggle the corresponding tweet's favorited property
     - tweet: The tweet corresponding with the selected cell
     */
    func toggleFavor(_ tweet: Tweet) {
        Tweet.toggleFavor(tweet, tweetArray: tweets, success: { (tweet,index) in
            self.tweets[index] = tweet
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /// If user taps on a tweet, this will segue to a detail VC for that tweet
    func tweetSegue(_ cell: UITableViewCell) {
        performSegue(withIdentifier: "tweetTapSegue", sender: cell)
    }
    
    /// If user taps on a profile picture, this will segue to the corresponding user's profile
    func profileSegue(_ cell: UITableViewCell) {
        performSegue(withIdentifier: "profileSegue", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "tweetTapSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            let navVC = segue.destination as? UINavigationController
            let detailedVC = navVC?.viewControllers.first as! TweetDetailsViewController
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
            let navVC = segue.destination as? UINavigationController
            let tweetVC = navVC?.viewControllers.first as! newTweetViewController
            tweetVC.user = currentUser
        }
    }
}
