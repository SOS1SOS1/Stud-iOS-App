//
//  MenuController.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TableViewCell"

class MenuController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var options: [String] = []
    var icons: [UIImage] = []
    
    var didTapMenuOption: ((MenuOption) -> Void)?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch MenuOption.Calendar {
            case .Calendar:
                options.append(MenuOption.Calendar.description)
                icons.append(MenuOption.Calendar.image)
                fallthrough
            case .Settings:
                options.append(MenuOption.Settings.description)
                icons.append(MenuOption.Settings.image)
        }
        
        configureUI()
        
    }
    
    func configureUI() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TableCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
}

extension MenuController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableCell
        cell.headingLabel.text = options[indexPath.row]
        cell.addIcon(icons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menuOption = MenuOption(rawValue: indexPath.row) {
            self.dismiss(animated: true) { [weak self] in
                self?.didTapMenuOption?(menuOption)
            }
        }
    }
}
