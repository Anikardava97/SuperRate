//
//  OrderInfo.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import Foundation

struct OrderInfo {
  let fromCurrency: String
  let toCurrency: String
  let fromAmount: String
  let toAmount: String
  let selectedIban: IbanNumber?
}
