//: Playground - noun: a place where people can play

import Alamofire
import SwiftyJSON

let url = "https://randomuser.me/api/"

Alamofire.request(.GET, url).validate().responseJSON {response in
    if (response.result.isSuccess) {
        if let response = response.result.value {
            print(JSON(response))
        }
    } else {
        print("oh, no!")
    }
}

let foo : Double! = 8 / 0

