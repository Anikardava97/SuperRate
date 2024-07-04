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

  private var isChecked: Bool = false {
    didSet {
      checkboxButton.setImage(isChecked ? UIImage(named: "checkbox.fill") : UIImage(named: "checkbox"), for: .normal)
    }
  }

  private lazy var companyNameTextField = TextFieldComponent(placeholder: "კომპანიის სახელი")

  private lazy var companyNameErrorLabel = createErrorLabel()

  private lazy var companyIdentificationCode = TextFieldComponent(placeholder: "საიდენტიფიკაციო კოდი", keyboard: .numberPad)

  private lazy var companyCodeErrorLabel = createErrorLabel()

  private lazy var companyPhoneNumber = TextFieldComponent(placeholder: "მობილურის ნომერი", keyboard: .numberPad)

  private lazy var companyPhoneNumberErrorLabel = createErrorLabel()

  private lazy var emailTextField = TextFieldComponent(placeholder: "ელფოსტა")

  private lazy var emailErrorLabel = createErrorLabel()

  private lazy var passwordTextField = TextFieldComponent(placeholder: "პაროლი", isSecure: true)

  private lazy var passwordErrorLabel = createErrorLabel()

  private lazy var passwordConfirmationTextField = TextFieldComponent(placeholder: "პაროლის გამეორება", isSecure: true)

  private lazy var passwordConfirmationErrorLabel = createErrorLabel()

  private lazy var checkboxButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "checkbox"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(checkboxButtonDidTap), for: .touchUpInside)
    return button
  }()

  private lazy var checkboxText: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.numberOfLines = 2
    label.textAlignment = .left
    label.textColor = .white
    label.text = "ვეთანხმები აპლიკაციის გამოყენების პირობებსა და კონფიდენციალურობის პოლიტიკას"
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
    updateUI(for: companyNameTextField, fieldType: .name)
    updateUI(for: companyIdentificationCode, fieldType: .code)
    updateUI(for: companyPhoneNumber, fieldType: .number)
    updateUI(for: emailTextField, fieldType: .email)
    updateUI(for: passwordTextField, fieldType: .password)
    updateUI(for: passwordConfirmationTextField, fieldType: .confirmPassword)
  }

  // MARK: - Methods
  private func setup() {
    setupBackground()
    setupSubviews()
    setupConstraints()
    setupTapGesture()
  }

  private func setupBackground() {
    view.backgroundColor = .customBackgroundColor
  }

  private func setupSubviews() {
    view.addSubview(companyNameTextField)
    view.addSubview(companyNameErrorLabel)

    view.addSubview(companyIdentificationCode)
    view.addSubview(companyCodeErrorLabel)

    view.addSubview(companyPhoneNumber)
    view.addSubview(companyPhoneNumberErrorLabel)

    view.addSubview(emailTextField)
    view.addSubview(emailErrorLabel)

    view.addSubview(passwordTextField)
    view.addSubview(passwordErrorLabel)

    view.addSubview(passwordConfirmationTextField)
    view.addSubview(passwordConfirmationErrorLabel)

    view.addSubview(checkboxButton)
    view.addSubview(checkboxText)

    view.addSubview(signUpButton)
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

    companyIdentificationCode.snp.remakeConstraints { make in
      make.top.equalTo(companyNameTextField.snp.bottom).offset(CGFloat.spacing5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    companyCodeErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(companyIdentificationCode.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }

    companyPhoneNumber.snp.remakeConstraints { make in
      make.top.equalTo(companyIdentificationCode.snp.bottom).offset(CGFloat.spacing5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    companyPhoneNumberErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(companyPhoneNumber.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }

    emailTextField.snp.remakeConstraints { make in
      make.top.equalTo(companyPhoneNumber.snp.bottom).offset(CGFloat.spacing5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    emailErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }

    passwordTextField.snp.remakeConstraints { make in
      make.top.equalTo(emailTextField.snp.bottom).offset(CGFloat.spacing5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    passwordErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }

    passwordConfirmationTextField.snp.remakeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom).offset(CGFloat.spacing5)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }

    passwordConfirmationErrorLabel.snp.remakeConstraints { make in
      make.top.equalTo(passwordConfirmationTextField.snp.bottom).offset(6)
      make.leading.trailing.equalToSuperview()
    }

    checkboxButton.snp.remakeConstraints { make in
      make.top.equalTo(passwordConfirmationTextField.snp.bottom).offset(CGFloat.spacing5)
      make.leading.equalToSuperview()
      make.size.equalTo(24)
    }

    checkboxText.snp.remakeConstraints { make in
      make.centerY.equalTo(checkboxButton.snp.centerY)
      make.leading.equalTo(checkboxButton.snp.trailing).offset(CGFloat.spacing8)
      make.trailing.equalToSuperview()
    }

    signUpButton.snp.remakeConstraints { make in
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

  private func updateUI(for textField: UITextField, fieldType: SignUpViewModel.FormFieldType, errorLabel: UILabel? = nil) {
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
    viewModel.textFieldDidUpdate(type: .code, text: companyIdentificationCode.text ?? "")
    viewModel.textFieldDidUpdate(type: .number, text: companyPhoneNumber.text ?? "")
    viewModel.textFieldDidUpdate(type: .email, text: emailTextField.text ?? "")
    viewModel.textFieldDidUpdate(type: .password, text: passwordTextField.text ?? "")
    viewModel.textFieldDidUpdate(type: .confirmPassword, text: passwordConfirmationTextField.text ?? "")
  }

  private func updateUIForAllFields() {
    updateUI(for: companyNameTextField, fieldType: .name, errorLabel: companyNameErrorLabel)
    updateUI(for: companyIdentificationCode, fieldType: .code, errorLabel: companyCodeErrorLabel)
    updateUI(for: companyPhoneNumber, fieldType: .number, errorLabel: companyPhoneNumberErrorLabel)
    updateUI(for: emailTextField, fieldType: .email, errorLabel: emailErrorLabel)
    updateUI(for: passwordTextField, fieldType: .password, errorLabel: passwordErrorLabel)
    updateUI(for: passwordConfirmationTextField, fieldType: .confirmPassword, errorLabel: passwordConfirmationErrorLabel)
  }

  private func createErrorLabel() -> UILabel {
    let label = UILabel()
    label.textColor = .red
    label.font = UIFont.regularTitle4
    return label
  }

  private func showVerificationAlert() {
    let alertController = UIAlertController(title: "ვერიფიკაცია", message: "მითითებულ ელფოსტაზე გამოგეგზავნათ ვერიფიკაციის ბმული", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
      self?.delegate?.signUpViewControllerDidTapLogin(self!)
    }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }

  // MARK: - Actions
  @objc private func checkboxButtonDidTap() {
    isChecked.toggle()
  }

  @objc private func signUpButtonDidTap() {
    if viewModel.canRegisterUser() && isChecked == true {
      viewModel.registerUser()
      showVerificationAlert()
    } else {
      updateFormState()
      updateUIForAllFields()
    }
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}
