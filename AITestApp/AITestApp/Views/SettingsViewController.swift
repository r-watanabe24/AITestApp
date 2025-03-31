//
//  SettingsViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class SettingsViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    private var darkModeLabel: UILabel!
    private var darkModeSwitch: UISwitch!
    private var helpModelLabel: UILabel!
    private var helpModelSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "settings"
    

        setupSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }

    private func setupSubviews() {
        darkModeLabel = UILabel().then {
            $0.text = "ダークモード"
            $0.font = .systemFont(ofSize: 16)
            view.addSubview($0)
        }

        helpModelLabel = UILabel().then {
            $0.text = "チャットボットのLLM使用"
            $0.font = .systemFont(ofSize: 16)
            view.addSubview($0)
        }

        darkModeSwitch = UISwitch().then {
            $0.isOn = UserProfile.shared.isDarkMode
            view.addSubview($0)

            $0.rx.isOn.subscribe(onNext: { [weak self] isOn in
                UserProfile.shared.save(with: ["isDarkMode": isOn])
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = isOn ? .dark : .light
                    }
                }
                self?.updateBaseLayout()
            })
            .disposed(by: disposeBag)
        }

        helpModelSwitch = UISwitch().then {
            // UserDefaultsから初期値を取得（なければ false）
            $0.isOn = UserDefaults.standard.bool(forKey: Constants.helpModelKey)
            view.addSubview($0)

            $0.rx.isOn
                .subscribe(onNext: { [weak self] isOn in
                    UserDefaults.standard.set(isOn, forKey: Constants.helpModelKey)
                    self?.updateBaseLayout()
                })
                .disposed(by: disposeBag)
        }
    }

    private func updateLayout() {
        let width = view.bounds.width
        let padding: CGFloat = 24

        darkModeLabel.do {
            $0.frame = CGRect(x: padding, y: 150, width: 200, height: 30)
        }

        darkModeSwitch.do {
            $0.center = CGPoint(
                x: width - padding - $0.bounds.width / 2,
                y: darkModeLabel.center.y
            )
        }

        helpModelLabel.do {
            $0.frame = CGRect(x: padding, y: darkModeSwitch.frame.maxY + 20, width: 200, height: 30)
        }

        helpModelSwitch.do {
            $0.center = CGPoint(
                x: width - padding - $0.bounds.width / 2,
                y: helpModelLabel.center.y
            )
        }
    }
}
