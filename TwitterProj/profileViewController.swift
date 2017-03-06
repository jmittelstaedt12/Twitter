//
//  profileViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = tweet?.name
        handleLabel.text = "@" + (tweet?.screenName)!
        profileImageView.setImageWith((tweet?.profileURL)!)
        if let backgroundURL = tweet?.profileBackgroundURL{
            bannerImageView.setImageWith(backgroundURL)
        }
        tweetCountLabel.text = "\((tweet?.statusCount)!)"
        followingCountLabel.text = "\((tweet?.followingCount)!)"
        followersCountLabel.text = "\((tweet?.followersCount)!)"
        let ourTimeStamp: Date = (tweet?.timestamp)!
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy, h:mm a"
        let ourDate = dateformatter.string(from: ourTimeStamp)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
