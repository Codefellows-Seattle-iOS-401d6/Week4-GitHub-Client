//6.28.2016

//Given a non-negative number "num", return true if num is within 2 of a multiple of 10. Note: (a % b) is the remainder of dividing a by b, so (7 % 5) is 2.

38 % 10
39 % 10
41 % 10
42 % 10

func withinTwoOfTenMultiple(input: Int) -> Bool {
    let num = input % 10
    if num >= 8 || num <= 2 {
        return true
    } else {
        return false
    }
}

withinTwoOfTenMultiple(58)

withinTwoOfTenMultiple(79)

withinTwoOfTenMultiple(66)