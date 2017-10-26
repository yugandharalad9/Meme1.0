//
//  DetailMemedImageVC.swift
//  Meme 1.0
//
//  Created by Yugandhara Lad on 10/17/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//

import UIKit

class DetailMemedImageVC: UIViewController {

    @IBOutlet var ImgViewDetailedMeme: UIImageView!
    var detailMeme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        self.ImgViewDetailedMeme.image = detailMeme.memedImage
    }
    
    

}
