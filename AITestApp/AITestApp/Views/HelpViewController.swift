//
//  HelpViewController.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//


import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Then
import SVProgressHUD

class HelpViewController: BaseViewController {

    private let disposeBag = DisposeBag()

    private var tableView: UITableView!
    private var inputTextField: UITextField!
    private var sendButton: UIButton!

    private var messages: [Message] = []
    private var lastUserMessage: String?
    private var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ヘルプ"
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        setupSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateViews()
    }

    private func setupSubviews() {
        tableView = UITableView().then {
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .none
            view.addSubview($0)
        }

        inputTextField = UITextField().then {
            $0.placeholder = "メッセージを入力"
            $0.borderStyle = .roundedRect
            $0.returnKeyType = .send
            $0.delegate = self
            view.addSubview($0)
        }

        sendButton = UIButton(type: .system).then {
            $0.setTitle("送信", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .systemBlue
            $0.layer.cornerRadius = 6
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.rx.tap.subscribe(onNext: { [weak self] in
                self?.didTapSend()
            })
            .disposed(by: disposeBag)
            view.addSubview($0)
        }
    }

    private func updateViews() {
        let padding: CGFloat = 16
        let inputHeight: CGFloat = 44
        let buttonWidth: CGFloat = 60

        inputTextField.do {
            $0.frame = CGRect(
                x: padding,
                y: view.bounds.height - inputHeight - padding - keyboardHeight,
                width: view.bounds.width - buttonWidth - padding * 3,
                height: inputHeight
            )
        }

        sendButton.do {
            $0.frame = CGRect(
                x: inputTextField.frame.maxX + padding,
                y: inputTextField.frame.minY,
                width: buttonWidth,
                height: inputHeight
            )
        }

        tableView.do {
            $0.frame = CGRect(
                x: 0,
                y: view.safeAreaInsets.top + 70,
                width: view.bounds.width,
                height: inputTextField.frame.minY - view.safeAreaInsets.top - (padding + 50)
            )
        }
    }

    private func didTapSend() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        inputTextField.resignFirstResponder()
        inputTextField.text = ""

        let userMsg = Message(text: text, sender: .user)
        messages.append(userMsg)
        tableView.reloadData()
        scrollToBottom()

        let modelType = UserDefaults.standard.bool(forKey: Constants.helpModelKey) ? 1 : 0
        let params: [String : Any] = [
            "message": text,
            "modelType": modelType
        ]
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.show()
        APIClient.shared.get(Constants.Urls.help, parameters: params)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] json in
                let reply = Message(json: json)
                self?.messages.append(reply)
                self?.tableView.reloadData()
                self?.scrollToBottom()
                SVProgressHUD.dismiss()
            }, onFailure: { error in
                print("エラー: \(error)")
                SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
    }

    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        let convertedFrame = view.convert(frame, from: nil)
        let isKeyboardVisible = convertedFrame.origin.y < view.bounds.height
        keyboardHeight = isKeyboardVisible ? convertedFrame.height : 0

        UIView.animate(withDuration: duration) {
            self.updateViews()
        }
        scrollToBottom()
    }
}

extension HelpViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let bubbleView = UIView().then {
            $0.backgroundColor = .clear
            $0.layer.borderColor = UIColor.gray.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        let label = UILabel().then {
            $0.text = msg.text
            $0.numberOfLines = 0
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .label
        }

        let padding: CGFloat = 12
        let maxTextWidth = tableView.bounds.width * 0.7
        let textSize = label.sizeThatFits(CGSize(width: maxTextWidth, height: .greatestFiniteMagnitude))
        let bubbleWidth = textSize.width + padding * 2
        let bubbleHeight = textSize.height + padding * 2

        label.frame = CGRect(x: padding, y: padding, width: textSize.width, height: textSize.height)
        bubbleView.frame = CGRect(
            x: msg.sender == .user ? tableView.bounds.width - bubbleWidth - 16 : 16,
            y: 8,
            width: bubbleWidth,
            height: bubbleHeight
        )

        bubbleView.addSubview(label)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(bubbleView)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = messages[indexPath.row]

        let maxWidth = tableView.bounds.width * 0.7
        let padding: CGFloat = 12

        let label = UILabel().then {
            $0.numberOfLines = 0
            $0.font = .systemFont(ofSize: 14)
            $0.text = msg.text
        }

        let size = label.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        return size.height + padding * 2 + 16
    }
}

extension HelpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapSend()
        return false
    }
}
