//
//  PostIndexView.swift
//  TestProject
//
//  Created by pat t on 4/17/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class PostIndexView: UITableViewCell {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelCommentCount: UILabel!
    @IBOutlet weak var labelTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
