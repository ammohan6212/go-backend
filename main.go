// main.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")

    name := "Go Developer"
    greet(name)
}

func greet(name string) {
    fmt.Printf("Welcome, %s!\n", name)
}
