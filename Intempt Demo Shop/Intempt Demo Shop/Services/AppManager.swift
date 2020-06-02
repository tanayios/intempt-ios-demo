//
//  AppManager.swift
//  Tel Aviv Taxi
//
//  Created by tanay on 10/4/17.
//  Copyright © 2017 tanay. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    
    func AlertUser(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil) 
    }
    
    
    func dateformatter(str_date:String)->String
    {
        let format1 = DateFormatter()
        format1.dateFormat="MM/dd/yyyy"
        let date1 = format1.date(from: str_date)
        let format2 = DateFormatter()
        format2.dateFormat="MMM dd,yyyy"
        let str_result = format2.string(from: date1!)
        return str_result
    }
    func dateformatter_oooooo(str_date:String)->String
    {
        let format1 = DateFormatter()
        format1.dateFormat="yyyy-MM-dd"
        let date1 = format1.date(from: str_date)
        let format2 = DateFormatter()
        format2.dateFormat = "MM/dd/yyyy"
        let str_result = format2.string(from: date1!)
        return str_result
    }
    func reversedateformatter(str_date:String)->String
    {
        let format1 = DateFormatter()
        format1.dateFormat="dd MMM yyyy"
        let date1 = format1.date(from: str_date)
        let format2 = DateFormatter()
        format2.dateFormat="MM/dd/YYYY"
        let str_result = format2.string(from: date1!)
        return str_result
    }
    
    func dateformatternew(str_date:String)->String
    {
        let format1 = DateFormatter()
        format1.dateFormat="yyyy-MM-dd"
        let date1 = format1.date(from: str_date)
        let format2 = DateFormatter()
        format2.dateFormat="EEE,MMM d yyyy"
        let str_result = format2.string(from: date1!)
        return str_result
    }
    
    func timeformatter(str_date:String)->String
    {
        let format1 = DateFormatter()
        format1.dateFormat="HH:mm:ss"
        let date1 = format1.date(from: str_date)
        let format2 = DateFormatter()
        format2.dateFormat="H:mm a"
        let str_result = format2.string(from: date1!)
        return str_result
    }
    
    //MARK: Null Checking
    
    func nullToNil(value : AnyObject?) -> String {
        if value is NSNull {
            return ""
        } else {
            return value as! String
        }
    }
    
    //MARK:Email validation
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        
        
        
        
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
        
        
    }
    
    
}






















