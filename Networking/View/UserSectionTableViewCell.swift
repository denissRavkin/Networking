//
//  UserSectionTableViewCell.swift
//  Networking
//
//  Created by Denis Ravkin on 22.06.2021.
//

import UIKit

class UserSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var sectionLabel: UILabel!
    
    func configureCell(sectionName: String) {
        sectionLabel.text = sectionName
    }
}
