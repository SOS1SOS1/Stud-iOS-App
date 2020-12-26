//
//  CalendarController.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EventCell"

class CalendarController: UITableViewController {
    
    // MARK: - Properties
    
    var dates: [String] = []
    var events: [[Event]] = []
    var expandedEvents: [IndexPath] = []
        
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        //
    }
    
    // MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        tableView.register(EventCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
         
        let startString = dates[section]
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = startString
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventCell
        let event = events[indexPath.section][indexPath.row]
        cell.titleLabel.text = event.title
        cell.timeLabel.text = DateFormatter.localizedString(from: event.start.date, dateStyle: .none, timeStyle: .short) + "-" + DateFormatter.localizedString(from: event.end.date, dateStyle: .none, timeStyle: .short)
        if (event.desc != "") {
            cell.addDesc(event.desc)
            event.height = CGFloat(cell.descView.numberOfLines()*40 + 60)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if event has a description, then the cell expands and displays the description
        if (events[indexPath.section][indexPath.row].desc != "") {
            if (expandedEvents.contains(indexPath)) {
                // if already expanded, contract it
                expandedEvents = expandedEvents.filter({$0 != indexPath})
                if let cell = tableView.cellForRow(at: indexPath) as? EventCell {
                    cell.hideDesc()
                }
            } else {
                // expand it
                expandedEvents.append(indexPath)
                if let cell = tableView.cellForRow(at: indexPath) as? EventCell {
                    cell.showDesc()
                }
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedEvents.contains(indexPath) {
            return events[indexPath.section][indexPath.row].height
        } else {
            return 60
        }
    }
    
}

