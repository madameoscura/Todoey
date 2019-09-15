//
//  Category.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/14/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import Foundation
import RealmSwift

//by subclassing realm object, we are able to save our data using realm

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    //each category can have a number of items and that is a list of item objects
    //List is something like an array
    //e.g. let array : [Int] = [1,2,3] or let array : : Array<Int> = [1,2,3] or let array = Array<Int>()
}
