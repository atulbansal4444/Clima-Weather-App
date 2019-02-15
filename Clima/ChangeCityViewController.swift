//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Atul Bansal on 14/02/19.
//  Copyright © 2019 Atul Bansal. All rights reserved.
//
import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city : String)
}


class ChangeCityViewController: UIViewController {
    
    //delegate variable
    var delegate : ChangeCityDelegate?
    
    //linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        let cityName = changeCityTextField.text!
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
