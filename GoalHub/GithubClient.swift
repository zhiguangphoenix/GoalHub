//
//  GithubClient.swift
//  GoalHub
//
//  Created by 杨钺 on 2018/2/10.
//  Copyright © 2018年 ilime. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GithubClient {
    let BASE_URL = "https://api.github.com"
    var user = ""
    var token = ""
    
    init() {
        updateUser()
        updateToken()
    }
    
    func updateUser() {
        let defaults = UserDefaults.standard
        
        if let userString = defaults.string(forKey: "user") {
            user = userString
        }
    }
    
    func updateToken() {
        let defaults = UserDefaults.standard
        
        if let tokenString = defaults.string(forKey: "token") {
            token = tokenString
        }
    }
    
    func fetchProfile(callback: @escaping (String) -> Void) {
        if user != "" {
            Alamofire.request("https://github.com/\(user)").responseString { response in
                if response.result.isSuccess {
                    let docString = String(describing: response.result.value)
                    
                    do {
                        let regexp = try NSRegularExpression(pattern: "[0-9]+\\scontributions")
                        let resultRange = regexp
                            .firstMatch(in: docString, range: NSRange(docString.startIndex..., in: docString))?
                            .range
                        let result = String(docString[Range(resultRange!, in: docString)!])
                        
                        callback(result)
                    } catch let error {
                        NSLog("Invalid regexp: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func fetchEvents(callback: @escaping ([String: Int]) -> Void) {
        if user != "" {
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            var eventsDict: [String: Int] = [
                "PUSH": 0,
                "ISSUE": 0,
                "PULLREQUEST": 0,
                "STAR": 0,
                "CREATE": 0,
                "GIST": 0
            ]

            Alamofire.request(
                "\(BASE_URL)/users/\(user)/events\(token != "" ? "?access_token=" + token : "")",
                headers: headers)
                .responseJSON { response in
                    if let val = response.result.value {
                        let json = JSON(val)
                        
                        json.arrayValue.forEach {
                            switch $0["type"].stringValue {
                            case "PushEvent":
                                eventsDict["PUSH"]! += 1
                            case "IssuesEvent":
                                eventsDict["ISSUE"]! += 1
                            case "PullRequestEvent":
                                eventsDict["PULLREQUEST"]! += 1
                            case "WatchEvent":
                                eventsDict["STAR"]! += 1
                            case "CreateEvent":
                                eventsDict["CREATE"]! += 1
                            case "GistEvent":
                                eventsDict["GIST"]! += 1
                            default:
                                ()
                            }
                        }
                        
                        Alamofire.request(
                            "\(self.BASE_URL)/users/\(self.user)/events\(self.token != "" ? "?page=2&access_token=" + self.token : "?page=2")",
                            headers: headers)
                            .responseJSON { response in
                                if let val = response.result.value {
                                    let json = JSON(val)
                                    
                                    json.arrayValue.forEach {
                                        switch $0["type"].stringValue {
                                        case "PushEvent":
                                            eventsDict["PUSH"]! += 1
                                        case "IssuesEvent":
                                            eventsDict["ISSUE"]! += 1
                                        case "PullRequestEvent":
                                            eventsDict["PULLREQUEST"]! += 1
                                        case "WatchEvent":
                                            eventsDict["STAR"]! += 1
                                        case "CreateEvent":
                                            eventsDict["CREATE"]! += 1
                                        case "GistEvent":
                                            eventsDict["GIST"]! += 1
                                        default:
                                            ()
                                        }
                                    }
                                    
                                    callback(eventsDict)
                                }
                        }
                    }
            }
        }
    }
}
