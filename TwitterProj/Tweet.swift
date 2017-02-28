//
//  Tweet.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/26/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp : Date?
    var retweetCount : Int = 0
    var favoritesCount : Int = 0
    
    private var dateFormatter : DateFormatter = {
        
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        return dFormatter
    }()
    
    init(dictionary : NSDictionary) {
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_counrt"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_counrt"] as? Int) ?? 0
        
        if let timestampString = dictionary["created_at"] as? String {
            timestamp = dateFormatter.date(from: timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries : [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        dictionaries.forEach { (dictionary) in tweets.append(Tweet(dictionary:
            dictionary)) }
        
        return tweets
    }
}
