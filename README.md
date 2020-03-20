abceed
---

<img src="https://raw.githubusercontent.com/toshi0383/assets/master/abceed/screenshot.png" width="200" align="right">

This is a proof of concept project which demonstrates:

### 1. A basic implementation pattern of MVVM with Clean Architecture extension.

It has:

- Repository
- Builder
- Wireframe

It doesn't have:

- UseCase
- Presenter
- DataStore

Clean Architecture is basically extension of MVVM, so I only chose couple of components to fit my needs for current (and potentially future) state of this project.

### 2. Micro framework architecture

There are number of frameworks:

- AbceedCore: Common types and extensions (non-UI)
- AbceedLogic: Core Business Logic (ViewModel)
- AbceedUI: Common UI Components (View, ViewController, Wireframe and Builder)

It's still proof of concept, but feels okay to me.

- `Logic` depends on `Core`
- `UI` depends on both `Core` and `Logic`

Frameworks are linked statically, so there's no runtime overhead compared to monolithic app target.

### 3. Mock data driven UI development

All UI components are separated from main target, which means I can create app target **without actual network or database I/O**.  
This allows to build interested View or ViewController independently.    
This boosts up the UI development iteration cycle especially when project gets very large.

- UILibrary: Runs UI with mock data. Could have been a Xcode Playground too.

And of-course this makes it easy to test presentation layer using UITesting or snapshot testing etc..

## References

- https://dev.classmethod.jp/smartphone/iphone/clean-architecture-and-derivative-systems-for-ios
- https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md

## Xcode Version

- Xcode 11.3.1

## Bootstrap

```
carthage bootstrap --platform ios
xcodegen
```

## Unit Test

```
make test-all
```

## License

MIT
