//
//  ViewController.swift
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/15.
//  Copyright © 2016年 宫城. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var loadingView: GCLoadingView = GCLoadingView()
    var progressLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        let slide: UISlider = UISlider(frame: CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 100, 100, 50))
        self.view.addSubview(slide)
        slide.addTarget(self, action: #selector(updateProgress), forControlEvents: UIControlEvents.ValueChanged)
        slide.setValue(1.0, animated: false)
        
        self.progressLabel.frame = CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height - 150, 200, 50)
        self.progressLabel.textAlignment = .Center
        self.progressLabel.text = "progress = \(slide.value)"
        self.view.addSubview(self.progressLabel)
        
        self.loadingView.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 , 100, 100)
        self.view.addSubview(loadingView)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProgress(sender: AnyObject) {
        let slide = sender as! UISlider
        let progress = CGFloat(slide.value)
        self.loadingView.progress = progress
        self.progressLabel.text = "progress = \(progress)"
    }
}