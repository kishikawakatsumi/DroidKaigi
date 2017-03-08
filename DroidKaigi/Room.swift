//
//  Room.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

class Room {
    let id: Int
    let name: String?
    let hashtag: String?

    convenience init?(room: [String: Any]?) {
        guard let room = room else {
            return nil
        }
        let id = room["id"] as! Int
        let name = room["name"] as? String
        let hashtag = room["hashtag"] as? String
        self.init(id: id, name: name, hashtag: hashtag)
    }

    init(id: Int, name: String?, hashtag: String?) {
        self.id = id
        self.name = name
        self.hashtag = hashtag
    }
}
