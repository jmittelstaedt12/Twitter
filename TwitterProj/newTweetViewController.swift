//
//  newTweetViewController.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 3/5/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class newTweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    
    var tweetText: String!
    var user: User?
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "tweetToMainSegue", sender: nil)
    }
    
    @IBAction func tweetButton(_ sender: UIBarButtonItem) {
        tweetText = tweetTextView.text
        let paramsDict: NSDictionary = NSDictionary(dictionary: ["status" : tweetText!])
        
        TwitterClient.sharedInstance.createTweet(tweetText: tweetText!, params: paramsDict, completion: { (error) -> () in
            print("Composing")
            print(error?.localizedDescription)
        })
        
        performSegue(withIdentifier: "tweetToMainSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = user?.name
        handleLabel.text = user?.screenName
        profileImageView.setImageWith((user?.profileURL)!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


/*
    // In a storyboard-based application, you will often want to do a littl*preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }*/

}
