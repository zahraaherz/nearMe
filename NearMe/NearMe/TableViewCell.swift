//
//  TableViewCell.swift
//  NearYou
//
//  Created by Zahraa Herz on 30/10/2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var phoneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
