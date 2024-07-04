//
//  ProfileViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import UIKit

final class ProfileViewController: UIViewController {
  // MARK: - Properties
  let viewModel = ProfileViewModel()
  let userAuthenticationManager = UserAuthenticationManager.shared

  private lazy var infoSectionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.spacing = .spacing6
    stackView.backgroundColor = .customSecondaryColor
    stackView.layer.cornerRadius = 12
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: 24, left: 24, bottom: 24, right: 24)
    return stackView
  }()

  private lazy var aboutCompanyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.text = "კომპანიის მონაცემები:"
    label.textColor = .white
    return label
}()

  private lazy var companyName = createIconLabelStackView(
    iconName: "person.text.rectangle.fill",
    info: userAuthenticationManager.getName() ?? ""
  )

  private lazy var companyCode = createIconLabelStackView(
    iconName: "person.crop.rectangle.fill",
    info: userAuthenticationManager.getCode() ?? ""
  )

  private lazy var emailAddress = createIconLabelStackView(
    iconName: "envelope.fill",
    info: userAuthenticationManager.getEmail() ?? ""
  )

  private lazy var phoneNumber = createIconLabelStackView(
    iconName: "phone.fill",
    info: userAuthenticationManager.getNumber() ?? ""
  )

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
  }

  private func setupBackground() {
    view.backgroundColor = .customBackgroundColor
  }

  private func setupSubviews() {
    view.addSubview(infoSectionStackView)
    infoSectionStackView.addArrangedSubview(aboutCompanyLabel)
    infoSectionStackView.addArrangedSubview(companyName)
    infoSectionStackView.addArrangedSubview(companyCode)
    infoSectionStackView.addArrangedSubview(emailAddress)
    infoSectionStackView.addArrangedSubview(phoneNumber)
  }

  private func setupConstraints() {
    infoSectionStackView.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
    }
  }

  private func createIconLabelStackView(iconName: String, info: String) -> UIStackView {
    let stackView = UIStackView()
    stackView.spacing = 12

    let imageView = UIImageView()
    imageView.image = UIImage(systemName: iconName)
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .white

    let infoLabel = UILabel()
    infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    infoLabel.text = info
    infoLabel.textColor = .white

    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(infoLabel)

    return stackView
  }
}
