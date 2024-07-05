//
//  AddOrderViewController.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import UIKit
import SnapKit

final class AddOrderViewController: UIViewController {
  // MARK: - Properties
  private var calculator = CurrencyCalculator(
    fromCurrency: Currency.GEL.rawValue,
    toCurrency: Currency.USD.rawValue,
    fromAmount: "",
    toAmount: "",
    currencyComparisonText: .gelToDollar
  )

  private var ibanManager: IbanManager?

  private var selectedIban: IbanNumber?

  private lazy var paySumAmount = createLabel(labelText: "უზრუნველყოფის თანხა(3%) = 0.0 GEL", fontSize: 14)

  private let currencyPickerView = UIPickerView()

  private var isSelectingFromCurrency = true

  private let availableCurrencies: [Currency] = [.GEL, .USD, .EUR]

  private lazy var titleLabel = createLabel(labelText: "თანხის კონვერტაცია", fontSize: 16)

  private lazy var currentCurrencyLabel = createLabel(labelText: calculator.currencyComparisonText.rawValue, fontSize: 12)


  private lazy var currencyExchangeWrapperView: UIView = {
    let view = UIView()
    return view
  }()

  private var fromCurrencyLabel: UILabel = {
    let label = UILabel()
    label.text = Currency.GEL.rawValue
    return label
  }()

  private var toCurrencyLabel: UILabel = {
    let label = UILabel()
    label.text = Currency.USD.rawValue
    return label
  }()

  private lazy var fromCurrencyContainer: UIView = currencyContainer(currency: fromCurrencyLabel, isBidOrAsk: "საიდან", isInput: true)

  private lazy var toCurrencyContainer: UIView = currencyContainer(currency: toCurrencyLabel, isBidOrAsk: "სად", isInput: false)

