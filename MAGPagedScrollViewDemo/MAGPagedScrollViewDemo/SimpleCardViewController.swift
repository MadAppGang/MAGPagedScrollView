//
//  SimpleCardViewController.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 23/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class SimpleCardViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var imageName: String? = nil {
        didSet {
            if let imageName = imageName {
                self.imageView?.image = UIImage(named: imageName)
            } else {
                self.imageView?.image = nil
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = imageName {
            self.imageView?.image = UIImage(named: imageName)
        } else {
            self.imageView?.image = nil
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        NSBundle.mainBundle().loadNibNamed("SimpleCardViewController", owner: self, options: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
