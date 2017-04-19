//
//  PostItemViewController.swift
//  
//
//  Created by pat t on 4/18/17.
//
//

import UIKit

class PostItemViewController: UIViewController {
    @IBOutlet weak var postTitle: UILabel!
    
    var post : Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //post = Post(title: "ohg0ahga0g", image: "")
        
        // Do any additional setup after loading the view.
        
        postTitle.text = "test"
        postTitle.text = post?.title
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
