//
//  SepetSayfa.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import UIKit
import Kingfisher

class SepetSayfa: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet weak var sepetTableView: UITableView!
    @IBOutlet weak var toplamFiyat: UILabel!
    
    var sepet : [SepetYemekler] = []
   
    var yemeklerListesi = [SepetYemekler]()
    var hucre = SepetHucre()
    var viewModel = SepetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        
        sepetTableView.delegate = self
        sepetTableView.dataSource = self
        toplamFiyat.text = "0₺"
        
        sepetTableView.separatorStyle = .none
        sepetTableView.backgroundColor = .arkaplan
        
        sepetTableView.reloadData()
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: {liste in
            self.yemeklerListesi = liste
            DispatchQueue.main.async {
                self.sepetTableView.reloadData()
            }
        })
    }
    
    
    @IBAction func btnKapat(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func sepetiTemizle() {
        yemeklerListesi.removeAll()
        sepetTableView.reloadData()
        hesaplaToplamFiyat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.yemekleriGetir(kullanici_adi: "emre_aslan")
       sepetiTemizle()
       
    }

    @IBAction func btnSiparisiTamamla(_ sender: Any) {
        
        sepetiTemizle()
        
        let alert = UIAlertController(title: "Başarılı", message: "Siparişiniz başarıyla oluşturuldu", preferredStyle: .alert)
        let tamamAction = UIAlertAction(title: "Tamam", style: .default) { action in
            self.tabBarController?.selectedIndex = 0
        }
        alert.addAction(tamamAction)
        present(alert, animated: true, completion: nil)
       
    }
    
   
    
}

extension SepetSayfa : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yemeklerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let yemek = yemeklerListesi[indexPath.row]
        let hucre = sepetTableView.dequeueReusableCell(withIdentifier: "sepetHucre") as! SepetHucre
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
            
            if let yemekAdi = hucre.yemekAdi, let sepetImageView = hucre.sepetImageView {
                
                sepetImageView.kf.setImage(with: url)
                yemekAdi.text = yemek.yemek_adi
                hucre.yemekAdet!.text = "Adet : \(yemek.yemek_siparis_adet!) "
                hucre.yemekFiyat.text = "Fiyat : \(yemek.yemek_fiyat!) ₺"
                hesaplaToplamFiyat()
                
                hucre.backgroundColor = UIColor.renk2
                hucre.layer.shadowRadius = 100
                
                
            }
        }
        
        return hucre
    }
    
    func hesaplaToplamFiyat() {
        var toplamFiyat = 0
        for yemek in yemeklerListesi {
            if let fiyat = yemek.yemek_fiyat {
                toplamFiyat += Int(fiyat)!
            }
        }
        
        self.toplamFiyat.text = "Toplam Fiyat : \(toplamFiyat) ₺"
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){contentUnavailableConfiguration,view,bool in
            let yemekler = self.yemeklerListesi[indexPath.row]
            
            let alert = UIAlertController(title: "Ürün iptal edilsin mi?", message: "\(yemekler.yemek_adi!) Sepetten Çıkar ", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "Evet", style: .destructive){ action in
                self.viewModel.sil(sepet_yemek_id: yemekler.sepet_yemek_id!, kullanici_adi: yemekler.kullanici_adi)
            }
            alert.addAction(evetAction)
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
    
}
