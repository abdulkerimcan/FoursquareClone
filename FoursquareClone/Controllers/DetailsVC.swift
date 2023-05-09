//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Abdulkerim Can on 9.05.2023.
//

import UIKit
import Firebase

class DetailsVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func nextClick(_ sender: Any) {
        if nameText.text != "" && commentText.text != "" {
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            let destination = segue.destination as! MapVC
            destination.place?.name = nameText.text
            destination.place?.comment = commentText.text
            destination.place?.image = imageView.image
        }
    }
    
    func showAlert(title: String,message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okButton = UIAlertAction(title: "ok", style: .default,handler: nil)
           alert.addAction(okButton)
           self.present(alert,animated: true,completion: nil)
       }
}
