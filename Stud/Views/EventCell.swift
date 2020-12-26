//
//  EventCell.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Event"
        return label
    }()
    
    let descView: UITextView = {
       let desc = UITextView()
        desc.textColor = .black
        desc.font = UIFont.systemFont(ofSize: 19)
        desc.text = "Description"
        desc.backgroundColor = .clear
        return desc
    }()

    let timeLabel: UILabel = {
       let time = UILabel()
        time.textColor = .lightGray
        time.font = UIFont.systemFont(ofSize: 15)
        time.text = "Time"
        return time
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 35).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
    }
    
    func addDesc(_ description: String) {
        addSubview(descView)
        descView.text = description
        descView.translatesAutoresizingMaskIntoConstraints = false
        
        descView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        descView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        descView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        descView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        descView.isUserInteractionEnabled = false
        descView.isHidden = true
    }
    
    func showDesc() {
        descView.isHidden = false
    }
    
    func hideDesc() {
        descView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
