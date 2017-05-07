//
//  PostItemViewControllerNew.swift
//  TestProject
//
//  Created by pat t on 4/26/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class PostItemViewControllerNew: ViewController {
    @IBOutlet weak var labelPostTitle: UILabel!
    var post : Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelPostTitle.text = post?.title
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
