//
//  MyOrder.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import Foundation

struct OrdersResponse: Decodable {
  let orders: [MyOrder]
}

struct MyOrder: Decodable {
  let currency: String
  let money: Int
  let rate: Double
  let date: String
  let isActive: Bool
}
