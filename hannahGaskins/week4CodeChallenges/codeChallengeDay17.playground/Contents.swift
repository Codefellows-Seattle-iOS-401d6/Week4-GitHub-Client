//: Hannah Gaskins 6.28.2016

// code challenge: Write a function that takes in an array of numbers, and returns the lowest and highest numbers as a tuple.

let test = [1, 2, 3, 4]
let testTwo = [45, 2345, 235656]

func returnHighLowTuple(input: [Int]) -> (Int, Int) {
    
    var largest = 0
    
    let lowest = input.minElement()
    
    for numberHigh in input {
        if numberHigh > largest {
            largest = numberHigh
        }
    }
        
    
    return (lowest!, largest)
}

returnHighLowTuple(test)

returnHighLowTuple([45, 76, 23])

returnHighLowTuple(testTwo)

returnHighLowTuple([0,0,0,0])



