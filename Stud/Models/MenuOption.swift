//
//  MenuOption.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible, CaseIterable {
    case Calendar
    case Settings
    
    var description: String {
        switch self {
            case .Calendar: return "Calendar"
            case .Settings: return "Settings"
        }
    }
    
    var image: UIImage {
        switch self {
            case .Calendar: return UIImage(named: "calendar")!
            case .Settings: return UIImage(named: "settings")!
        }
    }
}
