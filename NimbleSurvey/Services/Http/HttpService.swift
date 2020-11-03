//
//  HttpService.swift
//  NimbleSurvey
//
//  Created by Mark G on 31/10/2020.
//

import SwiftyBase
import Alamofire
import Promises

// MARK: - Protocol
protocol HttpService {
    func request(
        method: HttpMethod,
        baseUrl: String,
        endPoint: String,
        params: HttpParametable?,
        headers: HttpHeaders?,
        interceptor: RequestInterceptor?
    ) -> Promise<Data>
}

// MARK: Implements
class HttpServiceImpl: HttpService {
    fileprivate static let _session = Session()
    
    func request(
        method: HTTPMethod,
        baseUrl: String,
        endPoint: String,
        params: HttpParametable? = nil,
        headers: HTTPHeaders? = nil,
        interceptor: RequestInterceptor? = nil
    ) -> Promise<Data> {
        
        
        // Create request
        var encoding: HttpParamsEncoding = params?.encoding ?? JsonParamsEncoding.default
        
        // Encoding for get request must be UrlParamsEncoding
        if method == .get
            && !(encoding is UrlParamsEncoding) {
            encoding = UrlParamsEncoding.default
        }
        
        let request = Self._session.request(
            "\(baseUrl)\(endPoint)",
            method: method,
            parameters: params?.toJSON(),
            encoding: encoding,
            headers: headers,
            interceptor: interceptor
        )
        
        // Execute the request
        return _excute(request: request)
    }
    
    fileprivate func _excute(request: DataRequest) -> Promise<Data> {
        
        let promise: Promise<Data> = Promise<Data>.pending()
        
        // Execute the request
        request.responseData { response in
            
            // Has error
            guard response.error == nil else {
                
                print("[http service] > error", response)
                let error = response.error! as NSError
                let exception = HttpException(
                    error: response.error!,
                    code: error.code,
                    message: error.description
                )
                promise.reject(exception)
                return;
            }
            
            // Success
            
            promise.fulfill(response.data!)
        }
        
        
        return promise
    }
}
