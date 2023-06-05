//
//  TabBar+Reducer.swift
//  MySampleUI
//
//  Created by Max Nguyen on 24/04/2023.
//

import ComposableArchitecture

struct TabBarReducer: ReducerProtocol {
	
	var body: some ReducerProtocol<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .binding:
				return .none
			case let .updatePlayerOffset(value):
				state.playerOffset = value
				return .none
			}
		}
	}
}

extension TabBarReducer {
	struct State: Equatable {
		var playerOffset: Double = 0.0
	}
}

extension TabBarReducer {
	enum Action: BindableAction {
		case binding(BindingAction<State>)
		case updatePlayerOffset(Double)
	}
}
