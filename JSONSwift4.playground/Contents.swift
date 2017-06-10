//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*
 Certainly these are exciting times to be iOS, tvOS or watchOS developer. ML and ARKit are powerful and exciting features to work on. However on this article, we will be looking at how to generate and parse JSON in swift 4.
 
 ---> Encoding, Decoding, and Serialization
 Swift library has way to make your data types encodable and decodable for compatibility with external representations such as JSON. This can be achieved using Codable protocol.
 
 let’s look at the simple case of converting a JSON to a struct.
 I have created file called car.json. This will contain a json of cars will try to parse into a struct.
 Here is what our json looks like:
 {
 "id":1,
 "color":"red",
 "make":"toyota",
 "model":"camry",
 "year":"2016"
 }
 */

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

/*
 Here we created a method to get json from the resource file. This might not be the best of code for reading json and definitely error handling could be better. However the primary concern of this article is parsing json. so let get to it.
 We create a file called model, create a struct for car and make it Codable
 -----------show code for struct
 */


/*
 We made Car struct to adopt Codable Protocol. Now we can call DataManager to get the JSON data
 */

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
/*
 The result of the print is this Car(id: 1, color: "red", make: "toyota", model: "camry", year: "2016").
 We passed the json with few lines of code. SWEET!!!
 What if we wanted an array of cars i.e [Car]?
 Lets create a json of cars.
 */

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
//[JSONSwift4_Sources.Car(id: 1, color: "red", make: "toyota", model: "camry", year: "2016"), JSONSwift4_Sources.Car(id: 2, color: "blue", make: "honda", model: "accord", year: "2015"), JSONSwift4_Sources.Car(id: 3, color: "white", make: "Mercedes", model: "C-Class", year: "2014"), JSONSwift4_Sources.Car(id: 4, color: "black", make: "Lexus", model: "RX 350", year: "2013")]
//SWEET

/*
 So far we have only looked at the Decodable protocol of Codable protocol. Lets look at the second protocol which is Encodable. With Encodable we can generate json of our struct Car.
 */

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

/*
 We get type Data when we encoded Car struct. WHat this means is we don't have to worry about converting our model to json and then serialize to Data. Imagine we want to make a post request, with swift 3, we would have a method that converts our model to dictionary
 ------show to json method
 then we serialize to Data before passing to httpBody
 */
//do {
//    let json:Any!
//    let data = try JSONSerialization.data(withJSONObject: json, options: [])
//    session.httpBody = data
//} catch  {
//
//}

//Encodable protocol simplifies this.

/*
 You must have noticed that the json so far matched struct. The keys of the json are exactly the same with the properties of our struct. What happens if they are different? My backend dev friends like to use underscore while iOS developers mostly use camel case. Codable has solution for this. CodingKey protocol is a type that can be used as a key for encoding and decoding.
 Let change id to carID.
 ---show new struct
 public struct Car: Codable {
 let carID: Int
 let color: String
 let make: String
 let model: String
 let year: String
 
 func toJSON() -> [String:Any] {
 return [
 "id":carID,
 "color":color,
 "make":make,
 "model":model,
 "year":year
 ]
 }
 }
 
 When we try to decode json,
 DataManager.getJSONFromURL("car") { (data, error) in
 guard let data = data else {
 PlaygroundPage.current.finishExecution()
 }
 let decoder = JSONDecoder()
 do {
 let car = try decoder.decode(Car.self, from: data)
 print(car)
 PlaygroundPage.current.finishExecution()
 } catch let e {
 print("failed to convert data \(e)")
 PlaygroundPage.current.finishExecution()
 }
 }
 
 we get keyNotFound error in the catch block. Key not found when expecting non-optional type Int for coding key \"carID\""
 Lets solve this using CodingKey protocol.
 We create an enum called CodingKeys. In this enum we create a case for all the properties of our struct. If the property name match the json key, then we only need enter the property name. If the property name doesn't match the json key, we have to specify the json key of that property.
 
 public struct Car: Codable {
 
 let carID: Int
 let color: String
 let make: String
 let model: String
 let year: String
 
 private enum CodingKeys : String, CodingKey {
 case carID = "id", color, make, model, year
 }
 
 func toJSON() -> [String:Any] {
 return [
 "id":carID,
 "color":color,
 "make":make,
 "model":model,
 "year":year
 ]
 }
 }
 
 This fixed the error! SWEET!!!
 */

//How about nested JSON?
/*
 This is easily handled by creating codable properties for the nested items.
 let created a new file called user.json to contain the json below
 {
 "id": 1,
 "name": "Fred Ian",
 "gender": "male",
 "car": {
 "id": 1,
 "color": "red",
 "make": "toyota",
 "model": "camry",
 "year": "2016"
 }
 }
 now create a user struct.
 public struct User: Codable {
 let name:String
 let id:Int
 let gender:String
 let car:Car
 }
 
 Let try to parse that.
 */

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
/*
 we get this User(name: "Fred Ian", id: 1, gender: "male", car: JSONSwift4_Sources.Car(carID: 1, color: "red", make: "toyota", model: "camry", year: "2016")).
 Easy!!!
 
 What if we don't want user struct to have car struct as a property? Something like this.
 public struct UserWithoutCarStruct: Codable {
 let name:String
 let id:Int
 let gender:String
 let carID: Int
 let color: String
 let make: String
 let model: String
 let year: String
 }
 How can we navigate into the nested json to get the values of color, make, model, year, carID?
 Since we want to handle the nested structure in json, we have to define CodingKeys including one for car.
 
 private enum CodingKeys : String, CodingKey {
 case name, id, gender, car
 }
 private enum CarKeys : String, CodingKey {
 case carID = "id", color, make, model, year
 }
 
 Next we override the initializer for UserWithoutCarStruct.
 */


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
/*
 We get this UserWithoutCarStruct(name: "Fred Ian", id: 1, gender: "male", carID: 1, color: "red", make: "toyota", model: "camry", year: "2016")
 That is it! Parsing JSON is certainly easy with Swift 4
 */











