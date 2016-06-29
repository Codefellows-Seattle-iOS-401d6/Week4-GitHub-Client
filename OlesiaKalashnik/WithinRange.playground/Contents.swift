import UIKit

func withinRange(input: Double) -> Bool {
    return (input % 10 <= 2) || (input % 10 >= 8)
}

//Tests
withinRange(17)
withinRange(0)
withinRange(0.9)