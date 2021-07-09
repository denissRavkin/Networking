//
//  UserPostsTableViewController.swift
//  Networking
//
//  Created by Denis Ravkin on 04.07.2021.
//

import UIKit

class UserPostsTableViewController: UITableViewController {
    private let networkManager = NetworkManager()
    var userID: Int?
    private var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        setupTableView()
    }
    
    func getPosts() {
        guard let userID = userID else { return }
        networkManager.getPosts(ofUserId: userID) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.tableView.reloadData()
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
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostTableViewCell", for: indexPath) as? UserPostTableViewCell else {
            fatalError("failed to dequeue UserPostTableViewCell")
        }
        let post = posts[indexPath.row]
        cell.configure(post: post)
        return cell
    }
    
    // MARK: = Delete Post
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletingCell = tableView.cellForRow(at: indexPath) as! UserPostTableViewCell
            deletingCell.isLoading = true
            networkManager.deletePost(post: posts[indexPath.row]) { (result) in
                DispatchQueue.main.async {
                    deletingCell.isLoading = false
                    switch result {
                    case .success:
                        self.posts.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
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
    }
    
    // MARK: = Edit/Add post
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [self] (_, _, handler) in
            showAlertForAddingOrEditingPost(title: "Edit post", postID: indexPath.row) { (editedPost) in
                self.networkManager.editPost(newPost: editedPost) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let editedPost):
                            posts[indexPath.row] = editedPost
                            let editedCell = tableView.cellForRow(at: indexPath) as! UserPostTableViewCell
                            editedCell.configure(post: editedPost)
                            tableView.reloadData()
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
            handler(true)
        }
        editAction.backgroundColor = #colorLiteral(red: 0, green: 0.6163546954, blue: 0.01877258797, alpha: 1)
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        return configuration
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        showAlertForAddingOrEditingPost(title: "Add post") { (newPost) in
            self.networkManager.postNewPost(post: newPost) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let post):
                        self.posts.append(post)
                        self.tableView.reloadData()
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
    }
    
    func showAlertForAddingOrEditingPost(title: String, postID: Int? = nil, completion: @escaping (Post) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfiled) in
            textfiled.placeholder = "title"
        }
        alertController.addTextField { (textfiled) in
            textfiled.placeholder = "text"
        }
        let actionPost = UIAlertAction(title: title, style: .default) { (actionPost) in
            guard let title = alertController.textFields?[0].text, title != "" else {
                self.showSimpleAlert(title: "Error", message: "title is empty")
                return
            }
            guard let body = alertController.textFields?[1].text, body != "" else {
                self.showSimpleAlert(title: "Error", message: "text is empty")
                return
            }
            guard let userID = self.userID else { return }
            if let postID = postID {
                let editedPost = Post(userId: userID, id: postID, title: title, body: body)
                completion(editedPost)
            } else {
                let newPost = Post(userId: userID, id: nil, title: title, body: body)
                completion(newPost)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(actionPost)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}

