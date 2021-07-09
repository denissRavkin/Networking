//
//  UserTableViewCell.swift
//  Networking
//
//  Created by Denis Ravkin on 22.06.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!

    func configureCell(user: UserForCell) {
        userNameLabel.text = user.name
    }
}
