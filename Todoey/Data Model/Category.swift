//
//  Category.swift
//  Todoey
//
//  Created by Anit Patel on 06/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    
    // The forward relationship from Category->Item
    //
    let items = List<Item>()
    
}
