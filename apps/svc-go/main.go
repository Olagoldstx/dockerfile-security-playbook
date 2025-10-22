package main
import (
  "net/http"
  "encoding/json"
)
func health(w http.ResponseWriter, r *http.Request) {
  json.NewEncoder(w).Encode(map[string]string{"status":"ok"})
}
func root(w http.ResponseWriter, r *http.Request) {
  json.NewEncoder(w).Encode(map[string]string{"msg":"Hello from secure Go service"})
}
func main() {
  http.HandleFunc("/healthz", health)
  http.HandleFunc("/", root)
  http.ListenAndServe(":8080", nil)
}
