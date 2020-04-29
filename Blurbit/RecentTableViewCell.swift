//
//  RecentTableViewCell.swift
//  Blurbit
//
//  Created by administrator on 4/12/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit

protocol RecentTableViewCellDelegate:class{
    func onRatingButton(_ sender:UIButton)
}

class RecentTableViewCell: UITableViewCell {
    

    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var ratingButton: UIButton!
    weak var delegate:RecentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onRating(_ sender: UIButton) {
        delegate?.onRatingButton(sender)
    }
    
}
