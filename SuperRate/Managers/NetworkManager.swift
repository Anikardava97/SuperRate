//
//  NetworkManager.swift
//  SuperRate
//
//  Created by AnaKardava on 04.07.24.
//

import UIKit

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
  case other(Error)
}

final class NetworkManager {
  // MARK: - Shared Instance
  static let shared = NetworkManager()

  // MARK: - Private Init
  private init() {}

  // MARK: - Fetch Restaurants
  public func fetch<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(.invalidURL))
      return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(.other(error)))
        return
      }

      guard let data = data else {
        completion(.failure(.noData))
        return
      }

      do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        DispatchQueue.main.async{
          completion(.success(decodedData))
        }
      } catch { completion(.failure(.decodingError)) }
    }.resume()
  }
}
