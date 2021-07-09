//
//  UsersViewController.swift
//  Networking
//
//  Created by Denis Ravkin on 22.06.2021.
//

import UIKit

protocol UsersViewControllerDelegate {
    func userWasSelected(user: User)
}

class UsersViewController: UIViewController {
    @IBOutlet weak var usersTableView: UITableView!
    var users: [User] = []
    var networkManager = NetworkManager()
    var delegate: UsersViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getUsers()
    }
    
    func setupTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
    
    func getUsers() {
        networkManager.getUsers { (result) in
            print("RESULT - \(result)")
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.usersTableView.reloadData()
                case .failure(let error):
                    if let error = error as? HTTPNetworkError {
                        self.showSimpleAlert(title: "Error", message: error.rawValue)
                    } else {
                        self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func selectFirstCell() {
        usersTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        delegate.userWasSelected(user: users[0])
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            fatalError("failed to dequeue UserTableViewCell")
        }
        let user = users[indexPath.row]
        cell.configureCell(user: user)
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        delegate.userWasSelected(user: users[indexPath.row])
    }
}

extension UIViewController {
    func showSimpleAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for alertAction in actions {
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: true)
    }
}
