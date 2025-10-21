//
//  TabBarController.swift
//  Pokéllection
//
//  Created by Julian Manaois on 10/21/25.
//


import SwiftUI
import UIKit

struct TabBarController<Content: View>: UIViewControllerRepresentable {
    @Binding var selectedIndex: Int
    var onReselect: ((Int) -> Void)?
    let content: Content

    init(selectedIndex: Binding<Int>, onReselect: ((Int) -> Void)? = nil, @ViewBuilder content: () -> Content) {
        _selectedIndex = selectedIndex
        self.onReselect = onReselect
        self.content = content()
    }

    func makeUIViewController(context: Context) -> UITabBarController {
        let controller = UITabBarController()
        let hosting = UIHostingController(rootView: content.environment(\.tabBarController, controller))
        controller.setViewControllers([hosting], animated: false)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedIndex: $selectedIndex, onReselect: onReselect)
    }

    class Coordinator: NSObject, UITabBarControllerDelegate {
        @Binding var selectedIndex: Int
        var onReselect: ((Int) -> Void)?

        init(selectedIndex: Binding<Int>, onReselect: ((Int) -> Void)? = nil) {
            _selectedIndex = selectedIndex
            self.onReselect = onReselect
        }

        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if selectedIndex == tabBarController.selectedIndex {
                // ✅ Same tab tapped again
                onReselect?(selectedIndex)
            }
            selectedIndex = tabBarController.selectedIndex
        }
    }
}

// Environment key so SwiftUI child views can access the controller if needed
private struct TabBarControllerKey: EnvironmentKey {
    static let defaultValue: UITabBarController? = nil
}

extension EnvironmentValues {
    var tabBarController: UITabBarController? {
        get { self[TabBarControllerKey.self] }
        set { self[TabBarControllerKey.self] = newValue }
    }
}