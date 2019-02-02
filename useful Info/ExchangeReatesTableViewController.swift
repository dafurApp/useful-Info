//
//  ExchangeReatesTableViewController.swift
//  useful Info
//
//  Created by Daniel Furrer on 05.12.18.
//  Copyright © 2018 Daniel Furrer. All rights reserved.
//

import UIKit
import Alamofire



class ExchangeReatesTableViewController: UITableViewController, CurrencyDataDelegate {
    @IBOutlet weak var segContrCurrency: UISegmentedControl!
    var currCurrency = "EUR"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CurrencyData.shared.delegate = self
        CurrencyData.shared.getPrices()
        
        
    }
  
    func newPrices() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrencyData.shared.currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let currency = CurrencyData.shared.currencies[indexPath.row]
        var chfFactor = 1.0
        
        if self.currCurrency == "EUR"{
            chfFactor = 1.0
            print("EURO")
        }
        if self.currCurrency == "CHF"{
            chfFactor = currency.factorCHF
            print(chfFactor)
        }
        
        //let rateToCHF = currency.rate * chfFactor
        //cell.textLabel?.text = "\(currency.symbol)  \(rateToCHF)"
        
        
        cell.textLabel?.text = "\(currency.symbol)  \(currency.rateAsString())"
        //cell.imageView?.image = currency.image
        
        return cell
    }
    
    @IBAction func segContrCurrValueChgd(_ sender: UISegmentedControl) {
        switch segContrCurrency.selectedSegmentIndex
        {
        case 0:
        self.currCurrency = "EUR"
        case 1:
        self.currCurrency = "CHF"
        default:
            break
        }
        tableView.reloadData()
    }
    
    
}
