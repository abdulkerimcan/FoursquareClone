//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signInClick(_ sender: Any) {
        if emailText.text != "" && passwordText.text != nil {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { data, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        if emailText.text != "" && passwordText.text != nil {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { data, error in
                if error != nil {
                    self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
    }
    func showAlert(title: String,message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okButton = UIAlertAction(title: "ok", style: .default,handler: nil)
           alert.addAction(okButton)
           self.present(alert,animated: true,completion: nil)
       }
}

