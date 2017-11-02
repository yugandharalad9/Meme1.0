//
//  MemeEditorViewController.swift
//  Meme 1.0
//
//  Created by Yugandhara Lad on 8/9/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,   UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

   
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
    
    
    
    //defining default text attributes
    let memeTextAttributes: [String: Any] = [NSStrokeColorAttributeName: UIColor.black, NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20) ?? 20, NSStrokeWidthAttributeName: 5]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")

        imgView.backgroundColor = UIColor.lightGray
        
        configureDefaultTextFieldSettings(textField: txtfldTOP)
        configureDefaultTextFieldSettings(textField: txtfldBOTTOM)
        
        //Disable Share button when Image is not picked
        shareButton.isEnabled = false
        
        //Assigning VC as the delegate for texfields
        self.txtfldTOP.delegate = self
        self.txtfldBOTTOM.delegate = self
    }
    
    func configureDefaultTextFieldSettings(textField: UITextField)  {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
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
        
        shareButton.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        
        savingImage(_source: .photoLibrary)
    }
  
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        
        print("pickImageFromCamera")
        
        savingImage(_source: .camera)
    }
    
    
    func savingImage(_source: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = _source
        present(controller, animated: true, completion: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        //self.tabBarController!.tabBar.isHidden = true
        //self.navigationController!.navigationBar.isHidden = false
        
    }

    func keyboardWillShow(_ notification:Notification) {
        print("goes into top txt")
        if txtfldBOTTOM.isFirstResponder {
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
    
    //text editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
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
        if txtfldBOTTOM.isFirstResponder {
            view.frame.origin.y = 0
            print("keyboard will hide")
        }
        
    }
    
    func saveMeme()  {
        //update the meme
        let meme = Meme(topText: txtfldTOP.text!, bottomText: txtfldBOTTOM.text!, originalImage: imgView.image!, memedImage: generateMemedImage())
        
        //Add saved memedImages to the meme array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        
        
        //Add the memed images to the memes array on the Application Delegate
        //(UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    
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
    
   
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
       imgView.image = nil
         
        txtfldTOP.text = "TOP"
        txtfldBOTTOM.text = "BOTTOM"
        
        dismiss(animated: true, completion: nil)
    }
}


