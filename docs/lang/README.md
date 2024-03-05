# Modest language

- [Comments](./comments.md)
- [Definitions](./def/README.md)
  * [Type](./def/type.md)
  * [Constant](./def/const.md)
  * [Variable](./def/var.md)
  * [Function](./def/func.md)

- [Types](./type/README.md)
  * [Generic](./type/generic.md)
  * [Base](./type/base.md)
  * [Array](./type/array.md)
  * [Record](./type/record.md)
  * [Function](./type/func.md)
  * [Pointer](./type/pointer.md)
  * [VA_List](./type/va_list.md)

- [Values](./value/README.md)
  <!--* [Numeric](./value/numeric.md)-->
  <!--* [String](./value/string.md)-->
  * [Literal](./value/literal.md)
  * [Binary](./value/binary.md)
  * [Cast](./value/cast.md)
  * [Unary](./value/unary.md)
  * [Binary](./value/binary.md)
  * [Call](./value/call.md)
  * [Index](./value/_index.md)
  * [Access](./value/access.md)
  * [Sizeof](./value/sizeof.md)

- [Statements](./stmt/README.md)
  * [If](./stmt/if.md)
  * [While](./stmt/while.md)
  * [Return](./stmt/return.md)
  * [Variable definiiton](./stmt/var.md)
  * [Constant definiiton](./stmt/const.md)
  * [Value evaluation](./stmt/eval.md)
  * [Variable assignation](./stmt/assign.md)
  * [Block statement](./stmt/block.md)

### Misc
  * [Directives](./directives.md)
  * [Attributes](./attributes.md)
  * [Builtin constants](./builtin_constants.md)


### Example


```
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
            // again statement ('continue' in C)
            again
        } else if number > 9 {
            // value evaluation statement
            printf("number must be less than nine, try again\n")
            // again statement ('continue' in C)
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

