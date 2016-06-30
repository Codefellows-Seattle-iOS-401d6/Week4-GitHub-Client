//
//  ViewController.swift
//  animation test
//
//  Created by Derek Graham on 6/29/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import UIKit
//import 

class ViewController: UIViewController {

    @IBOutlet weak var square: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        animateSquare()
        animateSquareWithKeyFrames()
    }

    
    func animateSquare(){
        
        UIView.animateWithDuration(1.0, delay: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.square.alpha = 0.5
            self.square.transform = CGAffineTransformMakeScale(2.0, 2.0)
            
        }) { (finished) in
            print("animation finished")
 
        }
        
        
    }
    
    func animateSquareWithKeyFrames() {
        
        UIView.animateKeyframesWithDuration(4.0, delay: 1.0, options: .CalculationModeLinear, animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.25, animations: { 
                
                self.square.transform = CGAffineTransformMakeTranslation(0, 100.0)
             
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.5, animations: {
                self.square.alpha = 0.25
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 1.0, animations: { 
                self.square.alpha = 0.5
                self.square.backgroundColor = UIColor.blueColor()
            })
        
            
            }, completion: nil)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

