//
//  AddActivityTaskController.swift
//  Activity Tracker App
//
//  Created by VijayaBhaskar on 04/05/19.
//  Copyright © 2019 VijayaBhaskar. All rights reserved.
//

import UIKit

class AddActivityTaskController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var titleTxtFeild: UITextField!
    
    @IBOutlet weak var descTxtFeils: UITextField!
    var imagePicker = UIImagePickerController()

    let datePicker = UIDatePicker()

    @IBOutlet weak var duedateTxtFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show date picker
        showDatePicker()
        self.navigationController?.navigationBar.shouldRemoveShadow(false)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cameraBtnClicked(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController (title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheetController.addAction( UIAlertAction (title: "Cancel", style: .cancel, handler: nil))

        actionSheetController.addAction( UIAlertAction (title: "Photo Library", style: .default, handler:{ (alert: UIAlertAction!) in self.chooseFromPhotoLibrary()}
        ))
        actionSheetController.addAction( UIAlertAction (title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in self.chooseFromCamera()}
        ))
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func chooseFromPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func chooseFromCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("This device has no Camera")
            
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        userImageView.image = chosenImage
//        userImageView.clipsToBounds = true
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage
        userImageView.image = chosenImage
        userImageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addbtnClicked(_ sender: Any) {
        
        if (titleTxtFeild.text?.isEmpty)!{
            showAlertMsg()
        }else if (descTxtFeils.text?.isEmpty)!{
            showAlertMsg()
        }else if (duedateTxtFeild.text?.isEmpty)!{
            showAlertMsg()
        }else{
            let alert = UIAlertController(title: "You have added successfully. Adding Your task is in still progress. Please wait", message: "", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                _ = self.navigationController?.popViewController(animated: true)
                alert.dismiss(animated: true, completion: nil)
                
                
            }
        }
    }
    
    func showAlertMsg() {
        let alert = UIAlertController(title: "Error", message: "Please fill all data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        duedateTxtFeild.inputAccessoryView = toolbar
        duedateTxtFeild.inputView = datePicker
        
    }

    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        duedateTxtFeild.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
