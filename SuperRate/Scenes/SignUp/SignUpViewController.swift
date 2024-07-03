//
//  SignUpViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
  func signUpViewControllerDidTapLogin(_ controller: SignUpViewController)
}

final class SignUpViewController: UIViewController {
  // MARK: - Properties
  private let viewModel = SignUpViewModel()
  weak var delegate: SignUpViewControllerDelegate?

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

  private lazy var signUpButton: MainButtonComponent = {
    let button = MainButtonComponent(text: "რეგისტრაცია")
    button.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
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
    setupBackground()
    setupSubviews()
    setupConstraints()
    setupTextFieldDelegates()
    setupTapGesture()
  }

  private func setupBackground() {
    view.backgroundColor = .customBackgroundColor
  }

  private func setupSubviews() {
    view.addSubview(emailTextField)
    view.addSubview(emailErrorLabel)

    view.addSubview(passwordTextField)
    view.addSubview(passwordErrorLabel)

    view.addSubview(signUpButton)
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

    //        ageTextField.snp.remakeConstraints { make in
    //            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
    //            make.leading.equalToSuperview()
    //            make.trailing.equalToSuperview()
    //            make.height.equalTo(48)
    //        }
    //
    //        ageErrorLabel.snp.remakeConstraints { make in
    //            make.top.equalTo(ageTextField.snp.bottom).offset(6)
    //            make.leading.equalToSuperview()
    //            make.trailing.equalToSuperview()
    //        }

    signUpButton.snp.remakeConstraints { make in
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

  private func updateUI(for textField: UITextField, fieldType: SignUpViewModel.FormFieldType, errorLabel: UILabel? = nil) {
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

  // MARK: - Actions
  @objc private func signUpButtonDidTap() {
    if viewModel.canRegisterUser() {
      viewModel.registerUser()
      delegate?.signUpViewControllerDidTapLogin(self)
    } else {
      updateFormState()
      updateUIForAllFields()
    }
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}

// MARK: - Extension: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateFormState()
    updateUIForAllFields()
  }
}
