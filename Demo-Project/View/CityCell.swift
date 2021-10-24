//
//  CityCell.swift
//  Demo-Project
//
//  Created by Михаил Зайцев on 20.10.2021.
//

import UIKit

class CityCell: UITableViewCell {

    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
