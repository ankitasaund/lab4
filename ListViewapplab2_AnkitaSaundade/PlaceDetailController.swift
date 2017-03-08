//
//  PlaceDetailController.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 2/8/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit
import CoreData

class PlaceDetailController: UIViewController {

    @IBOutlet var LablePlacename: UILabel!
    @IBOutlet var PlaceImage: UIImageView!
    @IBOutlet var Placedetail: UITextView!
    
   // var LablePlaceNametext : String!
  //  var PlaceImages : UIImage!
  //  var LablePlaceDetailtext: String!
    
    var plcDetail: PlaceObjectMO!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       /* self.LablePlacename.text = self.LablePlaceNametext
        self.Placedetail.text = self.LablePlaceDetailtext
        self.PlaceImage.image = self.PlaceImages*/
        // self.Placedetail.text = self.PlaceDetailText
        self.LablePlacename.text = self.plcDetail.iPlaceName
        self.Placedetail.text = self.plcDetail.iPlaceDetail
        self.PlaceImage.image = UIImage(data:self.plcDetail.iPlaceImage as! Data)
        navigationItem.title = self.LablePlacename.text
        
        //add fly-in animation for Image
        var rotationTransform : CATransform3D = CATransform3DIdentity
        rotationTransform = CATransform3DTranslate(rotationTransform, -250, -250, 0)
        PlaceImage?.layer.transform = rotationTransform
        UIView.animate(withDuration: 6, animations: {
            self.PlaceImage?.layer.transform = CATransform3DIdentity
        })

        //add fade in animation for text
        Placedetail.alpha = 0
        UIView.animate(withDuration: 10, animations: {self.Placedetail.alpha = 1})
        
        
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
