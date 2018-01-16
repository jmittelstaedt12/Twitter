//
//  TweetDetailsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/3/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBAction func homeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: TweetDetailActions?
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestures()
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

    }
    
    func setupGestures(){
        let tapFavor = UITapGestureRecognizer(target: self, action: #selector(favorDetailTweet(_:)))
        favoriteImageView.addGestureRecognizer(tapFavor)
        favoriteImageView.isUserInteractionEnabled = true
        
        let tapRetweet = UITapGestureRecognizer(target: self, action: #selector(retweetDetail(_:)))
        retweetImageView.addGestureRecognizer(tapRetweet)
        retweetImageView.isUserInteractionEnabled = true
    }
    @objc private func favorDetailTweet(_ gesture: UITapGestureRecognizer){
        delegate?.favorDetailTweet(tweet!)
        TwitterClient.sharedInstance.favorRequest(id: (self.tweet?.id)!, success: { (tweet) in
            
        }) { (error) in
            
        }
    }
    func retweetDetail(_ gesture: UITapGestureRecognizer){
        delegate?.retweetDetail(tweet!)
        TwitterClient.sharedInstance.retweetRequest(id: (self.tweet?.id)!, success: { (tweet) in
        }) { (error) in
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "replySegue") {
            let navVC = segue.destination as? UINavigationController
            let replyVC = navVC?.viewControllers.first as! replyViewController
            let tweetPass = self.tweet
            replyVC.tweet = tweetPass
            
            
            print("hey")

        }
    }
}
protocol TweetDetailActions: class{
    func favorDetailTweet(_ tweet: Tweet)
    func retweetDetail(_ tweet: Tweet)
}
