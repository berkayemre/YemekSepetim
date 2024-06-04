//
//  AnasayfaViewModel.swift
//  YemekSepetimApp
//
//  Created by Berkay Emre Aslan on 28.05.2024.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    var yrepo = YemeklerRepo()
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init() {
        yemeklerListesi = yrepo.yemeklerListesi
        yemekleriYukle()
    }
    
    func yemekleriYukle() {
        yrepo.yemekleriYukle()
    }
    
    func ara(aramaKelimesi:String){
        yrepo.ara(aramaKelimesi: aramaKelimesi)
    }
}
