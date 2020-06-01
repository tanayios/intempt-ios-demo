//
//  pricesData.swift
//  Intempt Demo Shop
//
//  Created by Tanay Bhattacharjee on 31/05/20.
//  Copyright © 2020 Tanay Bhattacharjee. All rights reserved.
//

import UIKit

struct pricesData: Decodable {
    
   
   let  data1: [data1]
    private enum CodingKeys: String, CodingKey {
       
         case data1 = "data"
     

    }

}
struct data1: Decodable {
    var currency: String
    var product: String
    var unit_amount: Int
   
  //  let lon: Double
    private enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case product = "product"

          case unit_amount = "unit_amount"
        
    }
}
