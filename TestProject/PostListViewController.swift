//
//  PostListViewController.swift
//  TestProject
//
//  Created by pat t on 4/7/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit
import AlamofireImage

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
}

class PostListViewController: UITableViewController {
    
    var posts = ["Special-Edition Puma ONE Chrome 2017-2018 Boots Leaked", "All-New Adidas Futurecraft 4D Runner Revealed"]
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        print("Download started")
        getDataFromUrl(url: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download finished")
            DispatchQueue.main.async () { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
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
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! PostTableViewCell
        
        let imageUrl = URL(string: "http://cdn.footyheadlines.com/header.jpg")
        
        cell.headerImageView?.af_setImage(withURL: imageURL)
        cell.label?.text = posts[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
