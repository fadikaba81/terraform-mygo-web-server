package main

import (
	"database/sql"
	"fmt"
	"html"
	"log"
	"net/http"
	"os"

	"github.com/fadikaba81/terraform-mygo-web-server/app/internal/handlers"
	"github.com/go-sql-driver/mysql"

)

func main() {
// 1️⃣ Connect to DB
	dbsql, err := establishDBConnection()
	if err != nil {
		log.Fatal(err)
	}
	
	// 2️⃣ Create router
	mux := http.NewServeMux()
	mux.HandleFunc("/", homeHandler)
	mux.HandleFunc("/about", aboutHandler)
	
	loggedMux := handlers.LogRequestMiddleware(dbsql, mux)

	// 4️⃣ Start server
	log.Println("Server running on :8080")
	log.Fatal(http.ListenAndServe(":8080", loggedMux))
}

func establishDBConnection() (*sql.DB, error){ 	
	
    cfg := mysql.NewConfig()
	cfg.User = os.Getenv("DBUSER")
	cfg.Passwd = os.Getenv("DBPASS")
	cfg.Net = "tcp"
	cfg.Addr = os.Getenv("DBHOST")
	cfg.DBName = "myapp_db"

	
	db, err := sql.Open("mysql", cfg.FormatDSN())
	if err != nil {
		return nil, err
	}

	if err := db.Ping(); err != nil {
		return nil, err
	}

	fmt.Println("Connected")
	return db, nil
}

func homeHandler(w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "hello, %q", html.EscapeString(r.URL.Path))
}
func aboutHandler(w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "hello, %q", html.EscapeString(r.URL.Path))
}