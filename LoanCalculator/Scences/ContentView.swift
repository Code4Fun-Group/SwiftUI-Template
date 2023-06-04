//
//  ContentView.swift
//  MySampleUI
//
//  Created by Max Nguyen on 23/04/2023.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
	var body: some View {
		TabBarView(store: Store(initialState: TabBarReducer.State(), reducer: TabBarReducer()))
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
