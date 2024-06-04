//
//  DetaySayfa.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import UIKit
import Kingfisher

class DetaySayfa: UIViewController {

    @IBOutlet weak var yemekAdet: UILabel!
    @IBOutlet weak var yemekFiyat: UILabel!
    @IBOutlet weak var yemekAdi: UILabel!
    @IBOutlet weak var yemekImage: UIImageView!
    
    var yemekler:Yemekler?
    var sepetYemekler:SepetYemekler?
    var viewModel = DetayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yemekAdet.text = "1"
        
        self.navigationController?.navigationBar.tintColor = UIColor.renk1
        
        if let yemekler = yemekler {
            yemekAdi.text = yemekler.yemek_adi
            
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemekler.yemek_resim_adi!)") {
                if let yemekAdi = yemekAdi, let yemekImage = yemekImage {
                    yemekImage.kf.setImage(with: url)
                    yemekAdi.text = yemekler.yemek_adi
                    yemekFiyat.text = "\(yemekler.yemek_fiyat!)"
                    
                }
            }
        }
    }
    @IBAction func btnAzalt(_ sender: Any) {
        if let adet = Int(yemekAdet.text ?? "") {
            if adet > 0 {
                yemekAdet.text = "\(adet - 1)"
                tutarGuncelle()
            }
        }
    }
    @IBAction func btnArttir(_ sender: Any) {
        if let adet = Int(yemekAdet.text ?? "") {
                yemekAdet.text = "\(adet + 1)"
                tutarGuncelle()
        }
    }
    
    @IBAction func btnSepeteEkle(_ sender: Any) {
        if let yemek_adi = yemekAdi.text,
        let yemek_fiyat = yemekFiyat.text,
        let yemek_siparis_adet = yemekAdet.text{
            viewModel.sepeteKaydet(yemek_adi: yemek_adi,
                                   yemek_fiyat: yemek_fiyat,
                                   yemek_resim_adi: yemekler!.yemek_resim_adi!,
                                   yemek_siparis_adet: yemek_siparis_adet,
                                   kullanici_adi: "emre_aslan")
        }
        
        self.tabBarController?.selectedIndex = 1
    }
    
    
    func tutarGuncelle(){
        if let adetString = yemekAdet.text,let adet = Int(adetString),let yemekFiyat = Int(yemekler?.yemek_fiyat ?? ""){
            let tutar = adet * yemekFiyat
            self.yemekFiyat.text = "\(tutar)"
        }
    }

}
