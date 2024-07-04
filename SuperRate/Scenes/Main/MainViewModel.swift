//
//  MainViewModel.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
  func viewModel(_ viewModel: MainViewModel, didChangeScreenTo screen: MainViewModel.MainScreens)
}

final class MainViewModel {
  enum MainScreens {
    case onboardingScreens
    case loginScreen
    case application
  }

  // MARK: - Properties
  weak var delegate: MainViewModelDelegate?

  private var currentScreen: MainScreens = .onboardingScreens {
    didSet {
      delegate?.viewModel(self, didChangeScreenTo: currentScreen)
    }
  }

  // MARK: - Methods
  func viewDidLoad() {
    let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedInm")
    currentScreen = isUserLoggedIn ? .application : .onboardingScreens
  }

  func userDidLogOut() {
    UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    currentScreen = .loginScreen
  }
}

// MARK: - Extension: UserAuthenticationViewControllerDelegate
extension MainViewModel: UserAuthenticationViewControllerDelegate {
  func userDidAuthenticate() {
    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
    currentScreen = .application
  }
}

// MARK: - Extension: OnboardingViewControllersDelegate
extension MainViewModel: OnboardingViewControllersDelegate {
  func onboardingDidFinish() {
    currentScreen = .loginScreen
  }
}
