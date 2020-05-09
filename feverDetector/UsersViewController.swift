//
//  UsersViewController.swift
//  feverDetector
//
//  Created by Hayato Nakamura on 2020/05/06.
//  Copyright © 2020 Hayatopia. All rights reserved.
//

import UIKit
import Foundation

class UsersViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var zipcodeObject: UITextField!
    @IBOutlet weak var currentZipLabel: UILabel!
    @IBOutlet weak var testedPosLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardOnTap()
        if (isKeyPresentInUserDefaults(key: "zip") == false) {
            let defaults = UserDefaults.standard
            defaults.set("10036", forKey: "zip")
        }
        let zip = UserDefaults.standard.string(forKey: "zip")
        currentZipLabel.text = "Current zipcode: " + zip!
        
        update_labels()
        
    }
    
    func update_labels(){
        let zip = UserDefaults.standard.string(forKey: "zip")
        if let url = URL(string: "https://raw.githubusercontent.com/nychealth/coronavirus-data/master/tests-by-zcta.csv") {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                let parsedCSV: [[String]] = contents.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
                
                for lists in parsedCSV {
                    if (lists[0] == zip){
                        self.testedPosLabel.text = "# Tested Positive: "+String(lists[1])
                        self.totalLabel.text = "Total Tested: "+String(lists[2])
                        self.percentageLabel.text = "Positive (%): "+String(lists[3])+" %"
                    }
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func zipcodeChanged(_ sender: Any) {
        print(zipcodeObject.text!)
        if (zipcodeObject.text!.count != 5){
            let alert = UIAlertController(title: "", message: "Please enter a valid NY zipcode.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                // Handle your ok action
            }
            alert.addAction(okAction)

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
        let defaults = UserDefaults.standard
        defaults.set(zipcodeObject.text!, forKey: "zip")
        let zip = UserDefaults.standard.string(forKey: "zip")
        currentZipLabel.text = "Current zipcode: " + zip!
        update_labels()
        }
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {

internal func hideKeyboardOnTap(){
let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
tap.cancelsTouchesInView = false
self.view.addGestureRecognizer(tap);

}

@objc private func hideKeyboard(){
self.view.endEditing(true);
}
}
