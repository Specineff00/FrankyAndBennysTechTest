//
//  RestaurantDetailsViewController.swift
//  FrankieAndBennys
//
//  Created by Yogesh N Ramsorrrun on 27/07/2019.
//  Copyright © 2019 Yogesh N Ramsorrrun. All rights reserved.
//

import UIKit
import SafariServices

class RestaurantDetailsViewController: UIViewController, RestaurantDetailsViewContract {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    let presenter:  RestaurantDetailsPresenterContract
    let restaurant: Restaurant
    
    init(presenter: RestaurantDetailsPresenterContract, restaurant: Restaurant) {
        self.presenter = presenter
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(close))
        
        
        bodySetup()
        linkSetup()
        
        nameLabel.text = restaurant.title
        bodyLabel.text = restaurant.body.withoutHtml
        linkLabel.text = restaurant.url?.absoluteString
    }
    
    fileprivate func bodySetup() {
        bodyLabel.sizeToFit()
        bodyLabel.numberOfLines = 0
    }
    
    fileprivate func linkSetup() {
        linkLabel.textColor = .blue
        linkLabel.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        linkLabel.addGestureRecognizer(tap)
        linkLabel.isUserInteractionEnabled = true
    }
    
    @objc func linkTapped() {
        guard let link = linkLabel.text,
            let url = URL(string: link) else { return }
        UIApplication.shared.open(url, options:[:], completionHandler: nil)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
