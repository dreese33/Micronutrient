//
//  ProfileController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/4/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    //Main view
    @IBOutlet weak var contentView: UIView!
    
    //Macronutrient circles
    var macronutrientCircles: UIView?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.macronutrientCircles = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        self.macronutrientCircles?.backgroundColor = .black
        
        self.contentView.addSubview(self.macronutrientCircles!)
        //self.addTestViews()
        
        self.updateContentSize()
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
        
        self.setNeedsFocusUpdate()
    }
    
    
    func updateContentSize() {
        var newContentSize: CGFloat = 0.0
        for view in contentView.subviews {
            newContentSize += view.bounds.height
        }
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: newContentSize)
    }
    
    
    func addTestViews() {
        let macronutrientCircles1 = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        macronutrientCircles1.backgroundColor = .orange
        let macronutrientCircles2 = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        macronutrientCircles2.backgroundColor = .yellow
        
        self.contentView.addSubview(macronutrientCircles1)
        self.contentView.addSubview(macronutrientCircles2)
    }
}
