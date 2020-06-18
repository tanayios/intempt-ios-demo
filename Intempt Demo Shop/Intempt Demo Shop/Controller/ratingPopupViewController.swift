
import UIKit

class ratingPopupViewController: UIViewController {
    @IBOutlet var popup_view: UIView!
    @IBOutlet var floatRatingView: FloatRatingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.popup_view.layer.borderColor = UIColor.clear.cgColor
             self.popup_view.layer.borderWidth = 5.0
             self.popup_view.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
        // Reset float rating view's background color
               floatRatingView.backgroundColor = UIColor.clear

               /** Note: With the exception of contentMode, type and delegate,
                all properties can be set directly in Interface Builder **/
               floatRatingView.delegate = self
               floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings
               
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
          self.removeAnimate()
          //self.view.removeFromSuperview()
      }
      
      func showAnimate()
      {
          self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
          self.view.alpha = 0.0;
          UIView.animate(withDuration: 0.25, animations: {
              
              
              
              self.view.alpha = 1.0
              self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
          });
      }
      
      func removeAnimate()
      {
          UIView.animate(withDuration: 0.25, animations: {
              [weak self] in
              self?.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
              self!.view.alpha = 0.0;
              }, completion:{(finished : Bool)  in
                  if (finished)
                  {
                      self.view.removeFromSuperview()
                  }
          });
      }
       @IBAction func submit(_ sender: Any) {
           
      //
        self.removeAnimate()
           }

}
extension ratingPopupViewController: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        //liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
    }
    
}
