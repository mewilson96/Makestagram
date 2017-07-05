//
//  HomeViewController.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/29/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    //MARK: - Properties
    var posts = [Post]()
    let refreshControl = UIRefreshControl()
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    //MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    func configureTableView() {
        
        //remove seperators for empty cells
        tableView.tableFooterView = UIView()
        
        //remove seperators from cells
        tableView.separatorStyle = .none
        
        //add pull to refresh
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func reloadTimeline() {
        UserService.timeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
            
            self.tableView.reloadData()
        }
    }
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        reloadTimeline()
        
    }

}

//MARK: UITableViewDataSource

//Seeting up our TableViewDataSource to retrieve data from our Post array
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    //return 3 rows for each section to corerspond withour header, image, and action cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
        
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
        
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
    }
    
    
    //MARK: UTITableViewDelegate
    
    //returns the height that each cell should be given an index path. this allows us to have cells that are varying  heights within the same table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            
        case 0 :
            return PostHeaderCell.height
            
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
            
        case 2:
            return PostActionCell.height
        
        default:
            fatalError()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
}

extension HomeViewController: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        
        //make sure a path exists for the given cell. we'll need it to reference the correct post
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        
        //set isUserInteractionEnabled property of the UIButtonto false so the user dones't accidently send multiple requests by tapping too quickly
        likeButton.isUserInteractionEnabled = false
        
        //reference the correct post corresponding with the PostActionCell that the user tapped
        let post = posts[indexPath.section]
        
        //use LikeService to like or unlike the post based on the isLiked property
        LikeService.setIsLike(!post.isLiked, for: post) { (success) in
            
            //use defer to set isUserInteractionEnabled to true whenever the closure returns
            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            //basic error handling in case something goes wrong
            guard success else {return}
            
            //change the likeCount and isLiked properties of our post if our network request was sucessful
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            //get a reference to the current cell
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            //update the UI of the cell on the main thread
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}
