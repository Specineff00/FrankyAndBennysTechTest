//
//  MapPresenter.swift
//  FrankieAndBennys
//
//  Created by Yogesh N Ramsorrrun on 27/07/2019.
//  Copyright © 2019 Yogesh N Ramsorrrun. All rights reserved.
//

import Foundation

class MapPresenter: MapPresenterContract {
    
    let url: String
    weak var view: MapViewContract?
    var restaurants: [Restaurant]?
    
    init(url: String) {
        self.url = url
    }
    
    func retrieveRestaurantData() {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else { return }
            
            do  {
                self?.restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                DispatchQueue.main.async {
                    guard let restaurants = self?.restaurants else  {
                        self?.view?.showLoadingFail()
                        return
                    }
                    self?.view?.showRestaurants(restaurants)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.view?.showLoadingFail()
                }
            }
            
            }.resume()
    }
}
