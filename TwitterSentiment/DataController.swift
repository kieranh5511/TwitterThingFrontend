//
//  DataController.swift
//  TwitterSentiment
//
//  Created by Kieran Hall on 23/04/2016.
//  Copyright © 2016 HackSussex. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataController {
    let url = "https://randomuser.me/api/"
    var previousSentiment : [String: Double]

    init() {
        previousSentiment = [String: Double]()
    }
    
    func getData(updateCallback: JSON -> Void) {
        Alamofire.request(.GET, url).validate().responseJSON {response in
            if (response.result.isSuccess) {
                if let response = response.result.value {
                    var json = JSON(response)
                    for (hashtag, data) in json {
                        var increasingSentiment = false
                        let sentiment : Double = data["positive"].double!/data["negative"].double!
                        if (self.previousSentiment[hashtag] == nil) {
                            self.previousSentiment[hashtag] = sentiment
                        } else {
                            let deltaSentiment : Double = 5
                            increasingSentiment = self.previousSentiment[hashtag] < sentiment
                            self.previousSentiment[hashtag]! += increasingSentiment ? -deltaSentiment : deltaSentiment
                        }
                        json[hashtag]["trend"] = JSON(self.previousSentiment[hashtag]!)
                        json[hashtag]["sentiment"] = JSON(sentiment)
                    }
                    updateCallback(JSON(response))
                }
            }
        }
    }
    
    func removeHashtag(hashtag : String) {
        Alamofire.request(.DELETE, url, parameters: ["hashtag": hashtag])
        previousSentiment[hashtag] = nil
    }
    
    func followHashtag(hashtag : String) {
        Alamofire.request(.POST, url, parameters: ["hashtag": hashtag])
    }
}