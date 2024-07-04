//
//  TextFieldComponent.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import UIKit
import DesignSystem

final class TextFieldComponent: UITextField {
  // MARK: - Init
  init(placeholder: String, keyboard: UIKeyboardType = .default, isSecure: Bool = false) {
    super.init(frame: .zero)

    backgroundColor = .customSecondaryColor
    layer.borderWidth = 0.8
    layer.cornerRadius = 8
    textColor = .white
    keyboardType = keyboard
    isSecureTextEntry = isSecure

    attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6),
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
      ]
    )

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.height))
    leftView = paddingView
    leftViewMode = .always
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
