//
//  PageViewController.swift
//  Eateries
//
//  Created by Michail Bondarenko on 2/5/19.
//  Copyright © 2019 Michail Bondarenko. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var headersArray = [NSLocalizedString("Write", comment: "Write"), NSLocalizedString("Search", comment: "Search")]
    var subheadersArray = [NSLocalizedString("Create your restaurant love list", comment: "Create your restaurant love list"), NSLocalizedString("Search and pin your love restaurants on map", comment: "Search and pin your love restaurants on map")]
    var imagesArray = ["food", "iphoneMap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        if let firstViewController = displayViewController(atIndex: 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        
        contentViewController.imageFile = imagesArray[index]
        contentViewController.header = headersArray[index]
        contentViewController.subheader = subheadersArray[index]
        contentViewController.index = index
        
        return contentViewController
    }
    
    func nextViewController(atIndex index: Int) {
        if let contentViewController = displayViewController(atIndex: +1) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.count
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//        return contentViewController!.index
//    }
}
