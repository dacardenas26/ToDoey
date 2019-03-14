//
//  Item.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 13/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
     @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    var parentCategory = LinkingObjects(fromType: Categorys.self, property: "items")
}
