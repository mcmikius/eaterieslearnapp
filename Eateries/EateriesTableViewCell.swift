//
//  EateriesTableViewCell.swift
//  Eateries
//
//  Created by Michail Bondarenko on 1/31/19.
//  Copyright © 2019 Michail Bondarenko. All rights reserved.
//

import UIKit

class EateriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
