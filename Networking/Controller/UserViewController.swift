//
//  UserViewController.swift
//  Networking
//
//  Created by Denis Ravkin on 22.06.2021.
//

import UIKit

protocol UserViewControllerDelegate {
    func postsTableViewCellwasTapped(userID: Int?)
    func photosTableViewCellwasTapped(userID: Int?)
}

class UserViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var dataSource = UserSectionDataSource()
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    var user: User? {
        didSet {
            userNameLabel.text = user?.name
            userPhoneNumber.text = user?.phone
        }
    }
    var delegate: UserViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.bounces = false
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(tableView.safeAreaLayoutGuide.layoutFrame.height/CGFloat(dataSource.userInfoSections.count))
        return tableView.safeAreaLayoutGuide.layoutFrame.height/CGFloat(dataSource.userInfoSections.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            delegate.postsTableViewCellwasTapped(userID: user?.id)
        case 1:
            delegate.photosTableViewCellwasTapped(userID: user?.id)
        default:
            break
        }
    }
}

