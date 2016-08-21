//
//  Client.swift
//  TestA
//
//  Created by gecko on 21/08/16.
//  Copyright © 2016 Chamsidine ATTOUMANI. All rights reserved.
//

import Foundation

class  Client {
//    var accessToken: String
//    var tokenType: String
//    var expiresIn: Int
//    var scope: String
//    var createdAt: Int
    var uid: String
    var secret: String
    var url: String
    
    
    init(uid: String, secret: String, url: String) {
        self.uid = uid
        self.secret = secret
        self.url = url
    }
    
    func SetUpClient() {
        let formattedUrl = String(format: "%@?grant_type=client_credentials&client_id=%@&client_secret=%@", url, uid, secret)
        let requURL = NSURL(string: formattedUrl)!
        let request = NSMutableURLRequest(URL: requURL)
        let session = NSURLSession.sharedSession()
        
        do {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                // do something with the response
                if error != nil {
                    print("error: \(error)")
                }
                else {
                    print("response: \(response)")
                }
            })
            task.resume()
        }
    }
}
