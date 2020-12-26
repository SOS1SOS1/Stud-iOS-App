//
//  SettingsController.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit
import GoogleSignIn

private let reuseIdentifier = "TableCell"

class SettingsController: UITableViewController {
    
    // MARK: - Properties
    
    var headers = ["", "Options"]
    var data = [[], ["Log Out"]]
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UserInfoCell.self, forCellReuseIdentifier: "UserInfoCell")
    }
    
    // MARK: - Helper Functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! UserInfoCell
            cell.nameLabel.text = username
            if let data = try? Data(contentsOf: imageURL!) {
                DispatchQueue.main.async {
                    if UIImage(data: data) != nil {
                        cell.profileImageView.image = UIImage(data: data)
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableCell
            cell.headingLabel.text = data[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        if headers[section] != "" {
            let title = UILabel()
            title.font = UIFont.boldSystemFont(ofSize: 16)
            title.textColor = .white
            title.text = headers[section]
            view.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if headers[section] != "" {
            return 30
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // asks user if they want to log out
                let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                    // logs user out
                    GIDSignIn.sharedInstance()?.signOut()
                    
                    // takes user to login screen
                    let controller = LoginController()
                    controller.modalPresentationStyle = .overCurrentContext
                    self.present(controller, animated: true, completion: nil)
                }))
                
                present(alert, animated: true)
            }
        }
    }
    
}
