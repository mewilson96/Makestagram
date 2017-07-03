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
    }
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()

        //fetching other posts from Firebase
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            print(posts)
            self.tableView.reloadData()
        }
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
            cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
            
            return cell
        
        default:
            fatalError("Error: unexpected indexPath.")
        }
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
