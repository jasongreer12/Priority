//
//  Category.swift
//  Priority
//
//  Created by Victoria Luce on 4/13/25.
//

import Foundation
import CoreData

@objc(Category)
class Category: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var priority: Int32
    @NSManaged var tasks: NSSet?
}
