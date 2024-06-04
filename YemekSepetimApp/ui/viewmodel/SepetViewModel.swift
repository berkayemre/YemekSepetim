//
//  SepetViewModel.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import Foundation
import RxSwift
import Alamofire

class SepetViewModel{
    var yrepo = YemeklerRepo()
    var sepetYemekler : [SepetYemekler] = []
    var yemeklerListesi = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    
    init(){
        yemeklerListesi = yrepo.sepettekiYemekler
        yemekleriGetir(kullanici_adi: "emre_aslan")
        
    }
    
    
    func yemekleriGetir(kullanici_adi:String) {
        yrepo.yemekleriGetir(kullanici_adi: kullanici_adi)
    }
    
    func sil(sepet_yemek_id:String, kullanici_adi:String){
        let params:Parameters = ["sepet_yemek_id":sepet_yemek_id, "kullanici_adi":kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post,parameters: params).response {
            response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("Başarı : \(cevap.success!)")
                    print("Mesaj  : \(cevap.message!)")
                    self.yemekleriGetir(kullanici_adi: "emre_aslan")

                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
 
