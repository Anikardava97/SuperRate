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

  private lazy var companyNameTextField = TextFieldComponent(placeholder: "კომპანიის სახელი")

  private lazy var companyNameErrorLabel = createErrorLabel()

  private lazy var passwordTextField = TextFieldComponent(placeholder: "პაროლი", isSecure: true)

  private lazy var passwordErrorLabel = createErrorLabel()

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
    updateUI(for: companyNameTextField, fieldType: .name)
    updateUI(for: passwordTextField, fieldType: .password)
  }

  // MARK: - Methods
  private func setup() {
    setupSubviews()
    setupConstraints()
    setupTapGesture()
  }

  private func setupSubviews() {
    view.addSubview(companyNameTextField)
    view.addSubview(companyNameErrorLabel)

    view.addSubview(passwordTextField)
    view.addSubview(passwordErrorLabel)

    view.addSubview(loginButton)
  }

  private func setupConstraints() {
    companyNameTextField.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    companyNameErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(companyNameTextField.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }

    passwordTextField.snp.remakeConstraints { make in
      make.top.equalTo(companyNameTextField.snp.bottom).offset(CGFloat.spacing5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    passwordErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }

    loginButton.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(48)
    }
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
      borderColor = UIColor.white.withAlphaComponent(0.1).resolvedColor(with: traitCollection).cgColor
      errorLabel?.text = ""
    }
    textField.layer.borderColor = borderColor
  }

  private func updateFormState() {
    viewModel.textFieldDidUpdate(type: .name, text: companyNameTextField.text ?? "")
    viewModel.textFieldDidUpdate(type: .password, text: passwordTextField.text ?? "")
  }

  private func updateUIForAllFields() {
    updateUI(for: companyNameTextField, fieldType: .name, errorLabel: companyNameErrorLabel)
    updateUI(for: passwordTextField, fieldType: .password, errorLabel: passwordErrorLabel)
  }

  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }

  private func createErrorLabel() -> UILabel {
    let label = UILabel()
    label.textColor = .red
    label.font = UIFont.regularTitle4
    return label
  }

  // MARK: - Actions
  @objc private func loginButtonDidTap() {
    guard
      let companyName = companyNameTextField.text,
      let password = passwordTextField.text else {
      return
    }
    updateFormState()
    updateUIForAllFields()
    if viewModel.loginCompany(name: companyName, password: password) {
      delegate?.loginViewControllerDidTapLogin(self)
    } else {
      if !companyName.isEmpty && !password.isEmpty {
        showAlert(title: "ვერ გაიარეთ ავტორიზაცია", message: "სახელი ან პაროლი არასწორია. \n კიდევ სცადეთ.")
      }
    }
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}
