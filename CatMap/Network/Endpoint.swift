//
//  Endpoint.swift
//  CatMap
//
//  Created by yun on 2023/08/19.
//

import UIKit


enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

class Endpoint<R>: ResponseRequestable {

    typealias Response = R

    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParametersEncodable: Encodable?
    let queryParameters: [String: Any]
    let bodyParametersEncodable: Encodable?
    let bodyParameters: [String: Any]
    let bodyParametersConvertible: MultipartFormDataConvertible?
    let bodyEncoding: BodyEncoding
    let responseDecoder: ResponseDecoder

    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         headerParameters: [String: String] = [:],
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String: Any] = [:],
         bodyParametersEncodable: Encodable? = nil,
         bodyParameters: [String: Any] = [:],
         bodyParametersConvertible: MultipartFormDataConvertible? = nil,
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyParametersConvertible = bodyParametersConvertible
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
    }
}

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyParametersConvertible : MultipartFormDataConvertible? { get }
    var bodyEncoding: BodyEncoding { get }

    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response

    var responseDecoder: ResponseDecoder { get }
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {

    func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        // path에 완벽한 url을 적었을 경우
        // 우리는 url 뒤에 path를 붙일 것이기 때문에 필요 없을 듯

        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        // query=apple&category=fruit 처럼 파라미터를 url에 생성한다.
        // 만약 encodable한 객체로 넘겨줬을 경우에는 dictionary로 변환한다.
        
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        // api_key, language처럼 기본적인 쿼리 파라미터가 필요할 때
        // 현재 우리 프로젝트에서는 사용할 필요가 없을 듯
        
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        // url은 리소스의 위치를 지정한 문자열이지만 urlRequest는 http메서드, 헤더, 바디 등 실제 요청에 필요한 정보를 담고 있다.
        
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        // config header는 필요없을 듯 하다.
        
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let bodyParametersConvertible = bodyParametersConvertible {
            let formData = bodyParametersConvertible.encode(request: &urlRequest)
            print(formData)
            print("===================")
            urlRequest.httpBody = formData
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }

    private func encodeBody(bodyParameters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            let data = try? JSONSerialization.data(withJSONObject: bodyParameters)
            print("data입니다", data, type(of: data))
            return data
//            return try? JSONSerialization.data(withJSONObject: bodyParameters)
            // 딕셔너리를 Json 형태로 변경
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(
                using: String.Encoding.ascii,
                allowLossyConversion: true
            )
            // 이건 필요 없을 듯 함
        }
    }
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
    // stringEncodingAscii에서 사용되는 extension
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
    // query 또는 body ParemtersEncodable DTO를 data 타입으로 변환 후 다시 딕셔너리로 변경했다가 왜 다시 데이터로 변경하는건지 모르겠음. 이 부분을 생략해도 될 것 같은데
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}


protocol MultipartFormDataConvertible {
    
}

extension MultipartFormDataConvertible {
    func encode(request: inout URLRequest) -> Data {
        let mirror = Mirror(reflecting: self)
        
        let boundary: String = UUID().uuidString
        let lineBreak = "\r\n"
        var body = Data()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        for case let (label?, value) in mirror.children {
            if let images = value as? [UIImage] {
                for image in images {
                    let uuid = UUID().uuidString.components(separatedBy: "-").first!
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(label)\"; filename=\"\(uuid).jpg\"\(lineBreak)")
                    body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                    body.append(image.jpegData(compressionQuality: 0.99)!)
                    // assertion 넣지 않기
                    // Jpeg가 아닌 경우면 어떻게 하지
                    body.append(lineBreak)
                }
            } else if let stringValue = value as? String {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(label)\"\(lineBreak + lineBreak)")
                body.append(stringValue)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        if let bodyString = String(data: body.prefix(500), encoding: .utf8) {
            print(bodyString)
        } else {
            print("안된다고요!")
        }
        
        return body
        
    }
}
