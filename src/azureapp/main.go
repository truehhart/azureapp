package main

import (
	//"log"
	"net/http"
	//"os"
	"strings"

	"github.com/truehhart/azureapp/src/azureapp/routes"
)

func main() {
	// Quick check for necessary environment variables.
	// reqEnvironmentVars := []string{
	// 	"HTTP_LISTEN_PORT",
	// 	"APP_MESSAGE",
	// 	"APP_ENVIRONMENT",
	// 	"APP_REVISION",
	// }
	// for _, variable := range reqEnvironmentVars {
	// 	_, present := os.LookupEnv(variable)
	// 	if !(present) {
	// 		log.Fatalf("%s environment variable is not defined. The following environment variables must be defined: %v", variable, reqEnvironmentVars)
	// 	}
	// }

	// listenPort, _ := os.LookupEnv("HTTP_LISTEN_PORT")
	
	http.ListenAndServe(strings.Join([]string{":", "8080"}, ""), routes.Router())
}
