//
//  Data.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/14/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    //need to add these two modifiers basically so that REALM can monitor for changes in the value of this property.
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
