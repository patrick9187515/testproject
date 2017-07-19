//
//  BootListViewController.swift
//  TestProject
//
//  Created by pat t on 5/4/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import GoogleMobileAds

class BootListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, GADNativeExpressAdViewDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
    {
    case 0:
        //Upcoming
        /*
        scroll_old = tableView.contentOffset.y
        let offset = tableView.contentOffset
        tableView.setContentOffset(offset, animated: false)
         */
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        boots = boots_new
        tableView.reloadData()
    case 1:
        //Released
        /*
        scroll_new = tableView.contentOffset.y
        let offset = tableView.contentOffset
        tableView.setContentOffset(offset, animated: false)
        //Initial load if required
         */
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
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
    var adsToLoad = [GADNativeExpressAdView]()
    let adViewHeight = CGFloat(300)
    let adViewWidth = CGFloat(320)
    var adCountNew = 8
    var adCountOld = 8
    var selectedBoot : Boot?
    var selectedUrl : String?
    var page_0 = 1
    var page_1 = 1
    let dateFormatter = DateFormatter()
    let dateFormatterShort = DateFormatter()
    var dateFormatterToString = DateFormatter()
    var dateFormatterMonth = DateFormatter()
    var initialLoad = true;
    var selected = 0;
    var scroll_new = CGFloat(0);
    var scroll_old = CGFloat(0);
    var previousTabBarIndex = 1;
    var previousMonth_new = ""
    var previousCollection_new = ""
    var previousMonth_old = ""
    var previousCollection_old = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.register(UINib(nibName: "BootIndexView", bundle: nil),
                           forCellReuseIdentifier: "BootIndexViewCell")
        tableView.register(UINib(nibName: "SeperatorTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "Seperator")
        tableView.register(UINib(nibName: "DateHeaderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DateHeader")
        tableView.register(UINib(nibName: "CollectionHeaderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CollectionHeader")
        tableView.register(UINib(nibName: "NativeExpressAd", bundle: nil),
                           forCellReuseIdentifier: "NativeExpressAdViewCell")
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        //load data
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatterShort.dateFormat = "MMM"
        dateFormatterMonth.dateFormat = "MMM yyyy"
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
    
    
    
    func loadNextAd() {
        if !adsToLoad.isEmpty {
            let adView = adsToLoad.removeFirst()
            adView.load(GADRequest())
        }
    }
    
    func addAds(type: Int) {
        var adCount = adCountNew
        if type == 1 {
            adCount = adCountOld
        }
        let adSize = GADAdSizeFromCGSize(CGSize(width: adViewWidth, height: adViewHeight))
        while (adCount < boots.count) {
            if (boots[adCount-1] as? Boot) != nil {
                    let adView = GADNativeExpressAdView(adSize: adSize)
                    adView?.adUnitID = "ca-app-pub-3940256099942544/8897359316"
                    adView?.rootViewController = self
                    adView?.delegate = self
                    boots.insert(adView!, at: adCount)
                    boots.insert(nil, at: adCount)
                    //posts2.insert(nil, at: (3 + adCount * 4))
                    adsToLoad.append(adView!)
                    adCount += (2 * 6 + 2)
            } else {
                adCount += 1
            }
        }
        loadNextAd()
        
        if type == 0 {
            adCountNew = adCount
            boots_new = boots
        } else {
            adCountOld = adCount
            boots_old = boots
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if (tabBarIndex == 1 && previousTabBarIndex == 1) {
            //tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            previousTabBarIndex = tabBarIndex
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
        if (boots[indexPath.row] as? Boot) != nil {
            selectedBoot = boots[indexPath.row] as? Boot
            selectedUrl = selectedBoot?.url
            self.performSegue(withIdentifier: "ShowPost", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PostItemWebViewController
        destinationVC.url = selectedUrl
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if boots[indexPath.row] as? GADNativeExpressAdView != nil {
            return adViewHeight
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        if (segmentedControl.selectedSegmentIndex == 0) {
            page_0 = 1
            boots = [Boot]()
            adCountNew = 8
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            page_1 = 1
            boots = [Boot]()
            adCountOld = 8
        }
        
        loadBoots()
        
        refreshControl.endRefreshing()
    }
    
    func loadBoots() {
        if (segmentedControl.selectedSegmentIndex == 0) {
        let url = "http://cdn.footyheadlines.com/api/?type=boots&order=new&page=" + String(page_0)
        
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
                            if let tempBoot = Boot(postDict: postDict) {
                                let month = self.dateFormatterMonth.string(from: tempBoot.release_date)
                                if month != self.previousMonth_new {
                                    self.boots.append(DateHeader(name: month))
                                    self.previousMonth_new = month
                                }
                                if tempBoot.collection != self.previousCollection_new && !tempBoot.collection.isEmpty {
                                    self.boots.append(CollectionHeader(name: tempBoot.collection))
                                    self.previousCollection_new = tempBoot.collection
                                }
                                self.boots.append(tempBoot)
                                self.boots.append(nil)
                            }
                        }
                    }
                    self.boots_new = self.boots
                }
            }
            
            OperationQueue.main.addOperation {
                self.addAds(type: 0)
                self.tableView.reloadData()
            }
        }).resume()
        } else if (segmentedControl.selectedSegmentIndex == 1) {
        let url_old = "http://cdn.footyheadlines.com/api/?type=boots&order=old&page=" + String(page_1)
        
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
                            if let tempBoot = Boot(postDict: postDict) {
                                let month = self.dateFormatterMonth.string(from: tempBoot.release_date)
                                if month != self.previousMonth_old {
                                    self.boots.append(DateHeader(name: month))
                                    self.previousMonth_old = month
                                }
                                if tempBoot.collection != self.previousCollection_old && !tempBoot.collection.isEmpty {
                                    self.boots.append(CollectionHeader(name: tempBoot.collection))
                                    self.previousCollection_old = tempBoot.collection
                                }
                                self.boots.append(tempBoot)
                                self.boots.append(nil)
                            }
                        }
                    }
                    self.boots_old = self.boots
                }
            }
            
            OperationQueue.main.addOperation {
                self.addAds(type: 1)
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
                if let temp = boots[indexPath.row] as? Boot {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BootIndexViewCell", for: indexPath) as! BootIndexView
                cell.bootImage?.sd_setImage(with: URL(string: (temp.image)))
                cell.labelName?.text = (temp.brand) + " " + (temp.name)
                let labelDateText = dateFormatterToString.string(from: (temp.release_date))
                    if temp.not_sure == "0" {
                cell.labelDate?.text = labelDateText
                    } else {
                        let monthText = dateFormatterShort.string(from: (temp.release_date))
                        cell.labelDate?.text = monthText
                    }
                
                return cell
                } else if let row = boots[indexPath.row] as? DateHeader {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DateHeader", for: indexPath) as! DateHeaderTableViewCell
                    
                    cell.label.text = row.title
                    
                    return cell
                } else if let row = boots[indexPath.row] as? CollectionHeader {
                    let cell =  tableView.dequeueReusableCell(withIdentifier: "CollectionHeader", for: indexPath) as! CollectionHeaderTableViewCell
                    
                    cell.label.text = row.title
                    
                    return cell
                } else {
                    let adView = boots[indexPath.row] as! GADNativeExpressAdView
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NativeExpressAdViewCell", for: indexPath)
                    for subview in cell.contentView.subviews {
                        subview.removeFromSuperview()
                    }
                    cell.contentView.addSubview(adView)
                    adView.center = cell.contentView.center
                    return cell
                }
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "Seperator", for: indexPath)
            }
        }
        return UITableViewCell()
    }
    
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        loadNextAd()
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
