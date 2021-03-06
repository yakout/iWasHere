//
//  MemoriesViewController.swift
//  iWasHere
//
//  Created by Khalil Mohammed Yakout on 9/6/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire

class MemoriesViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    struct Const {
        static let GridView = "GridCellIdentifer"
        static let showImageIdentifier = "showImage"
    }
    
    var memories = [Memory]()
    var folderName: String = ""
    var folderIndex : Int!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    
    // MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "pull to refresh")
        refreshControl.addTarget(self, action: #selector(MemoriesViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        collectionView.addSubview(refreshControl) // not required when using UITableViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        memories = User.currentUser.places?[folderIndex].memories ?? []
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout methods very important !!
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1;
    }
    
    
    
    // MARK: - UICollectionViewDatasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Const.GridView, forIndexPath: indexPath) as? MemoryCollectionViewCell
                
        let memory = memories[indexPath.row]
        let memoryName =  memory.name ?? ""
        let memoryDesc = memory.description ?? ""
        
        cell?.spinner.hidesWhenStopped = true
        cell?.spinner.startAnimating()
        
        if let cachedImage = imageCache.objectForKey(memoryName) as? UIImage {
            cell?.memoryImage.image = cachedImage
            cell?.memoryName = memoryName
            cell?.spinner.stopAnimating()
            cell?.memoryDescription.text = memoryDesc
            
            cell?.layer.cornerRadius = 10.0
            cell?.layer.borderColor = UIColor.grayColor().CGColor
            cell?.layer.borderWidth = 2
            
            return cell!
        }
        
        Alamofire.request(.GET, "\(url)/image", parameters:[
            "id":User.currentUser.uid ?? "",
            "token": User.currentUser.token ?? "",
            "folderName": folderName,
            "imageName": memoryName ?? "",
            ])
            .responseJSON { response in
                let base64 = String(data:(response.data)!, encoding: NSUTF8StringEncoding)!
                dispatch_async(dispatch_get_main_queue()) {
                    if let data = NSData(base64EncodedString: base64, options: []) {
                        if let image = UIImage(data: data) {
                            cell?.memoryImage.image = image
                            cell?.memoryName = memoryName
                            cell?.spinner.stopAnimating()
                            cell?.memoryDescription.text = memoryDesc
                            imageCache.setObject(image, forKey: memoryName)
                        }
                    }
                }
        }

        cell?.layer.cornerRadius = 10.0
        cell?.layer.borderColor = UIColor.grayColor().CGColor
        cell?.layer.borderWidth = 2
        
        // cell.backgroundColor = chooseColor()
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if User.currentUser.isList {
            return CGSize(width: self.view.frame.width, height: self.view.frame.width + 100.0)
        }
        return CGSize(width: self.view.frame.width/3 - 2.0, height: self.view.frame.width/3 + 60.0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier(Const.showImageIdentifier, sender: cell)
        }
    }
    
    
    // MARK: - helpers
    
    func refresh(sender:AnyObject) {
        collectionView.reloadData()
        sleep(4)
        refreshControl.endRefreshing()
    }

    // for testing purposes
    func chooseColor() -> UIColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: 0.7)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Const.showImageIdentifier {
            if let dest = segue.destinationViewController as? ImageViewController {
                let cell = sender as! MemoryCollectionViewCell
                dest.imageName = cell.memoryName
                dest.folderName = folderName
            }
        }
    }

}
