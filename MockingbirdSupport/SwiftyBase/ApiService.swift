import Foundation
import Promises
import Alamofire

public protocol ApiService {
    func request(
        method: HttpMethod,
        baseUrl: String?,
        endPoint: String,
        token: String?,
        params: HttpParametable?
    ) -> Promise<ApiResponse>
    
    func upload(
        method: HttpMethod,
        baseUrl: String?,
        endPoint: String,
        token: String?,
        params: FormDataParametable
    ) -> Promise<ApiResponse>
    
    func download(
        method: HttpMethod,
        baseUrl: String?,
        endPoint: String,
        token: String?,
        params: HttpParametable
    ) -> Promise<URL>
}
