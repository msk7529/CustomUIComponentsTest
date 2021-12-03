//
//  ViewController.swift
//  CustomUIComponentsTest
//
//  Created on 2021/12/03.
//

import SnapKit
import UIKit

final class ViewController: UIViewController {
    
    private lazy var button1: CommonButton = {
        let button: CommonButton = .init(frame: .zero)
        button.title = "AlertController with textField"
        button.addTarget(self, action: #selector(didTapButton1), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

    private func initView() {
        view.addSubview(button1)
        
        button1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
        }
    }
}

extension ViewController {
    @objc private func didTapButton1() {
        let vc: TextFieldAlertController = .init()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.alertTitle = "테스트"
        vc.maxTextLength = 15
        self.present(vc, animated: false, completion: nil)
    }
}

extension ViewController: TextFieldAlertControllerDelegate {
    
}
