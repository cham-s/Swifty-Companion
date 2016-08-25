//
//  ViewController.swift
//  TestA
//
//  Created by Chamsidine ATTOUMANI on 8/20/16.
//  Copyright © 2016 Chamsidine ATTOUMANI. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    
    // MARK: Properties
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    let auth =  AuthInfo()
    var tokenTask: NSURLSessionDataTask?
    var token = ""

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        searchBar.becomeFirstResponder()

        tableView.rowHeight = 80
        //        Helper.collectAuthInfo(clientSession) { (dictionary, error) -> Void in
//            if error != nil {
//                print(error)
//            } else {
//                self.auth.accessToken = dictionary!["access_token"] as! String
//                self.auth.tokenType = dictionary!["token_type"] as! String
//                self.auth.expiresIn = dictionary!["expires_in"] as! Int
//                self.auth.scope = dictionary!["scope"] as! String
//                self.auth.createdAt = dictionary!["created_at"] as! Int
//            }
//        }
        
        print(token)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Methods
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "Error reading data from 42 API. Please try again", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        
        if !searchBar.text!.isEmpty {
            isLoading = true
            tableView.reloadData()
            
            hasSearched = true
            let clientSession = ClientSession(uid: ClientKey.Uid, secret: ClientKey.Secret, authURL: ClientKey.AuthURL)
            let formattedUrl = String(format: "%@?grant_type=client_credentials&client_id=%@&client_secret=%@", clientSession.authURL,
                                      clientSession.uid, clientSession.secret)
            let requURL = NSURL(string: formattedUrl)!
            let request = NSMutableURLRequest(URL: requURL)
            let session = NSURLSession.sharedSession()
            do {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPMethod = "POST"
                tokenTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    // do something with the response
                    if let error = error {
                        print("error: \(error)")
                    }
                    else if let httpResponse = response as? x where httpResponse.statusCode == 200 {
                        let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                        if let result = dataString {
                            if let dictionary = Helper.parseJSON(result) {
                                self.auth.accessToken = dictionary["access_token"] as! String
                                self.auth.tokenType = dictionary["token_type"] as! String
                                self.auth.expiresIn = dictionary["expires_in"] as! Int
                                self.auth.scope = dictionary["scope"] as! String
                                self.auth.createdAt = dictionary["created_at"] as! Int
                                print("Access token: \(self.auth.accessToken)")
                                
                                let urlStr = "https://api.intra.42.fr/v2/users/\(searchBar.text!)?access_token=\(self.auth.accessToken)"
                                let url = NSURL(string: urlStr)!
                                let newSession = NSURLSession.sharedSession()
                                let task = newSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                                    if let error = error {
                                        print("error: \(error)")
                                    } else {
                                        let newData = String(data: data!, encoding: NSUTF8StringEncoding)
                                        print(newData!)
                                        if let res = newData {
                                            if let dict = Helper.parseJSON(res) {
                                                print(dict)
                                            }
                                        }
                                    }
                                })
                                
                                task.resume()
                                
                                return
                            }
                        }
                    }
                    else {
                        print("Failure! \(response)")
                    }
                })
                tokenTask?.resume()
            }
            
            
            isLoading = false
            tableView.reloadData()
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 1
        }
        else if !hasSearched {
            return 0
        }
        else if searchResults.count == 0 {
            return 1
        }
        else {
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.stopAnimating()
            return cell
        }
        if searchResults.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.loginLabel.text = searchResult.login
            cell.locationLabel.text = searchResult.workingLocation
            return cell
        }
    }
    
    // MARK - structs
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}