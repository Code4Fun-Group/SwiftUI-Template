#!/usr/bin/env groovy

pipeline {
	agent {
		label 'slave-macos-m1'
	}

	options {
		disableConcurrentBuilds()
	}

	environment {
		APP_NAME = "MySampleSwiftUI"
	}

// Update submodules
	stages {
		stage("Update submodules") {
			steps {
				sh """
				git submodule foreach git checkout .
				git submodule update --init --recursive
				"""
			}
		}

// Install bundle
		stage("Install bundle") {
			steps {
				sh """
				export APP_NAME='$APP_NAME'
				bundle install
				"""
			}
		}

// Swiftlint    
		stage("Swiftlint") {
			steps {
				sh """
				bundle exec fastlane run swiftlint
				"""
			}
		}

// Danger	
		stage("Danger") {
			environment {
				ACCOUNT_GITHUB = credentials('ACCOUNT_GITHUB')
			}
			steps {
				sh """
				export DANGER_GITHUB_API_TOKEN=$ACCOUNT_GITHUB_PSW
				bundle exec fastlane run danger
				"""
			}
		}
	}
}
