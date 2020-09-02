//
//  TEDVideoTableViewCell.swift
//  TEDBrowser
//
//  Created by Никита Плахин on 8/27/20.
//  Copyright © 2020 Никита Плахин. All rights reserved.
//

import UIKit

class TEDVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
}
