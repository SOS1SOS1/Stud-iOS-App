//
//  TableCell.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    // MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let headingLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Sample Text"
        return label
    }()

    let subHeadingLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Sample Text"
        return label
    }()
    
    var headingLabelXAnchor: NSLayoutConstraint?
    var headingLabelYAnchor: NSLayoutConstraint?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabelYAnchor = headingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        headingLabelYAnchor?.isActive = true
        headingLabelXAnchor = headingLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: -20)
        headingLabelXAnchor?.isActive = true
        headingLabel.textColor = .black
    }
    
    func setBackgroundColor(color: UIColor) {
        backgroundColor = color
    }
    
    func setHeadingColor(color: UIColor) {
        headingLabel.textColor = color
    }
    
    func setSubHeadingColor(color: UIColor) {
        headingLabel.textColor = color
    }
    
    func disableSelection() {
        selectionStyle = .none
    }
    
    func addIcon(_ image: UIImage?) {
        if let i = image {
            iconImageView.image = i
            
            headingLabelXAnchor?.constant = 25
            headingLabel.updateConstraints()
        }
    }
    
    func addSubHeading(_ text: String) {
        subHeadingLabel.text = text
        addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 15).isActive = true
        subHeadingLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
        subHeadingLabel.textColor = .lightGray
        headingLabelYAnchor?.constant = -10
        headingLabel.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
