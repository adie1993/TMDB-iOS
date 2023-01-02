//
//  Array+Extension.swift
//  tmdb-app
//
//  Created by Adie on 02/01/23.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index < endIndex, index >= startIndex else { return nil}
        return self[index]
    }
}
