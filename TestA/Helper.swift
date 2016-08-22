//
//  Helper.swift
//  TestA
//
//  Created by gecko on 22/08/16.
//  Copyright © 2016 Chamsidine ATTOUMANI. All rights reserved.
//

import Foundation

class Helper {
    class func parseJSON(jsonString: String) -> [String: AnyObject]? {
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
            else {return nil}
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    class func collectAuthInfo(client: ClientSession, callback: (auth: AuthInfo?, error: NSError?) -> Void){
        let formattedUrl = String(format: "%@?grant_type=client_credentials&client_id=%@&client_secret=%@", client.authURL, client.uid, client.secret)
        let requURL = NSURL(string: formattedUrl)!
        let request = NSMutableURLRequest(URL: requURL)
        let session = NSURLSession.sharedSession()
        let auth = AuthInfo()
        
        do {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                // do something with the response
                if error != nil {
                    print("error: \(error)")
                    callback(auth: nil, error: error)
                }
                else {
                    let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                    if let result = dataString{
                        if let dictionary = Helper.parseJSON(result) {
                            auth.accessToken = dictionary["access_token"] as! String
                            auth.tokenType = dictionary["token_type"] as! String
                            auth.expiresIn = dictionary["expires_in"] as! Int
                            auth.scope = dictionary["scope"] as! String
                            auth.createdAt = dictionary["created_at"] as! Int
                            callback(auth: auth, error: nil)
                        }
                    }
                }
            })
            task.resume()
            
        }
    }
}

