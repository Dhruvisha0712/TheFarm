//
//  DropDownTableViewCell.swift
//  TheFarm
//
//  Created by Nandan on 28/02/24.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {

    @IBOutlet weak var dropDownLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
