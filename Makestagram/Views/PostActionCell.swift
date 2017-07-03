//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Mary Wilson on 7/2/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit

class PostActionCell: UITableViewCell {
    
    static let height: CGFloat = 46
    
    //MARK: - Subviews
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
    //MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - IBActions
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        print("like button tapped")
    }
    

   
}
