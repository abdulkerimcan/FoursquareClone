//
//  FeedVC.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import UIKit
import Firebase

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(logout))
    }
    
    @objc func addButton() {
        
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toLoginVC", sender: nil)
        } catch {
            showAlert(title: "Error", message: "Error exists when trying to log out")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func showAlert(title: String,message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okButton = UIAlertAction(title: "ok", style: .default,handler: nil)
           alert.addAction(okButton)
           self.present(alert,animated: true,completion: nil)
       }
    
}
