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
    
    //Calories views
    var caloriesCircle: AdaptiveCircle?
    var caloriesView: UIView?
    
    //Macronutrient circles
    var macronutrientCirclesView: UIView?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        
        //Update test
        do {
            try self.caloriesCircle!.updateCirclePercent(percent: 0.95, time: 3)
        } catch is AdaptiveCircleException {
            print("Adapt")
        } catch {
            print("other")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.caloriesView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        self.caloriesView?.backgroundColor = .white
        
        self.contentView.addSubview(self.caloriesView!)
        self.addTestViews()
        
        self.caloriesCircle = AdaptiveCircle(radius: 100.0, centerPt: self.caloriesView!.center, percentComplete: 0.75)
        self.caloriesView?.addSubview(self.caloriesCircle!)
        //self.contentView.addSubview(circleTestView)
        
        //Finish UI Setup
        self.updateContentSize()
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
        self.setNeedsFocusUpdate()
        
    }
    
    
    func updateContentSize() {
        self.contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.getCurrentY())
    }
    
    
    func getCurrentY() -> CGFloat {
        var newContentSize: CGFloat = 0.0
        for view in contentView.subviews {
            newContentSize += view.bounds.height
        }
        
        return newContentSize
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
