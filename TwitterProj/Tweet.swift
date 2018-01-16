//
//  Tweet.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/26/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
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
        
        screenName = dictionary.value(forKeyPath: "user.screen_name") as? String
        name = dictionary.value(forKeyPath: "user.name") as? String
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweeted = (dictionary.value(forKeyPath: "retweeted") as? Bool)!
        favorited = (dictionary.value(forKeyPath: "favorited") as? Bool)!
        statusCount = (dictionary.value(forKeyPath: "user.statuses_count") as? Int)!
        followersCount = (dictionary.value(forKeyPath: "user.followers_count") as? Int)!
        followingCount = (dictionary.value(forKeyPath: "user.friends_count") as? Int)!
        if let profileURLString = dictionary.value(forKeyPath: "user.profile_image_url_https") as? String {
            profileURL = URL(string: profileURLString)
            profileURLHD = URL(string: profileURLString.replacingOccurrences(of: "_normal", with: ""))
        }
        if let profileBackgroundURLString = dictionary.value(forKeyPath: "user.profile_banner_url") as? String {
            profileBackgroundURL = URL(string: profileBackgroundURLString)
        }
        
        if let timestampString = dictionary["created_at"] as? String {
            timestamp = dateFormatter.date(from: timestampString)
        }
        id = dictionary["id_str"] as! String
    }
    
    class func tweetsWithArray(dictionaries : [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        dictionaries.forEach { (dictionary) in tweets.append(Tweet(dictionary:
            dictionary)) }
        
        return tweets
    }
}
