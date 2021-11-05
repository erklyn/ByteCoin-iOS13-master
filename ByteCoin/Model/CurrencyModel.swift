//
//  CurrencyModel.swift
//  ByteCoin
//
//  Created by Utku enes Gürsel on 5.11.2021.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation


struct CurrencyModel{
    let rate: Float
    
    var rateString:String {
        String(format: "%.2f", rate)
    }
}
