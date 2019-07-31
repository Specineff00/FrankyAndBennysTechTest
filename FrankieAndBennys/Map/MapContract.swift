//
//  MapContract.swift
//  FrankieAndBennys
//
//  Created by Yogesh N Ramsorrrun on 27/07/2019.
//  Copyright © 2019 Yogesh N Ramsorrrun. All rights reserved.
//

import Foundation

protocol MapViewContract: class {
    func showRestaurants(_ restaurants: [Restaurant])
    func showLoadingFail()
}

protocol MapPresenterContract: class {
    func retrieveRestaurantData()
    
}
