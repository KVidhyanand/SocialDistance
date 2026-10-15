//
//  LocationsCell.swift
//  SafetyDemo
//

import UIKit

class LocationsCell: UITableViewCell {
    
    @IBOutlet var latitudeLbl: UILabel!
    @IBOutlet var longitudeLbl: UILabel!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var distanceLbl: UILabel!
    @IBOutlet var zoneLbl: UILabel!
    @IBOutlet var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
