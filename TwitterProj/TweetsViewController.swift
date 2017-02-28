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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets : [Tweet])
            in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text!)
            }
            }) { (error) in
            print(error.localizedDescription)
            }
        self.tableView.reloadData()
        }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.filteredData?[0] ?? "nada")
            return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //print(self.filteredData?[0] ?? "nada")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterTableViewCell",for: indexPath) as! TwitterTableViewCell
        let ourTweet = tweets[indexPath.row]
        cell.tweetLabel.text = ourTweet.text
        return cell
    }
}
