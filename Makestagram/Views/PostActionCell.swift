//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Mary Wilson on 7/2/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit

//allows us to define a protocol that any delegate of PostActionCell must conform to which allows the delegate to handle the event of the likeButton being tapped
protocol PostActionCellDelegate: class{
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}

class PostActionCell: UITableViewCell {
    
    //MARK: - Properties
    weak var delegate: PostActionCellDelegate?
    
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
        
        //notifies the delegate that the like button was tapped
        delegate?.didTapLikeButton(sender, on: self)
    }
   
}
