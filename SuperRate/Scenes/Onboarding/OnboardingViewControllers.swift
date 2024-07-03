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
    description: "ჩვენ გთავაზობთ ვალუტის საუკეთესო კურსს",
    buttonLabelText: "შემდეგი"
  )

  let onboarding1ViewController = OnboardingViewController(
    imageName: "exchange",
    titleText: "SuperRate",
    description: "აპლიკაციაში შეძლებთ მარტივად გადაცვალოთ თანხა",
    buttonLabelText: "შემდეგი"
  )

  let onboarding2ViewController = OnboardingViewController(
    imageName: "login",
    titleText: "SuperRate",
    description: "გაიარე ავტორიზაცია და მიიღე საუკეთესო შეთავაზებები",
    buttonLabelText: "დაწყება"
  )


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
    setUpOnboardingViewControllerDelegate()
  }

  private func setUpOnboardingViewControllerDelegate() {
    welcomeViewController.delegate = self
    onboarding1ViewController.delegate = self
    onboarding2ViewController.delegate = self
  }

  private func setupPageControl() {
    pageControl.numberOfPages = onboardingViewControllers.count
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.currentPageIndicatorTintColor = .customAccentColor
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

// MARK: - Extension: OnboardingViewControllerDelegate
extension OnboardingViewControllers: OnboardingViewControllerDelegate {
  func onboardingViewControllerDidTapNext(_ controller: OnboardingViewController) {
    guard let currentIndex = onboardingViewControllers.firstIndex(of: controller) else {
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
        }
      }
    }
  }
}
