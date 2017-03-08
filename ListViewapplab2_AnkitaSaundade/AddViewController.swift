//
//  AddViewController.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 3/2/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    @IBOutlet var addPlaceName: UITextField!
    @IBOutlet var addPlaceDetail: UITextField!
    @IBOutlet var addPlaceImage: UITextField!
    
    @IBAction func clickedCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickedSave(_ sender: Any) {
        // Check if name is empty
        if (!addPlaceName.hasText) {
            self.alertError("Unable to save", msg: "Item name can't be blank.")
        }
        else{

            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
            newPlaces = NSEntityDescription.insertNewObject(forEntityName: "PlaceObject", into: managedObjectContext) as! PlaceObjectMO
        
            newPlaces.iPlaceName = addPlaceName.text
            newPlaces.iPlaceImage = NSData(data: UIImagePNGRepresentation(UIImage(named: addPlaceImage.text!)!)!)
            newPlaces.iPlaceDetail = addPlaceDetail.text
            newPlaces.iPlaceChecked = false
        
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //var newPlaces : ((PlaceObject) -> ())!
    var newPlaces : PlaceObjectMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func alertError(_ title: String, msg: String) {
        let alert    = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }
 

}
