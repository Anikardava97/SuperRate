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
    case gelToDollar = "1 GEL = 0.36 USD"
    case dollarToGel = "1 USD = 2.75 GEL"
    case gelToEuro = "1 GEL = 0.33 EUR"
    case euroToGel = "1 EUR = 2.98 GEL"
  }
}

enum Currency: String {
  case GEL, USD, EUR
}
