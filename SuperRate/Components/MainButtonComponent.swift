//
//  MainButtonComponent.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import UIKit
import DesignSystem

final class MainButtonComponent: UIButton {
    // MARK: - Init
    init(text: String) {
        super.init(frame: .zero)

        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.boldTitle3
        setTitleColor(.white, for: .normal)
        self.backgroundColor = .customAccentColor
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
