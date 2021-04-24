package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Println(r.Method, r.URL.String(), r.RemoteAddr)
		fmt.Fprintf(w, "this is medea")
	})
	log.Println(http.ListenAndServe(":8080", nil))
}
