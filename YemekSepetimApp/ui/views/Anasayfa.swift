//
//  ViewController.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 27.05.2024.
//

import UIKit
import Alamofire
import Kingfisher
import RxSwift

class Anasayfa: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var yemeklerTableView: UITableView!
    var yemeklerListesi = [Yemekler]()
    var viewModel = AnasayfaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yemeklerTableView.delegate = self
        yemeklerTableView.dataSource = self
       
        searchBar.delegate = self
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
                    searchTextField.backgroundColor = UIColor.white
                }
        
        yemeklerTableView.separatorStyle = .none
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemeklerListesi = liste
            DispatchQueue.main.async {
                self.yemeklerTableView.reloadData()
            }
        })
        
        if let navigationBar = self.navigationController?.navigationBar {
                    navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "renk1")!]
                }

        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay"{
            if let yemekler = sender as? Yemekler{
                let destinationVC = segue.destination as! DetaySayfa
                destinationVC.yemekler = yemekler
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.yemekleriYukle()
    }

}

extension Anasayfa : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yemeklerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let yemek = yemeklerListesi[indexPath.row]
        let hucre = tableView.dequeueReusableCell(withIdentifier: "yemeklerHucre") as! YemeklerHucre
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)"){
            if let yemekAdi = hucre.yemekAdi, let yemekResim = hucre.yemekResim {
                yemekResim.kf.setImage(with: url)
                yemekAdi.text = yemek.yemek_adi
                hucre.yemekFiyat.text = "\(yemek.yemek_fiyat!)₺"
                hucre.backgroundColor = .arkaplan
            }
        }
        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        yemeklerTableView.deselectRow(at: indexPath, animated: false)
        let yemek = yemeklerListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: yemek)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension Anasayfa : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            viewModel.yemekleriYukle()
            } else {
                yemeklerListesi = yemeklerListesi.filter({ yemekler  in
                    return ((yemekler.yemek_adi?.contains(searchText)) ?? false)
            })
        }
        self.yemeklerTableView.reloadData()
    
    }
}
