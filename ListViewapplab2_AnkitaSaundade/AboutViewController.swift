//
//  AboutViewController.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 2/8/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var myPicture: UIImageView!
    //@IBOutlet var AboutwebView: UIWebView!
    @IBOutlet var aboutMe: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      /*  let myURL = URL(string: "https://about.me/Anusaundade")
        let myRequest = URLRequest(url: myURL! as URL)
        AboutwebView.loadRequest(myRequest as URLRequest) */
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
