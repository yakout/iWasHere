//
//  ImageViewController.swift
//  cassini
//
//  Created by Ahmed Yakout on 8/3/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit



var count = 0
class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    
    // MARK: image
    var imageUrl: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
            fetchImage() // what if i set the model and fetch the data but the view never appeared in the screen? (user didn't request that) so i shouldn't fetch any data unless the view appeared in ImageViewController so we should check view.window first
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageUrl {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [weak weakSelf = self] in
               let contentsOfURL = NSData(contentsOfURL: url)
                print("image data fetching")
                if url == weakSelf?.imageUrl { // in case user request another picture before the data fetched
                    dispatch_async(dispatch_get_main_queue()) {
                        if let imageData = contentsOfURL {
                        weakSelf?.image = UIImage(data: imageData)
                        } else {
                            weakSelf?.spinner?.stopAnimating()
                        }
                    }
                } else {
                    print(" ignore data return from url \(url)")
                }
            }
        }
    }
    private var imageView = UIImageView() // note it has no parameters, it's frame is at 0,0
    
    var image: UIImage? {
        set {
            imageView.image = newValue
            imageView.sizeToFit() // to fit what ever image in it
            spinner?.stopAnimating()
            //scrollView?.contentSize = imageView.bounds.size
        }
        get {
            return (imageView.image)
        }
    }
    

    
    @IBOutlet weak var spinner: UIActivityIndicatorView! // dont forget to check the hide when stopped option in spinner inspector
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            //scrollView?.contentSize = imageView.bounds.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView // the thing we want to zoom it will return the the transformed picture every time we zoom out/in
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    
    deinit {
        count-=1
        print("ImageViewController left the heap = \(count)")
    }
    
    
    
    // MVC life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // image = UIImage(named: "Image")
        //imageUrl = NSURL(string: DemoURL.Stanford) // urls are classed not string
        view.addSubview(scrollView) //
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.bounds.size
        
        count+=1
        print("ImageViewController loaded count = \(count)")
        
        imageView.alpha = 0
        UIView.animateWithDuration(5) { [weak self] in
            self?.imageView.alpha = 1
        }
        
        // Do any additional setup after loading the view.
    }
}
