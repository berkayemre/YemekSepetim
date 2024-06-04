//
//  SepetHucre.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import UIKit

class SepetHucre: UITableViewCell {
    @IBOutlet weak var yemekAdet: UILabel!
    @IBOutlet weak var yemekFiyat: UILabel!
    @IBOutlet weak var yemekAdi: UILabel!
    @IBOutlet weak var sepetImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
