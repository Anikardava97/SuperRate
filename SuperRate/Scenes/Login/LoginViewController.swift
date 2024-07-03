//
//  LoginViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import UIKit
import DesignSystem
import SnapKit

protocol LoginViewControllerDelegate: AnyObject {
  func loginViewControllerDidTapLogin(_ controller: LoginViewController)
}

final class LoginViewController: UIViewController {
  // MARK: - Properties
  private let viewModel = LoginViewModel()
  weak var delegate: LoginViewControllerDelegate?

  private lazy var emailTextField: UITextField = {
    let textField = UITextField()
    textField.keyboardType = .default
    textField.layer.borderWidth = 1.0
    textField.layer.cornerRadius = 8
    textField.textColor = .white

    textField.attributedPlaceholder = NSAttributedString(
      string: "ელფოსტა",
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8),
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
      ]
    )

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    return textField
  }()

  private let emailErrorLabel: UILabel = {
    let label = UILabel()
    label.textColor = .red
    label.font = UIFont.regularTitle4
    return label
  }()

  private lazy var passwordTextField: UITextField = {
    let textField = UITextField()
    textField.isSecureTextEntry = true
    textField.keyboardType = .default
    textField.layer.borderWidth = 1.0
    textField.layer.cornerRadius = 8
    textField.textColor = .white

    textField.attributedPlaceholder = NSAttributedString(
      string: "პაროლი",
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8),
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
      ]
    )

    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    return textField
  }()

  private let passwordErrorLabel: UILabel = {
    let label = UILabel()
    label.textColor = .red
    label.font = UIFont.regularTitle4
    return label
  }()

  private lazy var loginButton: MainButtonComponent = {
    let button = MainButtonComponent(text: "ავტორიზაცია")
    button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    return button
  }()

  // MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidLayoutSubviews() {
    updateUI(for: emailTextField, fieldType: .email)
    updateUI(for: passwordTextField, fieldType: .password)
  }

  // MARK: - Methods
  private func setup() {
    setupSubviews()
    setupConstraints()
    setupTextFieldDelegates()
    setupTapGesture()
  }

  private func setupSubviews() {
    view.addSubview(emailTextField)
    view.addSubview(emailErrorLabel)

    view.addSubview(passwordTextField)
    view.addSubview(passwordErrorLabel)

    view.addSubview(loginButton)
  }

  private func setupConstraints() {
    emailTextField.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    emailErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom).offset(6)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }

    passwordTextField.snp.remakeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom).offset(32)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    passwordErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom).offset(6)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }

    loginButton.snp.remakeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(48)
    }
  }

  private func setupTextFieldDelegates() {
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }

  private func setupTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }

  private func updateUI(for textField: UITextField, fieldType: LoginViewModel.FormFieldType, errorLabel: UILabel? = nil) {
    guard let validationState = viewModel.formState[fieldType] else {
      return
    }
    let borderColor: CGColor
    if validationState.state == .error {
      borderColor = UIColor.red.cgColor
      errorLabel?.text = validationState.errorMessage
    } else {
      borderColor = UIColor.white.resolvedColor(with: traitCollection).cgColor
      errorLabel?.text = ""
    }
    textField.layer.borderColor = borderColor
  }

  private func updateFormState() {
    viewModel.textFieldDidUpdate(type: .email, text: emailTextField.text ?? "")
    viewModel.textFieldDidUpdate(type: .password, text: passwordTextField.text ?? "")
  }

  private func updateUIForAllFields() {
    updateUI(for: emailTextField, fieldType: .email, errorLabel: emailErrorLabel)
    updateUI(for: passwordTextField, fieldType: .password, errorLabel: passwordErrorLabel)
  }

  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }

  // MARK: - Actions
  @objc private func loginButtonDidTap() {
    guard let email = emailTextField.text,
          let password = passwordTextField.text else {
      return
    }
    updateFormState()
    updateUIForAllFields()
    if viewModel.loginUser(email: email, password: password) {
      delegate?.loginViewControllerDidTapLogin(self)
    } else {
      showAlert(title: "ვერ გაიარეთ ავტორიზაცია", message: "ელფოსტა ან პაროლი არასწორია. \n კიდევ სცადეთ.")
    }
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}

// MARK: - Extension: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateFormState()
    updateUIForAllFields()
  }
}