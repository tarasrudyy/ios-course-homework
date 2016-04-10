//
//  RecordTableViewCell.swift
//  Diary
//
//  Created by Taras Rudyi on 4/4/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var weatherImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
