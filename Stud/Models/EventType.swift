//
//  Event.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

enum EventType: String {
    case Homework
    case Quiz
    case Test
    case Final
    case Other
    
    var rawValue: String {
        switch self {
        case.Homework: return "Homework"
        case.Quiz: return "Quiz"
        case.Test: return "Test"
        case.Final: return "Final"
        case.Other: return "Other"
        }
    }
}

class Event: NSObject {
    
    // MARK: - Properties
    var type: EventType
    var title = ""
    var desc = ""
    var start: GTLRDateTime!
    var end: GTLRDateTime!
    var height: CGFloat = 60.0
    
    // MARK: - Init
    
    init(type: EventType, title: String, desc: String?, start: GTLRDateTime, end: GTLRDateTime) {
        self.type = type
        self.title = title
        if let desc = desc {
            self.desc = desc
        }
        self.start = start
        self.end = end
    }
    
    // MARK: - Helper Functions
    
    
    
}
