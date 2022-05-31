//
//  NetworkManager.swift
//  Just Desserts
//
//  Created by Eddie Caballero on 5/25/22.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getDesserts(completed: @escaping (Result<[Dessert], AngryError>) -> Void) {
        
        guard let url = URL(string: baseURL + "filter.php?c=Dessert") else {
            completed(.failure(.idError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.gotError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completed(.failure(.dataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let payload = try decoder.decode(Payload.self, from: data)
                guard let desserts = payload.meals else {
                    completed(.failure(.noMealsError))
                    return
                }
                let sortedDesserts = desserts.sorted(by: {$0.strMeal > $1.strMeal})
                completed(.success(sortedDesserts))
            } catch {
                completed(.failure(.decodeError))
            }
        }
        
        task.resume()
    }
    
    func getDessert(id: String, completed: @escaping (Result<Dessert, AngryError>) -> Void) {
        
        guard let url = URL(string: baseURL + "lookup.php?i=\(id)") else {
            completed(.failure(.idError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.gotError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completed(.failure(.dataError))
                return
            }
            
            do {
                let payload = try JSONDecoder().decode(Payload.self, from: data)
                guard let dessert = payload.meals?.first else {
                    completed(.failure(.noMealsError))
                    return
                }
                completed(.success(dessert))
            } catch {
                completed(.failure(.decodeError))
            }
        }
        
        task.resume()
    }
    
    func getImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let placeholderImage = DessertImage.placeholder
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
