import AbceedCore
import AbceedLogic
import RxSwift
import SDWebImageSwiftUI
import SwiftUI

struct AppView: View {
    @ObservedObject var store: AppStore

    @State var currentPage = 0

    var body: some View {
        GeometryReader { proxy in
            PagerView(pageCount: self.store.state.topCategories.count, currentIndex: self.$currentPage) {
                ForEach(self.store.state.topCategories) { topCategory in
                    TopCategoryView(topCategory: topCategory)
                        .frame(width:  proxy.size.width, height: proxy.size.height)
                        .edgesIgnoringSafeArea([.leading, .trailing])
                }
            }
            .edgesIgnoringSafeArea([.leading, .trailing])
        }
    }

    init(store: AppStore) {
        self.store = store
    }

}

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    @GestureState var translation: CGFloat = 0
    let content: Content

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width + geometry.safeAreaInsets.leading)
            .offset(x: self.translation - geometry.safeAreaInsets.leading)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .updating(self.$translation) { value, state, _ in
                        state = value.translation.width
                }
                .onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
}

struct TopCategoryView: View {
    let topCategory: TopCategory

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(self.topCategory.subCategories) { subCategory in
                        BookListView(category: subCategory)
                            .frame(width: proxy.size.width, height: 250)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

}

struct BookListView: View {
    let category: AbceedCore.Category

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(self.category.name)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach((self.category.books.startIndex..<self.category.books.endIndex)) { (book: Int) in
                            if book == 0 { Spacer(minLength: 8) }
                            WebImage(url: URL(string: self.category.books[book].imgURL)!)
                                .resizable()
                                .indicator(.activity)
                                .aspectRatio(contentMode: ContentMode.fit)
                            if book + 1 == self.category.books.count { Spacer(minLength: 8) }
                        }
                    }
                }
            }
        }

    }

}

final class AppStore: ObservableObject {
    var state: TopCategoryTabState = .loading {
        didSet {
            objectWillChange.send()
        }
    }

    private let disposeBag = DisposeBag()

    init(bookRepository: BookRepository = BookRepositoryImpl()) {
        bookRepository.getAll()
            .optionalizeError()
            .map(TopCategoryTabState.init(response:))
            .startWith(.loading)
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.state = state
            })
            .disposed(by: disposeBag)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppStore())
    }
}
