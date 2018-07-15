//
//  Button.swift
//  RxWrappersExample
//
//  Created by Sourav Chandra on 12/07/18.
//  Copyright © 2018 Sourav Chandra. All rights reserved.
//

import Foundation
import UIKit

protocol ClickableViewDelegate: class {
    func onTap()
}

final class ClickableView: UIView {
    
    let label = UILabel()
    weak var delegate: ClickableViewDelegate?
    
    // MARK: Init methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        label.textColor = .darkGray
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Instance methods
    
    @objc private func handleTap() {
        delegate?.onTap()
    }
    
}
