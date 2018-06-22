//
//  ResaleCell.swift
//  Konka
//
//  Created by shengling on 2018/5/24.
//  Copyright © 2018年 Heading. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func display(for item: Repo) {
        nameLabel.text = item.name
        starCountLabel.text = "stars: \(item.stars)"
        languageLabel.text = item.language
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/DD HH:mm:ss"
        if let date = item.created {
            dateLabel.text = dateFormat.string(from: date)
        }
        totalLabel.text = item.url
    }
    
}
