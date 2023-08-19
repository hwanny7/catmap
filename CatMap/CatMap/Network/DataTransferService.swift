//
//  DataTransferService.swift
//  CatMap
//
//  Created by yun on 2023/08/05.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

// MARK: - DataTransferService protocol

protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    //
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where E.Response == T
    
    // E.Response는 MoviesResponseDTO ( APIEndpoints 파일에서 명시 )
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where E.Response == T

    @discardableResult
    func request<E: ResponseRequestable>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
    
    @discardableResult
    func request<E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<Void>
    ) -> NetworkCancellable? where E.Response == Void
}


// MARK: - DefaultDataTransferService

final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    
    init(
        with networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    
    
}

// MARK: - Extension DefaultDataTransferService

extension DefaultDataTransferService: DataTransferService {
    
}
