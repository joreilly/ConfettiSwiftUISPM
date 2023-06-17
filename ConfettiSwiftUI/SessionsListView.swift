//
//  SessionsListView.swift
//  ConfettiSwiftUI
//
//  Created by John O'Reilly on 16/06/2023.
//

import SwiftUI
import ConfettiKit

struct SessionsListView: View {
    let component: SessionsComponent
    
    @StateValue
    private var uiState: SessionsUiState
    
    init(_ component: SessionsComponent) {
        self.component = component
        _uiState = StateValue(component.uiState)
    }

    var body: some View {
        switch uiState {
        case is SessionsUiStateLoading: ProgressView()
        case is SessionsUiStateError: ErrorView()
        case let state as SessionsUiStateSuccess: SessionsContentView(component: component, sessionUiState: state)
        default: EmptyView()
        }
    }
}


private struct SessionsContentView: View {
    let component: SessionsComponent
    let sessionUiState: SessionsUiStateSuccess
    @State private var selectedDateIndex: Int = 0

    var body: some View {
        VStack {
            let formattedConfDates = sessionUiState.formattedConfDates
            Picker(selection: $selectedDateIndex, label: Text("Date")) {
                ForEach(0..<formattedConfDates.count, id: \.self) { i in
                    Text("\(formattedConfDates[i])").tag(i)
                }
            }
            .pickerStyle(.segmented)

            List {
                ForEach(sessionUiState.sessionsByStartTimeList[selectedDateIndex].keys.sorted(), id: \.self) {key in
                    
                    Section(header: HStack {
                        Image(systemName: "clock")
                        Text(key).font(.headline).bold()
                    }) {
                                                    
                        let sessions = sessionUiState.sessionsByStartTimeList[selectedDateIndex][key] ?? []
                        ForEach(sessions, id: \.self) { session in
                            SessionView(session: session)
                                .onTapGesture { component.onSessionClicked(id: session.id) }
                        }
                    }
                    
                }
            }
        }
    }
}


private struct SessionView: View {
    var session: SessionDetails
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(session.title).font(.headline)
            if session.room != nil {
                Text(session.sessionSpeakers() ?? "").font(.subheadline)
                Text(session.room?.name ?? "").font(.subheadline).foregroundColor(.gray)
            }
        }
    }
}



struct ErrorView: View {
    let text: String = "Something went wrong"
    
    var body: some View {
        Text(text)
    }
}


