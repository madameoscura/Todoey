//
//  Item.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/11/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import Foundation

//with Encodable protocol, item type is now able to encode itself into e.g. a plist
//in order for a class to be encodable, all of its properties must have standard data types
class Item: Codable {
    var title : String = ""
    var done : Bool = false
}
