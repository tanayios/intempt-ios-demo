//
//  productList.swift
//  Intempt Demo Shop
//
//  Created by Tanay Bhattacharjee on 31/05/20.
//  Copyright © 2020 Tanay Bhattacharjee. All rights reserved.
//

import UIKit


struct productList: Decodable {
    
    var object : String
   let  data: [data]
    private enum CodingKeys: String, CodingKey {
       
         case data = "data"
        case object = "object"

    }

}
struct data: Decodable {
    var name: String
    var id: String
    var description: String
    var images : [String]
    let metadata : metadata
  //  let lon: Double
    private enum CodingKeys: String, CodingKey {
        case description = "description"
        case name = "name"
     case metadata = "metadata"
          case images = "images"
      case id = "id"
        
    }
}
struct metadata: Decodable {
let address : String
    private enum CodingKeys: String, CodingKey {
          case address = "address"
      
  }
}
