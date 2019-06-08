//
//  ContentViewController.swift
//  Eateries
//
//  Created by Michail Bondarenko on 2/5/19.
//  Copyright © 2019 Michail Bondarenko. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        switch index {
        case 0:
            let pageViewController = parent as! PageViewController
            pageViewController.nextViewController(atIndex: index)
        case 1:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "wasIntroWatched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        pageButton.layer.borderColor = (#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)).cgColor
        
        switch index {
        case 0:
            pageButton.setTitle(NSLocalizedString("Next", comment: "Next"), for: .normal)
        case 1:
            pageButton.setTitle(NSLocalizedString("Open App", comment: "Open App"), for: .normal)
        default:
            break
        }
        
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
