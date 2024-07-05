//
//  MyIbansTableViewCell.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import UIKit

protocol MyIbansTableViewCellDelegate: AnyObject {
  func removeIban(for cell: MyIbansTableViewCell?)
}

final class MyIbansTableViewCell: UITableViewCell {
  // MARK: - Properties
  weak var delegate: MyIbansTableViewCellDelegate?

  private lazy var wrapperView: UIView = {
    let view = UIView(frame: .zero)
    return view
  }()

  private let ibanNumberLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .white
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    return label
  }()

  private lazy var deleteIbanImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "trash.circle.fill")
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .white
    imageView.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteCardDidTap))
    imageView.addGestureRecognizer(tapGesture)
    return imageView
  }()

  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubview()
    setupConstraints()
    setupCellAppearance()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: - CellLifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    ibanNumberLabel.text = nil
  }

  // MARK: - Methods
  private func addSubview() {
    contentView.addSubview(wrapperView)
    wrapperView.addSubview(ibanNumberLabel)
    wrapperView.addSubview(deleteIbanImageView)
  }

  private func setupConstraints() {
    wrapperView.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }

    ibanNumberLabel.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(CGFloat.spacing7)
    }

    deleteIbanImageView.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-CGFloat.spacing7)
      make.size.equalTo(CGFloat.spacing5)
    }
  }

  private func setupCellAppearance() {
    layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 12

    contentView.layer.cornerRadius = layer.cornerRadius
    contentView.layer.masksToBounds = true

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowRadius = 6.0
    layer.shadowOpacity = 0.1
    layer.masksToBounds = false
  }

  // MARK: - Actions
  @objc private func deleteCardDidTap() {
    delegate?.removeIban(for: self)
  }

  // MARK: - Configuration
  func configure(with iban: IbanNumber) {
    ibanNumberLabel.text = iban.ibanNumber
    backgroundColor = .customBackgroundColor
  }
}
