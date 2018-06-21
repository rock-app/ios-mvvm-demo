//
//  ResaleCell.swift
//  Konka
//
//  Created by shengling on 2018/5/24.
//  Copyright © 2018年 Heading. All rights reserved.
//

import UIKit

class ResaleListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func display(for item: Resale) {
        nameLabel.text = "提交人: " + "--"
        carLabel.text = "tz10093"
        orderNumberLabel.text = item.id
        if let length = item.created?.utf8.count, length > 4 {
            dateLabel.text = item.created
        }
        var text: String = ""
        let returnCondition = true
        let swapCondition = true
        if returnCondition {
            text = "退货再售 1 种"
        }
        if swapCondition {
            text = "换货再售 1 种"
        }
        if returnCondition && swapCondition {
            text = "退货再售 1 种   换货再售 2 种"
        }
        totalLabel.text = text
    }
    
}
