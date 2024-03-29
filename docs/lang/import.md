# Import

During the import process, the compiler first looks for the module in the current directory, then in the directories specified in the compiler parameters, and only then in the directory whose path is specified in the MODEST_LIB environment variable.

## Import directive


### Common form

```
import <# string_value_expression #>
```

## Examples

```golang
import "libc/stdio"
import "myapp"
```
