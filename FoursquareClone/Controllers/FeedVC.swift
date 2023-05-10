//
//  FeedVC.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var docID = ""
    var docIdList = [String]()
    var namesList = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(logout))
        
        getData()
    }
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("Places").addSnapshotListener { snapshot, error in
            if error != nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                    
                    if snapshot?.isEmpty == false {
                        
                        self.namesList.removeAll(keepingCapacity: false)
                        for document in snapshot!.documents {
                            
                            self.docIdList.append(document.documentID)
                            print("asa")
                            if let name = document.get("comment") as? String {
                                self.namesList.append(name)
                            }
                        }
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    @objc func addButton() {
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
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
        return namesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = namesList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        docID = docIdList[indexPath.row]
        performSegue(withIdentifier: "toPlaceVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlaceVC" {
            let destination = segue.destination as! PlaceVC
            destination.docId = docID
        }
    }
    
    func showAlert(title: String,message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okButton = UIAlertAction(title: "ok", style: .default,handler: nil)
           alert.addAction(okButton)
           self.present(alert,animated: true,completion: nil)
       }
    
}
