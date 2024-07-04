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
    animateFadeTransition(to: child)
  }

  private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
    let current = self.currentChild
    addChild(new)

    transition(from: current, to: new, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseInOut], animations: {
    }, completion: { _ in
      current.removeFromParent()
      new.didMove(toParent: self)
      self.currentChild = new
      completion?()
    })
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
