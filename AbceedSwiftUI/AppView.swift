import AbceedCore
import AbceedLogic
import RxSwift
import SDWebImageSwiftUI
import SwiftUI

struct AppView: View {
    @ObservedObject var store: AppStore

    var body: some View {
        GeometryReader { proxy in
            PagerView {
                ForEach(self.store.state.topCategories) { topCategory in
                    TopCategoryView(topCategory: topCategory)
                        .frame(width:  proxy.size.width + proxy.safeAreaInsets.horizontal, height: proxy.size.height)
                        .environmentObject(self.store.dragState)
                }
            }
            .edgesIgnoringSafeArea([.leading, .trailing])
            .environmentObject(self.store.dragState)
        }
    }

    init(store: AppStore) {
        self.store = store
    }
}

final class DragState: ObservableObject {
    @Published var translation: CGFloat = 0
    @Published var currentIndex: Int = 0
    @Published var pageCount: Int = 0
}

struct PagerView<Content: View>: View {
    let content: Content

    @EnvironmentObject var dragState: DragState

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .offset(x: -CGFloat(self.dragState.currentIndex) * geometry.size.width)
            .animation(.interactiveSpring(response: 0.3))
            .offset(x: self.dragState.translation)
        }
    }
}

struct TopCategoryView: View {
    let topCategory: TopCategory

    @EnvironmentObject var dragState: DragState

    var body: some View {
        GeometryReader { proxy in
            List {
                ForEach(self.topCategory.subCategories) { subCategory in
                    BookListView(category: subCategory)
                        .frame(width: proxy.size.width, height: 180)
                        .environmentObject(self.dragState)
                }
            }
        }
    }

}

struct BookListView: View {

    @EnvironmentObject var dragState: DragState

    let category: AbceedCore.Category

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text(self.category.name)
                    .offset(x: /*proxy.safeAreaInsets.leading + */8, y: 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.dragState.translation = value.translation.width
                            }
                            .onEnded { value in
                                let a = abs(value.translation.width)
                                let offset: CGFloat = a > 30 ? value.translation.width / a : 0
                                let newIndex = (CGFloat(self.dragState.currentIndex) - offset).rounded()
                                self.dragState.translation = 0
                                self.dragState.currentIndex = min(max(Int(newIndex), 0), self.dragState.pageCount - 1)
                            }
                    )
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(self.category.books) { book in
                            WebImage(url: URL(string: book.imgURL)!)
                                .resizable()
                                .indicator(.activity)
                                .aspectRatio(contentMode: ContentMode.fit)
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

    let dragState = DragState()

    private let disposeBag = DisposeBag()

    init(bookRepository: BookRepository = BookRepositoryImpl()) {
        bookRepository.getAll()
            .optionalizeError()
            .map(TopCategoryTabState.init(response:))
            .startWith(.loading)
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.state = state
                self?.dragState.pageCount = state.topCategories.count
            })
            .disposed(by: disposeBag)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: AppStore())
    }
}
