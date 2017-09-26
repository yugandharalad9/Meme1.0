//
//  ViewController.swift
//  Meme 1.0
//
//  Created by Yugandhara Lad on 8/9/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//

import UIKit

class ViewController: UIViewController,   UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnCamera: UIBarButtonItem!
    @IBOutlet var txtfldTOP: UITextField!
    @IBOutlet var txtfldBOTTOM: UITextField!
    //For ToolBar and Navigation Bar
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var navigationBar: UINavigationBar!
    //Share and Cancel button
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    
    
    
    let memeTextAttributes: [String: Any] = [NSStrokeColorAttributeName: UIColor.black, NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20) ?? 20, NSStrokeWidthAttributeName: 5]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")

        imgView.backgroundColor = UIColor.lightGray
        
        txtfldTOP.defaultTextAttributes = memeTextAttributes
        txtfldBOTTOM.defaultTextAttributes = memeTextAttributes
        txtfldTOP.textAlignment = .center
        txtfldBOTTOM.textAlignment = .center
        //txtfldTOP.delegate = self
        //txtfldBOTTOM.delegate = self
        //txtfldTOP.tag = 0
        //txtfldBOTTOM.tag = 1
        
        //self.hideKeyboardWhenTappedAround()
        
    }
    
   


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotification()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("imagePickerController")
        
        let imageSelected = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgView.image = imageSelected
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        
        print("pickImage")
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
        print("got the pic")
    }
  
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        
        print("pickImageFromCamera")
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        present(controller, animated: true, completion: nil)
       print("Clicked the photo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }

    func keyboardWillShow(_ notification:Notification) {
        print("goes into bottm txt")
        if txtfldBOTTOM.isEditing {
            print("bottom is editing")
            view.frame.origin.y -= getKeyboardHeight(notification)
            print("frame shifted")
            
            
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let myUserInfo = notification.userInfo
        let keyboardSize = myUserInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        print("Keyboard Size")
        print(keyboardSize.cgRectValue.height)
        return keyboardSize.cgRectValue.height
        
        
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("Now keyboard is abt to return")
        
        //try to find the next responder
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
            print("Now keyboard hides")
        }
        return false
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
        print("keyboard will hide")
    }
    
    func saveMeme()  {
        let meme = Meme(topText: txtfldTOP.text!, bottomText: txtfldBOTTOM.text!, originalImage: imgView.image!, memedImage: generateMemedImage())
        
    
    }
    
    func generateMemedImage() -> UIImage {
        
        //hiding toolbar and navigation bar
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //showing toolbar and navigation bar after the memed image is generated
        toolBar.isHidden = false
        navigationBar.isHidden = false
        
        return memedImage
    }
    
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
            let memedImage = generateMemedImage()
            var memedImages = [UIImage]()
            memedImages.append(memedImage)
            
            //passing memedImages as activity items in the Activity View Controller
            
            let activityController = UIActivityViewController(activityItems: memedImages as [AnyObject], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.view
            
            present(activityController, animated: true, completion: nil)
            
            activityController.completionWithItemsHandler = { (activity, success, items, error) in
                print(success ? "SUCCESS!" : "FAILURE")
                
                if success {
                    self.saveMeme()
                    print("Memed Imaged saved")
                    self.dismiss(animated: true, completion: nil)
                }
                
        }
        
        
    }
    
    /*func saveMemedImageAfterSharing(text: String,completion: Bool) {
        if completion {
            self.saveMeme()
            self.dismiss(animated: true, completion: nil)
        }
    }*/
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
       imgView.image = nil
        
        txtfldTOP.text = "TOP"
        txtfldBOTTOM.text = "BOTTOM"
        
    }
    

    }


