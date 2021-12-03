//
//  CommonButton.swift
//  CustomUIComponentsTest
//
//  Created by kakao on 2021/12/03.
//

import UIKit

final class CommonButton: UIButton {
    
    static let height: CGFloat = 20
    
    var title: String = "" {
        didSet {
            setTitle(title + "    ", for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemTeal
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = Self.height / 2
    }
}
