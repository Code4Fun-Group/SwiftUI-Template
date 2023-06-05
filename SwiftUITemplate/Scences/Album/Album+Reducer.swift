//
//  Album+Reducer.swift
//  MySampleUI
//
//  Created by Max Nguyen on 25/04/2023.
//

import ComposableArchitecture

struct AlbumReducer: ReducerProtocol {
	func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
		switch action {
		case .loadScreen:
			return .none
		}
	}
}

extension AlbumReducer {
	struct State: Equatable {
		var bannerModel: BannerModel?
	}
}

extension AlbumReducer {
	enum Action: Equatable {
		case loadScreen
	}
}
