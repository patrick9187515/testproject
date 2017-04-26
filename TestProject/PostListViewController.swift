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

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(20, 20, 0, 20))
    }
}

class PostListViewController: UITableViewController {
    var posts2 = [Post]()
    var page = 1
    var selectedPost : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Footy Headlines"
        
        tableView.register(UINib(nibName: "PostIndexView", bundle: nil),
                           forCellReuseIdentifier: "PostIndexViewCell")
        tableView.register(UINib(nibName: "PostIndexZZZView", bundle: nil),
                            forCellReuseIdentifier: "PostZZZIndexViewCell")
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath.row
        
        selectedPost = posts2[indexPath.row]
        
        //let destinationVC = PostItemViewController()
        //destinationVC.post = selectedPost
        
        //destinationVC.performSegue(withIdentifier: "ShowPost", sender: nil)
        
        self.performSegue(withIdentifier: "ShowPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostItemViewController
        
        destinationVC.post = selectedPost
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        let post = posts2[indexPath.row]
        
        if (post.zzz == 0) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostIndexViewCell", for: indexPath) as! PostIndexView
        
        if posts2.count > indexPath.row {
        cell.headerImage?.sd_setImage(with: URL(string: posts2[indexPath.row].image))
        cell.label?.text = posts2[indexPath.row].title
        }
        
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostZZZIndexViewCell", for: indexPath) as! PostIndexZZZView
            
            if posts2.count > indexPath.row {
                cell.headerImage?.sd_setImage(with: URL(string: posts2[indexPath.row].imageSquare))
                cell.title?.text = posts2[indexPath.row].title
                }
            
            return cell
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
        posts2 = [Post]()
        
        loadPosts()
        
        refreshControl.endRefreshing()
    }
    
    func loadPosts() {
        let url = "http://cdn.footyheadlines.com/_/api.php?page=" + String(page)
        
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
                
                if let postsArray = jsonData!.value(forKey: "posts") as? NSArray {
                    for post in postsArray {
                        if let postDict = post as? NSDictionary {
                            self.posts2.append(Post(
                                url: postDict.value(forKey: "url") as! String,
                                title: postDict.value(forKey: "title") as! String,
                                image: postDict.value(forKey: "image") as! String,
                                content: postDict.value(forKey: "content") as! String,
                                zzz: Int(postDict.value(forKey: "ZZZ") as! String)!)!)
                        }
                    }
                }
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }).resume()
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
