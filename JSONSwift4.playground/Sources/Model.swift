import Foundation

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

public struct User: Codable {
    let name:String
    let id:Int
    let gender:String
    let car:Car
}

public struct UserWithoutCarStruct: Decodable {
    let name:String
    let id:Int
    let gender:String
    let carID: Int
    let color: String
    let make: String
    let model: String
    let year: String

    fileprivate enum CodingKeys : String, CodingKey {
        case name, id, gender, car
    }
    fileprivate enum CarKeys : String, CodingKey {
        case carID = "id", color, make, model, year
    }
}

extension UserWithoutCarStruct {
    public init(from decoder: Decoder) throws {
        let userObject = try decoder.container(keyedBy: CodingKeys.self)
        let name = try userObject.decode(String.self, forKey: .name)
        let id = try userObject.decode(Int.self, forKey: .id)
        let gender = try userObject.decode(String.self, forKey: .gender)

        let carObject = try userObject.nestedContainer(keyedBy: CarKeys.self, forKey: .car)
        let color = try carObject.decode(String.self, forKey: .color)
        let make = try carObject.decode(String.self, forKey: .make)
        let model = try carObject.decode(String.self, forKey: .model)
        let year = try carObject.decode(String.self, forKey: .year)
        let carId = try carObject.decode(Int.self, forKey: .carID)

        self.init(name:name, id:id, gender:gender, carID:carId, color:color, make:make, model:model, year:year)
    }
}
