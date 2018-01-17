//
//  Tweet.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/26/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var retweeterName: String?
    var tweetDictionary: NSDictionary!
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var profileURLHD: URL?
    var text: String?
    var timestamp : Date?
    var retweetCount : Int = 0
    var favoritesCount : Int = 0
    var id: String!
    var retweeted: Bool
    var favorited: Bool
    var statusCount: Int = 0
    var followersCount: Int = 0
    var followingCount: Int = 0
    var profileBackgroundURL: URL?
    
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
        text = tweetDictionary["text"] as? String
        retweetCount = (tweetDictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (tweetDictionary["favorite_count"] as? Int) ?? 0
        retweeted = (tweetDictionary.value(forKeyPath: "retweeted") as? Bool)!
        favorited = (tweetDictionary.value(forKeyPath: "favorited") as? Bool)!
        statusCount = (tweetDictionary.value(forKeyPath: "user.statuses_count") as? Int)!
        followersCount = (tweetDictionary.value(forKeyPath: "user.followers_count") as? Int)!
        followingCount = (tweetDictionary.value(forKeyPath: "user.friends_count") as? Int)!
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
        id = tweetDictionary["id_str"] as! String
    }
    
    class func tweetsWithArray(dictionaries : [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        dictionaries.forEach { (dictionary) in tweets.append(Tweet(dictionary:
            dictionary)) }
        
        return tweets
    }
}
