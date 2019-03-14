//
//  Categorys.swift
//  ToDoey
//
//  Created by Daniel Cárdenas on 13/03/19.
//  Copyright © 2019 Daniel Cárdenas. All rights reserved.
//

import Foundation
import RealmSwift

class Categorys: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
 
}
