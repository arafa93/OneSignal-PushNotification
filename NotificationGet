//
//  NotificationPost.swift
//  beehive services
//
//  Created by Mohamed Arafa on 8/11/18.
//  Copyright © 2018 Swaqny. All rights reserved.
//

import Foundation

struct NotificationGet : Codable{
    
    let app_id:String
    let filters:[filters]
    var headings: [String: String] = ["en":"title"]
    var contents: [String: String] = ["en":"message"]
    var subtitle: [String: String] = ["en":"SubTitle"]
    var content_available : Bool

}



struct filters : Codable{
    
    let field:String
    let key:String
    let relation:String
    let value:String
}
