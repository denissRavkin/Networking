//
//  RootViewController.swift
//  Networking
//
//  Created by Denis Ravkin on 21.06.2021.
//

import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerUsersViewController: UIView!
    @IBOutlet weak var containerUserViewController: UIView!
    weak var usersViewController: UsersViewController!
    weak var userViewController: UserViewController!
    var isleftViewControllerHide: Bool = false {
        didSet {
            let point: CGPoint
            if isleftViewControllerHide {
                point = containerUserViewController.frame.origin
            } else {
                point = containerUsersViewController.frame.origin
            }
            scrollView.setContentOffset(point, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupLeftNavigationItem()
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
    }
    
    func setupLeftNavigationItem() {
        let item = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(leftNavigationItemTapped))
        self.navigationItem.leftBarButtonItem = item
    }
    
    @objc func leftNavigationItemTapped() {
        isleftViewControllerHide.toggle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "UsersVCSegue":
            if let usersViewController = segue.destination as? UsersViewController {
                self.usersViewController = usersViewController
                usersViewController.delegate = self
            } else {
                fatalError("segue.identifier - UsersVCSegue, segue.destination as? UsersViewController == nil")
            }
        case "UserVCSegue":
            if let userViewController = segue.destination as? UserViewController {
                self.userViewController = userViewController
                self.userViewController.delegate = self
            } else {
                fatalError("segue.identifier - UserVCSegue, segue.destination as? UserViewController == nil")
            }
        case "showUserPostsSegue":
            if let userPostsTableViewController = segue.destination as? UserPostsTableViewController {
                userPostsTableViewController.userID = sender as? Int
            } else {
                fatalError("segue.identifier - showUserPostsSegue, segue.destination as? UserPostsTableViewController == nil")
            }
        case "showUserPhotosSegue":
            if let userPhotosViewController = segue.destination as? UserPhotosCollectionViewController {
                userPhotosViewController.userID = sender as? Int
            } else {
                fatalError("segue.identifier - showUserPhotosSegue, segue.destination as? UserPhotosCollectionViewController == nil")
            }
        default:
            break
        }
    }
}

extension RootViewController: UsersViewControllerDelegate {
    func userWasSelected(user: User) {
        userViewController.user = user
        isleftViewControllerHide = true
        title = user.name
    }
}

extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset == containerUserViewController.frame.origin {
            isleftViewControllerHide = true
        } else if scrollView.contentOffset == containerUsersViewController.frame.origin {
            isleftViewControllerHide = false
        }
    }
}

extension RootViewController: UserViewControllerDelegate {
    func postsTableViewCellwasTapped(userID: Int?) {
        performSegue(withIdentifier: "showUserPostsSegue", sender: userID)
    }
    
    func photosTableViewCellwasTapped(userID: Int?) {
        performSegue(withIdentifier: "showUserPhotosSegue", sender: userID)
    }
}

