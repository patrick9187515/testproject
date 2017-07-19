//
//  PostListViewController.swift
//  TestProject
//
//  Created by pat t on 4/7/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import GoogleMobileAds

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(20, 20, 0, 20))
    }
}

class PostListViewController: UITableViewController, GADNativeExpressAdViewDelegate {
    var posts2 = [Any?]()
    var adsToLoad = [GADNativeExpressAdView]()
    let adViewHeight = CGFloat(300)
    let adViewWidth = CGFloat(320)
    let numberOfAds = 3
    var adCount = 1
    var page = 1
    var selectedPost : Post?
    var selectedUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PostIndexView", bundle: nil),
                           forCellReuseIdentifier: "PostIndexViewCell")
        tableView.register(UINib(nibName: "PostIndexZZZView", bundle: nil),
                           forCellReuseIdentifier: "PostZZZIndexViewCell")
        tableView.register(UINib(nibName: "SeperatorTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "Seperator")
        tableView.register(UINib(nibName: "NativeExpressAd", bundle: nil),
                           forCellReuseIdentifier: "NativeExpressAdViewCell")
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        //load data
        loadPosts()
        
        //refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        //add to table view
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    func loadNextAd() {
        if !adsToLoad.isEmpty {
            let adView = adsToLoad.removeFirst()
            adView.load(GADRequest())
        }
    }
    
    func addAds() {
        let adSize = GADAdSizeFromCGSize(CGSize(width: adViewWidth, height: adViewHeight))
        while (adCount < posts2.count) {
            if (posts2[adCount-1] as? Post) != nil {
                let tempPost = posts2[adCount-1] as? Post
                if (tempPost?.zzz == 1) {
                    adCount += 1
                } else {
                    let adView = GADNativeExpressAdView(adSize: adSize)
                    adView?.adUnitID = "ca-app-pub-3940256099942544/8897359316"
                    adView?.rootViewController = self
                    adView?.delegate = self
                    posts2.insert(adView!, at: adCount)
                    posts2.insert(nil, at: adCount)
                    //posts2.insert(nil, at: (3 + adCount * 4))
                    adsToLoad.append(adView!)
                    adCount += 8
                }
            } else {
                adCount += 1
            }
        }
        loadNextAd()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath.row
        
        if (posts2[indexPath.row] as? Post) != nil {
            selectedPost = posts2[indexPath.row] as? Post
            selectedUrl = selectedPost?.url
            self.performSegue(withIdentifier: "ShowPost", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostItemWebViewController
        destinationVC.url = selectedUrl
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if posts2[indexPath.row] as? GADNativeExpressAdView != nil {
            return adViewHeight
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if posts2.count > indexPath.row {
        if (posts2[indexPath.row] != nil) {
            if let post = posts2[indexPath.row] as? Post {
        
        if (post.zzz == 0) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostIndexViewCell", for: indexPath) as! PostIndexView
        var commentText = (String)(post.commentCount)
            
            if post.commentCount == 1 {
                commentText += " comment"
            } else {
                commentText += " comments"
            }
        
        cell.headerImage?.sd_setImage(with: URL(string: post.image))
        cell.label?.text = post.title
            cell.labelCommentCount?.text = commentText
            cell.labelTime?.text = post.ageLabel
        
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostZZZIndexViewCell", for: indexPath) as! PostIndexZZZView
            
            if posts2.count > indexPath.row {
                cell.headerImage?.sd_setImage(with: URL(string: post.imageSquare))
                cell.title?.text = post.title
                }
            
            return cell
        }
            } else {
                let adView = posts2[indexPath.row] as! GADNativeExpressAdView
                let cell = tableView.dequeueReusableCell(withIdentifier: "NativeExpressAdViewCell", for: indexPath)
                for subview in cell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                cell.contentView.addSubview(adView)
                adView.center = cell.contentView.center
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Seperator", for: indexPath)
            
            return cell
        }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = posts2.count - 1
        if indexPath.row >= lastElement {
            page += 1
            
            loadPosts()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        page = 1
        adCount = 0
        posts2 = [AnyObject?]()
        
        loadPosts()
        
        refreshControl.endRefreshing()
    }
    
    func loadPosts() {
        let url = "http://cdn.footyheadlines.com/api/?page=" + String(page)
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
            
            guard error == nil else {
                print("there is an error")
                return
            }
            
            guard data != nil else {
                print("there is no data")
                return
            }
            
            if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(abbreviation: "CET")
                let displayFormat = DateFormatter()
                displayFormat.dateFormat = "MMMM dd, yyyy"
                
                if let postsArray = jsonData!.value(forKey: "posts") as? NSArray {
                    for post in postsArray {
                        if let postDict = post as? NSDictionary {
                            var ageString = ""
                            let published = postDict.value(forKey: "published") as! String
                            let date = dateFormatter.date(from: published)
                            let now = Date()
                            let diff = Calendar.current.dateComponents([.minute], from: date!, to: now).minute!
                            if (diff < 60) {
                                ageString = (String)(diff) + "m"
                            } else if (diff < (60 * 24)) {
                                ageString = (String)(diff / 60) + "h"
                            } else if (diff < (60 * 24 * 7)) {
                                ageString = (String)(diff / (60 * 24)) + "d"
                            } else {
                                ageString = displayFormat.string(from: date!)
                            }
                            
                            self.posts2.append(Post(
                                url: postDict.value(forKey: "url") as! String,
                                title: postDict.value(forKey: "title") as! String,
                                image: postDict.value(forKey: "image") as! String,
                                content: postDict.value(forKey: "content") as! String,
                                zzz: Int(postDict.value(forKey: "ZZZ") as! String)!,
                                commentCount: Int(postDict.value(forKey: "comment_count") as! String)!,
                                ageLabel: ageString))
                        }
                        self.posts2.append(nil)
                    }
                }
            }
            
            OperationQueue.main.addOperation {
                self.addAds()
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        loadNextAd()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func get_data_from_url(url:String)
    {
        let httpMethod = "GET"
        let timeout = 15
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!,
                                             cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
                                             timeoutInterval: 15.0)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                if data.length > 0 && error == nil{
                    self.extract_json(data!)
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
        }
        )
    }
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
