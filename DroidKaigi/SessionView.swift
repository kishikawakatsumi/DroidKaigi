//
//  SessionView.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import UserNotifications

let timeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

class SessionView: UIView {

    var topicView = UIView()
    var timeLabel = UILabel()
    var titleLabel = UILabel()
    var languageLabel = UILabel()
    var nameLabel = UILabel()
    var checkImageView = UIImageView(image: UIImage(named: "check"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        topicView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 2)
        topicView.autoresizingMask = [.flexibleWidth]

        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = .red

        titleLabel.font = UIFont.systemFont(ofSize: 10)

        languageLabel.font = UIFont.systemFont(ofSize: 10)
        languageLabel.textColor = .gray
        languageLabel.textAlignment = .center
        languageLabel.layer.borderWidth = 1.0
        languageLabel.layer.cornerRadius = 4.0
        languageLabel.layer.borderColor = UIColor.lightGray.cgColor

        nameLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.textColor = .lightGray

        titleLabel.numberOfLines = 3
        
        checkImageView.isHidden = true

        addSubview(topicView)
        addSubview(timeLabel)
        addSubview(titleLabel)
        addSubview(languageLabel)
        addSubview(nameLabel)
        addSubview(checkImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var session: Session! {
        didSet {
            timeLabel.text = String(format: "%@ (%d min)", timeFormatter.string(from: session.startTime), session.duration)
            titleLabel.text = session.title
            languageLabel.text = session.language?.uppercased()
            nameLabel.text = session.speaker?.name
            checkImageView.isHidden = !session.isNotify
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let topicColors: [UIColor] = [.blue, .brown, .green, .orange, .orange, .yellow, .red, .purple]
        if let topic = session.topic {
            topicView.backgroundColor = topicColors[topic.id]
        }

        do {
            timeLabel.frame = CGRect(x: 4, y: 2, width: bounds.width - 4 * 2, height: 0)
            let size = timeLabel.sizeThatFits(timeLabel.bounds.size)
            timeLabel.frame.size = size
        }
        do {
            titleLabel.frame = CGRect(x: 4, y: timeLabel.frame.maxY + 2, width: bounds.width - 4 * 2, height: 0)
            let size = titleLabel.sizeThatFits(titleLabel.bounds.size)
            titleLabel.frame.size = size
        }
        do {
            languageLabel.frame = CGRect(x: 4, y: titleLabel.frame.maxY + 2, width: bounds.width - 4 * 2, height: 0)
            var size = languageLabel.sizeThatFits(languageLabel.bounds.size)
            size.width += 4
            languageLabel.frame.size = size
        }
        do {
            nameLabel.frame = CGRect(x: 4, y: languageLabel.frame.maxY + 2, width: bounds.width - 4 * 2, height: 0)
            var size = nameLabel.sizeThatFits(nameLabel.bounds.size)
            size.width = bounds.width - 4 * 2
            nameLabel.frame.size = size
        }
        do {
            checkImageView.frame = CGRect(x: 4, y: nameLabel.frame.maxY + 2, width: 24, height: 24)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let time = session.startTime.timeIntervalSinceNow
        if time < 0 {
            return
        }
        
        if session.isNotify {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [session.notificationId])
            self.checkImageView.isHidden = true
            session.isNotify = false
        }
        else {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Droid Kaigi"
            content.body = self.session.title
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
            let request = UNNotificationRequest(identifier: session.notificationId, content: content, trigger: trigger)
            center.add(request)
            
            session.isNotify = true
            self.checkImageView.isHidden = false
        }
    }
}
