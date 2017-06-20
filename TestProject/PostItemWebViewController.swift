//
//  PostItemWebViewController.swift
//  TestProject
//
//  Created by pat t on 4/26/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class PostItemWebViewController: ViewController, UIWebViewDelegate {
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
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // open links in Safari
            guard let url = request.url else { return true }
            let realUrl = url.absoluteString + "?m=1&app=1"
            
            if url.host?.range(of: "footyheadlines.com") != nil {
                wevView.loadRequest(URLRequest(url: URL(string: realUrl)!))
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
