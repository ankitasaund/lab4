//
//  PlaceDetailController.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 2/8/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit

class PlaceDetailController: UIViewController {

    @IBOutlet var LablePlacename: UILabel!
    @IBOutlet var PlaceImage: UIImageView!
     //@IBOutlet var LablePlaceDetail: UILabel!
    
    @IBOutlet var Placedetail: UITextView!
    
   // var LablePlaceNametext : String!
  //  var PlaceImages : UIImage!
  //  var LablePlaceDetailtext: String!
    
    var plcDetail: PlaceObject!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       /* self.LablePlacename.text = self.LablePlaceNametext
        self.Placedetail.text = self.LablePlaceDetailtext
        self.PlaceImage.image = self.PlaceImages*/
        // self.Placedetail.text = self.PlaceDetailText
        self.LablePlacename.text = self.plcDetail.iPlaceName
        self.Placedetail.text = self.plcDetail.iPlaceDetail
        self.PlaceImage.image = self.plcDetail.iPlaceImage
        navigationItem.title = self.LablePlacename.text
        
        
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