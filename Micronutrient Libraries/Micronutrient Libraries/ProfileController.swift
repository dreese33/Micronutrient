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
    
    //Calendar View
    var calendarView: UIView!
    var currentDate: UILabel!
    var rightArrow: UIImageView!
    var leftArrow: UIImageView!
    
    //Calories views
    var caloriesCircle: AdaptiveCircle!
    var caloriesView: UIView!
    var caloriesLabel: UILabel!
    var caloriesGoal: UILabel!
    
    var currentCalories: Int = 0
    var currentGoal: Int = 0
    
    //Macronutrient circles
    var macronutrientCirclesView: UIView?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Nutrient Profile"
        
        //Update test
        self.update(circle: self.caloriesCircle!, percent: 0.95, time: 1.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCalendarView()
        self.addCaloriesView()
        
        //Finish UI Setup
        //self.updateContentSize()
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
        self.setNeedsFocusUpdate()
    }
    
    /*
    func updateContentSize() {
        self.contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.getCurrentY())
    }*/
    
    /*
    func getCurrentY() -> CGFloat {
        var newContentSize: CGFloat = 0.0
        for view in contentView.subviews {
            newContentSize += view.bounds.height
        }
        
        return newContentSize
    }*/
    
    
    func addTestViews() {
        let macronutrientCircles1 = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        macronutrientCircles1.backgroundColor = .orange
        let macronutrientCircles2 = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        macronutrientCircles2.backgroundColor = .yellow
        
        self.contentView.addSubview(macronutrientCircles1)
        self.contentView.addSubview(macronutrientCircles2)
    }
    
    
    func addCaloriesView() {
        print(self.calendarView.frame.height)
        self.caloriesView = UIView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        //self.caloriesView = UIView()
        self.caloriesView.backgroundColor = .white
        self.caloriesView.layer.borderColor = UIColor.black.cgColor
        self.caloriesView.layer.borderWidth = 1
         
        self.contentView.addSubview(self.caloriesView!)
        // self.addTestViews()
         
        self.caloriesCircle = AdaptiveCircle(radius: self.caloriesView!.frame.width / 4, centerPt: CGPoint(x: self.caloriesView!.bounds.width / 2, y: self.caloriesView!.bounds.height / 2), percentComplete: 0.75)
        self.caloriesView?.addSubview(self.caloriesCircle!)
        //self.contentView.addSubview(circleTestView)
        
        //frame: CGRect(x: 0, y: 150, width: 100, height: 100)
        self.caloriesLabel = UILabel()
        self.caloriesLabel.text = "Calories: " + String(self.currentCalories) + " kcal"
        self.caloriesLabel.textAlignment = .center
        self.caloriesView.addSubview(caloriesLabel)
        
        self.caloriesGoal = UILabel()
        self.caloriesGoal.text = "Goal: " + String(self.currentGoal) + " kcal"
        self.caloriesLabel.textAlignment = .center
        self.caloriesView.addSubview(caloriesGoal)
        
        [caloriesGoal, caloriesLabel].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            //Calories Label
            self.caloriesLabel.centerXAnchor.constraint(equalTo: self.caloriesView.centerXAnchor),
            self.caloriesLabel.centerYAnchor.constraint(equalTo: self.caloriesCircle.topAnchor, constant: -40),
            self.caloriesLabel.heightAnchor.constraint(equalToConstant: 40),
            
            //Calories Goal
            self.caloriesGoal.centerXAnchor.constraint(equalTo: self.caloriesView.centerXAnchor),
            self.caloriesGoal.centerYAnchor.constraint(equalTo: self.caloriesCircle.bottomAnchor, constant: 40),
            self.caloriesGoal.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func addCalendarView() {
        self.calendarView = UIView()
        self.calendarView.backgroundColor = UIColor.init(red: 54.0 / 255.0, green: 157.0 / 255.0, blue: 158.0 / 255.0, alpha: 1)
        self.calendarView.layer.borderColor = UIColor.black.cgColor
        //self.calendarView.layer.borderWidth = 1

        self.currentDate = UILabel()
        self.currentDate.text = "5/6/20"
        self.currentDate.textColor = .black
        self.currentDate.layer.borderColor = UIColor.black.cgColor
        self.currentDate.layer.borderWidth = 1
        self.currentDate.textAlignment = .center
        self.currentDate.backgroundColor = .white

        guard let imgLeft = UIImage(systemName: "arrow.left"),
            let imgRight = UIImage(systemName: "arrow.right") else {
                fatalError("Could not create arrow images!")
        }

        let image1 = imgLeft.withTintColor(.blue)
        let image2 = imgRight.withTintColor(.blue)

        self.leftArrow = UIImageView(image: image1)
        self.rightArrow = UIImageView(image: image2)
        
        self.leftArrow.tintColor = .white
        self.rightArrow.tintColor = .white

        self.calendarView.addSubview(currentDate)
        self.calendarView.addSubview(self.leftArrow)
        self.calendarView.addSubview(self.rightArrow)

        self.view.addSubview(self.calendarView)

        [calendarView, currentDate, leftArrow, rightArrow].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }

        // respect safe area
        let g = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            // calendarView to view (safe area) Top / Leading / Trailing
            //  Height: 60
            calendarView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
            calendarView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
            calendarView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
            calendarView.heightAnchor.constraint(equalToConstant: 60.0),

            // currentDate label to calendarView centerX & centerY
            //  Width: 1/2 of calendarView width
            //  Height: 40
            currentDate.centerXAnchor.constraint(equalTo: calendarView.centerXAnchor),
            currentDate.centerYAnchor.constraint(equalTo: calendarView.centerYAnchor),
            currentDate.heightAnchor.constraint(equalToConstant: 40.0),
            currentDate.widthAnchor.constraint(equalTo: calendarView.widthAnchor, multiplier: 0.5),

            // leftArrow to calendarView Leading: 10 Width: 40 Height: 40 centerY
            leftArrow.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10.0),
            leftArrow.widthAnchor.constraint(equalToConstant: 40.0),
            leftArrow.heightAnchor.constraint(equalToConstant: 40.0),
            leftArrow.centerYAnchor.constraint(equalTo: calendarView.centerYAnchor),

            // rightArrow to calendarView Trailing: -10 Width: 40 Height: 40 centerY
            rightArrow.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -10.0),
            rightArrow.widthAnchor.constraint(equalToConstant: 40.0),
            rightArrow.heightAnchor.constraint(equalToConstant: 40.0),
            rightArrow.centerYAnchor.constraint(equalTo: calendarView.centerYAnchor),

        ])
    }
    
    
    func update(circle: AdaptiveCircle, percent: CGFloat, time: CGFloat) {
        do {
            try circle.updateCirclePercent(percent: percent, time: time)
        } catch is AdaptiveCircleException {
            print("Adapt")
        } catch {
            print("other")
        }
    }
}
