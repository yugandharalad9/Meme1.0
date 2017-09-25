//
//  KeyboardTouchHide.swift
//  Meme 1.0
//
//  Created by Yugandhara Lad on 8/16/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//
import UIKit
import Foundation
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    }
    func dismissKeyboard()  {
        view.endEditing(true)
    }
}
