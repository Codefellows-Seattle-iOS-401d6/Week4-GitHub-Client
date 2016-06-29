import UIKit


func highLow(inputArray: [Int]) -> (Int, Int)? {
    var low: Int
    var high: Int
    let length = inputArray.count
    var index = 0
    
    if length > 0 {
        low = inputArray[index]
        high = inputArray[index]
        
        
        while index < length {
            if low > inputArray[index] {
                low = inputArray[index]
            }
            
            if high < inputArray[index] {
                high = inputArray[index]
            }
            index += 1
        }
        return (low, high)
    }
    return nil
}


//Tests
let firstArray = [2, 3, 4, 8, 9, 2343]
let secondArray = [Int]()
let thirdArray = [-3]
highLow(firstArray)
highLow(secondArray)
highLow(thirdArray)