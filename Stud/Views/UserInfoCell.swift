//
//  UserInfoCell.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    
    // MARK: - Properties
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.frame.size = CGSize(width: 60, height: 60)
        iv.layer.cornerRadius = iv.frame.size.width/2
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Profile Name"
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
