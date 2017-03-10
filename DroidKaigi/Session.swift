//
//  Session.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import Foundation

let zeroDatetime: Date = {
    let date = datetimeFormatter.date(from: "2017/03/09 10:00:00")!
    return date
}()

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy/MM/dd"
    return dateFormatter
}()

let datetimeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return dateFormatter
}()

class Topic {
    let id: Int
    let name: String?

    convenience init?(topic: [String: Any]?) {
        guard let topic = topic else {
            return nil
        }
        let id = topic["id"] as! Int
        let name = topic["name"] as? String
        self.init(id: id, name: name)
    }

    init(id: Int, name: String?) {
        self.id = id
        self.name = name
    }
}

class Session {
    let id: Int
    let title: String
    let room: Room?
    let speaker: Speaker?
    let topic: Topic?
    let date: Date
    let startTime: Date
    let endTime: Date
    let duration: Int
    let type: String
    let language: String?
    let desc: String?
    var isNotify = false

    var coordinate: (x: Int, y: Int) {
        let diff = startTime.timeIntervalSinceReferenceDate - zeroDatetime.timeIntervalSinceReferenceDate
        let y = Int((diff / 60) / 10)
        if let room = room {
            if room.id == 0 {
                if diff > 0 {
                    return (0, y)
                }
                return (0, 0)
            }
            if let name = room.name {
                let s = (name as NSString).substring(from: (name as NSString).length - 1)
                return (Int(s)! - 1, y)
            }
        }
        return (0, y)
    }
    
    var notificationId: String {
        get {
            return "sessionid-\(id)"
        }
    }

    var height: Int {
        if type == "break" {
            return 4
        }
        
        let calendar = datetimeFormatter.calendar!
        let hour = calendar.component(.hour, from: startTime)
        if hour == 12 {
            return Int((duration) / 10)
        } else {
            return Int((duration + 20) / 10)
        }
    }

    convenience init(session: [String: Any]) {
        let id = session["id"] as! Int
        let title = session["title"] as! String
        let room = session["room"] as? [String: Any]
        let speaker = session["speaker"] as? [String: Any]
        let topic = session["topic"] as? [String: Any]
        let date = dateFormatter.date(from: session["date"] as! String)!
        let startTime = datetimeFormatter.date(from: session["stime"] as! String)!
        let endTime = datetimeFormatter.date(from: session["etime"] as! String)!
        let duration = session["duration_min"] as! Int
        let type = session["type"] as! String
        let language = session["lang"] as? String
        let desc = session["desc"] as? String
        self.init(id: id, title: title, room: Room(room: room), speaker: Speaker(speaker: speaker), topic: Topic(topic: topic), date: date, startTime: startTime, endTime: endTime, duration: duration, type: type, language: language, desc: desc)
    }

    init(id: Int, title: String, room: Room?, speaker: Speaker?, topic: Topic?, date: Date, startTime: Date, endTime: Date, duration: Int, type: String, language: String?, desc: String?) {
        self.id = id
        self.title = title
        self.room = room
        self.speaker = speaker
        self.topic = topic
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.type = type
        self.language = language
        self.desc = desc
    }

}
