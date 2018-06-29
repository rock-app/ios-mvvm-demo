//
//  PlainCell.swift
//  iOS_MVVM_Demo
//
//  Created by shengling on 2018/6/29.
//  Copyright © 2018 ShengLing. All rights reserved.
//

import UIKit

class PlainCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var despLabel: UILabel!
    
    var item: Repo? {
        didSet {
            nameLabel.text = item?.name
            starsLabel.text = "stars: \((item?.stars ?? 0))"
            despLabel.text = item?.description
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
