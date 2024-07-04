//
//  LoginViewModel.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import Foundation

final class LoginViewModel {
  enum FormFieldType: CaseIterable {
    case name, password
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
    case .password:
      newState = validatePassword(text: text)
    }
    formState[type] = newState
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

  private func validatePassword(text: String) -> TextFieldValidationState {
    if text.isEmpty {
      return TextFieldValidationState(state: .error, error: .empty)
    } else if !isValidPassword(text) {
      return TextFieldValidationState(state: .error, error: .passwordRequirements)
    } else {
      return TextFieldValidationState(state: .valid)
    }
  }

  private func isValidName(_ name: String) -> Bool {
    authenticationManager.validateName(name)
  }

  private func isValidPassword(_ password: String) -> Bool {
    authenticationManager.validatePassword(password)
  }

  func loginCompany(name: String, password: String) -> Bool {
    let registeredCompanies = UserDefaults.standard.array(forKey: "registeredCompanies") as? [[String: String]] ?? []

    for company in registeredCompanies {
      if let companyName = company["name"], let companyPassword = company["password"] {
        if companyName == name && companyPassword == password {
          return true
        }
      }
    }
    return false
  }
}
