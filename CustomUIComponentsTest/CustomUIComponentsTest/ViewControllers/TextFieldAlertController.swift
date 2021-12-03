//
//  TextFieldAlertController.swift
//  CustomUIComponentsTest
//
//  Created on 2021/12/03.
//

import SnapKit
import UIKit

final class TextFieldAlertController: UIViewController {
    
    private let dimView: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = .init(rgb: 0x000000, alpha: 0.5)
        return view
    }()
    
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
        textField.textColor = .black    // 레이어부터 여기까지는 텍스트필드 커스터마이징시 그쪽으로 이동
        textField.delegate = self
        return textField
    }()
    
    private let lengthLabel: UILabel = {
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
    
    private let cancelButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("취소", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initView() {
        view.addSubview(dimView)
        view.addSubview(visualEffectView)
        
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        visualEffectView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(162)
        }
        
        visualEffectView.contentView.addSubview(alertContainer)
        
        alertContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [titleLabel, textField, lengthLabel, buttonStackView, horizontalSeperator, verticalSeperator].forEach {
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
        
        lengthLabel.snp.makeConstraints { make in
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
}

extension TextFieldAlertController: UITextFieldDelegate {
    
}
