//
//  SignUpViewModel.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import Foundation

final class SignUpViewModel {
  enum FormFieldType: CaseIterable {
    case name, code, number, email, password, confirmPassword
  }
  // MARK: - Properties
  private let authenticationManager = UserAuthenticationManager.shared
  
  private var fieldValues: [FormFieldType: String] = [:]

  lazy var formState: [FormFieldType: TextFieldValidationState] = {
    Dictionary(uniqueKeysWithValues: FormFieldType.allCases.map { ($0, .init()) })
  }()

  // MARK: - Methods
  func textFieldDidUpdate(type: FormFieldType, text: String) {
    fieldValues[type] = text
    let newState: TextFieldValidationState
    switch type {
    case .name:
      newState = validateName(text: text)
    case .code:
      newState = validateCode(text: text)
    case .number:
      newState = validateNumber(text: text)
    case .email:
      newState = validateEmail(text: text)
    case .password:
      newState = validatePassword(text: text)
    case .confirmPassword:
      newState = validatePasswordsMatch(text: text)
    }
    formState[type] = newState

    if type == .password {
      formState[.confirmPassword] = validatePasswordsMatch(text: fieldValues[.confirmPassword] ?? "")
    }
  }

  private func validateName(text: String) -> TextFieldValidationState {
    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else if !isValidName(text) {
      return TextFieldValidationState(state: .error, error: .nameRequirements)
    } else {
      return TextFieldValidationState(state: .valid)
    }
  }

  private func validateCode(text: String) -> TextFieldValidationState {
    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else {
      return TextFieldValidationState(state: .valid)
    }
  }

  private func validateNumber(text: String) -> TextFieldValidationState {
    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else if !isValidNumber(text) {
      return TextFieldValidationState(state: .error, error: .invalidNumber)
    } else {
      return TextFieldValidationState(state: .valid)
    }
  }

  private func validateEmail(text: String) -> TextFieldValidationState {
    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else if isEmailAlreadyRegistered(text) {
      return TextFieldValidationState(state: .error, error: .alreadyRegistered)
    } else if !isValidEmail(text) {
      return TextFieldValidationState(state: .error, error: .invalidEmail)
    } else {
      return TextFieldValidationState(state: .valid)
    }
  }

  private func validatePassword(text: String) -> TextFieldValidationState {
    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else if !isValidPassword(text) {
      return TextFieldValidationState(state: .error, error: .passwordRequirements)
    } else {
      return TextFieldValidationState(state: .valid)
    }
  }

  private func validatePasswordsMatch(text: String) -> TextFieldValidationState {
    guard let password = fieldValues[.password] else {
      return TextFieldValidationState(state: .error, error: .empty)
    }

    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else if text != password {
      return TextFieldValidationState(state: .error, error: .passwordMismatch)
    } else {
      return TextFieldValidationState(state: .valid)
    }
  }

  private func isValidName(_ name: String) -> Bool {
    authenticationManager.validateName(name)
  }

  private func isValidNumber(_ number: String) -> Bool {
    authenticationManager.validateNumber(number)
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    authenticationManager.validateEmail(email) && !authenticationManager.isEmailAlreadyRegistered(email: email)
  }

  private func isValidPassword(_ password: String) -> Bool {
    authenticationManager.validatePassword(password)
  }

  private func isEmailAlreadyRegistered(_ email: String) -> Bool {
    authenticationManager.isEmailAlreadyRegistered(email: email)
  }

  func canRegisterUser() -> Bool {
    formState.values.allSatisfy { $0.state == .valid }
  }

  func registerUser() {
    guard
      let name = fieldValues[.name],
      let code = fieldValues[.code],
      let number = fieldValues[.number],
      let email = fieldValues[.email],
      let password = fieldValues[.password],
      canRegisterUser() else {
      return
    }
    authenticationManager.registerUser(name: name, code: code, number: number, email: email, password: password)
  }
}
