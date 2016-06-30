//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//Code Challenge:
//Given a non-negative number "num", return true if num is within 2 of a multiple of 10. Note: (a % b) is the remainder of dividing a by b, so (7 % 5) is 2.

func test(number: Int) -> Bool
{
    return number % 10 >= 8 || number % 10 <= 2 ?  true :  false
}


print(test(50))
print(test(55))
print(test(58))
print(test(7))

