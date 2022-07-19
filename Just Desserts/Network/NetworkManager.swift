//
//  NetworkManager.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/25/22.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    private func urlRequest(endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        return urlRequest
    }
    
    func call<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, AngryError>) -> Void) {
        
        guard let urlRequest = urlRequest(endpoint: endpoint) else {
            completion(.failure(.endpointError))
            return
        }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            if let _ = error {
                completion(.failure(.gotError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let payload = try decoder.decode(T.self, from: data)
                completion(.success(payload))
            } catch {
                completion(.failure(.decodeError))
            }
        }
        dataTask.resume()
    }
    
    func getImage(from urlString: String, placeholderImage: UIImage, completed: @escaping (UIImage) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(placeholderImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(placeholderImage)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}
