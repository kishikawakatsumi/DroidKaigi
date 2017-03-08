//
//  SessionsViewController.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit

class SyncScrollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class SessionsViewController: UIViewController, UIGestureRecognizerDelegate {

    var headerScrollView = SyncScrollView()
    var scrollView = SyncScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        headerScrollView.frame = view.bounds
        headerScrollView.frame.origin.y = 64
        headerScrollView.frame.size.height = 44
        headerScrollView.autoresizingMask = [.flexibleWidth]
        headerScrollView.showsHorizontalScrollIndicator = false
        headerScrollView.showsVerticalScrollIndicator = false
        view.addSubview(headerScrollView)

        scrollView.frame = view.bounds
        scrollView.frame.origin.y = headerScrollView.frame.maxY
        scrollView.frame.size.height = scrollView.frame.height - headerScrollView.frame.maxY - tabBarController!.tabBar.bounds.height
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .lightGray
        view.addSubview(scrollView)

        view.addGestureRecognizer(headerScrollView.panGestureRecognizer)
        view.addGestureRecognizer(scrollView.panGestureRecognizer)

        let endpoint = URL(string: "https://droidkaigi.github.io/2017/sessions.json")!
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: endpoint) { (data, response, error) in
            if let data = data {
                let sessions = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]

                DispatchQueue.main.async {
                    var maxWidth: CGFloat = 0.0
                    var maxHeight: CGFloat = 0.0

                    var previousRows = [SessionView]()
                    var previousOrigin: CGFloat = 0.0
                    var origin: CGFloat = 0.0
                    for session in sessions {
                        let session = Session(session: session)

                        let size = self.view.bounds.size
                        let width = size.width / 10 * 3
                        let height = width / 4
                        var frame = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))

                        let coordinate = session.coordinate
                        frame.origin.x = width * CGFloat(coordinate.x)
                        if session.type == "ceremony" {
                            frame.size.width = width * 3
                        }
                        frame.size.height = height * CGFloat(session.height) + 20

                        if session.startTime != previousRows.last?.session.startTime {
                            for previousRow in previousRows {
                                previousRow.frame.origin.y = previousOrigin
                            }
                            previousOrigin += origin
                            origin = 0.0
                            previousRows.removeAll()

                        }

                        let sessionView = SessionView()
                        sessionView.session = session
                        sessionView.frame = frame

                        self.scrollView.addSubview(sessionView)

                        maxWidth = max(maxWidth, frame.maxX)
                        maxHeight = max(maxHeight, frame.maxY)

                        previousRows.append(sessionView)
                        origin = max(origin, frame.height)
                    }

                    for previousRow in previousRows {
                        previousRow.frame.origin.y = previousOrigin
                    }
                    previousOrigin += origin
                    origin = 0.0
                    previousRows.removeAll()

                    self.scrollView.contentSize = CGSize(width: maxWidth, height: previousOrigin + origin)

                    let size = self.view.bounds.size
                    let width = size.width / 10 * 3

                    for i in 1...6 {
                        let label = UILabel()
                        label.text = String(format: "Room %d", i)
                        label.textAlignment = .center
                        label.font = UIFont.boldSystemFont(ofSize: 12)

                        label.frame = self.headerScrollView.bounds
                        label.frame.size.width = width
                        label.frame.origin.x = CGFloat(i - 1) * label.frame.width
                        
                        self.headerScrollView.addSubview(label)
                    }
                    self.headerScrollView.contentSize.width = self.scrollView.contentSize.width
                }
            }
        }.resume()
    }

}
