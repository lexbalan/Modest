# Definitions

A *definition* binds an identifier to an entity. There are four kinds:

| Kind | Keyword | Creates |
|------|---------|---------|
| [Type](./type.md) | `type` | type alias / named type |
| [Constant](./const.md) | `const` | compile-time value |
| [Variable](./var.md) | `var` | mutable storage |
| [Function](./func.md) | `func` | function |

Every module-level definition may carry an access modifier (`public` /
`private`, see [access modifiers](../access_modifiers.md)) and
[annotations](../attribute.md). Redefinition of an identifier within one
scope is an error.

All module-level names are declared before definitions are processed, so a
definition may refer to entities defined later in the file — no forward
declarations are needed.

```modest
type Point = {x: Int32, y: Int32}

const origin = Point {x = 0, y = 0}

var current: Point

func reset () -> Unit {
	current = origin
}
```
