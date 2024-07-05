//
//  SnackBar.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import UIKit

final class SnackBar {
  static func show(in view: UIView, message: String, bottomOffset: CGFloat = 16) {
    let bannerView = UIView()
    bannerView.backgroundColor = UIColor.white
    bannerView.layer.cornerRadius = 8
    bannerView.clipsToBounds = true

    let screenWidth = view.frame.size.width
    let bannerWidth = screenWidth - 32
    let bannerHeight: CGFloat = 40
    let bottomPadding = bottomOffset + bannerHeight + 20

    bannerView.frame = CGRect(x: 16,
                              y: view.frame.size.height - bottomPadding,
                              width: bannerWidth,
                              height: bannerHeight)
    bannerView.alpha = 0

    let checkmarkImageView = UIImageView()
    checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
    checkmarkImageView.contentMode = .scaleAspectFit
    checkmarkImageView.tintColor = .black

    let messageLabel = UILabel()
    messageLabel.text = message
    messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    messageLabel.textColor = .black
    messageLabel.textAlignment = .left

    bannerView.addSubview(checkmarkImageView)
    bannerView.addSubview(messageLabel)
    view.addSubview(bannerView)

    checkmarkImageView.snp.remakeConstraints { make in
      make.leading.equalTo(bannerView.snp.leading).offset(CGFloat.spacing7)
      make.centerY.equalTo(bannerView.snp.centerY)
      make.size.equalTo(24)
    }

    messageLabel.snp.remakeConstraints { make in
      make.top.equalTo(bannerView.snp.top)
      make.leading.equalTo(checkmarkImageView.snp.trailing).offset(6)
      make.trailing.equalTo(bannerView.snp.trailing)
      make.bottom.equalTo(bannerView.snp.bottom)
    }

    UIView.animate(withDuration: 0.5) {
      bannerView.alpha = 1
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
      UIView.animate(withDuration: 0.5, animations: {
        bannerView.alpha = 0
      }) { _ in
        bannerView.removeFromSuperview()
      }
    }
  }
}
