//
//  OnboardingViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 03.07.24.
//

import UIKit
import DesignSystem
import SnapKit

final class OnboardingViewController: UIViewController {
  // MARK: - Properties
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [onboardingImage, titleLabel, appBenefitsLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = .spacing4
    return stackView
  }()

  private let onboardingImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.mediumLargeTitle
    label.textColor = .customAccentColor
    return label
  }()

  private let appBenefitsLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.mediumTitle3
    label.textAlignment = .center
    label.numberOfLines = 0
    label.textColor = .white
    return label
  }()

  // MARK: - Init
  init(imageName: String, titleText: String, description: String) {
    super.init(nibName: nil, bundle: nil)
    onboardingImage.image = UIImage(named: imageName)
    titleLabel.text = titleText
    appBenefitsLabel.text = description
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
    view.addSubview(mainStackView)
  }

  private func setupConstraints() {
    mainStackView.snp.remakeConstraints { make in
      make.top.equalToSuperview().offset(200)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }

    onboardingImage.snp.remakeConstraints { make in
      make.size.equalTo(160)
    }
  }
}
