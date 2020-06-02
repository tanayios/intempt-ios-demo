//
//  ViewController.swift
//  Intempt Demo Shop
//
//  Created by Tanay Bhattacharjee on 31/05/20.
//  Copyright © 2020 Tanay Bhattacharjee. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import FBSDKLoginKit
import Auth0
import Combine
import FBSDKCoreKit
import Stripe
import SKActivityIndicatorView
class ViewController: UIViewController {
     @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var fbView: UIView!
     @IBOutlet weak var btnSignIn: UIButton!
    private let fbAPIURL = "https://graph.facebook.com/v7.0"
    var productData:productList!
    var priceData:pricesData!
    let stripeProducts = "https://api.stripe.com/v1/products"
    let stripePrices = "https://api.stripe.com/v1/prices"
    var productListItem = [data]()
    var productPriceData = [data1]()
    private func setupLoginButton() {
        let loginButton = FBLoginButton(permissions: [.publicProfile, .email])
           loginButton.center = fbView.center
           loginButton.delegate = self
           fbView.addSubview(loginButton)
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = AccessToken.current,
              !token.isExpired {
              // User is logged in, do work such as go to next view controller.
            btnSignIn.setTitle("Sign Out", for: .normal)
            
            let name = UserDefaults.standard.value(forKey: "name") as! String
            let img = UserDefaults.standard.value(forKey: "img") as! String
            self.imgView.isHidden = false
            self.profileName.isHidden = false
            let remoteImageURL = URL(string: "\(img)")
            self.imgView.kf.setImage(with: remoteImageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                                         if (image != nil){
                                            self.imgView.image = image
                                         }
                                         else {
                                            self.imgView.image = image
                                         }
                                         })
            self.profileName.text = "\(name)"
                                
          }
        else
        {
            
            btnSignIn.setTitle("Sign In", for: .normal)
                          self.imgView.isHidden = true
                          self.profileName.isHidden = true
        }
    
        tblView.tableFooterView = UIView()
        SKActivityIndicator.spinnerStyle(.defaultSpinner)
        SKActivityIndicator.show("", userInteractionStatus: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

            self.loadData()
       }
        
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        let stripeAuthHeader: HTTPHeaders = [
            "Authorization": "Bearer sk_test_zjKhYcNvboNfRUCcrAaW7Pxs00wSbMTMGv"
        ]
        AF.request(stripeProducts, headers: stripeAuthHeader).responseJSON {response in
            print(response)
            let json = response.data
            
            do{
                //created the json decoder
                let decoder = JSONDecoder()
                
                self.productData  = try decoder.decode(productList.self, from: json!)
            
                self.productListItem = self.productData.data
                
                print( self.productListItem.count)
                self.loadPriceData()
                
            }catch let err{
                print(err)
                SKActivityIndicator.dismiss()

            }
            
        }
        
    }

    func loadPriceData()
    {
        let stripeAuthHeader: HTTPHeaders = [
            "Authorization": "Bearer sk_test_zjKhYcNvboNfRUCcrAaW7Pxs00wSbMTMGv"
        ]
        AF.request(stripePrices, headers: stripeAuthHeader).responseJSON {response in
            print(response)
            let json = response.data
            
            do{
                //created the json decoder
                let decoder = JSONDecoder()
                self.priceData  = try decoder.decode(pricesData.self, from: json!)
             
                self.productPriceData = self.priceData.data1
                
                print(self.productPriceData)
                self.tblView.reloadData()
                SKActivityIndicator.dismiss()

                
            }catch let err{
                print(err)
                SKActivityIndicator.dismiss()

            }
            
        }
        
    }
    @IBAction func signIn(_ sender: UIButton) {
      
        self.facebookLoginData()
    }

}

