import Foundation
import Alamofire
import Promises
import ObjectMapper
import SwiftyJSON

public protocol HttpService {
    func request(
        method: HttpMethod,
        baseUrl: String,
        endPoint: String,
        params: HttpParametable?,
        headers: HttpHeaders?,
        interceptor: RequestInterceptor?
    ) -> Promise<Data>
    
    func upload(
        method: HTTPMethod,
        baseUrl: String,
        endPoint: String,
        params: FormDataParametable,
        headers: HTTPHeaders?,
        interceptor: RequestInterceptor?
    ) -> Promise<Data>
    
    func download(
        method: HTTPMethod,
        baseUrl: String,
        endPoint: String,
        params: HttpParametable?,
        headers: HTTPHeaders?,
        interceptor: RequestInterceptor?
    ) -> Promise<URL>
}
