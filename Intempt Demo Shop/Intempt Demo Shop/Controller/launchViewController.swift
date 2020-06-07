

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
