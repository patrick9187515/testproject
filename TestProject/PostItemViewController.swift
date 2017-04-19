//
//  PostItemViewController.swift
//  
//
//  Created by pat t on 4/18/17.
//
//

import UIKit

class PostItemViewController: UITableViewController {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var post : Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //post = Post(title: "ohg0ahga0g", image: "")
        
        // Do any additional setup after loading the view.
        
        postTitle.text = "test"
        postTitle.text = post?.title
        
        let paragraphs = getParagraphs(content: (post?.content)!)
        
        for paragraph in paragraphs {
            let label = UILabel()
            label.text = paragraph
            label.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(label)
        }
    }
    
    func getParagraphs(content: String) -> Array<String> {
        let paragraphs = content.components(separatedBy: "<br />")
        
        return paragraphs
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
