//
//  ProfileViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
  func signOut()
}

final class ProfileViewController: UIViewController {
  // MARK: - Properties
  var userAuthenticationManager: UserAuthenticationManager?
  var ibanManager: IbanManager?

  weak var delegate: ProfileViewControllerDelegate?

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
    info: userAuthenticationManager?.getName() ?? ""
  )

  private lazy var companyCode = createIconLabelStackView(
    iconName: "person.crop.rectangle.fill",
    info: userAuthenticationManager?.getCode() ?? ""
  )

  private lazy var emailAddress = createIconLabelStackView(
    iconName: "envelope.fill",
    info: userAuthenticationManager?.getEmail() ?? ""
  )

  private lazy var phoneNumber = createIconLabelStackView(
    iconName: "phone.fill",
    info: userAuthenticationManager?.getNumber() ?? ""
  )

  private lazy var addIbanView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "border.shape")
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true

    let label = UILabel()
    label.text = "+ ანგარიშის დამატება"
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = .white

    imageView.addSubview(label)

    label.snp.remakeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addIbanButtonDidTap))
    imageView.addGestureRecognizer(tapGesture)

    return imageView
  }()

  private lazy var myIbansLabel = createIconLabelStackView(
    iconName: "creditcard",
    info: "ჩემი ანგარიშები:"
  )

  private var tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()

  private lazy var signOutButton: MainButtonComponent = {
    let button = MainButtonComponent(text: "გასვლა")
    button.addTarget(self, action: #selector(signOutDidTap), for: .touchUpInside)
    return button
  }()

  // MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    userAuthenticationManager = UserAuthenticationManager.shared
    ibanManager = IbanManager.shared
    setup()
  }

  // MARK: - Methods
  private func setup() {
    setupBackground()
    setupSubviews()
    setupConstraints()
    setupTableView()
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

    view.addSubview(addIbanView)
    view.addSubview(myIbansLabel)
    view.addSubview(tableView)
    view.addSubview(signOutButton)
  }

  private func setupConstraints() {
    infoSectionStackView.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    addIbanView.snp.remakeConstraints { make in
      make.top.equalTo(infoSectionStackView.snp.bottom).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(130)
    }

    myIbansLabel.snp.remakeConstraints { make in
      make.top.equalTo(addIbanView.snp.bottom).offset(CGFloat.spacing8)
      make.leading.equalToSuperview().inset(20)
    }

    tableView.snp.remakeConstraints { make in
      make.top.equalTo(myIbansLabel.snp.bottom).offset(CGFloat.spacing7)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(200)
    }

    signOutButton.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
      make.height.equalTo(48)
    }
  }

  private func createIconLabelStackView(iconName: String, info: String, stackViewIsHidden: Bool = false) -> UIStackView {
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
    stackView.isHidden = stackViewIsHidden

    return stackView
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(MyIbansTableViewCell.self, forCellReuseIdentifier: "myIbansTableViewCell")
  }

  // MARK: - Actions
  @objc private func addIbanButtonDidTap() {
    let addIbanViewController = AddIbanViewController()
    addIbanViewController.ibanManager = self.ibanManager
    addIbanViewController.delegate = self
    navigationController?.pushViewController(addIbanViewController, animated: true)
  }

  @objc private func signOutDidTap() {
    let alert = UIAlertController(title: "გასვლა", message: "ნამდვილად გსურთ გასვლა?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "გაუქმება", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "გასვლა", style: .destructive, handler: { [weak self] _ in
      self?.delegate?.signOut()
    }))
    present(alert, animated: true)
  }
}

// MARK: - Extension: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ibanManager?.ibans.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: "myIbansTableViewCell", for: indexPath) as? MyIbansTableViewCell,
      let iban = ibanManager?.ibans[indexPath.row] else { return UITableViewCell() }
    cell.configure(with: iban)
    cell.delegate = self
    return cell
  }
}

// MARK:  Extension: TableViewDelegate
extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
}

// MARK:  Extension: MyCreditCardsTableViewCellDelegate
extension ProfileViewController: MyIbansTableViewCellDelegate {
  func removeIban(for cell: MyIbansTableViewCell?) {
    guard
      let cell = cell,
      let indexPath = tableView.indexPath(for: cell) else { return }
    ibanManager?.removeIban(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}

// MARK: - Extension: AddCardViewControllerDelegate
extension ProfileViewController: AddIbanViewControllerDelegate {
  func didAddNewIban() {
    ibanManager?.loadIbansForCurrentUser()
    tableView.reloadData()
  }
}
