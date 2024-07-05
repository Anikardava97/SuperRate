//
//  CurrencyCalculator.swift
//  SuperRate
//
//  Created by AnaKardava on 05.07.24.
//

import Foundation

struct CurrencyCalculator {
  var fromCurrency: String
  var toCurrency: String
  var fromAmount: String
  var toAmount: String
  var currencyComparisonText: CurrencyComparisonText

  enum CurrencyComparisonText: String {
    case gelToDollar = "1 GEl = 0.2785 USD"
    case dollarToGel = "1 USD = 2.785 GEL"
    case gelToEuro = "1 GEL = 0.298 EUR"
    case euroToGel = "1 EUR = 2.98 GEL"
  }
}

enum Currency: String {
  case GEL, USD, EUR
}
