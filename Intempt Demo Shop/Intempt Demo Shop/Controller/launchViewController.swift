//
//  launchViewController.swift
//  Intempt Demo Shop
//
//  Created by Tanay Bhattacharjee on 02/06/20.
//  Copyright © 2020 Tanay Bhattacharjee. All rights reserved.
//

import UIKit

class launchViewController: UIViewController {
    override func viewDidLoad() {
         super.viewDidLoad()
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          let obj = self.storyboard?.instantiateViewController(withIdentifier: "VC") as! ViewController
            self.navigationController?.pushViewController(obj, animated: false)
       }
        
    }
}
