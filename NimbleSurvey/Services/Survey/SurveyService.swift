//
//  SurveyService.swift
//  NimbleSurvey
//
//  Created by Mark G on 01/11/2020.
//

import Promises
import SwiftyBase

// MARK: - Protocol
protocol SurveyService {
    func list(params: SurveyListParams) -> Promise<ListResponse<SurveyInfo>>
}

// MARK: Implements
class SurveyServiceImpl: SurveyService {
    
    @Inject fileprivate var _api: ApiService
    
    func list(params: SurveyListParams) -> Promise<ListResponse<SurveyInfo>> {
        _api.request(
            method: .get,
            baseUrl: nil,
            endPoint: "/surveys",
            token: nil,
            params: params
        )
        .map {
            $0.asList()
        }
    }
}
