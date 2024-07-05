//
//  CardTextField.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import UIKit

final class CardTextField: UITextField {
  // MARK: - Properties
  private let paddingWidth: CGFloat = 44

  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .center
    imageView.tintColor = .white
    return imageView
  }()

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupTextField()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupTextField()
  }

  // MARK: - Setup
  private func setupTextField() {
    textColor = .white
    font = UIFont.systemFont(ofSize: 16)
    backgroundColor = .clear
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 6

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: bounds.height))
    leftView = paddingView
    leftViewMode = .always

    addSubview(iconImageView)

    iconImageView.snp.remakeConstraints { make in
      make.leading.equalToSuperview().offset(12)
      make.centerY.equalToSuperview()
      make.size.equalTo(CGFloat.spacing6)
    }

    tintColor = .white
  }

  // MARK: - Configure
  func configure(placeholder: String?, keyboardType: UIKeyboardType, icon: UIImage?) {
    attributedPlaceholder = NSAttributedString(
      string: placeholder ?? "",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
    )
    self.keyboardType = keyboardType
    iconImageView.image = icon
  }
}
