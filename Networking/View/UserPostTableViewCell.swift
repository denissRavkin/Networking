//
//  UserPostTableViewCell.swift
//  Networking
//
//  Created by Denis Ravkin on 04.07.2021.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var viewBehindActivityIndicator: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                viewBehindActivityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                viewBehindActivityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewBehindActivityIndicator()
        setupAactivityIndicator()
    }
    
    func setupViewBehindActivityIndicator() {
        viewBehindActivityIndicator.isHidden = true
        viewBehindActivityIndicator.layer.cornerRadius = 10
    }
    
    func setupAactivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    func configure(post: PostForCell) {
        postTitleLabel.text = post.title
        postTextLabel.text = post.body
    }
}
