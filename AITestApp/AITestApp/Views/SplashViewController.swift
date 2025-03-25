//
//  SplashViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit
import Then

class SplashViewController: BaseViewController {

    var logoText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Splash"
        view.backgroundColor = .white

        setupSubviews()
        updateLayout()
    }

    func setupSubviews() {
        logoText = UILabel().then {
            view.addSubview($0)
        }
    }

    func updateLayout() {
        logoText.do {
            $0.text = R.string.localizable.splash_title()
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textColor = .red
            $0.sizeToFit()
            $0.center.x = centerX
            $0.center.y = centerY
        }
    }
}
