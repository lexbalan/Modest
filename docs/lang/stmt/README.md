# Statements


*Statement* is a command to computer to do an action.
```swift
// this is a statement (value evaluation statement 'call')
// (calling function printf with an argument "Hello World!\n")
printf("Hello World!\n")
```

A few statement can be combined into one *block statement* with `{}` brackets
```swift
// this four statements are combined into one logical statement by braces
{
	printf("Hello World!\n")
	printf("I'm feeling good!\n")

	// you can separate statements by newline
	// (most preferable way, as shown above)
	// or use semicolon for one-line recording

	printf("How are you?\n"); printf("I hope everything in its right place\n")
}
```

After execution this example you're see on the screen:

```
Hello World!
I'm feeling good!
How are you?
I hope everything in its right place
```

Statements inside *block statement* are executed in our usual reading order from left to right, top to bottom. This abstract example shows order of execution:

```
{
	<statement1>; <statement2>
	<statement3>; <statement4>
	<statement5>
	<statement6>
	...
}
```


### Examples

A Simple example that asks the user to enter a number from 0 to 9, and if it is within the specified limits, compares it with a constant *n* and prints result of this comparison. **This simple example shows all kinds of statement**

```swift
import "libc/stdio"

public func main () -> Int32 {

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
	} else if number > n {
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


### More information every statements

  * [Block statement](./block.md)
  * [Value evaluation statement](./eval.md)
  * [Variable assignation statement](./assign.md)
  * [If statement](./if.md)
  * [While statement](./while.md)
  * [Return statement](./return.md)
  * [Asm statement](./asm_inline.md)

