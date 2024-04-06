//
//  ConfettiSwiftUIApp.swift
//  ConfettiSwiftUI
//
//  Created by John O'Reilly on 16/06/2023.
//

import SwiftUI
import ConfettiKit

@main
struct ConfettiSwiftUIApp: App {
    @State private var component: SessionsComponent
    private let lifecycle: LifecycleRegistry

    
    init() {
        KoinKt.doInitKoin()
        
        lifecycle = LifecycleRegistryKt.LifecycleRegistry()
        LifecycleRegistryExtKt.resume(lifecycle)
        
        self.component = DefaultSessionsComponent(
            componentContext: DefaultComponentContext(lifecycle: lifecycle),
            conference: "androidmakers2024", user: nil, onSessionSelected: {_ in }, onSignIn: {})
    }
    
    var body: some Scene {
        WindowGroup {
            SessionsListView(component)
        }
    }
}
