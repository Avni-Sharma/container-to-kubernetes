package main

import (
	"fmt"
	"net/http"
)

func helloWorld(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World")
}

func kubernetes(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Ahoy Kubernetes")
}

func main() {
	http.HandleFunc("/", helloWorld)
	http.HandleFunc("/kubernetes", kubernetes)
	http.ListenAndServe(":8080", nil)
}
