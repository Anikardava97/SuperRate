//
//  CircularButton.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import UIKit

final class CircularButton: UIButton {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.bounds.size.height / 2
    self.clipsToBounds = true
  }
}
