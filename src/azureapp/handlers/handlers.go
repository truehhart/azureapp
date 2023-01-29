package handlers

import (
	"encoding/json"
	"net/http"
)

func ReturnMessage(input map[string]string) http.HandlerFunc {
	jsonObj, _ := json.Marshal(input)
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(jsonObj))
	}
}

func Redirect(redirectPath string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
			http.Redirect(w, r, redirectPath, http.StatusFound)
	}
}

func ReturnOk(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
}

func ReturnEnv(value string, status bool) string {
	return value
}