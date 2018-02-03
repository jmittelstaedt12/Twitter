//
//  TweetDetailsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/3/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

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
    var retweetLabelString: String = ""
    var favoriteLabelString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        usernameLabel.text = tweet?.name
        handleLabel.text = "@" + (tweet?.screenName)!
        userRetweetedLabel.text = (tweet?.retweeterName!)! + " Retweeted"
        tweetLabel.text = tweet?.text
        let ourTimeStamp: Date = (tweet?.timestamp)!
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy, h:mm a"
        let ourDate = dateformatter.string(from: ourTimeStamp)
        timeStampLabel.text = ourDate
        retweetLabel.text = retweetLabelString
        favoritesLabel.text = favoriteLabelString
        profileImageView.setImageWith((tweet?.profileURLHD)!)
        if tweet?.retweeted == true{
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else{
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon")
        }
        if tweet?.favorited == true{
            favoriteImageView.image = #imageLiteral(resourceName: "favor-icon-red")
        } else{
            favoriteImageView.image = #imageLiteral(resourceName: "favor-icon")
        }
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
        
        TwitterClient.sharedInstance.replyTimelineRequest(screen_name: tweet.screenName!, since_id: tweet.id, success: { (tweets) in
            self.replyTweets = tweets
            self.replyTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        profileImageView.isUserInteractionEnabled = true
        favoriteImageView.isUserInteractionEnabled = true
        retweetImageView.isUserInteractionEnabled = true
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapProfile))
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        let favorTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapFavor))
        favoriteImageView.addGestureRecognizer(favorTapGestureRecognizer)
        let retweetTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapRetweet))
        retweetImageView.addGestureRecognizer(retweetTapGestureRecognizer)
        
        if tweet?.retweeterName == ""{
            retweetHeightConstraint.constant = 0
        }else{
            retweetHeightConstraint.constant = 20
        }
        DispatchQueue.main.async {
            self.replyTableView.tableHeaderView?.frame = CGRect(x: self.replyTableView.frame.origin.x, y: self.replyTableView.frame.origin.y, width: self.view.frame.width, height: self.retweetImageView.frame.origin.y + 38)
            self.replyTableView.reloadData()
        }
    }
    
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
        
    }
    
    func toggleFavor(_ tweet: Tweet) {
        
    }
    
    func tweetSegue(_ cell: UITableViewCell) {
        
    }
    
    func profileSegue(_ cell: UITableViewCell) {
        
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
            profileVC.tweet = self.tweet
            profileVC.screen_name = self.tweet.screenName
        }
    }
}
