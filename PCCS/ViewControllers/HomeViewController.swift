//
//  HomeViewController.swift
//  PCCS
//
//  Created by Sivaramsingh on 05/05/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeViewController: UIViewController,URLSessionDelegate, XMLParserDelegate {
    
    var mutableData:NSMutableData  = NSMutableData()
    
    let recordKey = "Response"
    let dictionaryKeys = Set<String>(["ResponseCode","APIName", "Appointment","ResponseDescription"])
    
    // a few variables to hold the results as we parse the XML
    
    var results: [String: AnyObject]?         // the whole array of dictionaries
    var currentDictionary: [String: AnyObject]? // the current dictionary
    var currentInnerDictionary: [String: AnyObject]?
    var currentAppiontmentObj : AnyObject?
    var currentValue: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnRefreshClicked(_ sender: Any) {
        
        
        DispatchQueue.main.async { // 2
            MBProgressHUD.showHUDAddedGlobal()
        }


        let today = Date() // date is then today for this example
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"

        let username =  UserDefaults.standard.string(forKey: "Username") != nil ? UserDefaults.standard.string(forKey: "Username") : "borris"
       let password = UserDefaults.standard.string(forKey: "Password") != nil ? UserDefaults.standard.string(forKey: "Password") : "borris"
       let urlString = UserDefaults.standard.string(forKey: "Url") != nil ? UserDefaults.standard.string(forKey: "Url") : "https://www.skylinecms.co.uk/frozen/RemoteEngineerAPI/GetAppointmentDetails"
        let date = UserDefaults.standard.string(forKey: "Date") != nil ? UserDefaults.standard.string(forKey: "Date") : String(dateFormatter.string(from: today))

        let soapMessage = "<GetAppointmentDetails><SLUsername>\(username!)</SLUsername><SLPassword>\(password!)</SLPassword><CurrentDate>\(date!)</CurrentDate></GetAppointmentDetails>"


        let soapLenth = String(soapMessage.count)
        let theURL = NSURL(string: urlString!)
        let mutableR = NSMutableURLRequest(url: theURL! as URL)

        // MUTABLE REQUEST

        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: mutableR as URLRequest) { data, response, error in


            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    MBProgressHUD.dismissGlobalHUD()
                }
                print("error=\(error!)")
                let alertController = UIAlertController(title:"Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
                let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
                })
                alertController.addAction(yesAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.async {
                MBProgressHUD.dismissGlobalHUD()
            }
            print("response = \(response!)")
            let responseString = String(data: data, encoding: .utf8)
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            
            if parser.parse() {
                print(self.results!)
                
                var strmessage : String = ""
                var codeString : String = ""
                
                let code = self.results!["ResponseCode"] as? String ?? ""
                switch code {
                case "SC0002":
                    codeString = "SC0002"
                    strmessage = self.results!["ResponseDescription"] as? String ?? ""
                    break
                case "SC0001":
                    codeString = "SC0001"
                    strmessage = self.results!["ResponseDescription"] as? String ?? ""
                    break
                default:
                    break
                }
                
                let alertController = UIAlertController(title: codeString , message: strmessage , preferredStyle: UIAlertControllerStyle.alert)
                let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) in
                })
                alertController.addAction(yesAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            print("responseString = \(responseString!)")
        }
        task.resume()
        
    }
    
   

    @IBAction func btnSettingsClicked(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let navController = UINavigationController(rootViewController: settingsVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
  

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "GoToListVC") {
            if let listVC = segue.destination as? ListViewController {
               listVC.title = "PCCS"
                self.navigationController?.navigationBar.isHidden = false
            }
        }
        else{}
        
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        results = [:]
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
        else if dictionaryKeys.contains("Appointments")
        {
            currentInnerDictionary = [:]
        }
        else if dictionaryKeys.contains("Appointment")
        {
            currentAppiontmentObj = [:] as AnyObject
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            results = (currentDictionary!)
            currentDictionary = nil
        } else if dictionaryKeys.contains("ResponseCode") {
            currentDictionary![elementName] = currentValue as AnyObject
            currentValue = nil
        }
        else if dictionaryKeys.contains("Appointment") {
            currentInnerDictionary![elementName] = currentValue as AnyObject
            currentValue = nil
        }
        else if dictionaryKeys.contains("Appointments") {
            currentDictionary!["Appointments"] = currentInnerDictionary as AnyObject
            currentValue = nil
        }
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        
        currentValue = nil
        currentDictionary = nil
        results = nil
    }
    
    
   
}
