//
//  ListViewController.swift
//  PCCS
//
//  Created by Sivaramsingh on 05/05/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var addressTxtView: UITextView!
    @IBOutlet weak var lblCall: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PCCS"
        addressTxtView.textAlignment = .left
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
  
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCallClicked(_ sender: Any) {
        
        if let url = URL(string: "tel://\(lblCall.text!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else {
            print("Your device doesn't support this feature.")
        }
    }
    
    @available(iOS 10.0, *)
    @IBAction func btnAddressClicked(_ sender: Any) {
        
        let testURL: NSURL = NSURL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(testURL as URL) {
            if let address = addressTxtView.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let directionsRequest: String = "comgooglemaps-x-callback://" + "?daddr=\(address)" + "&x-success=sourceapp://?resume=true&x-source=AirApp"
                let directionsURL: NSURL = NSURL(string: directionsRequest)!
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(directionsURL as URL)) {
                    application.open(directionsURL as URL, options: [:], completionHandler: nil)
                }
            }
        } else {
            NSLog("Can't use comgooglemaps-x-callback:// on this device.")
        }
    }
    

}
