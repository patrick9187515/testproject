//
//  PostListViewController.swift
//  TestProject
//
//  Created by pat t on 4/7/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
}

class PostListViewController: UITableViewController {
    
    var posts = ["Special-Edition Puma ONE Chrome 2017-2018 Boots Leaked", "All-New Adidas Futurecraft 4D Runner Revealed"]
    
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
        
        /*
        let imageURL = NSURL(string: "http://cdn.footyheadlines.com/header.jpg")
        let data = NSData(contentsOf: imageURL! as URL)
        let image = UIImage(data: data! as Data)
 */
        
        if let filePath = Bundle.main.path(forResource: "http://cdn.footyheadlines.com/header.jpg", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
            cell.headerImageView.contentMode = .scaleAspectFit
            cell.headerImageView.image = image
        }
        
        cell.label?.text = posts[indexPath.row]
        //cell.headerImageView?.image = image
        
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
