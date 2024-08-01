//
//  ThemeManager.swift
//  Medy
//
//  Created by Utku on 31/07/24.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        // Varsayılan olarak koyu mod etkinleştir
        if UserDefaults.standard.object(forKey: "isDarkMode") == nil {
            UserDefaults.standard.set(true, forKey: "isDarkMode")
        }
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}
