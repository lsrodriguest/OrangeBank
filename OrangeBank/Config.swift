//
//  Config.swift
//  OrangeBank
//
//  Created by Luis Rodrigues on 24/01/2019.
//  Copyright © 2018 Luis Rodrigues. All rights reserved.
//

import Foundation

struct Config {
    
    // We obtain the value of API_BASE_URL according to the Build Configuration used: Debug / Release
    static let apiBaseUrl = Bundle.main.infoDictionary! ["API_BASE_URL"] as! String
}
