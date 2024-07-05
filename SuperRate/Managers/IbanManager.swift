//
//  IbanManager.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import Foundation

final class IbanManager {
  // MARK: - Shared Instance
  static let shared = IbanManager()

  // MARK: - Properties
  var ibans: [IbanNumber]

  // MARK: - Init
  private init() {
    self.ibans = []
    loadIbansForCurrentUser()
  }

  // MARK: - Methods
  func addIban(_ iban: IbanNumber) {
    ibans.append(iban)
    saveIbansForCurrentUser()
  }

  func removeIban(at index: Int) {
    guard index >= 0, index < ibans.count else { return }
    ibans.remove(at: index)
    saveIbansForCurrentUser()
  }
}

// MARK: - Extension: Save and Load Cards
extension IbanManager {
  func saveIbansForCurrentUser() {
    guard let userId = UserAuthenticationManager.shared.getName() else { return }
    let key = UserDefaults.standard.keyForUserSpecificData(base: "myCards", userId: userId)
    do {
      let data = try JSONEncoder().encode(ibans)
      UserDefaults.standard.set(data, forKey: key)
    } catch {
      print("Error saving cards for user \(userId): \(error)")
    }
  }

  func loadIbansForCurrentUser() {
    guard let userId = UserAuthenticationManager.shared.getName() else { return }
    let key = UserDefaults.standard.keyForUserSpecificData(base: "myCards", userId: userId)
    guard let data = UserDefaults.standard.data(forKey: key) else {
      return }
    if let ibans = try? JSONDecoder().decode([IbanNumber].self, from: data) {
      self.ibans = ibans
    } else {
      print("Failed to decode cards for user \(userId).")
    }
  }
}

extension UserDefaults {
  func keyForUserSpecificData(base: String, userId: String) -> String {
    "\(userId)_\(base)"
  }
}
