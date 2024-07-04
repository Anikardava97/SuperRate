//
//  TabBarController.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import UIKit

final class TabBarController: UITabBarController {
  // MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
    setupUI()
  }

  // MARK: - Setup Tabs
  private func setupTabs() {
    let home = createNavigationController(
      title: "ვალუტები", image: UIImage(systemName: "dollarsign.arrow.circlepath"),
      viewController: CurrencyViewController()
    )
    let profile = createNavigationController(
      title: "პროფილი", image: UIImage(systemName: "person"),
      viewController: ProfileViewController()
    )

    setViewControllers([home, profile], animated: true)
  }

  // MARK: - Setup NavigationController
  private func createNavigationController(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.tabBarItem.title = title
    navigationController.tabBarItem.image = image
    // navigationController.viewControllers.first?.navigationItem.title = title
    return navigationController
  }

  // MARK: - Setup UI
  private func setupUI() {
    tabBar.tintColor = .customAccentColor
    tabBar.unselectedItemTintColor = .white
    tabBar.isTranslucent = true
    tabBar.standardAppearance = createTabBarAppearance()
    tabBar.scrollEdgeAppearance = createTabBarScrollEdgeAppearance()
  }

  private func createTabBarAppearance() -> UITabBarAppearance {
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.backgroundColor = .customBackgroundColor
    return tabBarAppearance
  }

  private func createTabBarScrollEdgeAppearance() -> UITabBarAppearance {
    let tabBarScrollEdgeAppearance = UITabBarAppearance()
    tabBarScrollEdgeAppearance.backgroundColor = .customBackgroundColor
    return tabBarScrollEdgeAppearance
  }
}
