//
//  DetayViewModel.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import Foundation

class DetayViewModel {
    var yrepo = YemeklerRepo()
    var sepetVM = SepetViewModel()
    
    func sepeteKaydet(yemek_adi:String,yemek_fiyat:String,yemek_resim_adi:String, yemek_siparis_adet:String,kullanici_adi:String){
     yrepo.sepeteYemekEkle(yemek_adi: yemek_adi, yemek_fiyat: yemek_fiyat, yemek_resim_adi: yemek_resim_adi, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
     }
    
    
    
}
