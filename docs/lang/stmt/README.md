# Statements

[go back](../README.md)

  * [variable definiiton statement](./var.md)
  * [constant definiiton statement](./let.md)
  * [value evaluation statement](./eval.md)
  * [variable assignation statement](./assign.md)
  * [if statement](./if.md)
  * [while statement](./while.md)
  * [return statement](./return.md)


### Fast example

A Simple example that asks the user to enter a number from 0 to 9, and if it is within the specified limits, compares it with a constant. This simple example shows all kinds of statement

```swift
import "libc/stdio"

func main () -> Int32 {
    
    // variable definition statement
    var number: Int32
    
    // assignation statement
    number = 0
    
    // while statement
    while true {
        // value evaluation statement
        printf("enter a number (from 0 to 9): ")
        // value evaluation statement
        scanf("%d", &number)
    
        // if-else statement
        if number < 0 {
            // value evaluation statement
            printf("number must be greater than zero, try again\n")
            // again statement (continue in C)
            again
        } else if number > 9 {
            // value evaluation statement
            printf("number must be less than nine, try again\n")
            // again statement (continue in C)
            again
        } else {
            // break statement
            break
        }
    }
    
    // let statement
    let n = 5
    
    // if-else statement
    if number < n {
        // value evaluation statement
        printf("entered number (%i) is less than %i\n", number, n)
    } else number > n {
        // value evaluation statement
        printf("entered number (%i) is greater than %i\n", number, n)
    } else {
        // value evaluation statement
        printf("entered number (%i) is equal with %i\n", number, n)
    }
    
    // return statement
    return 0
}
```