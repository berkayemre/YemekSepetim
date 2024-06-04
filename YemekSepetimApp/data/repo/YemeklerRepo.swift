//
//  YemeklerRepo.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import Foundation
import RxSwift
import Alamofire

class YemeklerRepo {
    
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepettekiYemekler = BehaviorSubject<[SepetYemekler]>(value: [SepetYemekler]())
    
    func yemekleriYukle(){
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response {
            response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let liste = cevap.yemekler{
                        self.yemeklerListesi.onNext(liste)
                    }
                }catch{
                    print(String(describing: error))
                }
            }
        }
    }
    
    
    func ara(aramaKelimesi:String) {
        let params:Parameters = ["yemek_adi":aramaKelimesi]
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .post,parameters: params).response {
            response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let liste = cevap.yemekler{
                        self.yemeklerListesi.onNext(liste)
                    }
                }catch {
                    print(String(describing: error))
                }
            } else {
            }
        }
        
    
    }
    
    func yemekleriGetir(kullanici_adi:String = "emre_aslan"){
        let params:Parameters = ["kullanici_adi": kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post,parameters: params).response {
            response in
            if let data = response.data{
                do{
                    let cevap = try JSONDecoder().decode(SepettekilerCevap.self, from: data)
                    if let liste = cevap.sepet_yemekler{
                        self.sepettekiYemekler.onNext(liste)
                    }
                }catch{
                    print(String(describing: error))
                }
            }
        }
    }
    
  
        
    
    func sil(sepet_yemek_id:String, kullanici_adi:String, completion: @escaping () -> Void){
            let params:Parameters = ["sepet_yemek_id": sepet_yemek_id, "kullanici_adi": kullanici_adi]
            AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post,parameters: params).response {
                response in
                if let data = response.data {
                    do {
                        let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                        print("Başarı : \(cevap.success!)")
                        print("Mesaj  : \(cevap.message!)")
                        self.yemekleriGetir(kullanici_adi: kullanici_adi)
                        completion()
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    func sepeteYemekEkle(yemek_adi: String, yemek_fiyat: String, yemek_resim_adi: String, yemek_siparis_adet: String, kullanici_adi: String = "emre_aslan") {
        var mevcutSepetYemekler: [SepetYemekler] = []
        do {
            mevcutSepetYemekler = try sepettekiYemekler.value()
        } catch {
            print("Sepetteki yemekleri alırken hata oluştu: \(error)")
        }
        
        if let mevcutYemek = mevcutSepetYemekler.first(where: { $0.yemek_adi == yemek_adi && $0.kullanici_adi == kullanici_adi }) {
         
            if let mevcutAdet = Int(mevcutYemek.yemek_siparis_adet!), let eklenenAdet = Int(yemek_siparis_adet) {
                let yeniAdet = mevcutAdet + eklenenAdet
                mevcutYemek.yemek_siparis_adet = String(yeniAdet)
                if let mevcutFiyat = Double(mevcutYemek.yemek_fiyat!), let eklenenFiyat = Double(yemek_fiyat) {
                    let yeniFiyat = mevcutFiyat + (eklenenFiyat * Double(eklenenAdet))
                    mevcutYemek.yemek_fiyat = String(yeniFiyat)
                }
                
                sil(sepet_yemek_id: mevcutYemek.sepet_yemek_id!, kullanici_adi: mevcutYemek.kullanici_adi) {
                    let params: Parameters = ["yemek_adi": mevcutYemek.yemek_adi!, "yemek_fiyat": mevcutYemek.yemek_fiyat!, "yemek_resim_adi": mevcutYemek.yemek_resim_adi!, "yemek_siparis_adet": mevcutYemek.yemek_siparis_adet!, "kullanici_adi": mevcutYemek.kullanici_adi]
                    AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response {
                        response in
                        if let data = response.data {
                            do {
                                let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                                print("Başarılı : \(cevap.success!)")
                                print("Mesaj : \(cevap.message!)")
                                self.yemekleriGetir(kullanici_adi: kullanici_adi)
                            } catch {
                                print(String(describing: error))
                            }
                        }
                    }
                }
            }
        } else {
           
            let params: Parameters = ["yemek_adi": yemek_adi, "yemek_fiyat": yemek_fiyat, "yemek_resim_adi": yemek_resim_adi, "yemek_siparis_adet": yemek_siparis_adet, "kullanici_adi": kullanici_adi]
            AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response {
                response in
                if let data = response.data {
                    do {
                        let cevap = try JSONDecoder().decode(CRUDCevap.self, from: data)
                        print("Başarılı : \(cevap.success!)")
                        print("Mesaj : \(cevap.message!)")
                        self.yemekleriGetir(kullanici_adi: kullanici_adi)
                    } catch {
                        print(String(describing: error))
                    }
                }
            }
        }
    }
    
    
    }
        

