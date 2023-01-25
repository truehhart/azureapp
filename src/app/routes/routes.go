package routes

import (
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/truehhart/azureapp/src/app/handlers"
)


func Router() *mux.Router {
	router := mux.NewRouter()
	
	staticFileDirectory := http.Dir("./assets/")
	staticFileHandler := http.StripPrefix("/assets/", http.FileServer(staticFileDirectory))

	router.PathPrefix("/assets/").Handler(staticFileHandler).Methods("GET")

	messageToReturn, _ := os.LookupEnv("APP_RETURN_MESSAGE")
	router.HandleFunc("/helloworld", handlers.ReturnMessage(messageToReturn)).Methods("GET")
	router.PathPrefix("/index.html").Handler(staticFileHandler).Methods("GET")

	return router
}

// func notFound(w http.ResponseWriter, r *http.Request) {
// 	http.ServeFile(w, r, defaultRoute)
// 	http.Redirect(w, r, )
// }
