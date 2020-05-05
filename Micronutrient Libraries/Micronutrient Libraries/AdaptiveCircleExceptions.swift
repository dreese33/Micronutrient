//
//  AdaptiveCircleExceptions.swift
//  Micronutrient Libraries
//
//  Created by Eric Reese on 5/5/20.
//  Copyright © 2020 ReeseGames. All rights reserved.
//

import UIKit

enum AdaptiveCircleException: Error {
    case PercentOutOfRange(message: String)
    case AdaptiveValuesNotSet(message: String)
}
