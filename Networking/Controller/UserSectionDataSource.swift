//
//  usersDataSource.swift
//  Networking
//
//  Created by Denis Ravkin on 22.06.2021.
//

import UIKit

class UserSectionDataSource: NSObject, UITableViewDataSource {
    let userInfoSections = UserInformationSection.allCases
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserSectionTableViewCell", for: indexPath) as? UserSectionTableViewCell else {
            fatalError("failed to dequeue UserTableViewCell")
        }
        let sectionName = userInfoSections[indexPath.row].rawValue
        cell.configureCell(sectionName: sectionName)
        return cell
    }
}
