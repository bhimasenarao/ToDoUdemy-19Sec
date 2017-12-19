//
//  Category.swift
//  ToDoUdemy-19Sec
//
//  Created by Bhimasena Patri on 19/12/2017.
//  Copyright © 2017 Bhimasena Patri. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
