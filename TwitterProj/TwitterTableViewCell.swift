//
//  TwitterTableViewCell.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/27/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favorImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userRetweetedLabel: UILabel!
    @IBOutlet weak var imageInTweetView: UIImageView!
    @IBOutlet weak var retweetedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageInTweetHeightConstraint: NSLayoutConstraint!
    
    var imageInTweetHeight: Float!
    var retweetCountString = ""
    var favoritesCountString = ""
    var tweet: Tweet?{
        didSet{
            
            usernameLabel.text = tweet?.name
            handleLabel.text = "@" + (tweet?.screenName)!
            userRetweetedLabel.text = (tweet?.retweeterName)! + " Retweeted"
            retweetLabel.text = retweetCountString
            favoriteLabel.text = favoritesCountString
            tweetLabel.text = tweet?.text
            if tweet?.retweeted == true{
                retweetImageView.image = #imageLiteral(resourceName: "retweet-icon-green")
                
            } else{
                retweetImageView.image = #imageLiteral(resourceName: "retweet-icon")
            }
            if tweet?.favorited == true{
                favorImageView.image = #imageLiteral(resourceName: "favor-icon-red")
                
            } else{
                favorImageView.image = #imageLiteral(resourceName: "favor-icon")
            }
            let today = NSDate.init()
            var timeSince = Int(today.timeIntervalSince((tweet?.timestamp)!))
            if timeSince < 3600{
                timeSince = timeSince/60
                timeStampLabel.text = "\(timeSince)m"
            } else if timeSince < 86400{
                timeSince = timeSince/3600
                timeStampLabel.text = "\(timeSince)h"
            } else{
                timeSince = timeSince/86400
                timeStampLabel.text = "\(timeSince)d"
            }
            profileImageView.setImageWith((tweet?.profileURL)!)
            if tweet?.imageInTweetURL != nil{
                imageInTweetView.setImageWith((tweet?.imageInTweetURL)!)
                imageInTweetHeightConstraint.priority = 250
            }else{
                imageInTweetView.image = nil
                imageInTweetHeightConstraint.priority = 999
            }
            if tweet?.retweeterName == ""{
                retweetedHeightConstraint.constant = 0
            }else{
                retweetedHeightConstraint.constant = 20
            }
        }
    }
    weak var delegate: TweetCellActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
//        let imageFrame = self.imageInTweetView.frame
//        if self.imageInTweetView.image == nil{
//            self.imageInTweetView.frame = CGRect(x: imageFrame.origin.x, y: imageFrame.origin.y, width: imageFrame.width, height: 0)
//        }
//        else{
//            self.imageInTweetView.frame = imageFrame
//        }
    }
//    
//    override func prepareForReuse() {
//        
//    }
    
    func setupGestures(){

        let toggleRetweet = UITapGestureRecognizer(target: self, action: #selector(toggleRetweet(_:)))
        retweetImageView.addGestureRecognizer(toggleRetweet)
        retweetImageView.isUserInteractionEnabled = true

        let toggleFavor = UITapGestureRecognizer(target: self, action: #selector(toggleFavor(_ :)))
        favorImageView.addGestureRecognizer(toggleFavor)
        favorImageView.isUserInteractionEnabled = true
        
        let tapTweet = UITapGestureRecognizer(target: self, action: #selector(tweetSegue(_ :)))
        tweetLabel.addGestureRecognizer(tapTweet)
        tweetLabel.isUserInteractionEnabled = true
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(profileSegue(_ :)))
        profileImageView.addGestureRecognizer(tapImage)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc private func toggleRetweet(_ gesture: UITapGestureRecognizer){
        delegate?.toggleRetweet(tweet!)
    }
    
    @objc private func toggleFavor(_ gesture: UITapGestureRecognizer){
        delegate?.toggleFavor(tweet!)
    }
    
    @objc private func tweetSegue(_ gesture: UITapGestureRecognizer){
        delegate?.tweetSegue(self)
    }
    
    @objc private func profileSegue(_ gesture: UITapGestureRecognizer){
        delegate?.profileSegue(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

protocol TweetCellActions: class{
    func toggleRetweet(_ tweet: Tweet)
    func toggleFavor(_ tweet: Tweet)
    func tweetSegue(_ cell: UITableViewCell)
    func profileSegue(_ cell: UITableViewCell)
}
