//
//  ProfileViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class ProfileViewController: BaseViewController {

    private let disposeBag = DisposeBag()

    var userNameTextField: UITextField!
    var birthdayLabel: UILabel!
    var birthdayPicker: UIDatePicker!
    var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "プロフィール編集"

        setupSubviews()
        loadUserProfile()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }

    func setupSubviews() {
        userNameTextField = UITextField().then {
            $0.placeholder = "ユーザー名"
            $0.borderStyle = .roundedRect
            view.addSubview($0)
        }

        birthdayLabel = UILabel().then {
            $0.text = "生年月日"
            $0.font = .systemFont(ofSize: 16)
            view.addSubview($0)
        }

        birthdayPicker = UIDatePicker().then {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            view.addSubview($0)
        }

        saveButton = UIButton(type: .system).then {
            $0.rx.tap.subscribe(onNext: { [weak self] in
                    self?.saveProfile()
            })
            .disposed(by: disposeBag)
            $0.setTitle("保存", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
            $0.backgroundColor = .systemBlue
            $0.layer.cornerRadius = 8
            view.addSubview($0)
        }
    }

    func updateLayout() {
        let width = view.bounds.width
        let padding: CGFloat = 24

        userNameTextField.do {
            $0.frame = CGRect(x: padding, y: 100, width: width - padding * 2, height: 40)
        }

        birthdayLabel.do {
            $0.frame = CGRect(x: padding, y: userNameTextField.frame.maxY + 24, width: 200, height: 30)
        }

        birthdayPicker.do {
            $0.frame = CGRect(x: padding, y: birthdayLabel.frame.maxY + 24, width: width - padding * 2, height: 100)
        }

        saveButton.do {
            $0.frame = CGRect(x: (width - 120) / 2, y: birthdayPicker.frame.maxY + 40, width: 120, height: 44)
        }
    }

    private func loadUserProfile() {
        let profile = UserProfile.shared
        userNameTextField.text = profile.userName

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: profile.birthday) {
            birthdayPicker.date = date
        }
    }

    private func saveProfile() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let birthdayString = formatter.string(from: birthdayPicker.date)

        let profile = UserProfile.shared

        profile.save(with: [
            "userName": userNameTextField.text,
            "birthday": birthdayString
        ])

        let alert = UIAlertController(title: "保存完了", message: "プロフィールを保存しました", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
