//
//  Untitled.swift
//  CardsUA
//
//  Created by  Dmytro Matsenko on 22.02.2025.
//

import SwiftUI
import SwiftData

// MARK: - Data Model

@Model
class Word: Identifiable {
    var id: Int
    var word: String
    var translation: String
    var type: String
    var cefr: String
    var phon_br: String
    var phon_n_am: String
    var definition: String
    var example: String
  

    init(id: Int, word: String, translation: String, type: String, cefr: String, phon_br: String, phon_n_am: String, definition: String, example: String) {
        self.id = id
        self.word = word
        self.translation = translation
        self.type = type
        self.cefr = cefr
        self.phon_br = phon_br
        self.phon_n_am = phon_n_am
        self.definition = definition
        self.example = example
    }
}