  private lazy var switchButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "switchButton"), for: .normal)
    button.addTarget(self, action: #selector(switchButtonDidTap), for: .touchUpInside)
    return button
  }()

  private lazy var fromAmountTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter amount"
    textField.keyboardType = .decimalPad
    textField.addTarget(self, action: #selector(amountDidChange), for: .editingChanged)
    textField.backgroundColor = .clear
    textField.textColor = .white
    textField.attributedPlaceholder = NSAttributedString(
      string: "0.00",
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
      ]
    )
    return textField
  }()

  private lazy var toAmountLabel: UILabel = {
    let label = UILabel()
    label.text = "0.00"
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .white
    return label
  }()

  private lazy var ibansStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [ibanIcon, ibanLabel, UIView(), chevronImageView])
    stackView.spacing = 12
    stackView.backgroundColor = .customSecondaryColor
    stackView.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layer.cornerRadius = 10

    let creditCardsTapGesture = UITapGestureRecognizer(target: self, action: #selector(ibanStackViewDidTap))
    stackView.isUserInteractionEnabled = true
    stackView.addGestureRecognizer(creditCardsTapGesture)
    return stackView
  }()

  private lazy var ibanIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "creditcard")
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .white
    return imageView
  }()

  private lazy var ibanLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.text = ibanManager?.ibans.isEmpty == true ? "დაამატე ანგარიში" : "აირჩიე ანგარიში"
    label.textColor = .white
    return label
  }()

  private lazy var chevronImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "chevron.right")
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .white
    return imageView
  }()

  private lazy var placeOrder: MainButtonComponent = {
    let button = MainButtonComponent(text: "ორდერის განთავსება")
    button.isEnabled = false
    button.alpha = 0.5
    button.addTarget(self, action: #selector(placeOrderDidTap), for: .touchUpInside)
    return button
  }()

  // MARK: - ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupPickerView()
    addTapGestureToCurrencyLabels()
    amountDidChange()
    ibanManager = IbanManager.shared
  }

  // MARK: - Setup Methods
  private func setup() {
    setupBackground()
    setupSubviews()
    setupConstraints()
  }

  private func setupBackground() {
    view.backgroundColor = .customBackgroundColor
  }

  private func setupSubviews() {
    view.addSubview(titleLabel)
    view.addSubview(currentCurrencyLabel)
    view.addSubview(currencyExchangeWrapperView)

    currencyExchangeWrapperView.addSubview(fromCurrencyContainer)
    currencyExchangeWrapperView.addSubview(switchButton)
    currencyExchangeWrapperView.addSubview(toCurrencyContainer)

    view.addSubview(paySumAmount)
    view.addSubview(placeOrder)
    view.addSubview(ibansStackView)
  }

  private func setupConstraints() {
    titleLabel.snp.remakeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    currentCurrencyLabel.snp.remakeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    currencyExchangeWrapperView.snp.makeConstraints { make in
      make.top.equalTo(currentCurrencyLabel.snp.bottom).offset(CGFloat.spacing7)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(120)
    }

    fromCurrencyContainer.snp.remakeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalToSuperview()
    }

    switchButton.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(fromCurrencyContainer.snp.trailing).offset(CGFloat.spacing6)
      make.size.equalTo(40)
    }

    toCurrencyContainer.snp.remakeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.leading.equalTo(switchButton.snp.trailing).offset(CGFloat.spacing6)
      make.trailing.equalToSuperview()
      make.width.equalTo(fromCurrencyContainer.snp.width)
    }

    paySumAmount.snp.remakeConstraints { make in
      make.top.equalTo(currencyExchangeWrapperView.snp.bottom).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    ibansStackView.snp.remakeConstraints { make in
      make.top.equalTo(paySumAmount.snp.bottom).offset(CGFloat.spacing6)
      make.leading.trailing.equalToSuperview().inset(20)
    }

    placeOrder.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.height.equalTo(48)
    }
  }

  private func createLabel(labelText: String, fontSize: CGFloat) -> UILabel {
    let label = UILabel()
    label.text = labelText
    label.font = .systemFont(ofSize: fontSize)
    label.textColor = .white
    return label
  }

  private func currencyContainer(currency: UILabel, isBidOrAsk: String, isInput: Bool) -> UIView {
    let containerView = UIView()
    containerView.backgroundColor = .customSecondaryColor
    containerView.layer.cornerRadius = 12

    currency.textColor = .white
    currency.font = UIFont.boldSystemFont(ofSize: 16)

    let dropDownButton = UIButton()
    dropDownButton.setImage(UIImage(named: "chevron.down"), for: .normal)

    let bidAskLabel = UILabel()
    bidAskLabel.text = isBidOrAsk
    bidAskLabel.textColor = .white
    bidAskLabel.font = UIFont.systemFont(ofSize: 12)

    let valueView: UIView
    if isInput {
      valueView = fromAmountTextField
    } else {
      valueView = toAmountLabel
    }

    containerView.addSubview(currency)
    containerView.addSubview(dropDownButton)
    containerView.addSubview(bidAskLabel)
    containerView.addSubview(valueView)

    currency.snp.remakeConstraints { make in
      make.top.leading.equalToSuperview().offset(CGFloat.spacing7)
    }

    dropDownButton.snp.remakeConstraints { make in
      make.leading.equalTo(currency.snp.trailing).offset(CGFloat.spacing8)
      make.centerY.equalTo(currency.snp.centerY)
      make.size.equalTo(16)
    }

    bidAskLabel.snp.remakeConstraints { make in
      make.top.equalTo(currency.snp.bottom).offset(CGFloat.spacing7)
      make.leading.equalToSuperview().inset(CGFloat.spacing7)
    }

    valueView.snp.remakeConstraints { make in
      make.top.equalTo(bidAskLabel.snp.bottom).offset(CGFloat.spacing8)
      make.leading.trailing.equalToSuperview().inset(CGFloat.spacing7)
      make.bottom.equalToSuperview().inset(CGFloat.spacing7)
    }

    return containerView
  }

  // MARK: - Setup PickerView
  private func setupPickerView() {
    currencyPickerView.dataSource = self
    currencyPickerView.delegate = self
    currencyPickerView.isHidden = true
    currencyPickerView.isUserInteractionEnabled = true

    view.addSubview(currencyPickerView)

    currencyPickerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.height.equalTo(300)
    }
  }

  private func addTapGestureToCurrencyLabels() {
    let fromCurrencyTapGesture = UITapGestureRecognizer(target: self, action: #selector(fromCurrencyDidTap))
    fromCurrencyLabel.isUserInteractionEnabled = true
    fromCurrencyLabel.addGestureRecognizer(fromCurrencyTapGesture)

    let toCurrencyTapGesture = UITapGestureRecognizer(target: self, action: #selector(toCurrencyDidTap))
    toCurrencyLabel.isUserInteractionEnabled = true
    toCurrencyLabel.addGestureRecognizer(toCurrencyTapGesture)
  }

  private func showCurrencyPicker() {
    currencyPickerView.isHidden = false
  }

  private func hideCurrencyPicker() {
    currencyPickerView.isHidden = true
  }

  // MARK: - Currency Update Methods
  private func updateCurrency(selectedCurrency: Currency) {
    if isSelectingFromCurrency {
      updateFromCurrency(selectedCurrency)
    } else {
      updateToCurrency(selectedCurrency)
    }
    updateCurrencyComparisonText()
    amountDidChange()
  }

  private func updateFromCurrency(_ selectedCurrency: Currency) {
    calculator.fromCurrency = selectedCurrency.rawValue
    fromCurrencyLabel.text = selectedCurrency.rawValue

    if selectedCurrency == .GEL {
      ensureToCurrencyIsNotGEL()
    } else {
      setToCurrencyToGEL()
    }
  }

  private func updateToCurrency(_ selectedCurrency: Currency) {
    calculator.toCurrency = selectedCurrency.rawValue
    toCurrencyLabel.text = selectedCurrency.rawValue

    if selectedCurrency == .GEL {
      ensureFromCurrencyIsNotGEL()
    } else {
      setFromCurrencyToGEL()
    }
  }

  private func ensureToCurrencyIsNotGEL() {
    if calculator.toCurrency == Currency.GEL.rawValue {
      calculator.toCurrency = Currency.USD.rawValue
      toCurrencyLabel.text = Currency.USD.rawValue
    }
  }

  private func setToCurrencyToGEL() {
    calculator.toCurrency = Currency.GEL.rawValue
    toCurrencyLabel.text = Currency.GEL.rawValue
  }

  private func ensureFromCurrencyIsNotGEL() {
    if calculator.fromCurrency == Currency.GEL.rawValue {
      calculator.fromCurrency = Currency.USD.rawValue
      fromCurrencyLabel.text = Currency.USD.rawValue
    }
  }

  private func setFromCurrencyToGEL() {
    calculator.fromCurrency = Currency.GEL.rawValue
    fromCurrencyLabel.text = Currency.GEL.rawValue
  }

  private func updateCurrencyComparisonText() {
    let fromCurrency = calculator.fromCurrency
    let toCurrency = calculator.toCurrency

    if fromCurrency == Currency.GEL.rawValue && toCurrency == Currency.USD.rawValue {
      calculator.currencyComparisonText = .gelToDollar
    } else if fromCurrency == Currency.GEL.rawValue && toCurrency == Currency.EUR.rawValue {
      calculator.currencyComparisonText = .gelToEuro
    } else if fromCurrency == Currency.USD.rawValue && toCurrency == Currency.GEL.rawValue {
      calculator.currencyComparisonText = .dollarToGel
    } else if fromCurrency == Currency.EUR.rawValue && toCurrency == Currency.GEL.rawValue {
      calculator.currencyComparisonText = .euroToGel
    }
    currentCurrencyLabel.text = calculator.currencyComparisonText.rawValue
  }

  private func updatePaySumAmountLabel(_ amount: Double) {
    let currency = fromCurrencyLabel.text ?? ""
    let formattedAmount = String(format: "%.2f", amount)
    paySumAmount.text = "უზრუნველყოფის თანხა(3%) = \(formattedAmount) \(currency)"
  }

  private func updateIbanDisplay(with ibanNumber: IbanNumber) {
    ibanLabel.text = ibanNumber.ibanNumber
    selectedIban = ibanNumber
    updatePlaceOrderButtonState()
  }

  private func updatePlaceOrderButtonState() {
    let amount = Double(fromAmountTextField.text ?? "") ?? 0
    let isEnabled = amount > 0 && selectedIban != nil
    placeOrder.isEnabled = isEnabled
    placeOrder.alpha = placeOrder.isEnabled ? 1.0 : 0.5
  }

  private func saveOrderInformation() {
    let _ = OrderInfo(
      fromCurrency: calculator.fromCurrency,
      toCurrency: calculator.toCurrency,
      fromAmount: fromAmountTextField.text ?? "",
      toAmount: toAmountLabel.text ?? "",
      selectedIban: selectedIban
    )
  }

  // MARK: - Actions
  @objc private func fromCurrencyDidTap() {
    isSelectingFromCurrency = true
    showCurrencyPicker()
  }

  @objc private func toCurrencyDidTap() {
    isSelectingFromCurrency = false
    showCurrencyPicker()
  }

  @objc private func switchButtonDidTap() {
    let tempCurrency = calculator.fromCurrency
    calculator.fromCurrency = calculator.toCurrency
    calculator.toCurrency = tempCurrency

    fromCurrencyLabel.text = calculator.fromCurrency
    toCurrencyLabel.text = calculator.toCurrency

    amountDidChange()

    updateCurrencyComparisonText()
  }

  @objc private func amountDidChange() {
    guard
      let fromAmountText = fromAmountTextField.text,
      let fromAmount = Double(fromAmountText) else {
      toAmountLabel.text = "0.00"
      return
    }

    let conversionRate: Double = {
      switch (calculator.fromCurrency, calculator.toCurrency) {
      case (Currency.GEL.rawValue, Currency.USD.rawValue):
        return 0.2785
      case (Currency.USD.rawValue, Currency.GEL.rawValue):
        return 2.785
      case (Currency.GEL.rawValue, Currency.EUR.rawValue):
        return 0.298
      case (Currency.EUR.rawValue, Currency.GEL.rawValue):
        return 2.98
      default:
        return 1.0
      }
    }()

    let toAmount = fromAmount * conversionRate
    toAmountLabel.text = String(format: "%.2f", toAmount)

    let payAmount = fromAmount * 0.03
    updatePaySumAmountLabel(payAmount)

    updatePlaceOrderButtonState()
  }

  @objc private func ibanStackViewDidTap() {
    if ibanManager?.ibans.isEmpty == true {
      let addIbanViewController = AddIbanViewController()
      navigationController?.pushViewController(addIbanViewController, animated: true)
    } else {
      let actionSheet = UIAlertController(title: "აირჩიე ანგარიში", message: nil, preferredStyle: .actionSheet)

      for ibanNumber in ibanManager?.ibans ?? [] {
        let ibanAction = UIAlertAction(title: ibanNumber.ibanNumber, style: .default) { [weak self] action in
          self?.updateIbanDisplay(with: ibanNumber)
        }
        actionSheet.addAction(ibanAction)
      }

      let addNewIbanAction = UIAlertAction(title: "დაამატე ახალი ანგარიში", style: .default) { [weak self] _ in
        let addIbanViewController = AddIbanViewController()
        self?.navigationController?.pushViewController(addIbanViewController, animated: true)
      }
      actionSheet.addAction(addNewIbanAction)

      let cancelAction = UIAlertAction(title: "გაუქმება", style: .cancel, handler: nil)
      actionSheet.addAction(cancelAction)

      actionSheet.view.tintColor = .customAccentColor
      present(actionSheet, animated: true, completion: nil)
    }
  }

  @objc private func placeOrderDidTap() {
    guard
      let fromAmount = fromAmountTextField.text,
      let fromCurrency = fromCurrencyLabel.text else { return }

    let message = "ნამდვილად გსურთ \(fromAmount) \(fromCurrency) ორდერის განთავსება ?"
    let alert = UIAlertController(title: "ორდერის განთავსება", message: message, preferredStyle: .alert)

    let yesAction = UIAlertAction(title: "მსურს", style: .default) { [weak self] _ in
      self?.saveOrderInformation()
      self?.navigationController?.popViewController(animated: true)
    }
    alert.addAction(yesAction)

    let cancelAction = UIAlertAction(title: "არ მსურს", style: .cancel, handler: nil)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension AddOrderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return availableCurrencies.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return availableCurrencies[row].rawValue
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedCurrency = availableCurrencies[row]
    updateCurrency(selectedCurrency: selectedCurrency)
    hideCurrencyPicker()
    amountDidChange()
  }

  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.text = availableCurrencies[row].rawValue
    return label
  }
}
