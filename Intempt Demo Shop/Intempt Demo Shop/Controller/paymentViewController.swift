  //
//  PopUpViewController.swift
//  PopUp
//
//  Created by Tanay Bhattacharjee on 6/06/2016.
//  Copyright © 2016 Seemu. All rights reserved.
//

import UIKit
import StoreKit
import Stripe
import Alamofire
class PopUpViewController: UIViewController,STPPaymentCardTextFieldDelegate {
    @IBOutlet var popup_view: UIView!
    @IBOutlet var stripeView: UIView!
    @IBOutlet var lblProductName : UILabel!
    @IBOutlet var lblPrice : UILabel!

    var strName = "",strDesc = "",strPrice = "",strPrice1 = ""
    let stripeTokenUrl = "https://api.stripe.com/v1/tokens"
    let stripeChargesUrl = "https://api.stripe.com/v1/charges"


    func validCardCheckout()
    {
        
     
        
        
        let stripeAuthHeader: HTTPHeaders = [
                  "Authorization": "Bearer sk_test_zjKhYcNvboNfRUCcrAaW7Pxs00wSbMTMGv"
              ]
        
     
        let params = ["card[number]": paymentTextField.cardNumber!,"card[exp_month]": paymentTextField.expirationMonth,"card[exp_year]": paymentTextField.expirationYear,"card[cvc]": paymentTextField.cvc!] as [String : Any]
        AF.request(stripeTokenUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: stripeAuthHeader ).responseJSON { (response) in
  print(response)
            
            self.payment()
        
        }
        
        
        
    }
    
    func payment()
       {
           
        
           
           
           let stripeAuthHeader: HTTPHeaders = [
                     "Authorization": "Bearer sk_test_zjKhYcNvboNfRUCcrAaW7Pxs00wSbMTMGv"
                 ]
           
        
        let params = ["amount": strPrice,"currency":"eur","source": "tok_visa","description": "\(self.strName) Description : \(self.strDesc)"] as [String : Any]
           AF.request(stripeChargesUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody , headers: stripeAuthHeader ).responseJSON { (response) in
     print(response)
           
           }
           
           
           
       }
    
    
    let paymentTextField = STPPaymentCardTextField()
    var productPriceData = [data1]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productPriceData)
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
        
        
        
     self.hideKeyboard1()
      
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        
     
        self.showAnimate()
        
        // Do any additional setup after loading the view.
        
        //popup_view.clipsToBounds=true
       // popup_view.layer.cornerRadius=3/
        
     
        
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
        self.validCardCheckout()
       let strCardnumber = "\(paymentTextField.cardNumber!)"
        if paymentTextField.cardNumber == strCardnumber
        {
            print("hello")

        }
        else
        {
            print("aaa")

            
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
