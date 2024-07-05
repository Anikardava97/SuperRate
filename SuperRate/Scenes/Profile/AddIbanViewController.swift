//
//  AddIbanViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import UIKit

protocol AddIbanViewControllerDelegate: AnyObject {
  func didAddNewIban()
}

final class AddIbanViewController: UIViewController {
  // MARK: - Methods
  var ibanManager: IbanManager!
  var ibanAddedSuccessfully: (() -> Void)?
  weak var delegate: AddIbanViewControllerDelegate?

  private let mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 24
    stackView.backgroundColor = .customSecondaryColor
    stackView.layer.cornerRadius = 12
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: 24, left: 24, bottom: 24, right: 24)
    return stackView
  }()

  private let headerLabel: UILabel = {
    let label = UILabel()
    label.text = "ანგარიშის დამატება"
    label.textColor = .white
    label.textAlignment = .left
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    return label
  }()

  private let ibanTextField: UITextField = {
    let textField = CardTextField()
    textField.configure(placeholder: "GE29TB7194336912345678", keyboardType: .default, icon: UIImage(systemName: "creditcard"))
    return textField
  }()

  private lazy var addIbanButton: UIButton = {
    let button = MainButtonComponent(text: "ანგარიშის დამატება")
    button.isEnabled = false
    return button
  }()

  // MARK: - ViewLifecycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  // MARK: - Methods
  private func setup() {
    setupTextFieldDelegates()
    setupBackground()
    setupSubviews()
    setupConstraints()
    setupTapGestureRecogniser()
    setupAddCardButtonAction()
    updateAddIbanButtonState()
  }

  private func setupTextFieldDelegates() {
    ibanTextField.delegate = self
    ibanTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }

  private func ibanFieldsAreValid() -> Bool {
    guard let ibanText = ibanTextField.text else { return false }
    return isValidIBAN(ibanText)
  }

  private func isValidIBAN(_ iban: String) -> Bool {
    let cleanedIBAN = iban.replacingOccurrences(of: " ", with: "").uppercased()
    let ibanRegex = "^GE\\d{2}[A-Z]{2}[0-9A-Z]{16}$"
    let ibanPredicate = NSPredicate(format: "SELF MATCHES %@", ibanRegex)

    return ibanPredicate.evaluate(with: cleanedIBAN)
  }

  private func setupBackground() {
    view.backgroundColor = .customBackgroundColor
  }

  private func setupSubviews() {
    view.addSubview(mainStackView)
    mainStackView.addArrangedSubview(headerLabel)
    mainStackView.addArrangedSubview(ibanTextField)
    mainStackView.addArrangedSubview(addIbanButton)
  }

  private func setupConstraints() {
    mainStackView.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.spacing7)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    ibanTextField.snp.remakeConstraints { make in
      make.height.equalTo(CGFloat.spacing3)
    }

    addIbanButton.snp.remakeConstraints { make in
      make.height.equalTo(CGFloat.spacing3)
    }
  }

  private func setupTapGestureRecogniser() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    view.addGestureRecognizer(tapGesture)
  }

  private func setupAddCardButtonAction() {
    addIbanButton.addTarget(self, action: #selector(addIbanButtonDidTap), for: .touchUpInside)
  }

  private func updateAddIbanButtonState() {
    let isValid = ibanFieldsAreValid()
    addIbanButton.isEnabled = isValid
    addIbanButton.backgroundColor = isValid ? .customAccentColor : .customAccentColor.withAlphaComponent(0.6)
    addIbanButton.setTitleColor(isValid ? .white : .white.withAlphaComponent(0.5), for: .normal)
  }

  // MARK: - Actions
  @objc private func handleTap() {
    view.endEditing(true)
  }

  @objc private func textFieldDidChange(_ textField: UITextField) {
    if textField == ibanTextField {
      if var text = textField.text {
        text = text.replacingOccurrences(of: "[^A-Za-z0-9]", with: "", options: .regularExpression)
        text = text.uppercased()

        if text.count > 22 {
          text = String(text.prefix(22))
        }

        textField.text = text
        textField.textColor = .white
      }
    }
    updateAddIbanButtonState()
  }

  @objc func addIbanButtonDidTap() {
    guard ibanFieldsAreValid() else { return }
    let newIban = IbanNumber(ibanNumber: ibanTextField.text ?? "")

    ibanManager.addIban(newIban)
    delegate?.didAddNewIban()
    DispatchQueue.main.async { [weak self] in
      self?.navigationController?.popViewController(animated: true)
      guard let self, let window = self.view.window else { return }
      SnackBar.show(in: window, message: "ანგარიში წარმატებით დაემატა")
    }
  }
}

// MARK: - Extension: TextField Validations
extension AddIbanViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == ibanTextField {
      let allowedCharacters = CharacterSet.alphanumerics
      let characterSet = CharacterSet(charactersIn: string)
      return allowedCharacters.isSuperset(of: characterSet)
    }
    return true
  }
}

// MARK: - Extension: String
extension String {
  func inserting(separator: String, every n: Int) -> String {
    var result: String = ""
    let characters = Array(self)
    stride(from: 0, to: characters.count, by: n).forEach {
      result += String(characters[$0..<min($0+n, characters.count)])
      if $0+n < characters.count {
        result += separator
      }
    }
    return result
  }
}
