//
//  SearchResultCell.swift
//  TestA
//
//  Created by gecko on 21/08/16.
//  Copyright © 2016 Chamsidine ATTOUMANI. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var studentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
