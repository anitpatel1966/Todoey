//
//  Item.swift
//  Todoey
//
//  Created by Anit Patel on 02/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import Foundation

// mark the class as conforming to Codable (ie encodable & decodable protocols).
// all of the classes properties must be of standard data-types
// cannot include class objects.
//
class Item : Codable {
    
    var title : String = ""
    var done : Bool = false
    
}
