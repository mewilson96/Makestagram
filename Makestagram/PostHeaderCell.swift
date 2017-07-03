//
//  PostHeaderCell.swift
//  Makestagram
//
//  Created by Mary Wilson on 7/2/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    static let height: CGFloat = 54

    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        
        print("options button tapped")
    }

}
