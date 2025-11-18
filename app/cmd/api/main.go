package main

import (
	"database/sql"
	"fmt"
	"html"
	"log"
	"net/http"
	"os"

	"github.com/fadikaba81/
	"github.com/go-sql-driver/mysql"
)

var db *sql.DB

func main() {

	

	dbsql, err := establishDBConnection()
	mux := http.NewServeMux()
	if err != nil {
		log.Println(err)
	}
	
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "hello, %q", html.EscapeString(r.URL.Path))
	})
	 LogRequestMiddleware(dbsql,mux )

	log.Fatal(http.ListenAndServe(":8080", nil))
}

func establishDBConnection() (*sql.DB, error){
    cfg := mysql.NewConfig()
	cfg.User = os.Getenv("DB_USER")
	cfg.Passwd = os.Getenv("DB_PASS")
	cfg.Net = "tcp"
	cfg.Addr = os.Getenv("DB_HOST")
	cfg.DBName = "myapp_db"

	var err error
	db, err = sql.Open("mysql", cfg.FormatDSN())

	
	if err != nil {
		log.Fatal(err)
	}
		
	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
		return nil, pingErr
	}
	fmt.Println("Connected")

	return db, nil
}
