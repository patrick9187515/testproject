//
//  PostItemViewController.swift
//  
//
//  Created by pat t on 4/18/17.
//
//

import UIKit
import Foundation

struct Image {
    let url: String
    var height: Int
    let width: Int
}

struct Paragraph {
    let content: String
    var images: [Image]
    let type: String
}

extension Paragraph {
    init?(content: String) {
        self.content = content
        self.images = [Image]()
        self.type = "text"
    }
}

class PostItemViewController: UITableViewController {
    @IBOutlet weak var postTitle: UILabel!
    
    var post : Post?
    var paragraphs = [Paragraph]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //post = Post(title: "ohg0ahga0g", image: "")
        
        // Do any additional setup after loading the view.
        
        //postTitle.text = "test"
        //postTitle.text = post?.title
        
        paragraphs = getParagraphs(content: (post?.content)!)
        
        tableView.register(UINib(nibName: "PostItemText", bundle: nil),
                           forCellReuseIdentifier: "PostTextCell")
        
        tableView.register(UINib(nibName: "PostItemImage", bundle: nil),
                           forCellReuseIdentifier: "PostImageCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //if paragraphs[indexPath.row].type == "image" {
            //return CGFloat(paragraphs[indexPath.row].images[0].height)
        //}
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paragraphs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var paragraph = paragraphs[indexPath.row]
        //var cell
        
        if (paragraph.type == "image") {
            let imageUrl = paragraph.images[0].url
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostItemImage
            
            cell.postItemImageView.sd_setImage(with: URL(string: imageUrl))
            /*cell.postItemImageView.sd_setImage(with: URL(string: imageUrl)), completed: { (image, error, imageCacheType, imageUrl) in
                paragraph.images[0].height = 20
                let mHeight = image?.size.height
                let mWidth = image?.size.width
                let newHeight = 320 * (mHeight! / mWidth!)
                
                paragraph.images[0].height = Int(newHeight)
                
                cell.postItemImageView.frame = CGRect(x: 0, y: 0, width: 320, height: newHeight)
                
                //let constraint = NSLayoutConstraint(item: cell.postItemImageView, attribute: NSLayoutAttribute.height, relatedBy: <#T##NSLayoutRelation#>, toItem: <#T##Any?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
                
                //cell.postItemImageView.addConstraint(constraint)
                
                print(newHeight)
            })*/
            
            return cell
        } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTextCell", for: indexPath) as! PostItemText
        
        if paragraphs.count > indexPath.row {
            cell.label.text = paragraphs[indexPath.row].content
            
            cell.webView.loadHTMLString(paragraphs[indexPath.row].content, baseURL: nil)
            
            return cell
        }
        }
        
        return UITableViewCell()
    }
    
    func getImageUrls(content: String) -> Array<Image> {
        var results = [Image]()
        
        let regex = try! NSRegularExpression(pattern: "<img[^>]+src=\"([^\"]+)", options: [])
        
        let matches = regex.matches(in: content, options: [], range: NSMakeRange(0, content.characters.count))
        
        guard let match = matches.first else { return results }
        
        let lastRangeIndex = (match.numberOfRanges) - 1
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.rangeAt(i)
            let matchedString = (content as NSString).substring(with: capturedGroupIndex)
            results.append(Image(url: matchedString, height: 200, width: 0))
        }
        
        return results
    }
    
    func getParagraphs(content: String) -> Array<Paragraph> {
        let parts = content.components(separatedBy: "<br />")
        var matches = [Paragraph]()
        
        for part in parts {
            let regex = try! NSRegularExpression(pattern: "[A-Za-z0-9]", options: [])
        
            if regex.numberOfMatches(in: part, options: [], range: NSRange(location: 0, length: part.characters.count)) > 0 {
                if (part.range(of: "<img") != nil) && !(part.range(of: "hiddenImg") != nil) {
                    matches.append(Paragraph(content: part, images: getImageUrls(content: part), type: "image"))
                } else {
                    matches.append(Paragraph(content: part)!)
                }
            }
        }
        
        return matches
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
