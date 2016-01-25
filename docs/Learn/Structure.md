# Structure

Iode is a general-purpose, imperative, statically typed programming language.

- Curly braces are common
- Parenthesis aren't
- Expressions end with a newline, just like in Swift
- Semicolons are not valid tokens

## vs. C

The following are example programs comparing Iode to the C programming language (C99).

### Iode:
```go
import cstdio

fn main() > Int {
	return 0
}
```

### C:
```c
#import <stdio.h>

int main() {
	return 0;
}
```

### Iode:
```swift
let constant = "Never changing"
```

### C:
```c
#DEFINE constant "Never changing"
```

### Iode:
```swift
import otherFile
```

### C:
```c
#import "otherFile.c"
```

### Iode:
```swift
var fruits:String = ["Apple", "Blueberry", "Orange", "Banana"]
```

### C:
```c
char *fruits[] = { "Apple", "Blueberry", "Orange", "Banana" };
```

# vs. JavaScript

The following are example programs comparing Iode to the JavaScript programming language (node.js).

### Iode:
```go
import cstdio

fn main() > Int {
	printf("Hello world!")
	return 0
}
```

### JavaScript:
```js
console.log("Hello world!");
```

### Iode:
```swift
let constant = "Never changing"
```

### JavaScript:
Not applicable.

### Iode:
```swift
import otherFile
```

### JavaScript:
```js
var otherFile = require("./otherFile");
```

### Iode:
```swift
var fruits:String = ["Apple", "Blueberry", "Orange", "Banana"]
```

### JavaScript:
```js
var fruits = [ "Apple", "Blueberry", "Orange", "Banana" ]
```
