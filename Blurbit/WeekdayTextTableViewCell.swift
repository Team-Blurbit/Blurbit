//
//  WeekdayTextTableViewCell.swift
//  Blurbit
//
//  Created by administrator on 4/22/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//
import UIKit

class WeekdayTextTableViewCell: UITableViewCell {

    
    @IBOutlet weak var weekdayText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
