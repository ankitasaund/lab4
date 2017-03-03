//
//  AddViewController.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 3/2/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var addPlaceName: UITextField!
    
    @IBOutlet var addPlaceDetail: UITextField!

    @IBOutlet var addPlaceImage: UITextField!
    
    
    var newPlaces : ((PlaceObject) -> ())!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func clickedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func clickedSave(_ sender: Any) {
        newPlaces(PlaceObject(iPlaceName: self.addPlaceName.text!, iPlaceImage: UIImage(named: self.addPlaceImage.text!)!, iPlaceDetail: self.addPlaceDetail.text!, iPlaceChecked: false))
        
        self.dismiss(animated: true, completion: nil)
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
