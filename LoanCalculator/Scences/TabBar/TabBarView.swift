//
//  TabBarView.swift
//  MySampleUI
//
//  Created by Max Nguyen on 23/04/2023.
//

import SwiftUI
import ComposableArchitecture
import Common

struct TabBarView: View {
	var store: StoreOf<TabBarReducer>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			GeometryReader { geometry in
				TabView {
					HomeView(store: Store(initialState: HomeReducer.State(), reducer: HomeReducer()))
						.tag(0)
						.tabItem {
							Image(systemName: "moon")
							Text("Home").foregroundColor(.white)
						}
				}
				.ignoresSafeArea()
				.onPreferenceChange(InnerContentSize.self, perform: { value in
					viewStore.send(.updatePlayerOffset(geometry.size.height - (value.last?.height ?? 0)))
				})
				.overlay(
					PlayerView(playerOffset: viewStore.playerOffset, store:
								Store(initialState:
										PlayerReducer.State(),
											reducer: PlayerReducer())),
					alignment: .bottom
				).onAppear {
					let appearance = UITabBarAppearance()
					appearance.backgroundEffect = .none
					appearance.backgroundColor = .clear
					
					UITabBar.appearance().standardAppearance = appearance
					UITabBar.appearance().scrollEdgeAppearance = appearance
				}
			}
		}
	}
}

struct TabBarView_Previews: PreviewProvider {
	static var previews: some View {
		TabBarView(store: Store(initialState: TabBarReducer.State(), reducer: TabBarReducer()))
	}
}

struct InnerContentSize: PreferenceKey {
	typealias Value = [CGRect]
	
	static var defaultValue: [CGRect] = []
	static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
		value.append(contentsOf: nextValue())
	}
}
