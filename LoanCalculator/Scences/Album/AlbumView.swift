//
//  AlbumView.swift
//  MySampleUI
//
//  Created by Max Nguyen on 25/04/2023.
//

import SwiftUI
import ComposableArchitecture

struct AlbumView: View {
	var store: StoreOf<AlbumReducer>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			// Header
			VStack(alignment: .leading) {
				VStack {
					Spacer()
					Text("asdasd")
					Text("asdasd")
				}
				.frame(
					maxWidth: .infinity,
					maxHeight: 200,
					alignment: .topLeading
				)
				.background(
					AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
					} placeholder: {
						Image("")
					}
						.padding(.top, 16.0)
						.cornerRadius(16.0)
						.padding(.top, -16.0)
				)
				Spacer()
			}
			.ignoresSafeArea()
			.onAppear { viewStore.send(.loadScreen) }
		}
	}
}

struct AlbumView_Previews: PreviewProvider {
	static var previews: some View {
		AlbumView(store: Store(initialState: AlbumReducer.State(), reducer: AlbumReducer()))
	}
}
