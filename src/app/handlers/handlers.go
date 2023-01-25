package handlers

import (
	"fmt"
	"net/http"
)

func ReturnMessage(input string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(fmt.Sprintf(`{"output":"%s"}`, input)))
	}
}