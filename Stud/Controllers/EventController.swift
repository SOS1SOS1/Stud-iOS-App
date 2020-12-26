//
//  EventController.swift
//  Stud
//
//  Created by Shanti Mickens on 5/15/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class EventController: UIViewController {
    
    // MARK: - Properties
    
    var titleField: UITextField!
    var descField: UITextView!
    var typeField: UIPickerView!
    var startField: UIDatePicker!
    var endField: UIDatePicker!
    var submitButton: UIButton!
    
    var eventTypes = [EventType.Homework, EventType.Quiz, EventType.Test, EventType.Final, EventType.Other]
    
    var addEvent: ((GTLRCalendar_Event) -> (Void))?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Add Event"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismiss")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        // creates form elements
        
        // text field for title
        titleField = UITextField(frame: CGRect(x: view.center.x-375/2, y: 160, width: 375, height: 40))
        titleField.placeholder = "Title"
        titleField.font = UIFont.systemFont(ofSize: 18)
        titleField.borderStyle = .roundedRect
        titleField.autocorrectionType = .yes
        titleField.keyboardType = .default
        titleField.returnKeyType = .default
        titleField.clearButtonMode = .whileEditing
        titleField.contentVerticalAlignment = .center
        titleField.layer.backgroundColor = UIColor.white.cgColor
        view.addSubview(titleField)
                
        // large text field for description
        descField = UITextView(frame: CGRect(x: view.center.x-375/2, y: 220, width: 375, height: 150))
        descField.text = "Description"
        descField.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        descField.font = UIFont.systemFont(ofSize: 18)
        descField.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        descField.layer.borderWidth = 1
        descField.layer.cornerRadius = 5
        descField.autocorrectionType = .yes
        descField.keyboardType = .default
        descField.returnKeyType = .default
        descField.isUserInteractionEnabled = true
        descField.layer.backgroundColor = UIColor.white.cgColor
        descField.delegate = self
        view.addSubview(descField)
        
        let typeLabel = UILabel(frame: CGRect(x: view.center.x-375/2, y: 350, width: 60, height: 100))
        typeLabel.text = "Type -"
        typeLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(typeLabel)
        
        // selection for event type: homework, quiz, test, other
        typeField = UIPickerView(frame: CGRect(x: view.center.x-375/2+75, y: 350, width: 300, height: 100))
        typeField.delegate = self
        typeField.dataSource = self
        view.addSubview(typeField)
        
        let startLabel = UILabel(frame: CGRect(x: view.center.x-375/2, y: 440, width: 60, height: 110))
        startLabel.text = "Start -"
        startLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(startLabel)
        
        // start date dropdown
        startField = UIDatePicker(frame: CGRect(x: view.center.x-375/2+75, y: 440, width: 300, height: 110))
        view.addSubview(startField)
        
        let endLabel = UILabel(frame: CGRect(x: view.center.x-375/2, y: 540, width: 60, height: 110))
        endLabel.text = "End -"
        endLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(endLabel)
        
        // end date dropdown
        endField = UIDatePicker(frame: CGRect(x: view.center.x-375/2+75, y: 540, width: 300, height: 110))
        view.addSubview(endField)
        
        // submit button
        submitButton = UIButton(frame: CGRect(x: view.center.x-60, y: 665, width: 120, height: 40))
        submitButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        submitButton.setTitle("Add Event", for: .normal)
        submitButton.layer.borderColor = CGColor(srgbRed: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        view.addSubview(submitButton)
        
    }
    
    // MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAdd(sender: UIButton!) {
        // add event
        if let title = titleField.text?.trimmingCharacters(in: .whitespaces), title != ""  {
            let event = GTLRCalendar_Event()
            if descField.text?.trimmingCharacters(in: .whitespaces) != "" {
                event.descriptionProperty = descField.text?.trimmingCharacters(in: .whitespaces)
            }
            event.summary = title
            event.start = GTLRCalendar_EventDateTime()
            event.start?.dateTime = GTLRDateTime(date: startField.date)
            event.end = GTLRCalendar_EventDateTime()
            event.end?.dateTime = GTLRDateTime(date: endField.date)
            
            // reminders
            let reminder_30min_before = GTLRCalendar_EventReminder()
            reminder_30min_before.minutes = 30
            reminder_30min_before.method = "popup"
            let reminder_day_before = GTLRCalendar_EventReminder()
            reminder_day_before.minutes = 60*24 as NSNumber
            reminder_day_before.method = "popup"
            let reminder_2day_before = GTLRCalendar_EventReminder()
            reminder_2day_before.minutes = 60*24*2 as NSNumber
            reminder_2day_before.method = "popup"
            let reminder_week_before = GTLRCalendar_EventReminder()
            reminder_week_before.minutes = 60*24*7 as NSNumber
            reminder_week_before.method = "popup"
            let reminder_2week_before = GTLRCalendar_EventReminder()
            reminder_2week_before.minutes = 60*24*14 as NSNumber
            reminder_2week_before.method = "popup"
            let type = eventTypes[typeField.selectedRow(inComponent: 0)]
            event.reminders = GTLRCalendar_Event_Reminders()
            switch type {
            case .Homework:
                // reminder day before
                event.reminders?.overrides = [reminder_30min_before, reminder_day_before]
            case .Quiz:
                // reminder two days and day before
                event.reminders?.overrides = [reminder_30min_before, reminder_day_before, reminder_2day_before]
            case .Test:
                // reminder a week, two days, and day before
                event.reminders?.overrides = [reminder_30min_before, reminder_day_before, reminder_2day_before, reminder_week_before]
            case .Final:
                // reminder two weeks, week, two days, and day before
                event.reminders?.overrides = [reminder_30min_before, reminder_day_before, reminder_2day_before, reminder_week_before, reminder_2week_before]
            case .Other:
                // default 30 minutes before
                event.reminders?.overrides = []
            }
            event.reminders?.useDefault = false
            self.addEvent?(event)
        } else {
            print("finish filling out add event form")
        }
        
    }
    
}

extension EventController: UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventTypes[row].rawValue
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descField.textColor != UIColor.black {
            textView.text = ""
            textView.textColor = .black
        }
    }
}

extension UITextView {
    func numberOfLines() -> Int {
        if let fontUnwrapped = self.font {
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}
