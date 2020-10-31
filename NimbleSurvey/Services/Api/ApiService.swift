//
//  ApiService.swift
//  NimbleSurvey
//
//  Created by Mark G on 29/10/2020.
//

import SwiftyBase
import Promises
import SwiftyJSON
import L10n_swift
import Alamofire

// MARK: Implements
class ApiServiceImpl: ApiService {
    
    // Depend
    @Inject fileprivate var http: HttpService
    
    
    func request(
        method: HttpMethod,
        baseUrl: String? = nil,
        endPoint: String,
        token: String? = nil,
        params: HttpParametable? = nil
    ) -> Promise<ApiResponse> {
        
        return Promise(on: .global()) { () -> ApiResponse  in
            
            // Request
            let request: RequestHandler = { [unowned self] in
                self.http.request(
                    method: method,
                    baseUrl: baseUrl ?? ApiConfigs.baseUrl,
                    endPoint: endPoint,
                    params: params,
                    headers: self._headers(token ?? ApiConfigs.token),
                    interceptor: nil
                )
            }
            
            let response = try await(request())
            
            let trace = "\(endPoint) | \(ApiConfigs.token?.suffix(5) ?? "")"
            return try self._apiResponse(response: response, request: request, trace: trace)
        }
    }
}

// MARK: - Private
extension ApiServiceImpl {
    fileprivate func _apiResponse(response: Data, request: RequestHandler, trace: String = "") throws -> ApiResponse {
        
        // Convert data to json
        guard let json = try? JSON(data: response) else {
            throw ApiException.invalidResponse
        }
        
        // Get data
        do {
            try self._validate(json)
            return ApiResponse(response: json.dictionaryObject!)
        } catch {
            
            print("[api service] - request > ", trace, error)
            
            // Make sure it's api exception
            guard let apiException = error as? ApiException else {
                throw error
            }
            
            // Retry policy
            let data = try ApiConfigs.retry(apiException, request, trace)
            return try _apiResponse(response: data, request: request, trace: trace)
        }
    }
    
    // Validate structure of json
    fileprivate func _validate(_ json: JSON) throws {
        
        // Reponse must be a dictionary & has 'status' field is int
        guard
            let response = json.dictionary
        else { throw ApiException.invalidResponse }
        
        // Validate error structure
        guard
            let errors = response["errors"]?.dictionaryObject,
            let errorBag = ApiErrorBag(JSON: errors)
        else { throw ApiException.invalidResponse }
        
        throw ApiException.other(bag: errorBag)
    }
    
    /// Headers
    fileprivate func _headers(_ token: String?) -> HttpHeaders {
        
        var headers = HttpHeaders()
        
        // Language
        headers["Accept-Language"] = L10n.shared.language
        
        // Append token
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    fileprivate func _handle(_ error: Error) throws {
        
        // We wont throw 401, so let it refresh
        guard
            let httpException = error as? HttpException,
            let afError = httpException.error as? AFError,
            case .responseValidationFailed(let reason) = afError,
            case .unacceptableStatusCode(let code) = reason,
            code == 401
        else {
            throw error
        }
        
        // End this request, cause it will be retry
        throw ApiException.invalidResponse
    }
}
