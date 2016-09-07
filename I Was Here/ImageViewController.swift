//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Ahmed Yakout on 8/8/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit
import Alamofire


let center = NSNotificationCenter.defaultCenter()
var alamoFireManager : Alamofire.Manager?


class ImageViewController: UIViewController, UIScrollViewDelegate {
    var imageName: String?
    var folderName: String?
    @IBOutlet weak var image:UIImageView?
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView?.delegate = self
            scrollView?.maximumZoomScale = 2
            scrollView?.minimumZoomScale = 0.3
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func done(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteImage(sender: AnyObject) {
        // delete from data base
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this picture? It will no longer be available", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            action in
            // delete
            
            Alamofire.request(.DELETE, "\(url)/folder/\(self.folderName!)/image/\(self.imageName!)", parameters:[
                "id":User.currentUser.uid ?? "",
                "token": User.currentUser.token ?? ""
                ], encoding: .JSON)
                .responseJSON { response in
                    debugPrint(response)
                    
                    print(String(data:response.data ?? NSData(), encoding: NSUTF8StringEncoding))

            }
            self.done(nil)
            })
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)) // do no thing
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        if let imageToBeSaved = image?.image {
            UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
        }
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return image
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = imageName {
            image?.image = imageCache.objectForKey(imageName) as? UIImage
        }
    }
    
}
