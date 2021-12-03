//
//  TextFieldAlertController.swift
//  CustomUIComponentsTest
//
//  Created on 2021/12/03.
//

import Combine
import SnapKit
import UIKit

@objc protocol TextFieldAlertControllerDelegate: NSObjectProtocol {
    @objc
    optional func textFieldAlertControllerDidConfirm(withText text: String, reservedText: String?)
    @objc
    optional func textFieldAlertControllerDidCancel()
}

final class TextFieldAlertController: UIViewController {
    
    // MARK: - Properties
    
    private let dimView: UIView = {
        let view: UIView = .init(frame: .zero)
        view.alpha = 0
        view.backgroundColor = .init(rgb: 0x000000, alpha: 0.5)
        return view
    }()
    
    private let contentView: UIView = .init(frame: .zero)
    
    private let visualEffectView: UIVisualEffectView = {
        let visualEffectView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .extraLight))
        visualEffectView.backgroundColor = .systemGray5
        visualEffectView.layer.cornerRadius = 12
        visualEffectView.clipsToBounds = true
        return visualEffectView
    }()
    
    private let alertContainer: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField: UITextField = .init(frame: .zero)
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = .none
        textField.backgroundColor = .systemBackground
        textField.placeholder = "플레이스홀더"
        textField.font = .systemFont(ofSize: 13)
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.textColor = .black    // 레이어부터 여기까지는 텍스트필드 커스터마이징시 그쪽으로 이동
        textField.addTarget(self, action: #selector(textFieldEditingDidEndOnExit(_:)), for: .editingDidEndOnExit)
        textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private let textLengthLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray2
        label.textAlignment = .right
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView: UIStackView = .init(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        button.setTitle("확인", for: .normal)
        button.setTitle("확인", for: .disabled)
        button.setTitleColor(.systemGray2, for: .disabled)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    private let horizontalSeperator: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let verticalSeperator: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = .systemGray4
        return view
    }()
    
    override var editingInteractionConfiguration: UIEditingInteractionConfiguration {
        return .none
    }
    
    var alertTitle: String = "" {
        didSet {
            titleLabel.text = alertTitle
        }
    }
    
    var reservedText: String? {
        didSet {
            textField.text = reservedText
        }
    }
    
    var maxTextLength: Int = 30 {
        didSet {
            updateTextLengthLabel()
        }
    }
    
    private var bottomSpacing: NSLayoutConstraint?
    private var cancellables: Set<AnyCancellable> = .init()
    weak var delegate: TextFieldAlertControllerDelegate?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateShow()
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - UI
    
    private func initView() {
        view.addSubview(dimView)
        view.addSubview(contentView)
        
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        bottomSpacing = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomSpacing?.isActive = true
        
        contentView.addSubview(visualEffectView)
        
        visualEffectView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(162)
        }
        
        visualEffectView.contentView.addSubview(alertContainer)
        
        alertContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [titleLabel, textField, textLengthLabel, buttonStackView, horizontalSeperator, verticalSeperator].forEach {
            alertContainer.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(18)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(25)
        }
        
        textLengthLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.right.equalTo(textField)
            make.height.equalTo(16)
            make.width.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
        
        horizontalSeperator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(buttonStackView)
            make.height.equalTo(1)
        }
        
        verticalSeperator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(buttonStackView)
        }
    }
    
    // MARK: - Helpers
    
    private func addObservers() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .sink { [weak self] noti in
                self?.keyBoardWillShow(notification: noti)
            }.store(in: &cancellables)
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .sink { [weak self] noti in
                self?.keyBoardWillHide(notification: noti)
            }.store(in: &cancellables)
    }
    
    private func updateTextLengthLabel() {
        textLengthLabel.text = "\(textField.text?.count ?? 0)/\(maxTextLength)"
    }
    
    private func animateShow() {
        UIView.animate(withDuration: 0.3, delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.dimView.alpha = 1
        }, completion: nil)
        alertContainer.zoomInAndPop(duration: 0.3, from: 1.1, completion: { })
    }
    
    @objc
    private func keyBoardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let keyboardHeight = keyboardFrame.height

        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? .zero
        let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? .zero

        let curve = UIView.AnimationCurve(rawValue: curveRaw) ?? UIView.AnimationCurve.easeInOut
        bottomSpacing?.constant = -keyboardHeight
        UIViewPropertyAnimator(duration: duration, curve: curve) {
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    // MARK: - Actions
    
    @objc
    private func keyBoardWillHide(notification: Notification) {
        bottomSpacing?.constant = 0
    }
    
    
    @objc
    private func textFieldEditingDidEndOnExit(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else { return }
        didTapConfirmButton()
    }
    
    @objc
    private func didTapCancelButton() {
        delegate?.textFieldAlertControllerDidCancel?()
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func didTapConfirmButton() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        delegate?.textFieldAlertControllerDidConfirm?(withText: text, reservedText: reservedText)
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func textFieldDidChanged(_ sender: UITextField) {
        guard let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if text.count > maxTextLength {
            let endIndex = text.index(text.startIndex, offsetBy: maxTextLength)
            textField.text = String(text[..<endIndex])
        }
        
        if let reservedText = reservedText {
            confirmButton.isEnabled = text.isEmpty == false && text != reservedText
        } else {
            confirmButton.isEnabled = text.isEmpty == false
        }
        
        if let textFieldText = sender.text, text.isEmpty && !textFieldText.isEmpty {
            sender.text = text
        }
        
        updateTextLengthLabel()
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldAlertController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        return text.isEmpty == false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let length = text.count + string.count - range.length
        return length <= maxTextLength
    }
}
