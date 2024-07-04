//
//  MyOrdersTableViewCell.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import UIKit

final class MyOrdersTableViewCell: UITableViewCell {
  // MARK: - Properties
  private var order: MyOrder?

  private lazy var wrapperView: UIView = {
    let view = UIView(frame: .zero)
    return view
  }()

  private lazy var currencyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .white
    return label
  }()

  private lazy var moneyLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .white
    return label
  }()

  private lazy var rateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .white
    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .white.withAlphaComponent(0.6)
    return label
  }()

  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupCellAppearance()
    addSubviews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - CellLifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    currencyLabel.text = nil
    moneyLabel.text = nil
    rateLabel.text = nil
    dateLabel.text = nil
  }

  // MARK: - Private Methods
  private func setupCellAppearance() {
    layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 8

    contentView.layer.cornerRadius = layer.cornerRadius
    contentView.layer.masksToBounds = true

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowRadius = 6.0
    layer.shadowOpacity = 0.1
    layer.masksToBounds = false
  }

  private func addSubviews() {
    contentView.addSubview(wrapperView)
    wrapperView.addSubview(currencyLabel)
    wrapperView.addSubview(moneyLabel)
    wrapperView.addSubview(rateLabel)
    wrapperView.addSubview(dateLabel)
  }

  private func setupConstraints() {
    wrapperView.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }

    currencyLabel.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(CGFloat.spacing7)
    }

    moneyLabel.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(currencyLabel.snp.trailing).offset(CGFloat.spacing9)
    }

    rateLabel.snp.remakeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }

    dateLabel.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-CGFloat.spacing7)
    }
  }

  // MARK: - Configuration
  func configure(with order: MyOrder) {
    self.order = order
    currencyLabel.text = order.currency
    moneyLabel.text = String(order.money)
    rateLabel.text = String(order.rate)
    dateLabel.text = order.date

    backgroundColor = .customSecondaryColor
  }
}
