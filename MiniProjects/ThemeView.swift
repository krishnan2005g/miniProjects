//
//  ThemeView.swift
//  MiniProjects
//
//  Created by test on 08/05/25.
//

import SwiftUI

struct ThemeView: View {
    @Environment(\.colorScheme) private var scheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(userTheme.color(scheme).gradient)
                .frame(width: 150, height: 150)
            
            Text("Choose a Style")
                .font(.title2.bold())
                .padding()
            
            HStack(spacing: 0) {
                ForEach(Theme.allCases, id: \.rawValue) { theme in
                    Text(theme.rawValue)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        .background {
                            ZStack {
                                if userTheme == theme {
                                    Capsule()
                                        .fill(.themeBG)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }
                        }
                        .animation(.snappy, value: userTheme)
                        .onTapGesture {
                            userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.05), in: Capsule())
            .padding(.top)
        }
    }
}

#Preview {
    ThemeView()
}



enum Theme:String, CaseIterable {
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"
    
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
            case .systemDefault:
                return scheme == .dark ? .moon : .sun
            case .light:
                return .sun
            case .dark:
                return .moon
        }
    }
}

