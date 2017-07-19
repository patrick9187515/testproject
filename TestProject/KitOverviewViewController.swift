//
//  KitOverviewViewController.swift
//  FootyHeadlines
//
//  Created by pat t on 7/19/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class KitOverviewViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var kitOverviewWebController: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        kitOverviewWebController.delegate = self
        
        //self.navigationController?.pushViewController(KitOverviewViewController, animated: true)
        
        let url = "http://www.footyheadlines.com/2017/01/2017-18-kit-overview-all-leaked-17-18-shirts.html?m=1&app=1"
        
        kitOverviewWebController.loadRequest(URLRequest(url: URL(string: url)!))
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // open links in Safari
            guard let url = request.url else { return true }
            let realUrl = url.absoluteString + "?m=1&app=1"
            
            if url.host?.range(of: "footyheadlines.com") != nil {
                //kitOverviewWebController.loadRequest(URLRequest(url: URL(string: realUrl)!))
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostItemView") as! PostItemWebViewController
                //let newViewController = PostItemWebViewController()
                newViewController.url = realUrl
                self.navigationController?.pushViewController(newViewController, animated: true)
                return false
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // handle other navigation types...
            return true
        }
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
