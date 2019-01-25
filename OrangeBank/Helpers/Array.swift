//
//  Array.swift
//  OrangeBank
//
//  Created by Luis Rodrigues on 24/01/2019.
//  Copyright © 2018 Luis Rodrigues. All rights reserved.
//

import Foundation

extension Array {
    
    // Remove duplicates from array of non-equatable objects
    func removeDuplicates<T: Hashable>(byKey key: (Element) -> T) -> [Element] {
        
        var result = [Element]()
        var seen   = Set<T>()
        
        for value in self {
            
            if seen.insert(key(value)).inserted {
                
                result.append(value)
            }
        }
        
        return result
    }
}
