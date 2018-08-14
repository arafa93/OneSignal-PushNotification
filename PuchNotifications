//
//  PussNotification.swift
//  beehive services
//
//  Created by Mohamed Arafa on 8/13/18.
//  Copyright © 2018 Swaqny. All rights reserved.
//

import UIKit
import OneSignal

struct PuchNotifications{
    static func PushNotification(tag:Int,headings:String,content:String,subtitle:String,key:String,content_available:Bool,completed : @escaping ()->()){
        // -- Mark - Start of Push Notification
        guard let url = URL(string: "https://onesignal.com/api/v1/notifications") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic NDMzODZlMTctZDYxZi00ZmE1LWEyMjgtYjQ5NzU0NzdmMjU2", forHTTPHeaderField: "Authorization")
        
        let filt = [filters(field: "tag", key: key, relation: "=", value: "\(tag)")]
        
        let SupE = NotificationGet(app_id: "67b34326-6383-497f-86a4-fb08d3d0e628", filters: filt, headings: ["en":headings], contents: ["en":content], subtitle: ["en":subtitle], content_available : content_available)
        
        let encoder = JSONEncoder()
        do {
            let SupEmailJson = try encoder.encode(SupE)
            request.httpBody = SupEmailJson
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data else {return}
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                
                print("json" , json)
                
            } catch let error  {
                print(error)
                
            }
            
        }
        task.resume()
    }
}
