//
//  Note.swift
//  Health
//
//  Created by Даниил Марусенко on 04.02.2021.
//

import Foundation
import RealmSwift

class Note: Object {

    @objc dynamic var measure: String = ""
    @objc dynamic var value: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var date: String = ""
    
}

