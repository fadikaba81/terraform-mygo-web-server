package handlers

import (
	"database/sql"
	"fmt"
	"log"
	"net"
	"time"

	"net/http"
)

type StatusRecorder struct {
	http.ResponseWriter
	Status int
}

func (r *StatusRecorder) WriteHeader(status int) {
	r.Status = status
	r.ResponseWriter.WriteHeader(status)
}

func LogRequestMiddleware(db *sql.DB, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		recorder := &StatusRecorder{
			ResponseWriter: w,
			Status:         200,
		}

		next.ServeHTTP(recorder, r)

		latency := time.Since(start).Milliseconds()
		success := recorder.Status < 400
		clientIP, _, _ := net.SplitHostPort(r.RemoteAddr)

		_, err := db.Exec(`
			INSERT INTO api_requests (request_time, endpoint, status_code, latency_ms, success, client_ip)
			VALUES (?, ?, ?, ?, ?, ?)`,
			time.Now(),
			r.URL.Path,
			recorder.Status,
			latency,
			success,
			clientIP,
		)

		if err != nil {
			log.Println("Failed to insert API request log:", err)
		}
	})
}
