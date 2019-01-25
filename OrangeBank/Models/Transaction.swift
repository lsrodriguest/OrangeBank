//
//  Transaction.swift
//  OrangeBank
//
//  Created by Luis Rodrigues on 24/01/2019.
//  Copyright © 2018 Luis Rodrigues. All rights reserved.
//

import Foundation
import Unbox

// MARK: - struct Transaction

struct Transaction: Unboxable {
    
    let id:          String
    let date:        Date?
    let amount:      Double
    let fee:         Double?
    let description: String?
    
    init(unboxer: Unboxer) throws {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        self.id          = try unboxer.unbox(key: "id")
        self.date        =     unboxer.unbox(key: "date", formatter: dateFormatter)
        self.amount      = try unboxer.unbox(key: "amount")
        self.fee         =     unboxer.unbox(key: "fee")
        self.description =     unboxer.unbox(key: "description")
        
    }
}
