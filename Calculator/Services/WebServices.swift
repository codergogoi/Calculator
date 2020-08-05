//
//  WebServices.swift
//  Calculator
//
//  Created by JAYANTA GOGOI on 8/5/20.
//  Copyright © 2020 JAYANTA GOGOI. All rights reserved.
//

import UIKit


let BaseURL  = "http://localhost:8000/"

struct WebSerivce {
    
    func getRequest<T: Decodable>(endPoint: String, response: @escaping(T?)->()){
        
        guard let url = URL(string: "\(BaseURL)\(endPoint)") else {
            DispatchQueue.main.async {
                response(nil)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, urlResponse, erorr) in
            
            guard let responseData = data, erorr == nil else {
                DispatchQueue.main.async {
                    response(nil)
                }
                return
            }
            
            do{
                
                let genericResponse = try JSONDecoder().decode(T.self, from: responseData)
                DispatchQueue.main.async {
                    response(genericResponse)
                }
            }catch let jsonError{
                 print(jsonError.localizedDescription)
                DispatchQueue.main.async {
                    response(nil)
                }
            }
            
        }.resume()
    }
    
}
