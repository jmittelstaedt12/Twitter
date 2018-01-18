//
//  User.swift
//  TwitterProj
//
//  Created by Jacob Mittelstaedt on 2/26/17.
//  Copyright © 2017 Jacob Mittelstaedt. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var tagLine: String?
    var dictionary: NSDictionary?
    var userTweets: [Tweet]!
    
    init(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        if let profileURLString = dictionary["profile_image_url_https"] as?
            String {
            profileURL = URL(string: profileURLString.replacingOccurrences(of: "_normal", with: ""))
            
        }
        
        tagLine = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotificationName = NSNotification.Name(rawValue:
        "UserDidLogout")
    static var _currentUser : User?
    
    class var currentUser : User? {
        set {
            let user = newValue
            _currentUser = user
            let defaults = UserDefaults.standard
            if user != nil {
            let data = try! JSONSerialization.data(withJSONObject: (user?.dictionary)!, options: [])
                defaults.setValue(data, forKey: "currentUser")
            }else {
                defaults.removeObject(forKey: "currentData")

            }
            defaults.synchronize()
        }
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.object(forKey: "currentUser") as?
                    Data {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
    }
}
