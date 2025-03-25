//
//  MyPageViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import UIKit
import Then

class MyPageViewController: BaseViewController {

    var tableView: UITableView!
    let items = ["プロフィール", "設定", "ヘルプ"]

    lazy var transitionManager = TransitionManager(viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MyPage"

        setupSubviews()
        updateLayout()
    }

    func setupSubviews() {
        tableView = UITableView().then {
            $0.backgroundColor = .systemGroupedBackground
            $0.delegate = self
            $0.dataSource = self
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            view.addSubview($0)
        }
    }

    func updateLayout() {
        tableView.frame = view.bounds
    }
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorInset = .zero
        return UITableViewCell(style: .default, reuseIdentifier: "cell").then {
            $0.textLabel?.text = items[indexPath.row]
            $0.accessoryType = .disclosureIndicator
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0: transitionManager.showProfile()
        case 1: transitionManager.showSettings()
        case 2: transitionManager.showHelp()
        default: break
        }
    }
}
