//
//  Item.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/14/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    //defining the inverse relationship of items: each item has an inverse relationship to parentcategory --> links each item back to a parent category
}

