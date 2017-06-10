//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
public final class DataManager {
    public static func getJSONFromURL(_ resource:String, completion:@escaping (_ data:Data?, _ error:Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let filePath = Bundle.main.path(forResource: resource, ofType: "json")
            let url = URL(fileURLWithPath: filePath!)
            let data = try! Data(contentsOf: url, options: .uncached)
            completion(data, nil)
        }
        
    }
}

//DataManager.getJSONFromURL("car") { (data, error) in
//    guard let data = data else {
//        PlaygroundPage.current.finishExecution()
//    }
//    let decoder = JSONDecoder()
//    do {
//        let car = try decoder.decode(Car.self, from: data)
//        print(car)
//        PlaygroundPage.current.finishExecution()
//    } catch let e {
//        print("failed to convert data \(e)")
//        PlaygroundPage.current.finishExecution()
//    }
//}

//DataManager.getJSONFromURL("cars") { (data, error) in
//    guard let data = data else {
//        PlaygroundPage.current.finishExecution()
//    }
//    let decoder = JSONDecoder()
//    do {
//        let cars = try decoder.decode([Car].self, from: data)
//        print(cars)
//        PlaygroundPage.current.finishExecution()
//    } catch  {
//        print("failed to convert data")
//        PlaygroundPage.current.finishExecution()
//    }
//}


//    DataManager.getJSONFromURL("car") { (data, error) in
//        guard let data = data else {
//            PlaygroundPage.current.finishExecution()
//        }
//        let decoder = JSONDecoder()
//        do {
//            let car = try decoder.decode(Car.self, from: data)
//
//            //Encoding
//            let encoder = JSONEncoder()
//            let json = try encoder.encode(car)
//            print(json)
//            PlaygroundPage.current.finishExecution()
//        } catch  {
//            print("failed to convert data")
//
//            PlaygroundPage.current.finishExecution()
//        }
//    }

//DataManager.getJSONFromURL("user") { (data, error) in
//    guard let data = data else {
//        return
//    }
//    let decoder = JSONDecoder()
//    do {
//        let user = try decoder.decode(User.self, from: data)
//        print(user)
//        PlaygroundPage.current.finishExecution()
//    } catch let e {
//        print("failed to convert \(e)")
//        PlaygroundPage.current.finishExecution()
//    }
//}

DataManager.getJSONFromURL("user") { (data, error) in
    guard let data = data else {
        return
    }
    let decoder = JSONDecoder()
    do {
        let user = try decoder.decode(UserWithoutCarStruct.self, from: data)
        print(user)
        PlaygroundPage.current.finishExecution()
    } catch let e {
        print("failed to convert \(e)")
        PlaygroundPage.current.finishExecution()
    }
}











