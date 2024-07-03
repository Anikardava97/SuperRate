//
//  LoginViewModel.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import Foundation

final class LoginViewModel {
  enum FormFieldType: CaseIterable {
    case email, password
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
    case .email:
      newState = validateEmail(text: text)
    case .password:
      newState = validatePassword(text: text)
    }
    formState[type] = newState
  }

  private func validateEmail(text: String) -> TextFieldValidationState {
    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else if !isValidEmail(text) {
      return TextFieldValidationState(state: .error, error: .invalid)
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

  private func isValidEmail(_ email: String) -> Bool {
    authenticationManager.validateEmail(email)
  }

  private func isValidPassword(_ password: String) -> Bool {
    authenticationManager.validatePassword(password)
  }

  func loginUser(email: String, password: String) -> Bool {
    let registeredUsers = UserDefaults.standard.array(forKey: "registeredUsers") as? [[String: String]] ?? []

    for user in registeredUsers {
      if let userEmail = user["email"], let userPassword = user["password"] {
        if userEmail == email && userPassword == password {
          return true
        }
      }
    }
    return false
  }
}
