//
//  CurrencyViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import UIKit

final class CurrencyViewController: UIViewController {
  // MARK: - Properties
  let viewModel = CurrencyViewModel()
  let todaysDollarRate = "2.785"
  let todaysEuroRate = "2.98"
  let recieveExchangeRateDate = "6.07.2024, 15:00"

  private var orders: [MyOrder] = []
  private var activeOrders: [MyOrder] = []
  private var inactiveOrders: [MyOrder] = []

  private lazy var exchangeRateTitle = createSectionTitle()

  private lazy var dollarWrapperView = createCurrencyWrapperView()
  private lazy var dollarContainerHeader = createCurrencySignHeader(currency: "dollarsign")
  private lazy var dollarExchangeRate = createExchangeRateLabel(currency: "$", rate: todaysDollarRate)
  private lazy var dollarGraphImageView = createGraphImageView(currency: "graph.dollar")

  private lazy var euroWrapperView = createCurrencyWrapperView()
  private lazy var euroContainerHeader = createCurrencySignHeader(currency: "eurosign")
  private lazy var euroExchangeRate = createExchangeRateLabel(currency: "€", rate: todaysEuroRate)
  private lazy var euroGraphImageView = createGraphImageView(currency: "graph.euro")

  private lazy var exchangeRateDateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .light)
    label.textColor = .white
    label.text = "ბოლო განახლება: " + recieveExchangeRateDate
    return label
  }()

  private lazy var addOrderView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "border.shape")
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true

    let label = UILabel()
    label.text = "+ ორდერის დამატება"
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.textColor = .white

    imageView.addSubview(label)

    label.snp.remakeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addOrderDidTap))
    imageView.addGestureRecognizer(tapGesture)

    return imageView
  }()

  private lazy var activeOrdersLabel = createOrdersLabel(isActiveOrder: true)

  private  var activeOrdersTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()

  private lazy var inactiveOrdersLabel = createOrdersLabel(isActiveOrder: false)

  private lazy var inactiveOrdersTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()


  // MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    viewModel.viewDidLoad()
  }

  // MARK: - Methods
  private func setup() {
    setupViewModelDelegate()
    setupBackground()
    setupSubviews()
    setupConstraints()
    setupTableViews()
  }

  private func setupViewModelDelegate() {
    viewModel.delegate = self
  }

  private func setupBackground() {
    view.backgroundColor = .customBackgroundColor
  }

  private func setupSubviews() {
    view.addSubview(exchangeRateTitle)

    view.addSubview(dollarWrapperView)
    dollarWrapperView.addSubview(dollarContainerHeader)
    dollarWrapperView.addSubview(dollarExchangeRate)
    dollarWrapperView.addSubview(dollarGraphImageView)

    view.addSubview(euroWrapperView)
    euroWrapperView.addSubview(euroContainerHeader)
    euroWrapperView.addSubview(euroExchangeRate)
    euroWrapperView.addSubview(euroGraphImageView)

    view.addSubview(exchangeRateDateLabel)

    view.addSubview(addOrderView)

    view.addSubview(activeOrdersLabel)
    view.addSubview(activeOrdersTableView)

    view.addSubview(inactiveOrdersLabel)
    view.addSubview(inactiveOrdersTableView)
  }

  private func setupConstraints() {
    exchangeRateTitle.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    dollarWrapperView.snp.remakeConstraints { make in
      make.top.equalTo(exchangeRateTitle.snp.bottom).offset(CGFloat.spacing7)
      make.leading.equalToSuperview().offset(20)
      make.size.equalTo(160)
    }

    dollarContainerHeader.snp.remakeConstraints { make in
      make.top.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(42)
    }

    dollarExchangeRate.snp.remakeConstraints { make in
      make.top.equalTo(dollarContainerHeader.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
    }

    dollarGraphImageView.snp.remakeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
    }

    euroWrapperView.snp.remakeConstraints { make in
      make.top.equalTo(exchangeRateTitle.snp.bottom).offset(CGFloat.spacing7)
      make.trailing.equalToSuperview().offset(-20)
      make.size.equalTo(160)
    }

    euroContainerHeader.snp.remakeConstraints { make in
      make.top.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(42)
    }

    euroExchangeRate.snp.remakeConstraints { make in
      make.top.equalTo(euroContainerHeader.snp.bottom).offset(16)
      make.centerX.equalToSuperview()
    }

    euroGraphImageView.snp.remakeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
    }

    exchangeRateDateLabel.snp.remakeConstraints { make in
      make.top.equalTo(dollarWrapperView.snp.bottom).offset(CGFloat.spacing7)
      make.leading.equalToSuperview().offset(20)
    }

    addOrderView.snp.remakeConstraints { make in
      make.top.equalTo(exchangeRateDateLabel.snp.bottom).offset(CGFloat.spacing7)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(130)
    }

    activeOrdersLabel.snp.remakeConstraints { make in
      make.top.equalTo(addOrderView.snp.bottom).offset(CGFloat.spacing7)
      make.leading.equalToSuperview().offset(20)
    }

    activeOrdersTableView.snp.remakeConstraints { make in
      make.top.equalTo(activeOrdersLabel.snp.bottom).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(100)
    }

    inactiveOrdersLabel.snp.remakeConstraints { make in
      make.top.equalTo(activeOrdersTableView.snp.bottom).offset(CGFloat.spacing7)
      make.leading.equalToSuperview().offset(20)
    }

    inactiveOrdersTableView.snp.remakeConstraints { make in
      make.top.equalTo(inactiveOrdersLabel.snp.bottom).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(100)
    }
  }

  private func createSectionTitle() -> UILabel {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
    label.text = "ვალუტის კურსი"
    return label
  }

  private func createCurrencyWrapperView() -> UIView {
    let view = UIView()
    view.backgroundColor = .customSecondaryColor
    view.layer.cornerRadius = 10
    return view
  }

  private func createCurrencySignHeader(currency: String) -> UIView {
    let wrapperView = UIView(frame: .zero)

    let imageView = UIImageView()
    imageView.image = UIImage(named: currency)
    imageView.contentMode = .scaleAspectFit

    let firstLabel = UILabel()
    firstLabel.textColor = .white
    firstLabel.font = .systemFont(ofSize: 12, weight: .medium)
    firstLabel.text = "ყიდვა"

    let secondLabel = UILabel()
    secondLabel.textColor = .white
    secondLabel.font = .systemFont(ofSize: 12, weight: .medium)
    secondLabel.text = "გაყიდვა"

    wrapperView.addSubview(imageView)
    wrapperView.addSubview(firstLabel)
    wrapperView.addSubview(secondLabel)

    imageView.snp.remakeConstraints { make in
      make.top.leading.equalToSuperview()
      make.size.equalTo(42)
    }

    firstLabel.snp.remakeConstraints { make in
      make.top.equalToSuperview().offset(4)
      make.leading.equalTo(imageView.snp.trailing).offset(12)
    }

    secondLabel.snp.remakeConstraints { make in
      make.bottom.equalToSuperview().offset(-4)
      make.leading.equalTo(imageView.snp.trailing).offset(12)
    }

    return wrapperView
  }

  private func createExchangeRateLabel(currency: String, rate: String) -> UILabel {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 24, weight: .medium)
    label.text = currency + rate
    return label
  }

  private func createGraphImageView(currency: String) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage(named: currency)
    return imageView
  }

  private func createOrdersLabel(isActiveOrder: Bool) -> UIView {
    let wrapperView = UIView(frame: .zero)

    let circleImageView = UIImageView()
    circleImageView.image = UIImage(systemName: "circle.circle.fill")
    circleImageView.tintColor = isActiveOrder ? .customAccentColor : .lightGray

    let label = UILabel()
    label.text = isActiveOrder ? "აქტიური ორდერები" : "დასრულებული ორდერები"
    label.textColor = .white
    label.font = .systemFont(ofSize: 14)

    wrapperView.addSubview(circleImageView)
    wrapperView.addSubview(label)

    circleImageView.snp.remakeConstraints { make in
      make.top.leading.equalToSuperview()
      make.size.equalTo(16)
    }

    label.snp.remakeConstraints { make in
      make.centerY.equalTo(circleImageView.snp.centerY)
      make.leading.equalTo(circleImageView.snp.trailing).offset(CGFloat.spacing8)
    }

    return wrapperView
  }

  private func setupTableViews() {
    activeOrdersTableView.dataSource = self
    activeOrdersTableView.delegate = self
    activeOrdersTableView.register(MyOrderTableViewCell.self, forCellReuseIdentifier: "MyOrders")

    inactiveOrdersTableView.register(MyOrderTableViewCell.self, forCellReuseIdentifier: "MyOrders")
    inactiveOrdersTableView.delegate = self
    inactiveOrdersTableView.dataSource = self
  }

  private func filterOrders() {
    activeOrders = orders.filter { $0.isActive }
    inactiveOrders = orders.filter { !$0.isActive }
    activeOrdersTableView.reloadData()
    inactiveOrdersTableView.reloadData()
  }

  // MARK: - Actions
  @objc func addOrderDidTap() {
    let addIOrderViewController = AddOrderViewController()
    navigationController?.pushViewController(addIOrderViewController, animated: true)
  }
}

// MARK: - Extension: TableViewDataSource
extension CurrencyViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableView == activeOrdersTableView ? activeOrders.count : inactiveOrders.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrders", for: indexPath) as? MyOrderTableViewCell else {
      return UITableViewCell()
    }

    let order = tableView == activeOrdersTableView ? activeOrders[indexPath.row] : inactiveOrders[indexPath.row]
    cell.configure(with: order)
    return cell
  }
}

// MARK:  Extension: TableViewDelegate
extension CurrencyViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
}

// MARK: - CurrencyViewModelDelegate
extension CurrencyViewController: CurrencyViewModelDelegate {
  func ordersFetched(_ orders: [MyOrder]) {
    self.orders = orders
    DispatchQueue.main.async { [weak self] in
      self?.filterOrders()
    }
  }

  func showError(_ error: any Error) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true)
    }
  }
}
