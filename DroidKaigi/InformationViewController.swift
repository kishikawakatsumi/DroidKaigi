//
//  InformationViewController.swift
//  DroidKaigi
//
//  Created by kishikawakatsumi on 3/9/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import SafariServices

class InformationViewController: UITableViewController {

    private enum Item: Int {
        case sponsor
        case enquete
        case contributer
        case translate
        case license
        case devInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private methods

    @IBAction func didTapTwitterButton(_ sender: Any) {
        openUrl(string: "https://twitter.com/DroidKaigi")
    }
    
    @IBAction func didTapFacebookButton(_ sender: Any) {
        openUrl(string: "https://www.facebook.com/DroidKaigi/")
    }
    
    @IBAction func didTapGithubButton(_ sender: Any) {
        openUrl(string: "https://github.com/DroidKaigi/conference-app-2017/")
    }
    
    @IBAction func didTapDroidKaigiButton(_ sender: Any) {
        openUrl(string: "https://droidkaigi.github.io/2017/")
    }
    
    @IBAction func didTapYoutubeButton(_ sender: Any) {
        openUrl(string: "https://www.youtube.com/droidkaigi")
    }
    
    private func openUrl(string: String) {
        if let url = URL(string: string) {
            let viewController = SFSafariViewController(url: url)
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        switch indexPath.row {
        case Item.sponsor.rawValue:
            openUrl(string: "https://droidkaigi.github.io/2017/#sponsors")
        case Item.enquete.rawValue:
            openUrl(string: "https://docs.google.com/forms/d/1SNBvJernnyBwglNentXxpdSUkWI9U6umWdDs4Na8OIU/viewform?edit_requested=true")
        case Item.contributer.rawValue:
            openUrl(string: "https://github.com/kishikawakatsumi/DroidKaigi/graphs/contributors")
        case Item.translate.rawValue:
            openUrl(string: "https://droidkaigi2017.oneskyapp.com/collaboration")
        default: break
        }
    }
}
