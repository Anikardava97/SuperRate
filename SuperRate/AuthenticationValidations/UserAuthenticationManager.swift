//
//  UserAuthenticationManager.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import Foundation

final class UserAuthenticationManager {
  // MARK: - Shared Instance
  static let shared = UserAuthenticationManager()

  // MARK: - Private Init
  private init() {}

  // MARK: - Properties
  private var registeredUsers: [[String: String]] {
    get {
      UserDefaults.standard.array(forKey: "registeredCompanies") as? [[String: String]] ?? []
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "registeredCompanies")
    }
  }

  // MARK: - Methods
  func isEmailAlreadyRegistered(email: String) -> Bool {
    registeredUsers.contains { $0["email"] == email }
  }

  func validateName(_ name: String) -> Bool {
    let isValidLength = name.count >= 4 && name.count <= 20

    if isValidLength {
      return true
    }
    return false
  }

  func validateNumber(_ number: String) -> Bool {
    guard number.count == 9 else { return false }

    guard number.first == "5" else { return false }

    let numberRegEx = "^[5][0-9]{8}$"
    let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
    return numberTest.evaluate(with: number)
  }

  func validateEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }

  func validatePassword(_ password: String) -> Bool {
    let symbolsCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+=-{}[]|\\:;\"'<>,.?/~`")
    let passwordRange = password.rangeOfCharacter(from: symbolsCharacterSet)

    let isValidLength = password.count >= 12 && password.count <= 20
    let containsSymbol = passwordRange != nil

    return isValidLength && containsSymbol
  }

  func registerUser(name: String, code: String, number: String, email: String, password: String) {
    guard validateName(name), validateEmail(email), validatePassword(password) else {
      return
    }

    guard !isEmailAlreadyRegistered(email: email) else {
      return
    }

    let user = ["name": name, "code": code, "number": number, "email": email, "password": password]
    registeredUsers.append(user)
  }
}
