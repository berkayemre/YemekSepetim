//
//  SepetCevap.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import Foundation

class SepetCevap: Codable {
    var yemek_adi: String
    var yemek_resim_adi: String
    var yemek_fiyat: Int
    var yemek_siparis_adet: Int
    var kullanici_adi: String

    init(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String) {
        self.yemek_adi = yemek_adi
        self.yemek_resim_adi = yemek_resim_adi
        self.yemek_fiyat = yemek_fiyat
        self.yemek_siparis_adet = yemek_siparis_adet
        self.kullanici_adi = kullanici_adi
    }
}
