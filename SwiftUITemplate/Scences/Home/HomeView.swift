//
//  HomeView.swift
//  MySampleUI
//
//  Created by Max Nguyen on 23/04/2023.
//

import SwiftUI
import ComposableArchitecture
import Common

struct HomeView: View {
	let store: StoreOf<HomeReducer>

	var body: some View {
		Text("Home")
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(store: Store(initialState: HomeReducer.State(), reducer: HomeReducer()))
	}
}
