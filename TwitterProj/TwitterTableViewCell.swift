//
//  TwitterTableViewCell.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/27/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {

    var tweet: Tweet?{
        didSet{
            usernameLabel.text = tweet?.name
            handleLabel.text = "@" + (tweet?.screenName)!
            retweetLabel.text = "\((tweet?.retweetCount)!)"
            favoriteLabel.text = "\((tweet?.favoritesCount)!)"
            tweetLabel.text = tweet?.text
            
            //cell.timeStampLabel.text = "\((ourTweet.timestamp)!)"
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

        }
    }
    @IBOutlet weak var favorImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    weak var delegate: TweetCellActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
    }
    
    func setupGestures(){
        let tapFavor = UITapGestureRecognizer(target: self, action: #selector(favorTweet(_ :)))
        favorImageView.addGestureRecognizer(tapFavor)
        favorImageView.isUserInteractionEnabled = true
        
        let tapRetweet = UITapGestureRecognizer(target: self, action: #selector(retweet(_ :)))
        retweetImageView.addGestureRecognizer(tapRetweet)
        retweetImageView.isUserInteractionEnabled = true
        
    }
    @objc private func favorTweet(_ gesture: UITapGestureRecognizer){
       delegate?.favorTweet(tweet!)
        
    }
    
    @objc private func retweet(_ gesture: UITapGestureRecognizer){
        delegate?.retweet(tweet!)
    }
    
    @objc private func toggleRetweet(_ gesture: UITapGestureRecognizer){
        delegate?.toggleRetweet(tweet!)
    }
    
    @objc private func toggleFavor(_ gesture: UITapGestureRecognizer){
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol TweetCellActions: class{
    func favorTweet(_ tweet: Tweet)
    func retweet(_ tweet: Tweet)
    func toggleRetweet(_ tweet: Tweet)
    func toggleFavor(_ tweet: Tweet)
}
