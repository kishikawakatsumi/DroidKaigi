//
//  SessionDetailViewController.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit

class SessionDetailViewController: UIViewController {

    var session: Session?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!

    @IBOutlet weak var speakerTitleLabel: UILabel!

    @IBOutlet weak var speakerNameLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var feedbackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let timeFormatter = DateFormatter()
        timeFormatter.calendar = Calendar(identifier: .gregorian)
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "HH:mm"

        title = session?.title

        if let session = session {
            dateLabel.text = String(format: "%@ %@〜%@ (%d min)", dateFormatter.string(from: session.startTime), timeFormatter.string(from: session.startTime), timeFormatter.string(from: session.endTime), session.duration)
        }
        roomLabel.text = session?.room?.name
        speakerNameLabel.text = session?.speaker?.name
        descriptionLabel.text = session?.desc
    }

}
