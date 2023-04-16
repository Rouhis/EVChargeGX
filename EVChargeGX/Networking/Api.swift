//
//  Api.swift
//  EvChargeGX
//
//  Created by iosdev on 16.4.2023.
//

import Foundation

//Apicall that returns "Base" objects
//Takes latitude and longitude as params and returns void if no objects are found
func callApi(latitude:Double , longitude: Double, completion: @escaping ([Base]?, Error?) -> Void) {
    guard let url = URL(string: "https://api.openchargemap.io/v3/poi?key=68accc45-bc62-4e30-8792-0c3edd0fa24c&latitude=\(latitude)&longitude=\(longitude)") else {
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else {
            completion(nil, error)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([Base].self, from: data)
            completion(result, nil)
        } catch {
            completion(nil, error)
        }
    }
    task.resume()
}
