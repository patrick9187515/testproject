//
//  BootIndexView.swift
//  TestProject
//
//  Created by pat t on 5/4/17.
//  Copyright © 2017 Footy Headlines. All rights reserved.
//

import UIKit

class BootIndexView: UITableViewCell {
    @IBOutlet weak var bootImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
