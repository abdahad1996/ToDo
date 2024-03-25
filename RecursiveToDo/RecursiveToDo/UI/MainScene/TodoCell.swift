//
//  TodoCell.swift
//  Todo
//
//  Created by macbook abdul on 13/03/2024.
//

import Foundation
import UIKit
import TodoShared

class TodoViewCell: UITableViewCell {
    private let checkboxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var model: Todo? {
        didSet {
            guard let model = model else{return}
            updateCheckboxImage()
            self.accessoryType = .disclosureIndicator
            self.indentationLevel = model.level
            self.indentationWidth = CGFloat(model.level * 5)
            self.textLabel?.text = model.titleLabel()
        }
    }
    
    var onCheckboxStateChanged: ((Todo) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Hide the button in editing mode
        checkboxButton.isHidden = isEditing
        
    }
    private func commonInit() {
        contentView.addSubview(checkboxButton)
        
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 320),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 40),
            checkboxButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        checkboxButton.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        
        
        updateCheckboxImage()
    }
    
    
    
    
    @objc private func checkboxButtonTapped() {
        if let model = model {
            onCheckboxStateChanged?(model)
        }
        
    }
    
    private func updateCheckboxImage() {
        let imageName = (model?.isCompleted ?? false) ? "checkmark.circle.fill" : "checkmark.circle"
        let image = UIImage(systemName: imageName)
        checkboxButton.setImage(image, for: .normal)
    }
}