extension ViewController
{
    func facebookLoginData()
    {
     let loginManager = LoginManager()
                
                if let _ = AccessToken.current {
                    self.btnSignIn.setTitle("Sign In", for: .normal)
                   self.imgView.isHidden = true
                   self.profileName.isHidden = true
                   loginManager.logOut()
                } else {
                    // Access token not available -- user already logged out
                    // Perform log in
                    loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                        
                        // Check for error
                        guard error == nil else {
                            // Error occurred
                            print(error!.localizedDescription)
                            return
                        }
                        // Check for cancel
                        guard let result = result, !result.isCancelled else {
                            print("User cancelled login")
                            return
                        }
                        Profile.loadCurrentProfile { (profile, error) in
                           print(Profile.current?.name as Any)
                           let pictureURL = profile?.imageURL(forMode: .square, size: CGSize (width: 100, height: 100))
                           print(pictureURL as Any)
                            self?.btnSignIn.setTitle("Sign Out", for: .normal)
                           self!.imgView.isHidden = false
                           self!.profileName.isHidden = false
                           self?.imgView.layer.borderWidth = 1.0
                           self?.imgView.layer.borderColor = UIColor.clear.cgColor

                           self?.profileName.text = "Hi \(Profile.current?.name ?? "Intempt")"
                           let remoteImageURL = URL(string: "\(pictureURL!)")
                            
                            UserDefaults.standard.set( self?.profileName.text, forKey: "name")
                            UserDefaults.standard.set( "\(pictureURL!)", forKey: "img")

                           self!.imgView.kf.setImage(with: remoteImageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                                 if (image != nil){
                                   self!.imgView.image = image
                                 }
                                 else {
                                   self!.imgView.image = image
                                 }
                                 })
    let accessToken = AccessToken.current
                            // Get the request publishers
                           let sessionAccessTokenPublisher = self!.fetchSessionAccessToken(appId: AccessToken.current!.appID,
                                                                                            accessToken: AccessToken.current!.tokenString)
                           let profilePublisher = self!.fetchProfile(userId: AccessToken.current!.userID, accessToken: AccessToken.current!.tokenString)
                                  _ = Publishers
                                      .Zip(sessionAccessTokenPublisher, profilePublisher)
                                      .sink(receiveCompletion: { completion in
                                          if case .failure(let error) = completion {
                                              print(error)
                                          }
                                      }, receiveValue: { sessionAccessToken, profile in
                                          // Perform the token exchange
                                          
                                          // print("hhh\(sessionAccessToken)eee\(sessionAccessToken)")
                                          Auth0
                                              .authentication()
                                              .login(facebookSessionAccessToken: sessionAccessToken, profile: profile)
                                              .start { result in
                                                  switch result {
                                                  case .success(let credentials):
                                                      print(credentials) // Auth0 user credentials
                                                      DispatchQueue.main.async {
                                                        //  UIAlertController.show(message: "Logged in as \(profile["first_name"]!) \(profile["last_name"]!)")
                                                          
                                                          print("Logged in as \(profile["first_name"]!) \(profile["last_name"]!)")
                                                      }
                                                  case .failure(let error): print("kkk---\(error.localizedDescription)")
                                              }
                                          }
                                      })
                           
                           
                        }
                    }
                }
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productListItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "list") as! productListCell
        
        cell.lblName.text = self.productListItem[indexPath.row].name
        cell.lblDescription.text = self.productListItem[indexPath.row].description
        cell.lblDescription.text = self.productListItem[indexPath.row].description
        cell.lblAddress.text = self.productListItem[indexPath.row].metadata.address
        cell.addButton.tag = indexPath.row
               cell.addButton.addTarget(self, action: #selector(ViewController.addBook(_:)), for:.touchUpInside)

        let value = self.productListItem[indexPath.row].images
        
        let str = value[0] 
        // The image to dowload
        let remoteImageURL = URL(string: str)
       cell.img.kf.setImage(with: remoteImageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
        if (image != nil){
            cell.img.image = image
        }
        else {
            cell.img.image = UIImage.init(named: "loading.jpg")
        }
        })
        let productId = self.productListItem[indexPath.row].id
        for i in 0...self.productPriceData.count-1 {
            let priceProductId = self.productPriceData[i].product
            
            if productId == priceProductId
            {
                
                let strPrice = "\(self.productPriceData[i].unit_amount)"
                let price = Float(strPrice)
                let priceDecimal = price! / 100
                cell.lblPrice.text = "€ \(priceDecimal) per night"
            }
                
            else
            {
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblView.deselectRow(at: indexPath, animated: true)
    }
    
     @objc func addBook(_ sender : UIButton) {
             if let token = AccessToken.current,
                        !token.isExpired {
                        // User is logged in, do work such as go to next view controller.
                var str = "",strPrice = ""
                     let productId = self.productListItem[sender.tag].id
                     let name = self.productListItem[sender.tag].name
                      let description = self.productListItem[sender.tag].description
                     
                            for i in 0...self.productPriceData.count-1 {
                                let priceProductId = self.productPriceData[i].product
                                
                                if productId == priceProductId
                                {
                                    
                                     strPrice = "\(self.productPriceData[i].unit_amount)"
                                    let price = Float(strPrice)
                                    let priceDecimal = price! / 100
                                    str = "€ \(priceDecimal) per night"
                                }
                                    
                                else
                                {
                                    
                                }
                              
                    }
                let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! paymentViewController
                                                      self.addChild(popOverVC)
                                                      popOverVC.strName  = name
                                                      popOverVC.strDesc  = description
                                                      popOverVC.strPrice  = strPrice
                                                      popOverVC.strPrice1 = str
                                                      self.view.addSubview(popOverVC.view)
                                                      popOverVC.didMove(toParent: self)
             }
                
                else
                {
                    
                     // self.facebookLoginData()
                    AppManager().AlertUser("Alert!", message: "Please SignIn", vc: self)

                    
                }
     
             
         
    }
    
    
}
extension ViewController {

