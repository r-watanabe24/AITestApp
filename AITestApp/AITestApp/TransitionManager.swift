//
//  TransitionManager.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//


import UIKit

class TransitionManager {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func showProfile() {
        let vc = ProfileViewController(isPresent: true)
        present(vc)
    }

    func showSettings() {
        let vc = SettingsViewController(isPresent: true)
        present(vc)
    }

    func showHelp() {
        let vc = HelpViewController(isPresent: true)
        present(vc)
    }

    private func present(_ vc: BaseViewController) {
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
}
