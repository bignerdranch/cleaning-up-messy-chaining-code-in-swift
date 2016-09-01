
//: Cleaning up messy chaining in Swift

let data = [ ["customerId": 1, "totalOrders": 1000, "shippedOrders": 200],
             ["customerId": 2, "totalOrders": 344, "shippedOrders": 240],
             ["customerId": 3, "totalOrders": 1, "shippedOrders": 0],
             ["customerId": 4, "totalOrders": 533, "shippedOrders": 533],
             ["customerId": 5, "totalOrders": 120, "shippedOrders": 111],
             ["customerId": 6, "totalOrders": 2, "shippedOrders": 2],
             ["customerId": 7, "totalOrders": 332, "shippedOrders": 122],
             ["customerId": 8, "totalOrders": 12, "shippedOrders": 12],
             ["customerId": 9, "totalOrders": 1200, "shippedOrders": 233]]

// customer details for the top gold medal customer that has outstanding orders
let topGMCustomer = data.filter { $0["shippedOrders"]! < $0["totalOrders"]! }.filter { $0["totalOrders"]! > 500 }.map { ["name":"customer(\($0["customerId"]!))", "outstandingOrders": $0["totalOrders"]! - $0["shippedOrders"]!] }.sorted {
    let first = Int("\($0["outstandingOrders"]!)")!
    let second = Int("\($1["outstandingOrders"]!)")!
    return first > second
    }.first!
topGMCustomer

struct Customer {
    let customerId: Int
    let totalOrders: Int
    let shippedOrders: Int
    
    var outstandingOrders: Int {
        get {
            return totalOrders - shippedOrders
        }
    }
    
    var goldMedal: Bool {
        get {
            return totalOrders > 500
        }
    }
    
    init?(details: Dictionary<String,Int>) {
        
        guard let customerId = details["customerId"], let totalOrders = details["totalOrders"], let shippedOrders = details["shippedOrders"] else {
            return nil
        }
        
        self.customerId = customerId
        self.totalOrders = totalOrders
        self.shippedOrders = shippedOrders
    }
}

let customer1 = Customer(details: data[0])
customer1?.customerId
customer1?.outstandingOrders

let allCustomers = data.flatMap(Customer.init)
allCustomers.count

extension Sequence where Iterator.Element == Customer {
    
    var withOustandingOrders: Array<Customer> {
        return self.filter { $0.outstandingOrders > 0 }
    }
    
    var areGoldMedal: Array<Customer> {
        return self.filter { $0.goldMedal }
    }
    
    var sortedByMostOutstandingOrders: Array<Customer> {
        return self.sorted { $0.outstandingOrders > $1.outstandingOrders }
    }
    
    var filteredByCritical: Array<Customer> {
        return self.filter { $0.outstandingOrders > 0 && $0.goldMedal }
    }
}

let topGM = allCustomers.filteredByCritical.sortedByMostOutstandingOrders.first
topGM?.customerId
topGM?.outstandingOrders
