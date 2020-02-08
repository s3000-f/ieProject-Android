//
//  DropdownCell.swift
//  IEProject
//
//  Created by Soroush Fathi on 2/3/20.
//  Copyright © 2020 WebGroup24. All rights reserved.
//

import UIKit

class DropdownCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dropdown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
