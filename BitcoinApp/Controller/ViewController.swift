//
//  ViewController.swift
//  BitcoinApp
//
//  Created by adrian silva on 1/5/18.
//  Copyright © 2018 Adrian silva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["USD","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    
    var finalUrl = ""
    
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalUrl = URL + currencyArray[row]
        getBitcoinData(url: finalUrl)
    }
    
    
    //get bitcoin data using alamofire
    func getBitcoinData(url: String)  {
        Alamofire.request(url, method: .get).responseJSON { (data) in
            guard data.result.isSuccess else{
                self.bitcoinPriceLabel.text = "Something Went Wrong"
                return
            }
            let jsonData: JSON = JSON(data.result.value)
            self.parseData(data: jsonData)
        }
    }
    
    //parse data using swiftyJSON
    func parseData(data: JSON){
        if let price = data["ask"].double{
            updateUI(price: price)
        }else{
            bitcoinPriceLabel.text = "Something Went Wrong"
        }
        
    }
    
    func updateUI(price: Double){
        bitcoinPriceLabel.text = "\(price)"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        bitcoinPriceLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

