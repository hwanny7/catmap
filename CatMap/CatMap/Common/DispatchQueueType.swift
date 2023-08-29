//
//  DispatchQueueType.swift
//  CatMap
//
//  Created by yun on 2023/08/28.
//

import Foundation


protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}
