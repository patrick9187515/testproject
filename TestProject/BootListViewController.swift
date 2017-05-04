//
//  BootListViewController.swift
//  TestProject
//
//  Created by pat t on 5/4/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class BootListViewController: UITableViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            //Upcoming
            textLabel.text = "Upcoming boots"
        case 1:
            //Released
            textLabel.text = "Released boots"
        default:
            break
        }
    }
    @IBOutlet weak var textLabel: UILabel!
    
    var boots = [Boot]()
    var page_0 = 1
    var page_1 = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Boot Calendar"
        
        tableView.register(UINib(nibName: "BootIndexView", bundle: nil),
                           forCellReuseIdentifier: "BootIndexViewCell")
        
        //load data
        loadBoots()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return boots.count
    }
    
    func loadBoots() {
        let url = "http://cdn.footyheadlines.com/_/api.php?type=boots&order=new&page=" + String(page_0)
        
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
                
                if let bootsArray = jsonData!.value(forKey: "boots") as? NSArray {
                    for boot in bootsArray {
                        if let postDict = boot as? NSDictionary {
                            self.boots.append(Boot(
                                brand: postDict.value(forKey: "brand") as! String,
                                name: postDict.value(forKey: "name") as! String,
                                collection: postDict.value(forKey: "collection") as! String,
                                releasedate: postDict.value(forKey: "release_date") as! Date,
                                notsure: postDict.value(forKey: "not_sure") as! String,
                                url: postDict.value(forKey: "url") as! String,
                                image: postDict.value(forKey: "image") as! String
                            )!)
                        }
                    }
                }
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }).resume()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BootIndexViewCell", for: indexPath)

        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
