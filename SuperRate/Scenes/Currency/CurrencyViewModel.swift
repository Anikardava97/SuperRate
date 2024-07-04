//
//  CurrencyViewModel.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import Foundation

protocol CurrencyViewModelDelegate: AnyObject {
  func ordersFetched(_ orders: [MyOrder])
  func showError(_ error: Error)
}

final class CurrencyViewModel {
  // MARK: - Properties
  private let ordersListURL = Constants.URLs.ordersListURL
  private var orders: [MyOrder]?
  weak var delegate: CurrencyViewModelDelegate?

  // MARK: - Methods
  func viewDidLoad() {
    fetchOrders()
  }

  private func fetchOrders() {
    NetworkManager.shared.fetch(from: ordersListURL) { [weak self] (result: Result<OrdersResponse, NetworkError>) in
      switch result {
      case .success(let fetchedOrders):
        self?.orders = fetchedOrders.orders
        self?.delegate?.ordersFetched(fetchedOrders.orders)
      case .failure(let error):
        self?.delegate?.showError(error)
      }
    }
  }
}
