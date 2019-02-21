//
//  TableViewCell.swift
//  fooddle
//
//  Created by Sudip Kar on 1/9/19.
//  Copyright © 2019 shraman kar. All rights reserved.
//

import UIKit

class donationCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPic: UIImageView!
    
    @IBOutlet weak var bgImage: UIView!
    @IBOutlet weak var donorEmail: UILabel!
    @IBOutlet weak var foodAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
