//
//  QiitaViewModel.swift
//  Combine+MVVM
//
//  Created by 渡邊魁優 on 2024/05/11.
//

import Foundation
import Combine

class QiitaViewModel {
    var cancellables = Set<AnyCancellable>()
    @Published var items: [QiitaItem] = []

    func fetchItems() {
        let url = URL(string: "https://qiita.com/api/v2/items")!

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [QiitaItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] items in
                self?.items = items
            })
            .store(in: &cancellables)
    }
}
