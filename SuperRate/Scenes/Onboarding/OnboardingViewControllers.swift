//
//  OnboardingViewControllers.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import UIKit

protocol OnboardingViewControllersDelegate: AnyObject {
  func onboardingDidFinish()
}

final class OnboardingViewControllers: UIViewController {
  // MARK: - Properties
  private var pageViewController: UIPageViewController?
  private var onboardingViewControllers: [UIViewController] = []
  private let pageControl = UIPageControl()
  weak var delegate: OnboardingViewControllersDelegate?

  let welcomeViewController = OnboardingViewController(
    imageName: "app",
    titleText: "SuperRate",
    description: "ჩვენ გთავაზობთ ვალუტის საუკეთესო კურსს"
  )

  let onboarding1ViewController = OnboardingViewController(
    imageName: "exchange",
    titleText: "SuperRate",
    description: "აპლიკაციაში შეძლებთ მარტივად გადაცვალოთ თანხა"
  )

  let onboarding2ViewController = OnboardingViewController(
    imageName: "login",
    titleText: "SuperRate",
    description: "გაიარე ავტორიზაცია და მიიღე საუკეთესო შეთავაზებები"
  )

  private lazy var nextButton: MainButtonComponent = {
    let button = MainButtonComponent(text: "შემდეგი")
    button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    return button
  }()

  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()

  // MARK: - ViewLifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setupOnboardingViewControllers()
    presentOnboardingViewController()
  }

  private func setupOnboardingViewControllers() {
    onboardingViewControllers = [
      welcomeViewController,
      onboarding1ViewController,
      onboarding2ViewController,
    ]
  }

  private func setupPageControl() {
    pageControl.numberOfPages = onboardingViewControllers.count
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.currentPageIndicatorTintColor = .customAccentColor
    pageControl.isUserInteractionEnabled = false
    view.addSubview(pageControl)

    pageControl.snp.remakeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-160)
    }
  }

  private func setupPageViewController() {
    pageViewController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )
    pageViewController?.dataSource = self
    pageViewController?.delegate = self
    pageViewController?.view.frame = view.bounds
    addChild(pageViewController!)
    view.addSubview(pageViewController!.view)
    pageViewController?.didMove(toParent: self)
    pageViewController?.setViewControllers(
      [onboardingViewControllers.first!],
      direction: .forward,
      animated: true,
      completion: nil
    )
  }

  private func setupNextButton() {
    view.addSubview(nextButton)

    nextButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.height.equalTo(48)
    }
  }

  private func showNextOnboardingPage() {
    guard let currentViewController = pageViewController?.viewControllers?.first,
          let currentIndex = onboardingViewControllers.firstIndex(of: currentViewController),
          currentIndex + 1 < onboardingViewControllers.count else {
      return
    }
    let nextViewController = onboardingViewControllers[currentIndex + 1]
    pageViewController?.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
  }

  private func presentOnboardingViewController() {
    setupOnboardingViewControllers()
    setupPageViewController()
    setupPageControl()
    setupNextButton()
  }

  private func updateButtonTitle(for index: Int) {
    if index == onboardingViewControllers.count - 1 {
      nextButton.setTitle("დაწყება", for: .normal)
    } else {
      nextButton.setTitle("შემდეგი", for: .normal)
    }
  }

  // MARK: - Actions
  @objc private func nextButtonDidTap() {
    guard
      let currentViewController = pageViewController?.viewControllers?.first as? OnboardingViewController,
      let currentIndex = onboardingViewControllers.firstIndex(of: currentViewController) else {
      return
    }

    if currentIndex == onboardingViewControllers.count - 1 {
      delegate?.onboardingDidFinish()
    } else {
      let nextIndex = currentIndex + 1
      let nextViewController = onboardingViewControllers[nextIndex]
      pageViewController?.setViewControllers([nextViewController], direction: .forward, animated: true) { [weak self] completed in
        if completed {
          self?.pageControl.currentPage = nextIndex
          self?.updateButtonTitle(for: nextIndex)
        }
      }
    }
  }
}

// MARK: - Extension: UIPageViewControllerDataSource
extension OnboardingViewControllers: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = onboardingViewControllers.firstIndex(of: viewController), viewControllerIndex - 1 >= 0 else {
      return nil
    }
    let previousIndex = viewControllerIndex - 1
    if previousIndex >= 0 {
      return onboardingViewControllers[previousIndex]
    } else {
      return nil
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = onboardingViewControllers.firstIndex(of: viewController) else {
      return nil
    }
    let nextIndex = viewControllerIndex + 1
    guard nextIndex < onboardingViewControllers.count else {
      return nil
    }
    return onboardingViewControllers[nextIndex]
  }
}

// MARK:  Extension: UIPageViewControllerDelegate
extension OnboardingViewControllers: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      if let viewController = pageViewController.viewControllers?.first,
         let index = onboardingViewControllers.firstIndex(of: viewController) {
        pageControl.currentPage = index
      }
    }
  }
}
