//
//  CollectionViewController.swift
//  Meme 2.0
//
//  Created by Yugandhara Lad on 10/26/17.
//  Copyright © 2017 Yugandhara Lad. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    @IBOutlet var myCollectionView: UICollectionView!
    
    private let reuseIdentifier = "CCell"

    var sentMemes: [Meme]! {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        return appDelegate.memes
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CCell")

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Meme", style: .plain, target: self, action: #selector(creatNewMemeCVC))
    }
//Navigationg to MemeEditorViewController from "NEW Meme" button
    
    func creatNewMemeCVC() {
        if let navigationController = navigationController {
            let memeEditorViewContoller = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
            navigationController.present(memeEditorViewContoller, animated: true, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView!.reloadData()
        print(sentMemes)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sentMemes.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCell", for: indexPath) as! CollectionViewCell
        
    
        // Configure the cell
    
        let memedImagesCollectionView = sentMemes[indexPath.row]
        
        cell.imageViewCollectionViewCell?.image = memedImagesCollectionView.memedImage
        
        print("Image = \(memedImagesCollectionView.memedImage)")
        
        print("Image in cell is \(cell.imageViewCollectionViewCell?.image)")
        /*if cell.imageViewCollectionViewCell.image != nil {
            print("Image")
        } else {
            print("no Image")
        }*/
        //cell.imageViewCollectionViewCell!.image = memedImagesCollectionView.memedImage
        
        cell.backgroundColor = UIColor.black
  
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
