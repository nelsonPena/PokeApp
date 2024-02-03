//
//  ImageUrl.swift
//  PokeApp
//
//  Created by Nelson Peña on 3/02/24.
//

import Foundation

class ImageUrl {
    
    static func getURL(index: String) -> URL? {
        URL(string: String(format: Bundle.main.infoDictionary?["ImageUrl"] as? String ?? "", index))
    }
}
