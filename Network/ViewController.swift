//
//  ViewController.swift
//  Network
//
//  Created by Dimz on 19.07.17.
//  Copyright © 2017 Dmitriy Zyablikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func getResponseTapped(_ sender: UIButton) {
        
        resultLabel.text = nil
        
        let requestURL = GetMemeEndpoint(name: "").request
        
        DispatchQueue.main.async {
            
        Network.performHTTPRequest(url: requestURL) { (data, response, error) in
            
            if error != nil {
                debugPrint(error?.localizedDescription ?? "Проверьте интернет соединение")
                
                if let message = (data as? String) {
                    self.showAlert(title: nil, message: message)
                }
                
                return
            }
            
            if response?.statusCode != 200 {
                // check for http errors
                self.showAlert(title: nil, message: "Error")
                self.resultLabel.text = "statusCode should be 200, but is \(String(describing: response?.statusCode))"
                print("response = \(response!)")
                return
            }
            
            self.resultLabel.text = "request succeeded"
            
//            if let resultJson = data as? [String : Any] {
//                if let code = resultJson["code"] as? String {
//                    print(code)
//                    
//                    self.phoneCode = code
//                    
//                    self.performSegue(withIdentifier: "codeSegue", sender: nil)
//                }
//            }
            }

        }
    }
    
    func showAlert(title: String?, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    


}

