
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
