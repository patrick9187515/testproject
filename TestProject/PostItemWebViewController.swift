//
//  PostItemWebViewController.swift
//  TestProject
//
//  Created by pat t on 4/26/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class PostItemWebViewController: UIViewController, UIWebViewDelegate {
    var post : Post?
    var url : String?
    @IBOutlet weak var wevView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wevView.delegate = self

        // Do any additional setup after loading the view.
        if url != nil {
            url = url! + "?m=1&app=1"
            wevView.loadRequest(URLRequest(url: URL(string: (url)!)!))
        }
    }
    
    func baseUrl (url: String) -> String {
        if let range = url.range(of: "[^?#]+", options: .regularExpression) {
            return url.substring(with: range)
        } else {
            return url
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // open links in Safari
            guard let newUrl = request.url else { return true }
            print(newUrl)
            let realUrl = baseUrl(url: newUrl.absoluteString) + "?m=1&app=1"
            print(realUrl)
            
            if newUrl.host?.range(of: "footyheadlines.com") != nil {
                if baseUrl(url: newUrl.absoluteString) != baseUrl(url: url!) {
                    let nextUrl = baseUrl(url: newUrl.absoluteString)
                    if nextUrl == "http://www.footyheadlines.com/2017/01/2017-18-kit-overview-all-leaked-17-18-shirts.html" {
                        tabBarController?.selectedIndex = 2
                    } else if nextUrl == "http://www.footyheadlines.com/2013/01/2013-boot-calender-updated-11-january.html" {
                        tabBarController?.selectedIndex = 1
                    } else {
                        //wevView.loadRequest(URLRequest(url: URL(string: realUrl)!))
                        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostItemView") as! PostItemWebViewController
                        //let newViewController = PostItemWebViewController()
                        newViewController.url = realUrl
                        self.navigationController?.pushViewController(newViewController, animated: true)
                    }
                }
                return false
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(newUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(newUrl)
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