    private func fetch(url: URL) -> AnyPublisher<[String: Any], URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated)) // Execute the request on a background thread
            .receive(on: DispatchQueue.main) // Execute the sink callbacks on the main thread
            .compactMap { try? JSONSerialization.jsonObject(with: $0.data) as? [String: Any] } // Get a JSON dictionary
            .eraseToAnyPublisher()
    }

    private func fetchSessionAccessToken(appId: String, accessToken: String) -> AnyPublisher<String, URLError> {
        var components = URLComponents(string: "\(fbAPIURL)/oauth/access_token")!
        components.queryItems = [URLQueryItem(name: "grant_type", value: "fb_attenuate_token"),
                                 URLQueryItem(name: "fb_exchange_token", value: accessToken),
                                 URLQueryItem(name: "client_id", value: appId)]

        return fetch(url: components.url!)
            .compactMap { $0["access_token"] as? String } // Get the Session Access Token
            .eraseToAnyPublisher()
    }

    private func fetchProfile(userId: String, accessToken: String) -> AnyPublisher<[String: Any], URLError> {
        var components = URLComponents(string: "\(fbAPIURL)/\(userId)")!
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken),
                                 URLQueryItem(name: "fields", value: "first_name,last_name,email")]

        return fetch(url: components.url!)
    }

    fileprivate func login(with accessToken: AccessToken) {
        // Get the request publishers
        let sessionAccessTokenPublisher = fetchSessionAccessToken(appId: accessToken.appID,
                                                                  accessToken: accessToken.tokenString)
        
        
       
        let profilePublisher = fetchProfile(userId: accessToken.userID, accessToken: accessToken.tokenString)
 print("hhh\(accessToken.appID) ooo  \(accessToken.tokenString)")
        // Start both requests in parallel and wait until all finish
        _ = Publishers
            .Zip(sessionAccessTokenPublisher, profilePublisher)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { sessionAccessToken, profile in
                // Perform the token exchange
                
                // print("hhh\(sessionAccessToken)eee\(sessionAccessToken)")
                Auth0
                    .authentication()
                    .login(facebookSessionAccessToken: sessionAccessToken, profile: profile)
                    .start { result in
                        switch result {
                        case .success(let credentials):
                            print(credentials) // Auth0 user credentials
                            DispatchQueue.main.async {
                              //  UIAlertController.show(message: "Logged in as \(profile["first_name"]!) \(profile["last_name"]!)")
                                
                                print("Logged in as \(profile["first_name"]!) \(profile["last_name"]!)")
                            }
                        case .failure(let error): print("kkk---\(error.localizedDescription)")
                    }
                }
            })
    }

}

extension ViewController: LoginButtonDelegate {

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error == nil, let accessToken = result?.token else {
            return print(error ?? "Facebook access token is nil")
        }

        print(accessToken.tokenString)
        login(with: accessToken)
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out")
    }

}

