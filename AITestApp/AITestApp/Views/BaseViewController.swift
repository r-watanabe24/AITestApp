//
//  BaseViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit
import Then

class BaseViewController: UIViewController {

    var isPresent: Bool? = false
    var centerX: CGFloat { view.bounds.midX }
    var centerY: CGFloat { view.bounds.midY }
    var isDarkMode: Bool { UserProfile.shared.isDarkMode }

    private var closeButton: UIButton?

    init(isPresent: Bool = false) {
        self.isPresent = isPresent
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Base"
        view.backgroundColor = .systemGroupedBackground

        setupBaseSubviews()
        updateBaseLayout()
    }

    func setupBaseSubviews() {
        if isPresent == true {
            closeButton = UIButton(type: .system).then {
                $0.setTitle("✕", for: .normal)
                $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                $0.setTitleColor(.black, for: .normal)
                $0.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
                view.addSubview($0)
            }
        }
    }

    func updateBaseLayout() {
        if let closeButton = closeButton {
            closeButton.do {
                $0.setTitleColor(isDarkMode ? .white : .black, for: .normal)
                let topInset = view.safeAreaInsets.top
                $0.frame = CGRect(x: view.bounds.width - 44, y: topInset + 10, width: 30, height: 30)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBaseLayout()
    }

    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}
