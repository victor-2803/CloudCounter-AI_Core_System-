//
//  CounterModel.swift
//  CloudCounter
//
//  Created by Mr.Chanoudom Tann on 17/2/2569 BE.
//
import Foundation
import Combine

final class CounterModel: ObservableObject {

    @Published private(set) var value: Int = 0

    func increment() {
        value += 1
    }

    func decrement() {
        value -= 1
    }

    func reset() {
        value = 0
    }

    func isEven() -> Bool {
        return value % 2 == 0
    }
}
