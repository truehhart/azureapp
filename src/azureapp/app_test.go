package main

import (
	"fmt"
	"net/http"
	"testing"
	"io"
	"encoding/json"
	"flag"
)

var testAppUrl  	  = flag.String("url", "http://localhost:8080", "Url of the deployed application to test against")// "http://localhost:8080"
var testAppRevision = flag.String("rev", "", "Revision of the deployed application")
var testAppMessage  = flag.String("msg", "", "Message to expect from the deployed application")

func contains(arr []int, input int) bool {
	for _, v := range arr {
		if v == input {
			return true
		}
	}
	return false
}

func TestCheckAvailability(t *testing.T) {
	url := fmt.Sprintf("%s/assets/index.html", *testAppUrl)
	resp, err := http.Get(url)
	if err != nil {
		t.Errorf("Availability test failed: got error %e when trying to access %s", err, url)
	}
	defer resp.Body.Close()

	if !contains([]int{200, 301}, resp.StatusCode) {
		t.Errorf("Availability test failed: Received StatusCode %d when trying to access %s", resp.StatusCode, url)
	}
}

func TestCheckVersion(t *testing.T) {
	url := fmt.Sprintf("%s/api/helloworld", *testAppUrl)
	resp, err := http.Get(url)
	if err != nil {
		t.Errorf("CheckVersion test failed: got error %e when trying to access %s", err, url)
	}

	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		t.Errorf("CheckVersion test failed: got error %e when trying to read reply body from %s", err, url)
	}
	if resp.StatusCode != 200 {
		t.Errorf("CheckVersion test failed: Received StatusCode %d when trying to access %s", resp.StatusCode, url)
	}

	type TResponse struct {
		Environment string `json:"-"`
		Message string `json:"message"`
		Revision string `json:"revision"`
	}
	var response TResponse
	json.Unmarshal([]byte(body), &response)
	if response.Revision != *testAppRevision {
		t.Errorf("CheckVersion test failed: Revision is set to '%s'. Expected: '%s'", response.Revision, *testAppRevision)
	}
	if response.Message != *testAppMessage {
		t.Errorf("CheckVersion test failed: Message is set to '%s'. Expected: '%s'", response.Message, *testAppMessage)
	}
}