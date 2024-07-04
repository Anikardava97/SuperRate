//
//  UserAuthenticationViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import UIKit
import DesignSystem
import SnapKit

protocol UserAuthenticationViewControllerDelegate: AnyObject {
  func userDidAuthenticate()
}

final class UserAuthenticationViewController: UIViewController {
  // MARK: - Properties
  weak var delegate: UserAuthenticationViewControllerDelegate?
  let segmentedControlItems = ["რეგისტრაცია", "ავტორიზაცია"]

  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: segmentedControlItems)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.tintColor = .customSecondaryColor
    segmentedControl.selectedSegmentTintColor = .customAccentColor
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueDidChange), for: .valueChanged)

    let normalTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white.withAlphaComponent(0.8),
      .font: UIFont.regularTitle4
    ]

    let selectedTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white,
      .font: UIFont.mediumTitle4
    ]

    segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
    segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    return segmentedControl
  }()

  private lazy var containerView: UIView = {
    let view = UIView()
    return view
  }()

  private lazy var loginViewController: LoginViewController = {
    let loginViewController = LoginViewController()
    loginViewController.view.isHidden = true
    addChild(loginViewController)
    return loginViewController
  }()

  private lazy var signUpViewController: SignUpViewController = {
    let signUpViewController = SignUpViewController()
    addChild(signUpViewController)
    return signUpViewController
  }()

  // MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  // MARK: - Methods
  private func setup() {
    setupBackground()
    setupSubviews()
    setupConstraints()
    setuploginViewController()
    setupSignUpViewController()
  }

  private func setupBackground() {
    view.backgroundColor = .customBackgroundColor
  }

  private func setupSubviews() {
    view.addSubview(segmentedControl)
    view.addSubview(containerView)
  }

  private func setuploginViewController() {
    loginViewController.delegate = self
    addChild(loginViewController)
    containerView.addSubview(loginViewController.view)
    loginViewController.view.frame = containerView.bounds
    loginViewController.didMove(toParent: self)
  }

  private func setupSignUpViewController() {
    signUpViewController.delegate = self
    addChild(signUpViewController)
    containerView.addSubview(signUpViewController.view)
    signUpViewController.view.frame = containerView.bounds
    signUpViewController.didMove(toParent: self)
  }

  private func setupConstraints() {
    segmentedControl.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(44)
    }

    containerView.snp.remakeConstraints { make in
      make.top.equalTo(segmentedControl.snp.bottom).offset(40)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
    }
  }

  // MARK: - Actions
  @objc private func segmentedControlValueDidChange() {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      signUpViewController.view.isHidden = false
      loginViewController.view.isHidden = true
    case 1:
      loginViewController.view.isHidden = false
      signUpViewController.view.isHidden = true
    default:
      break
    }
  }
}

// MARK: - Extension: LoginViewControllerDelegate, SignUpViewControllerDelegate
extension UserAuthenticationViewController: LoginViewControllerDelegate, SignUpViewControllerDelegate {
  func loginViewControllerDidTapLogin(_ controller: LoginViewController) {
    delegate?.userDidAuthenticate()
  }

  func signUpViewControllerDidTapLogin(_ controller: SignUpViewController) {
    delegate?.userDidAuthenticate()
  }
}
