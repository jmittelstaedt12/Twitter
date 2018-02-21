//
//  TweetsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/27/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets : [Tweet])
            in
            self.tweets = tweets
            TwitterClient.sharedInstance.currentAccount(success: { (user : User)
                in
                    self.user = user
                    self.tableView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        MBProgressHUD.hide(for: self.view, animated: true)
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
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets : [Tweet])
            in
            self.tweets = tweets
            TwitterClient.sharedInstance.currentAccount(success: { (user : User)
                in
                self.user = user
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }) { (error) in
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging{
                isMoreDataLoading = true
                MBProgressHUD.showAdded(to: self.view, animated: true)
                loadMoreData()
            }
        }
    }
    
    func loadMoreData(){
        TwitterClient.sharedInstance.homeTimeline(max_id: tweet_id, success: { (tweets : [Tweet])
            in
            self.isMoreDataLoading = false
            self.tweets.append(contentsOf: tweets)
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func toggleRetweet(_ tweet: Tweet) {
//        if let index = tweets.index(of: tweet) {
//
//            let indexPath = IndexPath(row: index, section: 0)
//            let favors = self.tweets[index].favoritesCount
//            let retweets = self.tweets[index].retweetCount
//            if self.tweets[index].retweeted{
//                TwitterClient.sharedInstance.unretweetRequest(id: (tweet.id)!, success: { (tweet) in
//                    tweet.retweetCount = retweets-1
//                    tweet.retweeted = false
//                    tweet.retweeterName = self.tweets[index].retweetOfRetweetName
//                    self.tweets[index] = tweet
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }) { (error) in
//
//                }
//            } else{
//                TwitterClient.sharedInstance.retweetRequest(id: (tweet.id)!, success: { (tweet) in
//                    tweet.retweetCount = retweets+1
//                    tweet.retweeted = true
//                    tweet.retweetOfRetweetName = self.tweets[index].retweeterName
//                    self.tweets[index] = tweet
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }) { (error) in
//
//                }
//            }
//            self.tweets[index].favoritesCount = favors
//        }
        
        Tweet.toggleRetweet(tweet, tweetArray: tweets, success: { (tweet,index) in
            self.tweets[index] = tweet
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
//        if tweets != nil{
//            let (index,retweetedTweet) = Tweet.toggleRetweet(tweet, tweetArray: tweets)
//            if index != nil, retweetedTweet != nil{
//                    tweets[index!] = retweetedTweet!
//                    self.tableView.reloadRows(at: [IndexPath(row: index!, section: 0)], with: .automatic)
//            }
//        }
    }
    
    func toggleFavor(_ tweet: Tweet) {
//        if let index = tweets.index(of: tweet) {
//            let indexPath = IndexPath(row: index, section: 0)
//            let favors = self.tweets[index].favoritesCount
//            if self.tweets[index].favorited{
//                TwitterClient.sharedInstance.unfavorRequest(id: (tweet.id)!, success: { (tweet) in
//                    tweet.favoritesCount = favors-1
//                    tweet.favorited = false
//                    self.tweets[index] = tweet
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }) { (error) in
//                    print(error.localizedDescription)
//                }
//            } else{
//                TwitterClient.sharedInstance.favorRequest(id: (tweet.id)!, success: { (tweet) in
//                    tweet.favoritesCount = favors+1
//                    tweet.favorited = true
//                    self.tweets[index] = tweet
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                }) { (error) in
//                    print(error.localizedDescription)
//                }
//            }
//        }
        Tweet.toggleFavor(tweet, tweetArray: tweets, success: { (tweet,index) in
            self.tweets[index] = tweet
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func favorDetailTweet(_ tweet: Tweet) {
        if let index = tweets.index(of: tweet) {
            let indexPath = IndexPath(row: index, section: 0)
            TwitterClient.sharedInstance.favorRequest(id: (tweet.id)!, success: { (tweet) in
                self.tweets[index] = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func retweetDetail(_ tweet: Tweet) {
        if let index = tweets.index(of: tweet) {
            let indexPath = IndexPath(row: index, section: 0)
            TwitterClient.sharedInstance.retweetRequest(id: (tweet.id)!, success: { (tweet) in
                self.tweets[index] = tweet
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
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
            profileVC.screen_name = tweet.screenName
        }
        
        if(segue.identifier == "newTweetSegue"){
            let currentUser = self.user
            let navVC = segue.destination as? UINavigationController
            let tweetVC = navVC?.viewControllers.first as! newTweetViewController
            tweetVC.user = currentUser
        }
    }
}
