//
//  InfoCell.swift
//  MorseString
//
//  Created by Anthony Benitez on 7/16/17.
//  Copyright © 2017 SymphoLife. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var literalLabel: UILabel!
    @IBOutlet weak var morseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
