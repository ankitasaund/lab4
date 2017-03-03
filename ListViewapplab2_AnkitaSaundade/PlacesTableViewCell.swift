//
//  PlacesTableViewCell.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 2/8/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var cellPlaceName: UILabel!
    
    @IBOutlet var cellPlaceDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
