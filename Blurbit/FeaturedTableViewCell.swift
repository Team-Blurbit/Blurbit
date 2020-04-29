//
//  FeaturedTableViewCell.swift
//  Blurbit
//
//  Created by administrator on 4/27/20.
//  Copyright © 2020 Team-Blurbit. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!

    override func awakeFromNib() {
        print("FeaturedTableViewCell.swift: awakeFromNib()")
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        print("FeaturedTableViewCell.swift: setSelected()")
        super.setSelected(selected, animated: animated)
    }

}
