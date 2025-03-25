//
//  HomeViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

    private let disposeBag = DisposeBag()

    private var userNameLabel: UILabel!
    private var statusLabel: UILabel!
    private var clockInButton: UIButton!
    private var clockOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"

        setupSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayout()
    }

    private func setupSubviews() {
        userNameLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textAlignment = .center
            $0.text = "ようこそ、\(UserProfile.shared.userName) さん"
            view.addSubview($0)
        }

        statusLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16)
            $0.textAlignment = .center
            $0.text = UserProfile.shared.isClockedIn ? "出勤済み" : "未出勤"
            view.addSubview($0)
        }

        clockInButton = UIButton(type: .system).then {
            $0.setTitle("出勤", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .systemGreen
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            view.addSubview($0)

            $0.rx.tap
                .subscribe(onNext: { [weak self] in
                    UserProfile.shared.save(with: ["isClockedIn": true])
                    self?.statusLabel.text = "出勤済み"
                })
                .disposed(by: disposeBag)
        }

        clockOutButton = UIButton(type: .system).then {
            $0.setTitle("退勤", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .systemRed
            $0.layer.cornerRadius = 8
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            view.addSubview($0)

            $0.rx.tap
                .subscribe(onNext: { [weak self] in
                    UserProfile.shared.save(with: ["isClockedIn": false])
                    self?.statusLabel.text = "未出勤"
                })
                .disposed(by: disposeBag)
        }
    }

    private func updateLayout() {
        let width = view.bounds.width
        let padding: CGFloat = 20
        let buttonHeight: CGFloat = 44
        let buttonWidth: CGFloat = 100

        userNameLabel.do {
            $0.frame = CGRect(x: padding, y: 120, width: width - padding * 2, height: 28)
        }

        statusLabel.do {
            $0.frame = CGRect(x: padding, y: userNameLabel.frame.maxY + 12, width: width - padding * 2, height: 24)
        }

        clockInButton.do {
            $0.frame = CGRect(x: (width - buttonWidth) / 2, y: statusLabel.frame.maxY + 40, width: buttonWidth, height: buttonHeight)
        }

        clockOutButton.do {
            $0.frame = CGRect(x: (width - buttonWidth) / 2, y: clockInButton.frame.maxY + 16, width: buttonWidth, height: buttonHeight)
        }
    }
}
