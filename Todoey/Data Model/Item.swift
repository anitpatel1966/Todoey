//
//  Item.swift
//  Todoey
//
//  Created by Anit Patel on 06/08/2019.
//  Copyright © 2019 TerikLimited. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
 
    // defines the relationship back to the parent (Category.self) and its forward
    // relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
