//
//  Helper.swift
//  TestA
//
//  Created by gecko on 22/08/16.
//  Copyright © 2016 Chamsidine ATTOUMANI. All rights reserved.
//

import Foundation
import UIKit

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
    

    class func collectAuthInfo(client: ClientSession, callback: (dictionary: [String: AnyObject]?, error: NSError?) -> Void) {
        let formattedUrl = String(format: "%@?grant_type=client_credentials&client_id=%@&client_secret=%@", client.authURL, client.uid, client.secret)
        let requURL = NSURL(string: formattedUrl)!
        let request = NSMutableURLRequest(URL: requURL)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        
        do {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                // do something with the response
                if error != nil {
                    print("error: \(error)")
                    callback(dictionary: nil, error: error)
                }
                else {
                    let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                    if let result = dataString{
                        if let dictionary = Helper.parseJSON(result) {
                            callback(dictionary : dictionary, error: nil)
                        }
                    }
                }
            })
            task.resume()
        }
    }
    
    class func performStoreRequestWithURL(url: NSURL) -> String? {
        do {
            return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch {
            print("Download Eroor: \(error)")
            return nil
        }
    }
}