//
//  GHFError.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 19/04/2023.
//

import Foundation

enum GHFError: String, Error {
    case invalidUsername = "This username is invalid."
    case unableToComplete = "Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error while you try to add this person to favorites. Please try again."
    case alreadyInFavorites = "You've already favorited this user."
}
