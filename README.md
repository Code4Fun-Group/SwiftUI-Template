## Base Project

## Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

## Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

## Build and Test
- Execute following command by sequence:
```swift
git submodule foreach git checkout .
git submodule update --init --recursive
```
- Add Package SPM local
- Add Frameworks to probject
- Build & run main target.

## Architecture
Composable : https://www.pointfree.co/

### Branching
|type|usage|
|--|--|
|develop|uses for development team and pre-release version|
|feature/module/ISSUE_ID|uses for feature development|
|bugfix/module/ISSUE_ID|uses for general bug fixing in next version releases|

### Commit Message
Follow this guideline

```
ISSUE_ID - ScreenName - Add models
ISSUE_ID - ScreenName - Fix bug xxx
```

### Pull Request
Follow this guideline
> :warning: You have to link ISSUE to your PR
```
feature/module/ISSUE_ID - ScreenName - Short issue title
bugfix/module/ISSUE_ID - ScreenName - Short issue title
```

### NOTE
- Prefer UpperCamelCase
- Using proxyman to mock API: https://proxyman.io/
- Self-review code and build project before create PR
- Follow coding convention by SwiftLint: https://github.com/realm/SwiftLint 
