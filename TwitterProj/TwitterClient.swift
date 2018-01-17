//
//  TwitterClient.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/27/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!,
        consumerKey:
        "KjyzHlNNBt3E35lAVuJVxHDZO",
        consumerSecret: "8W8GfM1COtot7L9IRVubOXZ7QvHUWVj1ednM86xYUSgNjlOKyP")!
    var loginSuccess : (() -> ())?
    var loginFailure : ((Error) -> ())?
    
    func login(success : @escaping ()->(), failure: @escaping (Error)->()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token",
                                                       method: "GET", callbackURL: URL(string:
                                                        "twitterproj://oauth"),
                                                        scope: nil,
                                                        success:
                                                        { (requestToken) in
                                                            let url = URL(string:
                                                                "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
                                                            
                                                            UIApplication.shared.open(url)
                                                            
    }, failure: { (error) in
    print("Error: \(error!.localizedDescription)")
    self.loginFailure?(error!)
    })
}
    func logout(){
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogoutNotificationName, object: nil)
    }
    func handleOpenURL(_ url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token",
        method: "POST",
        requestToken: requestToken,
        success: { (accessToken) in
        self.loginSuccess?()
        }) { (error) in
        print("error: \(error!.localizedDescription)")
        self.loginFailure?(error!)
        }
    }
    func homeTimeline(max_id: String = "", success: @escaping (([Tweet]) -> ()), failure : @escaping
        (Error) -> ()) {
        var getString = "1.1/statuses/home_timeline.json?count=20"
        if max_id != ""{
            getString = "1.1/statuses/home_timeline.json?count=20&max_id=\(max_id)"
        }
        get(getString,
            parameters: nil,
            progress: nil,
            success: { (task, response) in
                print("this succeeded")
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries:
                    dictionaries)
                success(tweets)
    }, failure: { (task, error) in
        print("this failed")
        failure(error)
    })
    }
    
    func retweetRequest(id : String, success: @escaping ((Tweet) -> ()), failure : @escaping
        (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json",
            parameters: nil,
            progress: nil,
            success: { (task, response) in
                    print("retweet succeeded")
                    let dictionary = response as! NSDictionary
                    let tweet = Tweet(dictionary: dictionary)
                    print("retweetcount: \(tweet.retweetCount)")
                    print("favorcount: \(tweet.favoritesCount)")
                success(tweet)
        }, failure: { (task, error) in
            print("1.1/statuses/retweet/\(id).json")
            print("retweet failed \(error.localizedDescription)")
            failure(error)
        })
    }
    func favorRequest(id : String, success: @escaping ((Tweet) -> ()), failure : @escaping
        (Error) -> ()) {
        post("1.1/favorites/create.json?id=\(id)",
            parameters: nil,
            progress: nil,
            success: { (task, response) in
                print("favor succeeded")
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                print("retweetcount: \(tweet.retweetCount)")
                print("favorcount: \(tweet.favoritesCount)")
                success(tweet)
        }, failure: { (task, error) in
            print("favor failed \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func createTweet(tweetText : String, params: NSDictionary?, completion: @escaping (_ error: Error?) -> ()) {
        post("1.1/statuses/update.json",
            parameters: params,
            progress: nil,
            success: {(operation: URLSessionDataTask!, response: Any?) -> Void in
                print("tweet succeeded: \(tweetText)")
                completion(nil)
        }, failure: { (operation: URLSessionDataTask?, error: Error?) -> Void in
            print("Couldn't compose")
            completion(error as Error?)
        })
    }
    func currentAccount(success: @escaping ((User) -> ()), failure : @escaping
        ((Error) -> ())) {
        get("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task, response) in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
               success(user)
        }, failure: {(task, error) in
            failure(error)}
        )
    }
    
    func unretweetRequest(id : String, success: @escaping ((Tweet) -> ()), failure : @escaping
        (Error) -> ()) {
        post("1.1/statuses/unretweet/\(id).json",parameters: nil,progress: nil,
             success: {(task, response) in
                
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                tweet.retweeted = false
                tweet.retweetCount -= 1
                success(tweet)
                
        },failure: {(task, error) in
            failure(error)})
    }
    func unfavorRequest(id : String, success: @escaping ((Tweet) -> ()), failure : @escaping
        (Error) -> ()) {
        post("1.1/favorites/destroy.json?id=\(id)",parameters: nil,progress: nil,
             success: {(task, response) in
                
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
        },failure: {(task, error) in
            failure(error)})
    }
    
    func userTimelineRequest(screen_name : String, success: @escaping (([Tweet]) -> ()), failure : @escaping
        (Error) -> ()){
        get("1.1/statuses/user_timeline.json?screen_name=\(screen_name)&count=20",parameters: nil,progress: nil,
            success: {(task, response) in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
        },failure: {(task,error) in
            failure(error)})
    }
}
