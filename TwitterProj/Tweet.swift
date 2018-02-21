//
//  Tweet.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/26/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var retweeterName: String!
    var tweetDictionary: NSDictionary!
    var retweetOfRetweetName: String?
    var name: String!
    var screenName: String!
    var profileURL: URL!
    var profileURLHD: URL!
    var text: String!
    var timestamp : Date!
    var retweetCount : Int = 0
    var favoritesCount : Int = 0
    var id: String!
    var retweeted: Bool!
    var favorited: Bool!
    var statusCount: Int = 0
    var followersCount: Int = 0
    var followingCount: Int = 0
    var profileBackgroundURL: URL!
    var imageInTweetURL: URL?
    private var dateFormatter : DateFormatter = {
        
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        return dFormatter
    }()
    
    init(dictionary : NSDictionary) {
        
        retweeterName = dictionary.value(forKeyPath: "user.name") as? String
        tweetDictionary = dictionary["retweeted_status"] as? NSDictionary
        if tweetDictionary == nil{
            tweetDictionary = dictionary
            retweeterName = ""
        }
        screenName = tweetDictionary.value(forKeyPath: "user.screen_name") as? String
        name = tweetDictionary.value(forKeyPath: "user.name") as? String
        text = tweetDictionary["full_text"] as? String
        retweetCount = (tweetDictionary["retweet_count"] as? Int)!
        favoritesCount = (tweetDictionary["favorite_count"] as? Int)!
        statusCount = (tweetDictionary.value(forKeyPath: "user.statuses_count") as? Int)!
        followersCount = (tweetDictionary.value(forKeyPath: "user.followers_count") as? Int)!
        followingCount = (tweetDictionary.value(forKeyPath: "user.friends_count") as? Int)!
        retweeted = (tweetDictionary.value(forKeyPath: "retweeted") as? Bool)!
        favorited = (tweetDictionary.value(forKeyPath: "favorited") as? Bool)!
        id = tweetDictionary["id_str"] as! String
        if let profileURLString = tweetDictionary.value(forKeyPath: "user.profile_image_url_https") as? String {
            profileURL = URL(string: profileURLString)
            profileURLHD = URL(string: profileURLString.replacingOccurrences(of: "_normal", with: ""))
        }
        if let profileBackgroundURLString = tweetDictionary.value(forKeyPath: "user.profile_banner_url") as? String {
            profileBackgroundURL = URL(string: profileBackgroundURLString)
        }
        
        if let timestampString = tweetDictionary["created_at"] as? String {
            timestamp = dateFormatter.date(from: timestampString)
        }
        if let imageInTweetArray = (tweetDictionary.value(forKeyPath: "extended_entities.media")) as? Array<NSDictionary> {
            imageInTweetURL = URL(string: imageInTweetArray[0].value(forKeyPath: "media_url_https") as! String)
        }else{
            imageInTweetURL = nil
        }
    }
    
    class func tweetsWithArray(dictionaries : [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        dictionaries.forEach { (dictionary) in tweets.append(Tweet(dictionary:
            dictionary)) }
        return tweets
    }
    
    class func shortenNumber(num : Int) -> String{
        var shortened = "\(num)"
        if num > 9999{
            if num > 99999{
                if num > 999999{
                    if num > 9999999{
                        shortened = "\(round((Double(num)*10)/1000000)/10)M"
                    }else{shortened = "\(round((Double(num)*100)/1000000)/100)M"}
                }else{shortened = "\(Int(round(Double(num)/1000)))K"}
            }else{shortened = "\(round(Double(num)*10/1000)/10)K"}
        }
        return shortened
    }
    
    class func toggleRetweet(_ tweet: Tweet,tweetArray: [Tweet], success: @escaping ((Tweet,Int) -> ()), failure : @escaping ((Error) -> ())){
        guard let index = tweetArray.index(of: tweet) else{
            print("No replies or reply not found")
            return
        }
        let retweets = tweetArray[index].retweetCount
        if tweetArray[index].retweeted{
            TwitterClient.sharedInstance.unretweetRequest(id: (tweet.id)!, success: { (tweet) in
                tweet.retweetCount = retweets-1
                tweet.retweeted = false
                success(tweet,index)
            }) { (error) in
                failure(error)
            }
        } else{
            TwitterClient.sharedInstance.retweetRequest(id: (tweet.id)!, success: { (tweet) in
                tweet.retweetCount = retweets+1
                tweet.retweeted = true
                success(tweet,index)
            }) { (error) in
                failure(error)
            }
        }
    }
    
    class func toggleFavor(_ tweet: Tweet,tweetArray: [Tweet], success: @escaping ((Tweet,Int) -> ()), failure: @escaping ((Error) -> ())){
        guard let index = tweetArray.index(of: tweet) else{
            print("No replies or reply not found")
            return
        }
        let favors = tweetArray[index].favoritesCount
        if tweetArray[index].favorited{
            TwitterClient.sharedInstance.unfavorRequest(id: (tweet.id)!, success: { (tweet) in
                tweet.favoritesCount = favors-1
                tweet.favorited = false
                success(tweet,index)
            }) { (error) in
                failure(error)
            }
        } else{
            TwitterClient.sharedInstance.favorRequest(id: (tweet.id)!, success: { (tweet) in
                tweet.favoritesCount = favors+1
                tweet.favorited = true
                success(tweet,index)
            }) { (error) in
                failure(error)
            }
        }
    }
}
