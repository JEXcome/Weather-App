//
//  BackendAPI.swift
//  Weather App
//
//  Created by (-.-) on 16.07.2020.
//  Copyright © 2020 Eugene Zimin. All rights reserved.
//

import Foundation
import UIKit

import CoreLocation

import RxCocoa
import RxSwift

import SwiftyJSON


public enum RequestType: String
{
    case GET, POST
}

protocol BackendAPI
{
    var method: RequestType { get }
    var baseUrl: String { get }
    var headers: [String : String] { get }
    var baseParams: [String : String] { get }
}

extension BackendAPI
{
    private func qeuryItems(_ params : [String:String]) -> [URLQueryItem]
    {
        var r = [URLQueryItem]()
        
        var cs = CharacterSet.urlQueryAllowed
        cs.remove("+")
        
        for param in params
        {
            r.append(URLQueryItem(name: param.key, value: param.value.addingPercentEncoding(withAllowedCharacters: cs)))
        }
        
        return r
    }
    
    
    func simpleGETRequest(_ url: String) -> URLRequest
    {
        let comps = NSURLComponents(string: url)!
  
        let composedURL = comps.url!
        
        var request = URLRequest(url: composedURL, cachePolicy: .useProtocolCachePolicy)
        
        request.httpMethod = RequestType.GET.rawValue
        
        return request
    }
    
    func request(_ params: [String : String] = [:]) -> URLRequest
    {
        let comps = NSURLComponents(string: baseUrl)!
        
        let merged = baseParams.merging(params)
        { (current, _) in current
            // preserving base params
        }
        
        if !merged.isEmpty
        {
            let items = qeuryItems(merged)
        
            comps.queryItems = items
        }
        
        let composedURL = comps.url!
        
        var request = URLRequest(url: composedURL, cachePolicy: .useProtocolCachePolicy)
        
        request.httpMethod = method.rawValue

        request.allHTTPHeaderFields = headers
        
        return request
    }
    
}

protocol DataRepresentable
{
    associatedtype ObjectType
    static func fromData(_ data: Data) throws -> ObjectType
}

extension  RichObject : DataRepresentable
{
    static func fromData(_ data: Data) throws -> RichObject
    {
        return try RichObject.init(data: data)
    }
}

extension  UIImage : DataRepresentable
{
    static func fromData(_ data: Data) throws -> UIImage
    {
        if let result = UIImage.init(data: data)
        {
            return result
        }
        
        throw CocoaError(CocoaError.coderInvalidValue)
    }
}


extension URLRequest
{
    func observe<T>(_ responseType: T.Type) -> Observable<T> where T : DataRepresentable
    {
        return Observable<T>.create
        { observer in
            
            let task = URLSession.shared.dataTask(with: self)
            { (data, response, error) in
                
                if let data = data
                {
                    do
                    {
                        let result = try T.fromData(data)
                        
                        observer.onNext(result as! T)
                    }
                    catch let error
                    {
                        observer.onError(error)
                    }
                }
                else
                if let error = error
                {
                    observer.onError(error)
                }

                observer.onCompleted()
            }
            
            task.resume()

            return Disposables.create
            {
                task.cancel()
            }
        }
    }
    
    
}


struct WeatherAPI : BackendAPI
{
    private init()
    {
        
    }
    
    public static var shared = WeatherAPI()
    
    var method: RequestType
    {
        return .GET
    }
    
    var baseUrl : String
    {
        return "https://api.openweathermap.org/data/2.5/onecall"
    }
    
    var headers : [String : String]
    {
        return [:]
    }
    
    var baseParams: [String : String]
    {
        return ["appid": "e5f59799087cd246a4b38ae93c25b676"]
    }
    
    public func weatherForCoordinate(_ coordinate : CLLocationCoordinate2D) -> Observable<RichObject>
    {
        
        // https://api.openweathermap.org/data/2.5/onecall?lat=33.441792&lon=-94.037689&exclude=hourly,daily&appid=xxyyzz
        
        var params = [String:String]()

        params["units"] = "metric"
        params["fields"] = "temp,weather_code,humidity,precipitation_type,cloud_cover"
        params["lat"] = String(coordinate.latitude)
        params["lon"] = String(coordinate.longitude)
        params["exclude"] = "minutely,hourly"
        params["lang"] = Locale.current.languageCode
        
        let request = self.request(params)
        
        return request.observe(RichObject.self)
    }
 
}
