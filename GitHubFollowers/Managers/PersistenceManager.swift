//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 22/04/2023.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: FollowerModel, actionType: PersistenceActionType, completion: @escaping (GHFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(where: { $0.login == favorite.login }) else {
                        
                        completion(.alreadyInFavorites)
                        return }
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                
                completion(saveFavorites(favorites: favorites))
                
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[FollowerModel], GHFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([FollowerModel].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func saveFavorites(favorites: [FollowerModel]) -> GHFError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
