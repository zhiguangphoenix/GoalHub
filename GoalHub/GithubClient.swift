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
        updateUserAndToken()
    }
    
    func updateUserAndToken() {
        let defaults = UserDefaults.standard
        
        if let tokenString = defaults.string(forKey: "token") {
            token = tokenString
        }
        if let userString = defaults.string(forKey: "user") {
            user = userString
        }
    }
    
    func fetchProfile() {
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
                        NSLog(result)
                    } catch let error {
                        NSLog("Invalid regexp: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
