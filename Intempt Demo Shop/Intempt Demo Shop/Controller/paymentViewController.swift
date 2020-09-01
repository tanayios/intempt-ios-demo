

import UIKit
import StoreKit
import Stripe
import Alamofire
//import intempt
//import SKActivityIndicatorView
class paymentViewController: UIViewController,STPPaymentCardTextFieldDelegate {
    @IBOutlet var popup_view: UIView!
    @IBOutlet var stripeView: UIView!
    @IBOutlet var lblProductName : UILabel!
    @IBOutlet var lblPrice : UILabel!
    @IBOutlet var btnPayment : UIButton!
    var strName = "",strDesc = "",strPrice = "",strPrice1 = ""
    var strSpaInterest = false
    let stripeTokenUrl = "https://api.stripe.com/v1/tokens"
    let stripeChargesUrl = "https://api.stripe.com/v1/charges"


    func validCardCheckout()
    {
    
        let stripeAuthHeader: HTTPHeaders = [
                  "Authorization": "Bearer sk_test_zjKhYcNvboNfRUCcrAaW7Pxs00wSbMTMGv"
            
              ]
        if paymentTextField.cardNumber != nil  && paymentTextField.cvc != nil
        {            let params = ["card[number]": paymentTextField.cardNumber!,"card[exp_month]": paymentTextField.expirationMonth,"card[exp_year]": paymentTextField.expirationYear,"card[cvc]": paymentTextField.cvc!] as [String : Any]
            
             AF.request(stripeTokenUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: stripeAuthHeader ).responseJSON { (response) in
                    switch response.result {
                             case .failure(let error):
                                 print(error)
                 //    SKActivityIndicator.dismiss()

                             case .success(let response):
                                 print(response)
                                    // let result = response.result
                                                      
                                     let json = response as! NSDictionary
                     
                         if         let data = json.value(forKey: "error")
                         {
                           //  SKActivityIndicator.dismiss()

                             let error = data as! NSDictionary
                             AppManager().AlertUser("", message: "\(error.value(forKey: "message") ?? "card_error")", vc: self)
                     }
                     else
                         {
                           
                             self.payment()
                     }
                     

             }
             }
             
        }
        else
        {
           //   SKActivityIndicator.dismiss()
        }

        
        
    }
    var strSpaPrice : String = "00.00"
    @IBAction func checkBoxTapped(_ sender: UIButton) {
          let hotelPrice = Float(self.strPrice)
                    
                        let decimalhotelPrice = hotelPrice!/100
          UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
              sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
          }) { (success) in
           if sender.isSelected {
                        sender.isSelected = false
            self.strSpaInterest = false
              self.strSpaPrice = "00.00"
            self.btnPayment.setTitle("BOOK FOR $\(decimalhotelPrice)", for: .normal)
                     } else {
                         sender.isSelected  = true
                    
          
                    self.strSpaInterest = true

            
            self.btnPayment.setTitle("BOOK FOR $\(decimalhotelPrice) + $ 30.0", for: .normal)
             self.strSpaPrice = "3000"
                     }
            
            
              UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                  sender.transform = .identity
               

              }, completion: nil)
          }
      }
    func payment()
       {
           
           let stripeAuthHeader: HTTPHeaders = [
                     "Authorization": "Bearer sk_test_zjKhYcNvboNfRUCcrAaW7Pxs00wSbMTMGv"
                 ]
        
            let hotelPrice = Float(strPrice)

        var amountPrice : Float
        if self.strSpaPrice == "00.00"
        {
            amountPrice = hotelPrice!
        }
        else
        {
            let  hotelSpaPrice = Float(strSpaPrice)
           
         amountPrice = hotelPrice! + hotelSpaPrice!
        }
        
        let params = ["amount": amountPrice,"currency":"eur","source": "tok_visa","description": "\(self.strName) Description : \(self.strDesc)"] as [String : Any]
           AF.request(stripeChargesUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: stripeAuthHeader ).responseJSON { (response) in
            switch response.result {
                     case .failure(let error):
                         print(error)
           //  SKActivityIndicator.dismiss()

                     case .success(let response):
                        //  SKActivityIndicator.dismiss()
                             let alertController = UIAlertController(title: "", message: "Payment Sucessfull.", preferredStyle: .alert)
                                    let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                                            self.removeAnimate()
                                      
                                               let arrData = NSMutableArray()
                                               let dic1 = NSMutableDictionary()
                                        dic1.setValue(self.strName, forKey: "hotelRoomName");
                                        dic1.setValue(self.strPrice, forKey: "amount");
                                        dic1.setValue(self.strDesc, forKey: "hotelRoomDesc");
                                        dic1.setValue("30000", forKey: "spaPrice");
                                        dic1.setValue(self.strSpaInterest, forKey: "spaInterest");
                                    
                                        dic1.setValue(true, forKey: "successfulTransaction");

                                              
                                               arrData.add(dic1)
                                            print(arrData)
                                               ///customEvent ///
                                             //  Intempt.track("hotel-booking-app", withProperties: arrData, error: nil)
                                        
                                        
                                        
                             }
                             alertController.addAction(action1)
                             self.present(alertController, animated: true, completion: {
                             })
     
     }
     }
           
           
       }
    
    
    let paymentTextField = STPPaymentCardTextField()
    var productPriceData = [data1]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productPriceData)
        self.popup_view.layer.borderColor = UIColor.clear.cgColor
        self.popup_view.layer.borderWidth = 5.0
        self.popup_view.layer.cornerRadius = 5.0

 paymentTextField.postalCodeEntryEnabled = false
     paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.size.width - 30, height: 44)
        paymentTextField.delegate = self
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.borderWidth = 0
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        stripeView.addSubview(paymentTextField)
        
        self.lblProductName.text = self.strName
        self.lblPrice.text = strPrice1
        
    self.btnPayment.setTitle("BOOK FOR \(self.lblPrice.text!)", for: .normal)

        
     self.hideKeyboard1()
      
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)

     
        self.showAnimate()
        
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
    
    
    
    @IBAction func Confirm(_ sender: Any) {
        
   //     SKActivityIndicator.spinnerStyle(.defaultSpinner)
            //   SKActivityIndicator.show("", userInteractionStatus: true)

               DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.validCardCheckout()
        }

    }


}

  extension UIViewController
  {
    
    func hideKeyboard1()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard1()
    {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.view.alpha = 0.0;
//        }, completion:{(finished : Bool)  in
//            if (finished)
//            {
//                self.view.removeFromSuperview()
//            }
//        });
    }
  }
