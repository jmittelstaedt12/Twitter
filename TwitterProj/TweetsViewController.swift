//
//  TweetsViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/27/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        cell.usernameLabel.text = user.name
        cell.tweetLabel.text = ourTweet.text
        cell.timeStampLabel.text = "\((ourTweet.timestamp)!)"
        cell.profileImageView.setImageWith(user.profileURL!)
        return cell
    }
}
