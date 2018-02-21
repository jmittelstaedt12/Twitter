//
//  TweetDetailsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/3/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellActions {
    
    @IBOutlet weak var replyTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var imageInTweetView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var userRetweetedLabel: UILabel!
    @IBOutlet weak var retweetHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var favorImageTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var imageInTweetHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageInTweetToTweetConstraint: NSLayoutConstraint!
    @IBAction func homeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var tweet: Tweet!
    var replyTweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        usernameLabel.text = tweet.name
        handleLabel.text = "@" + tweet.screenName
        userRetweetedLabel.text = (tweet.retweeterName != "") ? tweet.retweeterName + " Retweeted" : ""
        tweetLabel.text = tweet.text
        let ourTimeStamp: Date = tweet.timestamp
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy, h:mm a"
        let ourDate = dateformatter.string(from: ourTimeStamp)
        timeStampLabel.text = ourDate
        retweetLabel.text = Tweet.shortenNumber(num: tweet.retweetCount)
        favoritesLabel.text = Tweet.shortenNumber(num: tweet.favoritesCount)
        profileImageView.setImageWith(tweet.profileURLHD)
        retweetImageView.image = (tweet.retweeted == true) ? #imageLiteral(resourceName: "retweet-icon-green") : #imageLiteral(resourceName: "retweet-icon")
        favoriteImageView.image = (tweet.favorited == true) ? #imageLiteral(resourceName: "favor-icon-red") : #imageLiteral(resourceName: "favor-icon")
        if (tweet.imageInTweetURL != nil){
            imageInTweetView.setImageWith(tweet.imageInTweetURL!)
            let imageAspect = Double((imageInTweetView.image?.size.width)!)/Double((imageInTweetView.image?.size.height)!)
            imageInTweetHeightConstraint.constant = CGFloat(Double((imageInTweetView.frame.width))/imageAspect)
        }else{
            imageInTweetHeightConstraint.constant = 0
            imageInTweetToTweetConstraint.constant = 0
        }
        retweetImageLeadingConstraint.constant = (self.view.frame.width-60)/3
        favorImageTrailingConstant.constant = retweetImageLeadingConstraint.constant
        
        replyTableView.dataSource = self
        replyTableView.delegate = self
        replyTableView.estimatedRowHeight = 200
        replyTableView.rowHeight = UITableViewAutomaticDimension
        replyTableView.tableHeaderView = headerView
        
        profileImageView.isUserInteractionEnabled = true
        favoriteImageView.isUserInteractionEnabled = true
        retweetImageView.isUserInteractionEnabled = true
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapProfile))
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        let favorTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapFavor))
        favoriteImageView.addGestureRecognizer(favorTapGestureRecognizer)
        let retweetTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapRetweet))
        retweetImageView.addGestureRecognizer(retweetTapGestureRecognizer)
        
        if tweet.retweeterName == ""{
            retweetHeightConstraint.constant = 0
        }else{
            retweetHeightConstraint.constant = 20
        }
        DispatchQueue.main.async {
            self.replyTableView.tableHeaderView?.frame = CGRect(x: self.replyTableView.frame.origin.x, y: self.replyTableView.frame.origin.y, width: self.view.frame.width, height: self.retweetImageView.frame.origin.y + 38)
            self.replyTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.sharedInstance.replyTimelineRequest(screen_name: tweet.screenName, since_id: tweet.id, success: { (tweets) in
            self.replyTweets = tweets
            self.replyTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }    }
    
    func tapProfile(){
        performSegue(withIdentifier: "profileSegue", sender: tweet)
    }
    
    func tapRetweet(){
        let favors = tweet.favoritesCount
        let retweets = tweet.retweetCount
            if tweet.retweeted{
                TwitterClient.sharedInstance.unretweetRequest(id: (tweet.id)!, success: { (tweetBack) in
                    tweetBack.retweetCount = retweets-1
                    tweetBack.retweeted = false
                    self.tweet = tweetBack
                    self.viewDidLoad()
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else{
                TwitterClient.sharedInstance.retweetRequest(id: (tweet.id)!, success: { (tweetBack) in
                    tweetBack.retweetCount = retweets+1
                    tweetBack.retweeted = true
                    self.tweet = tweetBack
                    self.viewDidLoad()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            tweet.favoritesCount = favors
    }
    
    func tapFavor(){
        let favors = tweet.favoritesCount
        if tweet.favorited{
            TwitterClient.sharedInstance.unfavorRequest(id: (tweet.id)!, success: { (tweetBack) in
                tweetBack.favoritesCount = favors-1
                tweetBack.favorited = false
                self.tweet = tweetBack
                self.viewDidLoad()
            }) { (error) in
                print(error.localizedDescription)
            }
        } else{
            TwitterClient.sharedInstance.favorRequest(id: (tweet.id)!, success: { (tweetBack) in
                tweetBack.favoritesCount = favors+1
                tweetBack.favorited = true
                self.tweet = tweetBack
                self.viewDidLoad()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweetcount = self.replyTweets?.count {
            return tweetcount
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell",for: indexPath) as! TwitterTableViewCell
        let ourTweet = self.replyTweets?[indexPath.row]
        cell.tweet = ourTweet
        cell.delegate = self
        return cell
    }
    
    func toggleRetweet(_ tweet: Tweet) {
        if replyTweets == nil{
            return
        }
        Tweet.toggleRetweet(tweet, tweetArray: replyTweets!, success: { (tweet,index) in
            self.replyTweets![index] = tweet
            self.replyTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func toggleFavor(_ tweet: Tweet) {
        if replyTweets == nil{
            return
        }
        Tweet.toggleFavor(tweet, tweetArray: replyTweets!, success: { (tweet,index) in
            self.replyTweets![index] = tweet
            self.replyTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tweetSegue(_ cell: UITableViewCell) {
        let thisTweet = replyTweets?[replyTableView.indexPath(for: cell)!.row]
        guard replyTweets != nil,self.tweet.screenName != thisTweet?.screenName else{
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.tweet = thisTweet!
        viewDidLoad()
        viewWillAppear(true)
        replyTableView.setContentOffset(CGPoint.zero, animated: false)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func profileSegue(_ cell: UITableViewCell) {
        performSegue(withIdentifier: "profileSegue", sender: cell)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "replySegue") {
            let navVC = segue.destination as? UINavigationController
            let replyVC = navVC?.viewControllers.first as! replyViewController
            let tweetPass = self.tweet
            replyVC.tweet = tweetPass
        }
        
        if(segue.identifier == "profileSegue"){
            let profileVC = segue.destination as! profileViewController
            if let cell = sender as? TwitterTableViewCell{
                let indexPath = replyTableView.indexPath(for: cell)
                let tweet = replyTweets![indexPath!.row]
                profileVC.tweet = tweet
            }else{
                profileVC.tweet = self.tweet
            }
        }
    }
}
