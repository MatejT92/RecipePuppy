//
//  StringExtension.swift
//  RecipePuppy
//
//  Created by Matej Terek on 18/03/2021.
//

import Foundation

extension String {
    //Capitalize first letter of string
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }

}

