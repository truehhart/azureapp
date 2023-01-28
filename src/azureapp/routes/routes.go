package routes

import (
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/truehhart/azureapp/src/azureapp/handlers"
)


func Router() *mux.Router {
	router := mux.NewRouter()
	
	staticFileDirectory := http.Dir("./assets/")
	staticFileHandler := http.StripPrefix("/assets/", http.FileServer(staticFileDirectory))

	router.PathPrefix("/assets/").Handler(staticFileHandler).Methods("GET")

	messageToReturn := map[string]string{
		"environment": handlers.ReturnEnv(os.LookupEnv("APP_ENVIRONMENT")),
		"message": handlers.ReturnEnv(os.LookupEnv("APP_MESSAGE")),
		"revision": handlers.ReturnEnv(os.LookupEnv("APP_REVISION")),
	}
	router.HandleFunc("/api/helloworld", handlers.ReturnMessage(messageToReturn)).Methods("GET")
	router.PathPrefix("/index.html").Handler(staticFileHandler).Methods("GET")
	router.Path("/").Handler(handlers.Redirect("/assets/index.html"))

	return router
}
