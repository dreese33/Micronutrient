//
//  ProfileController.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/4/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    //Global colors
    var borderColors: CGColor = UIColor.gray.cgColor
    
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
    var macronutrientCirclesView: UIView!
    var macrosLabel: UILabel!
    
    //Protein
    var proteinCircle: AdaptiveCircle!
    var proteinLabel: UILabel!
    var proteinGoal: UILabel!
    var proteinAmount: UILabel!
    var currentProteinAmount: Int = 0
    var currentProteinGoal: Int = 0
    
    //Carbs
    var carbsCircle: AdaptiveCircle!
    var carbsLabel: UILabel!
    var carbsGoal: UILabel!
    var carbsAmount: UILabel!
    var currentCarbsAmount: Int = 0
    var currentCarbsGoal: Int = 0
    
    //Fats
    var fatsCircle: AdaptiveCircle!
    var fatsLabel: UILabel!
    var fatsGoal: UILabel!
    var fatsAmount: UILabel!
    var currentFatAmount: Int = 0
    var currentFatGoal: Int = 0
    

    //Foods List
    public static var foodsList: [Food] = []
    var foodsTable: UITableView!
    var foodsLabel: UILabel!
    var foodsSuperView: UIView!
    
    
    //Micronutrients List (change from Food to new Micronutrient class)
    public static var micronutrientsList: [Food] = []
    var micronutrientTable: UITableView!
    var micronutrientLabel: UILabel!
    var micronutrientSuperView: UIView!
    
    //Main Scroll View
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
        self.addMacronutrientViews()
        self.addFoodsView()
        self.addMicronutrientsView()
        
        //Finish UI Setup
        self.updateContentSize()
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
        self.setNeedsFocusUpdate()
    }
    
    
    func updateContentSize() {
        self.contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.getCurrentHeight())
    }
    
    func getCurrentHeight() -> CGFloat {
        var height: CGFloat = 0.0
        height += UIScreen.main.bounds.width * 5 + 60
        
        return height
    }
    
    
    func addTestViews() {
        let macronutrientCircles1 = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        macronutrientCircles1.backgroundColor = .orange
        let macronutrientCircles2 = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.width * 2, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        macronutrientCircles2.backgroundColor = .yellow
        
        self.contentView.addSubview(macronutrientCircles1)
        self.contentView.addSubview(macronutrientCircles2)
    }
    
    
    func addCalendarView() {
        
        self.calendarView = UIView()
        self.calendarView.backgroundColor = UIColor.init(red: 54.0 / 255.0, green: 157.0 / 255.0, blue: 158.0 / 255.0, alpha: 1)
        self.calendarView.layer.borderColor = self.borderColors
        //self.calendarView.layer.borderWidth = 1

        let radiusCorner: CGFloat = 20
        
        self.currentDate = UILabel()
        self.currentDate.text = "5/6/20"
        self.currentDate.textColor = .black
        self.currentDate.layer.borderWidth = 1
        self.currentDate.layer.borderColor = self.borderColors
        self.currentDate.textAlignment = .center
        self.currentDate.backgroundColor = .white
        self.currentDate.layer.cornerRadius = radiusCorner
        self.currentDate.layer.shadowRadius = radiusCorner
        self.currentDate.layer.masksToBounds = true

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

        self.calendarView.addSubview(self.currentDate)
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
    
    
    func addCaloriesView() {
        print(self.calendarView.frame.height)
        self.caloriesView = UIView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        //self.caloriesView = UIView()
        self.caloriesView.backgroundColor = .white
        self.caloriesView.layer.borderColor = self.borderColors
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
        self.caloriesLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.caloriesView.addSubview(caloriesLabel)
        
        self.caloriesGoal = UILabel()
        self.caloriesGoal.text = "Goal: " + String(self.currentGoal) + " kcal"
        self.caloriesLabel.textAlignment = .center
        self.caloriesGoal.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    
    func addMacronutrientViews() {
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2
        
        //Macronutrient View
        self.macronutrientCirclesView = UIView()
        self.macronutrientCirclesView.layer.borderWidth = 1
        self.macronutrientCirclesView.layer.borderColor = self.borderColors
        self.contentView.addSubview(self.macronutrientCirclesView)
        
        self.macrosLabel = UILabel()
        self.macrosLabel.text = "Macronutrients"
        self.macrosLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.macronutrientCirclesView.addSubview(self.macrosLabel)
        
        //Protein, Carbs, and Fats Circles
        let verticalOffset: CGFloat = 60.0
        
        let screenWidth = UIScreen.main.bounds.width
        let circleRadius = screenWidth / 8
        let offset: CGFloat = 5.0
        
        
        let centerPointP = CGPoint(x: halfWidth - circleRadius - offset * 2, y: halfWidth - circleRadius + verticalOffset + 27.5)
        let centerPointC = CGPoint(x: halfWidth + circleRadius + offset * 2, y: halfWidth - circleRadius + verticalOffset + 27.5)
        let centerPointF = CGPoint(x: halfWidth, y: halfWidth + circleRadius + verticalOffset + 27.5)
        
        self.proteinCircle = AdaptiveCircle(radius: circleRadius, centerPt: centerPointP, percentComplete: 0.75, borderWidth: 5)
        self.macronutrientCirclesView.addSubview(self.proteinCircle)
        
        self.carbsCircle = AdaptiveCircle(radius: circleRadius, centerPt: centerPointC, percentComplete: 0.75, borderWidth: 5)
        self.macronutrientCirclesView.addSubview(self.carbsCircle)
        
        self.fatsCircle = AdaptiveCircle(radius: circleRadius, centerPt: centerPointF, percentComplete: 0.75, borderWidth: 5)
        self.macronutrientCirclesView.addSubview(self.fatsCircle)
        
        
        //Protein, fats, and carbs labels
        self.proteinLabel = UILabel()
        self.fatsLabel = UILabel()
        self.carbsLabel = UILabel()
        
        self.proteinAmount = UILabel()
        self.carbsAmount = UILabel()
        self.fatsAmount = UILabel()
        
        self.proteinGoal = UILabel()
        self.fatsGoal = UILabel()
        self.carbsGoal = UILabel()
        
        self.proteinLabel.text = "Protein"
        self.proteinLabel.textAlignment = .center
        self.carbsLabel.text = "Carbs"
        self.carbsLabel.textAlignment = .center
        self.fatsLabel.text = "Fats"
        self.fatsLabel.textAlignment = .center
        //self.proteinLabel.layer.borderWidth = 1
        //self.fatsLabel.layer.borderWidth = 1
        //self.carbsLabel.layer.borderWidth = 1
        
        self.macronutrientCirclesView.addSubview(self.proteinLabel)
        self.macronutrientCirclesView.addSubview(self.carbsLabel)
        self.macronutrientCirclesView.addSubview(self.fatsLabel)
        
        
        //Protein, Carbs, and Fats amounts
        self.formatAmountLabel(label: self.proteinAmount)
        self.formatAmountLabel(label: self.carbsAmount)
        self.formatAmountLabel(label: self.fatsAmount)
        
        self.macronutrientCirclesView.addSubview(self.proteinAmount)
        self.macronutrientCirclesView.addSubview(self.carbsAmount)
        self.macronutrientCirclesView.addSubview(self.fatsAmount)
        
        //Protein, Carbs, and Fats Goals
        self.proteinGoal.text = "Protein:\t\t" + String(self.currentProteinAmount) + " / " + String(self.currentProteinGoal) + " g"
        self.proteinGoal.textAlignment = .center
        self.fatsGoal.text = "Fats:\t\t\t" + String(self.currentFatAmount) + " / " + String(self.currentFatGoal) + " g"
        self.fatsGoal.textAlignment = .center
        self.carbsGoal.text = "Carbs:\t\t\t" + String(self.currentCarbsAmount) + " / " + String(self.currentCarbsGoal) + " g"
        self.carbsGoal.textAlignment = .center
        
        self.macronutrientCirclesView.addSubview(self.proteinGoal)
        self.macronutrientCirclesView.addSubview(self.fatsGoal)
        self.macronutrientCirclesView.addSubview(self.carbsGoal)
        
        
        //Setup
        let setupVals = [self.macronutrientCirclesView, self.macrosLabel, self.proteinLabel,
                         self.carbsLabel, self.fatsLabel, self.proteinAmount, self.carbsAmount,
                         self.fatsAmount, self.proteinGoal, self.fatsGoal, self.carbsGoal]
        setupVals.forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let diameter: CGFloat = self.proteinCircle.getCircleRadius() * 2
        NSLayoutConstraint.activate([
            //Main macronutrients view
            self.macronutrientCirclesView.topAnchor.constraint(equalTo: self.caloriesView.bottomAnchor, constant: 0.0),
            self.macronutrientCirclesView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0.0),
            self.macronutrientCirclesView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0.0),
            self.macronutrientCirclesView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 2),
            
            //Macros label
            self.macrosLabel.centerXAnchor.constraint(equalTo: self.macronutrientCirclesView.centerXAnchor),
            self.macrosLabel.topAnchor.constraint(equalTo: self.macronutrientCirclesView.topAnchor, constant: 40),
            self.macrosLabel.heightAnchor.constraint(equalToConstant: 40),
            
            //Protein Label
            self.proteinLabel.heightAnchor.constraint(equalToConstant: 40),
            self.proteinLabel.centerXAnchor.constraint(equalTo: self.proteinCircle.centerXAnchor),
            self.proteinLabel.centerYAnchor.constraint(equalTo: self.macronutrientCirclesView.centerYAnchor, constant: -halfWidth - diameter + verticalOffset),
            
            //Fats Label
            self.fatsLabel.heightAnchor.constraint(equalToConstant: 40),
            self.fatsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: self.fatsCircle.getCircleRadius() + offset),
            self.fatsLabel.centerYAnchor.constraint(equalTo: self.macronutrientCirclesView.centerYAnchor, constant: -halfWidth - diameter + verticalOffset),
            
            //Carbs Label
            self.carbsLabel.heightAnchor.constraint(equalToConstant: 40),
            self.carbsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.carbsLabel.centerYAnchor.constraint(equalTo: self.macronutrientCirclesView.centerYAnchor, constant: -self.carbsCircle.getCircleRadius() + verticalOffset),
            
            //Protein Amount
            self.proteinAmount.heightAnchor.constraint(equalToConstant: 40),
            self.proteinAmount.centerXAnchor.constraint(equalTo: self.proteinCircle.centerXAnchor),
            self.proteinAmount.centerYAnchor.constraint(equalTo: self.proteinCircle.centerYAnchor),
            
            //Fats Amount
            self.fatsAmount.heightAnchor.constraint(equalToConstant: 40),
            self.fatsAmount.centerXAnchor.constraint(equalTo: self.fatsCircle.centerXAnchor),
            self.fatsAmount.centerYAnchor.constraint(equalTo: self.fatsCircle.centerYAnchor),
            
            //Carbs Amount
            self.carbsAmount.heightAnchor.constraint(equalToConstant: 40),
            self.carbsAmount.centerXAnchor.constraint(equalTo: self.carbsCircle.centerXAnchor),
            self.carbsAmount.centerYAnchor.constraint(equalTo: self.carbsCircle.centerYAnchor),
            
            //Protein Goal
            self.proteinGoal.heightAnchor.constraint(equalToConstant: 40),
            self.proteinGoal.centerXAnchor.constraint(equalTo: self.macronutrientCirclesView.centerXAnchor),
            self.proteinGoal.centerYAnchor.constraint(equalTo: self.carbsLabel.centerYAnchor, constant: 100),
            
            //Fats Goal
            self.fatsGoal.heightAnchor.constraint(equalToConstant: 40),
            self.fatsGoal.centerXAnchor.constraint(equalTo: self.macronutrientCirclesView.centerXAnchor),
            self.fatsGoal.centerYAnchor.constraint(equalTo: self.proteinGoal.centerYAnchor, constant: 25),
            
            //Carbs Goal
            self.carbsGoal.heightAnchor.constraint(equalToConstant: 40),
            self.carbsGoal.centerXAnchor.constraint(equalTo: self.macronutrientCirclesView.centerXAnchor),
            self.carbsGoal.centerYAnchor.constraint(equalTo: self.fatsGoal.centerYAnchor, constant: 25)
        ])
    }
    
    
    //Pass global label value
    func formatAmountLabel(label: UILabel) {
        label.text =  String(self.currentProteinAmount) + " g"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemRed
    }
    
    
    //Foods view
    func addFoodsView() {
        
        //Setup
        let screenWidth = UIScreen.main.bounds.width
        
        //Setup foods superview
        self.foodsSuperView = UIView()
        self.foodsSuperView.backgroundColor = .white
        self.foodsSuperView.layer.borderWidth = 1
        self.foodsSuperView.layer.borderColor = self.borderColors
        self.contentView.addSubview(self.foodsSuperView)
        
        //Setup foods label
        self.foodsLabel = UILabel()
        self.foodsLabel.text = "Foods Consumed:"
        self.foodsLabel.textAlignment = .center
        self.foodsLabel.font = .boldSystemFont(ofSize: 20)
        
        //Setup foods table
        self.foodsTable = UITableView()
        self.foodsTable.backgroundView?.backgroundColor = .black
        
        self.foodsSuperView.addSubview(self.foodsLabel)
        self.foodsSuperView.addSubview(self.foodsTable)
        
        let setupVals = [self.foodsLabel, self.foodsSuperView, self.foodsTable]
        setupVals.forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tableWidth = screenWidth * (2.0 / 3.0)
        
        NSLayoutConstraint.activate([
            //Foods super view
            self.foodsSuperView.topAnchor.constraint(equalTo: self.macronutrientCirclesView.bottomAnchor, constant: 0.0),
            self.foodsSuperView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.foodsSuperView.heightAnchor.constraint(equalToConstant: screenWidth),
            self.foodsSuperView.widthAnchor.constraint(equalToConstant: screenWidth),
            
            //Foods label
            self.foodsLabel.heightAnchor.constraint(equalToConstant: 40),
            self.foodsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.foodsLabel.topAnchor.constraint(equalTo: self.foodsSuperView.topAnchor, constant: 40),
            
            //Foods table
            self.foodsTable.heightAnchor.constraint(equalToConstant: tableWidth),
            self.foodsTable.widthAnchor.constraint(equalToConstant: tableWidth),
            self.foodsTable.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.foodsTable.centerYAnchor.constraint(equalTo: self.foodsSuperView.centerYAnchor, constant: 20)
        ])
    }
    
    
    //Micronutrients View
    func addMicronutrientsView() {
        //Setup
        let screenWidth = UIScreen.main.bounds.width
        
        //Setup micronutrients superview
        self.micronutrientSuperView = UIView()
        self.micronutrientSuperView.backgroundColor = .white
        self.micronutrientSuperView.layer.borderWidth = 1
        self.micronutrientSuperView.layer.borderColor = self.borderColors
        self.contentView.addSubview(self.micronutrientSuperView)
        
        //Setup micronutrients label
        self.micronutrientLabel = UILabel()
        self.micronutrientLabel.text = "Micronutrients:"
        self.micronutrientLabel.textAlignment = .center
        self.micronutrientLabel.font = .boldSystemFont(ofSize: 20)
        
        //Setup micronutrient table
        self.micronutrientTable = UITableView()
        self.micronutrientTable.backgroundView?.backgroundColor = .black
        
        self.micronutrientSuperView.addSubview(self.micronutrientLabel)
        self.micronutrientSuperView.addSubview(self.micronutrientTable)
        
        let setupVals = [self.micronutrientTable, self.micronutrientLabel, self.micronutrientSuperView]
        setupVals.forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tableWidth = screenWidth * (2.0 / 3.0)
        
        NSLayoutConstraint.activate([
            //Foods super view
            self.micronutrientSuperView.topAnchor.constraint(equalTo: self.foodsSuperView.bottomAnchor, constant: 0.0),
            self.micronutrientSuperView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.micronutrientSuperView.heightAnchor.constraint(equalToConstant: screenWidth),
            self.micronutrientSuperView.widthAnchor.constraint(equalToConstant: screenWidth),
            
            //Foods label
            self.micronutrientLabel.heightAnchor.constraint(equalToConstant: 40),
            self.micronutrientLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.micronutrientLabel.topAnchor.constraint(equalTo: self.micronutrientSuperView.topAnchor, constant: 40),
            
            //Foods table
            self.micronutrientTable.heightAnchor.constraint(equalToConstant: tableWidth),
            self.micronutrientTable.widthAnchor.constraint(equalToConstant: tableWidth),
            self.micronutrientTable.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.micronutrientTable.centerYAnchor.constraint(equalTo: self.micronutrientSuperView.centerYAnchor, constant: 20)
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
