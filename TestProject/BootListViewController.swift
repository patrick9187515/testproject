//
//  BootListViewController.swift
//  TestProject
//
//  Created by pat t on 5/4/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class BootListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
    {
    case 0:
        //Upcoming
        boots = boots_new
        tableView.reloadData()
    case 1:
        //Released
        //Initial load if required
        if (boots_old.count < 1) {
            loadBoots()
        }
        boots = boots_old
        tableView.reloadData()
    default:
        break
        }
    }
    
    var boots = [Any?]()
    var boots_new = [Any?]()
    var boots_old = [Any?]()
    var selectedBoot : Boot?
    var page_0 = 1
    var page_1 = 1
    let dateFormatter = DateFormatter()
    var dateFormatterToString = DateFormatter()
    var initialLoad = true;
    var selected = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.register(UINib(nibName: "BootIndexView", bundle: nil),
                           forCellReuseIdentifier: "BootIndexViewCell")
        
        tableView.rowHeight = 90
        
        //load data
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatterToString.dateStyle = .medium
        dateFormatterToString.locale = Locale(identifier: "en_US")
        loadBoots()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath.row
        
        selectedBoot = boots[indexPath.row] as? Boot
        
        //let destinationVC = PostItemViewController()
        //destinationVC.post = selectedPost
        
        //destinationVC.performSegue(withIdentifier: "ShowPost", sender: nil)
        
        self.performSegue(withIdentifier: "ShowPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostItemViewController
        
        destinationVC.url = selectedBoot?.url
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //("called number of rows in section")
        return boots.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = boots.count - 1
        if indexPath.row >= lastElement {
            switch segmentedControl.selectedSegmentIndex
            {
            case 0:
                page_0 += 1
                loadBoots()
            case 1:
                page_1 += 1
                loadBoots()
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        page_0 = 1
        if (segmentedControl.selectedSegmentIndex == 0) {
            boots_new = [Boot]()
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            boots_old = [Boot]()
        }
        
        loadBoots()
        
        refreshControl.endRefreshing()
    }
    
    func loadBoots() {
        if (segmentedControl.selectedSegmentIndex == 0) {
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
                            let date = self.dateFormatter.date(from: postDict.value(forKey: "release_date") as! String)
                            self.boots_new.append(Boot(
                                brand: postDict.value(forKey: "brand") as! String,
                                name: postDict.value(forKey: "name") as! String,
                                collection: postDict.value(forKey: "collection") as! String,
                                releasedate: date!,
                                notsure: postDict.value(forKey: "not_sure") as! String,
                                url: postDict.value(forKey: "url") as! String,
                                image: postDict.value(forKey: "image") as! String
                                )!)
                            self.boots_new.append(nil)
                        }
                    }
                    self.boots = self.boots_new
                }
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }).resume()
        } else if (segmentedControl.selectedSegmentIndex == 1) {
        let url_old = "http://cdn.footyheadlines.com/_/api.php?type=boots&order=old&page=" + String(page_1)
        
        URLSession.shared.dataTask(with: URL(string: url_old)!, completionHandler: {(data, response, error) in
            
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
                            let date = self.dateFormatter.date(from: postDict.value(forKey: "release_date") as! String)
                            self.boots_old.append(Boot(
                                brand: postDict.value(forKey: "brand") as! String,
                                name: postDict.value(forKey: "name") as! String,
                                collection: postDict.value(forKey: "collection") as! String,
                                releasedate: date!,
                                notsure: postDict.value(forKey: "not_sure") as! String,
                                url: postDict.value(forKey: "url") as! String,
                                image: postDict.value(forKey: "image") as! String
                                )!)
                        }
                    }
                    self.boots = self.boots_old
                }
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }).resume()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(indexPath.row)
        //print(boots.count)
        
        if (boots.count > indexPath.row) {
            if boots[indexPath.row] != nil {
                let temp = boots[indexPath.row] as? Boot
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BootIndexViewCell", for: indexPath) as! BootIndexView
                
                cell.bootImage?.sd_setImage(with: URL(string: (temp?.image)!))
                cell.labelName?.text = (temp?.brand)! + " " + (temp?.name)!
                let labelDateText = dateFormatterToString.string(from: (temp?.release_date)!)
                cell.labelDate?.text = labelDateText
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
        return UITableViewCell()
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
