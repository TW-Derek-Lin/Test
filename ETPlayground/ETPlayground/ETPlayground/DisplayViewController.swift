//
//  DisplayViewController.swift
//  ETPlayground
//
//  Created by Dong Han Lin on 2018/11/2.
//  Copyright © 2018 Dong Han Lin. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var scrollView : UIScrollView!
    
    var image: UIImage!
    var pageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImageView.image = image
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        self.scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.displayImageView
    }
}
