//
//  MainViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import UIKit

final class MainViewController: UIViewController {
  // MARK: - Properties
  let viewModel = MainViewModel()

  private var currentChild = UIViewController()

  // MARK: - Init
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setUpViewModelDelegate()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewLifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(currentChild)
    view.addSubview(currentChild.view)
    viewModel.viewDidLoad()
  }

  // MARK: - Methods
  private func setUpViewModelDelegate() {
    viewModel.delegate = self
  }

  private func addChildViewController(_ child: UIViewController, toView view: UIView) {
    addChild(child)
    child.view.frame = view.bounds
    child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    child.view.alpha = 0

    view.addSubview(child.view)

    UIView.animate(withDuration: 0.3, animations: {
      self.currentChild.view.alpha = 0
      child.view.alpha = 1
    }) { _ in
      self.currentChild.willMove(toParent: nil)
      self.currentChild.view.removeFromSuperview()
      self.currentChild.removeFromParent()

      child.didMove(toParent: self)

      self.currentChild = child
    }
  }

  private func presentOnboardingViewController() {
    let onboardingViewControllers = OnboardingViewControllers()
    onboardingViewControllers.delegate = viewModel
    addChildViewController(onboardingViewControllers, toView: self.view)
  }

  private func presentLoginViewController() {
    let registerViewController = UserAuthenticationViewController()
    registerViewController.delegate = viewModel
    addChildViewController(registerViewController, toView: self.view)
  }

  private func presentTabBarController() {
    let tabBarController = TabBarController()
    tabBarController.signOutDelegate = self
    addChildViewController(tabBarController, toView: self.view)
  }
}

// MARK: - Extension: MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
  func viewModel(_ viewModel: MainViewModel, didChangeScreenTo screen: MainViewModel.MainScreens) {
    switch screen {
    case .onboardingScreens:
      presentOnboardingViewController()
    case .loginScreen:
      presentLoginViewController()
    case .application:
      presentTabBarController()
    }
  }
}

// MARK: - Extension: ProfileViewControllerDelegate
extension MainViewController: ProfileViewControllerDelegate {
  func signOut() {
    viewModel.userDidSignOut()
  }
}
