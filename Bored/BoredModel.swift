//
//  BoredModel.swift
//  Bored
//
//  Created by Pavel Paddubotski on 11.09.21.
//

import RealmSwift

struct Bored: Codable {
    let activity: String
    let accessibility: Double
    let type: String
    let participants: Int
    let price: Double
}

class Tasks: Object {
    @objc dynamic var title = ""
}
