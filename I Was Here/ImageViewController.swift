//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Ahmed Yakout on 8/8/16.
//  Copyright © 2016 iYakout. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var image:UIImageView?
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView?.delegate = self
            scrollView?.maximumZoomScale = 2
            scrollView?.minimumZoomScale = 0.3
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return image
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
