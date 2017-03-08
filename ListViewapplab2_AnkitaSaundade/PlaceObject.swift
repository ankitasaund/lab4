//
//  PlaceObject.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 2/27/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit

class PlaceObject: NSObject {
    var iPlaceName = ""
    var iPlaceImage = UIImage(named: "")
    var iPlaceDetail = ""
    var iPlaceChecked = false
    init(iPlaceName: String, iPlaceImage: UIImage, iPlaceDetail: String, iPlaceChecked: Bool )
    {
        self.iPlaceName = iPlaceName
        self.iPlaceImage = iPlaceImage
        self.iPlaceDetail = iPlaceDetail
        self.iPlaceChecked = iPlaceChecked
    }
    
    
}
