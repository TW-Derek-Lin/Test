//
//  PhoneDisplayViewController.swift
//  ETPlayground
//
//  Created by Dong Han Lin on 2018/11/2.
//  Copyright © 2018 Dong Han Lin. All rights reserved.
//

import UIKit

class PhotoDisplayViewController: UIViewController, UIPageViewControllerDataSource {

    var albumIndex : Int = 0
    var albumName : String = ""
    var currentPageIndex : Int = 0
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhonePageViewController") as! UIPageViewController)
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.pageDisplayAtIndex(self.currentPageIndex)
        self.pageViewController.setViewControllers([initialContenViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
    }
    
    override func viewWillLayoutSubviews() {
        self.pageViewController.view.frame = self.view.bounds
    }
    
    func pageDisplayAtIndex(_ index: Int) -> DisplayViewController {
        let displayVC = DisplayViewController(nibName: "DisplayViewController", bundle: nil)
        displayVC.image = PhotoCacheContoller.shared.getImageFromAlbum(albumIndex: self.albumIndex, photoIndex: index)
        displayVC.pageIndex = index
        return displayVC
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! DisplayViewController
        var index = viewController.pageIndex as Int
        if index == 0 || index == NSNotFound {
            return nil
        }
        index -= 1
        return self.pageDisplayAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! DisplayViewController
        var index = viewController.pageIndex as Int
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == PhotoCacheContoller.shared.photoCollection[self.albumIndex].1.count {
            return nil
        }
        return self.pageDisplayAtIndex(index)
    }
}
