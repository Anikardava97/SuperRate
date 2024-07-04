//
//  TextFieldValidationState.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import Foundation

struct TextFieldValidationState {
  enum State {
    case pending, valid, error
  }

  enum TextFieldValidationError: String {
    case empty = "ფორმა არ უნდა იყოს ცარიელი"
    case alreadyRegistered = "ელფოსტა უკვე რეგისტრირებულია"
    case invalid = "ელფოსტა არავალიდურია"
    case passwordRequirements = "პაროლი უნდა შეიცავდეს მინიმუმ 12 სიმბოლოს"
    case passwordMismatch = "პაროლები არ ემთხვევა ერთმანეთს"
    case nameRequirements = "სახელი უნდა შეიცავდეს მინიმუმ 4 სიმბოლოს"
    case defaultCase = ""
  }

  var state: State
  let error: TextFieldValidationError

  init(state: State = .pending, error: TextFieldValidationError = .defaultCase) {
    self.state = state
    self.error = error
  }

  var errorMessage: String? {
    error.rawValue
  }
}
