//
//  ApiServiceTests.swift
//  NimbleTestTests
//
//  Created by Mark G on 31/10/2020.
//

@testable import NimbleSurvey
import XCTest
import Mockingbird
import Promises
import Nimble
import SwiftyJSON

class ApiServiceTests: XCTestCase {
    var service: ApiService!
    var httpService: HttpServiceMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        httpService = mock(HttpService.self)
        locator.mock(HttpService.self, httpService)
        
        service = ApiServiceImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// A valid response
    func testSuccessReponse() throws {
        
        let baseUrl = "http://example.com"
        let endPoint = "/api/v1/test"
        let token = "example"
        let id = 1
        let json = [
            "data": [
                "id": id
            ]
        ].toJSONString()!
        let data = json.data(using: .utf8)!

        // Mock
        given(
            httpService.request(
                method: any(),
                baseUrl: any(),
                endPoint: any(),
                params: any(),
                headers: any(),
                interceptor: any()
            )
        ) ~> .value(data)
        
        waitUntil {
            let apiResponse = try await(
                self.service.request(
                    method: .get,
                    baseUrl: baseUrl,
                    endPoint: endPoint,
                    token: token,
                    params: nil
                )
            )
            
            // Get id from response
            let response = JSON(apiResponse.response)
            let responseID = response["data"].dictionary?["id"]?.int
            
            //
            expect(responseID).to(equal(id))
        }
    }
    
    /// A invalid json
    func testInvalidJSONReponse() throws {
        
        let baseUrl = "http://example.com"
        let endPoint = "/api/v1/test"
        let token = "example"
        let data = "hi there"
            .data(using: .utf8)!
        
        // Mock
        given(
            httpService.request(
                method: any(),
                baseUrl: any(),
                endPoint: any(),
                params: any(),
                headers: any(),
                interceptor: any()
            )
        ) ~> .value(data)
        
        waitUntil {
            do {
                _ = try await(
                    self.service.request(
                        method: .get,
                        baseUrl: baseUrl,
                        endPoint: endPoint,
                        token: token,
                        params: nil
                    )
                )
            } catch {
                expect(error).to(matchError(ApiException.invalidResponse))
            }
        }
    }
    
    /// A valid json, but wrong structure
    func testInvalidReponse() throws {
        
        let baseUrl = "http://example.com"
        let endPoint = "/api/v1/test"
        let token = "example"
        let id = 1
        let json = [
            "wrong": [
                "id": id
            ]
        ].toJSONString()!
        let data = json.data(using: .utf8)!
        
        // Mock
        given(
            httpService.request(
                method: any(),
                baseUrl: any(),
                endPoint: any(),
                params: any(),
                headers: any(),
                interceptor: any()
            )
        ) ~> .value(data)
        
        waitUntil {
            do {
                _ = try await(
                    self.service.request(
                        method: .get,
                        baseUrl: baseUrl,
                        endPoint: endPoint,
                        token: token,
                        params: nil
                    )
                )
            } catch {
                expect(error).to(matchError(ApiException.invalidResponse))
            }
        }
    }
    
    /// A valid json, but wrong errors structure
    func testInvalidErrorReponse() throws {
        
        let baseUrl = "http://example.com"
        let endPoint = "/api/v1/test"
        let token = "example"
        let id = 1
        let json = [
            "errors": [
                "id": id
            ]
        ].toJSONString()!
        let data = json.data(using: .utf8)!
        
        // Mock
        given(
            httpService.request(
                method: any(),
                baseUrl: any(),
                endPoint: any(),
                params: any(),
                headers: any(),
                interceptor: any()
            )
        ) ~> .value(data)
        
        waitUntil {
            do {
                _ = try await(
                    self.service.request(
                        method: .get,
                        baseUrl: baseUrl,
                        endPoint: endPoint,
                        token: token,
                        params: nil
                    )
                )
            } catch {
                expect(error).to(matchError(ApiException.invalidResponse))
            }
        }
    }
    
    /// A valid errors response
    func testValidErrorReponse() throws {
        
        let baseUrl = "http://example.com"
        let endPoint = "/api/v1/test"
        let token = "example"
        let json = [
            "errors": [
                [
                    "code": "invalid_client",
                    "detail": "message"
                ]
            ]
        ].toJSONString()!
        let errorBag = ApiErrorBag(JSONString: json)!
        let data = json.data(using: .utf8)!
        
        // Mock
        given(
            httpService.request(
                method: any(),
                baseUrl: any(),
                endPoint: any(),
                params: any(),
                headers: any(),
                interceptor: any()
            )
        ) ~> .value(data)
        
        waitUntil {
            do {
                _ = try await(
                    self.service.request(
                        method: .get,
                        baseUrl: baseUrl,
                        endPoint: endPoint,
                        token: token,
                        params: nil
                    )
                )
            } catch {
                expect(error)
                    .to(
                        matchError(
                            ApiException.other(bag: errorBag)
                        )
                    )
            }
        }
    }
}
