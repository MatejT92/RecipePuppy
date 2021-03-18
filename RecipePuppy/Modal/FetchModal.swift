//
//  FetchModal.swift
//  RecipePuppy
//
//  Created by Matej Terek on 18/03/2021.
//
import Foundation
import UIKit
import SystemConfiguration

let RECIPESURL = "http://www.recipepuppy.com/api/"

struct RecipeData {
    var recipeName: String?
    var thumbnailURLString: String?
    var recipeHref: String?
    var ingredientsString: String?
}

class FetchModal: NSObject{
    //Method for fetching top tracks data
    func getRecipesData(parameter : String ,completion:(([RecipeData],(Bool),(String))->())?){
        //Network check
        if !isInternetAvailable(){
            completion!([RecipeData](), false,"NO Internet Connection")
            return
        }
        var wholeList = [RecipeData]()
        webserviceFetchGet(parameters: parameter)
        {
            (fetchedData,error,httpResponse) in
            //Fetching Successful
            if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 300{
                //Load recived data
                if let dict = fetchedData as? NSDictionary{
                    let dataArray = dict["results"] as? NSArray
                    var recipe = RecipeData()
                    for info in dataArray!{
                        if let data = info as? NSDictionary{
                            recipe.recipeName = data["title"] as? String  ?? "Unknown"
                            recipe.thumbnailURLString = data["thumbnail"] as? String ?? "Unknown"
                            recipe.recipeHref = data["href"] as? String ?? "Unknown"
                            recipe.ingredientsString = data["ingredients"] as? String ?? "Unknown"
                            wholeList.append(recipe)
                        }
                    }
                }
                completion!(wholeList, true, "Success")
            }
            //handle error
            else if httpResponse.statusCode >= 400{
                completion!([RecipeData](), false,"error occurred")
            }
        }
    }

    // Web Service
    private func webserviceFetchGet( parameters: String, completion: ((Any?,(Bool),(HTTPURLResponse))->())?) {
        let url = URL(string: RECIPESURL)
        let request = URLRequest(url: url! as URL)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if error != nil {
                print("error \(String(describing: httpResponse?.statusCode))")
                DispatchQueue.main.async {
                    //return parsed data
                    let parsedData = NSArray()
                    completion?(parsedData , true, HTTPURLResponse())
                }
            }
            guard let data = data, error == nil else {
                print(error!)                                 // some fundamental network error
                return
            }
            do {
                //parse received data
                let parsedData = try JSONSerialization.jsonObject(with: data, options: [])
                DispatchQueue.main.async {
                    completion?(parsedData, false,httpResponse!)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }

    //Check if User is connected to internet
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

}

