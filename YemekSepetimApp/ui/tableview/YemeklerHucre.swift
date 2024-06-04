//
//  YemeklerHucre.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import UIKit
import Kingfisher

class YemeklerHucre: UITableViewCell {

    @IBOutlet weak var yemekResim: UIImageView!
    @IBOutlet weak var yemekAdi: UILabel!    
    @IBOutlet weak var yemekFiyat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
