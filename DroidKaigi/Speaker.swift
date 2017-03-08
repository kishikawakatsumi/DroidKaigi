//
//  Speaker.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

class Speaker {
    let id: Int
    let name: String
    let imageUrl: URL?

    convenience init?(speaker: [String: Any]?) {
        guard let speaker = speaker else {
            return nil
        }
        let id = speaker["id"] as! Int
        let name = speaker["name"] as! String
        let imageUrl = speaker["image_url"] as? String
        self.init(id: id, name: name, imageUrl: imageUrl != nil ? URL(string: imageUrl!) : nil)
    }

    init(id: Int, name: String, imageUrl: URL?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}
