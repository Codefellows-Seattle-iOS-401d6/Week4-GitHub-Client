//: Hannah Gaskins 6.27.2016

var testArray = [1, 44, 3, 10, 5, 4, 6]

func returnMiddleThree(input: [Int]) -> [Int] {
    
    var outputArray: [Int] = []
    
    let median = (input.count - 1)/2
    
    outputArray.append(input[median - 1])
    
    outputArray.append(input[median])
    
    outputArray.append(input[median + 1])
    
    return outputArray
    
}

returnMiddleThree(testArray)


returnMiddleThree([1, 2, 3])

returnMiddleThree([0, 0, 0])
