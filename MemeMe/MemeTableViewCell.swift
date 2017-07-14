//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by BRIAN DUVERNEAY on 7/13/17.
//  Copyright © 2017 BRIAN DUVERNEAY. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet var topTextView: UITextView!
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var bottomTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
